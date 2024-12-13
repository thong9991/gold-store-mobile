import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/constants/constants.dart';
import '../../data/models/dtos/create_order_request.dart';
import '../../data/models/order.dart';
import '../../data/models/order_exchange.dart';
import '../../data/models/order_sale.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_exchange.dart';
import '../../domain/entities/order_sale.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/load_product.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final LoadProduct _loadProduct;
  final CreateOrder _createOrder;
  final AppGoldPriceCubit _goldPriceCubit;
  final AppUserCubit _userCubit;

  OrderBloc(
      {required LoadProduct loadProduct,
      required CreateOrder createOrder,
      required AppGoldPriceCubit goldPriceCubit,
      required AppUserCubit userCubit})
      : _loadProduct = loadProduct,
        _createOrder = createOrder,
        _goldPriceCubit = goldPriceCubit,
        _userCubit = userCubit,
        super(const OrderState()) {
    on<InitOrder>((_, emit) => emit(const OrderState()));
    on<ProductStatusChange>(_onProductStatusChange);
    on<GoldPriceChange>(_onGoldPriceChange);
    on<ProductLoad>(_onProductLoad);
    on<CutAmountChange>(_onCutAmountChange);
    on<WageChange>(_onWageChange);
    on<OrderExchangeAdd>(_onOrderExchangeAdd);
    on<OrderChange>(_onOrderChange);
    on<CreateOrderStatusChange>(_onCreateOrderStatusChange);
    on<OrderAdd>(_onOrderAdd);
  }

  void _onProductStatusChange(
          ProductStatusChange event, Emitter<OrderState> emit) =>
      emit(state.copyWith(productStatus: event.status));

  void _onGoldPriceChange(GoldPriceChange event, Emitter<OrderState> emit) {
    // update new total.
    int subtotal, totalWages, total;
    [subtotal, totalWages, total] = calculateOrder(
        state.order, (_goldPriceCubit.state as AppGoldPriceLoaded).goldPrices);

    OrderEntity newOrder =
        OrderModel.fromEntity(state.order).copyWith(total: total);

    emit(state.copyWith(
        order: newOrder, subtotal: subtotal, totalWages: totalWages));
  }

  void _onProductLoad(ProductLoad event, Emitter<OrderState> emit) async {
    if (state.order.orderSales.isNotEmpty) {
      for (var orderSale in state.order.orderSales) {
        if (orderSale.product.id == event.productId) {
          return;
        }
      }
    }

    // loading status.
    emit(state.copyWith(productStatus: ProductStatus.loading));

    final res = await _loadProduct(event.productId);
    res.fold(
      (failure) {
        // load fail.
        emit(state.copyWith(productStatus: ProductStatus.failure));
      },
      (product) {
        // new item.
        OrderSaleEntity orderSale = OrderSaleModel(
          product: product,
          newWage: product.wage,
        );

        // update order items.
        OrderEntity order = OrderModel.fromEntity(state.order);
        List<OrderSaleEntity> orderSales = [...order.orderSales, orderSale];

        OrderModel newOrder =
            OrderModel.fromEntity(order).copyWith(orderSales: orderSales);

        // update new total.
        int subtotal, totalWages, total;
        [subtotal, totalWages, total] = calculateOrder(
            newOrder, (_goldPriceCubit.state as AppGoldPriceLoaded).goldPrices);

        // load success.
        emit(state.copyWith(
            productStatus: ProductStatus.success,
            order: newOrder.copyWith(total: total),
            subtotal: subtotal,
            totalWages: totalWages));
      },
    );
  }

  void _onCutAmountChange(CutAmountChange event, Emitter<OrderState> emit) {
    OrderModel order = OrderModel.fromEntity(state.order);
    List<OrderSaleEntity> orderSales = order.orderSales;
    OrderSaleModel orderSale =
        OrderSaleModel.fromEntity(orderSales[event.index]);

    orderSale = orderSale.copyWith(cutAmount: event.value);
    orderSales[event.index] = orderSale;
    // update new total.
    int subtotal, totalWages, total;
    [subtotal, totalWages, total] = calculateOrder(
        order, (_goldPriceCubit.state as AppGoldPriceLoaded).goldPrices);
    emit(state.copyWith(
        order: order.copyWith(total: total),
        subtotal: subtotal,
        totalWages: totalWages));
  }

  void _onWageChange(WageChange event, Emitter<OrderState> emit) {
    OrderModel order = OrderModel.fromEntity(state.order);
    List<OrderSaleEntity> orderSales = order.orderSales;
    OrderSaleModel orderSale =
        OrderSaleModel.fromEntity(orderSales[event.index]);

    orderSale = orderSale.copyWith(newWage: event.value);
    orderSales[event.index] = orderSale;
    // update new total.
    int subtotal, totalWages, total;
    [subtotal, totalWages, total] = calculateOrder(
        order, (_goldPriceCubit.state as AppGoldPriceLoaded).goldPrices);
    emit(state.copyWith(
        order: order.copyWith(total: total),
        subtotal: subtotal,
        totalWages: totalWages));
  }

  void _onOrderExchangeAdd(OrderExchangeAdd event, Emitter<OrderState> emit) {
    List<OrderExchangeEntity> orderExchanges = state.order.orderExchanges;
    bool isAdded = false;

    for (int i = 0; i < orderExchanges.length; i++) {
      if (orderExchanges[i].goldPrice.goldType == event.goldType) {
        OrderExchangeModel orderExchange =
            OrderExchangeModel.fromEntity(orderExchanges[i])
                .copyWith(amount: orderExchanges[i].amount + event.amount);
        orderExchanges[i] = orderExchange;
        isAdded = true;
        break;
      }
    }

    if (!isAdded) {
      orderExchanges = [
        ...orderExchanges,
        OrderExchangeEntity(
            goldPrice: GoldPriceEntity(goldType: event.goldType),
            amount: event.amount)
      ];
    }

    orderExchanges.sort((a, b) => b.amount.compareTo(a.amount));
    OrderModel order = OrderModel.fromEntity(state.order)
        .copyWith(orderExchanges: orderExchanges);

    int subtotal, totalWages, total;
    [subtotal, totalWages, total] = calculateOrder(
        order, (_goldPriceCubit.state as AppGoldPriceLoaded).goldPrices);

    emit(state.copyWith(
        productStatus: ProductStatus.success,
        order: order.copyWith(total: total),
        subtotal: subtotal,
        totalWages: totalWages));
  }

  void _onOrderChange(OrderChange event, Emitter<OrderState> emit) async {
    if (event.order.description != state.order.description) {
      emit(state.copyWith(order: event.order));
    } else {
      OrderModel order = OrderModel.fromEntity(event.order);
      emit(state.copyWith(
        productStatus: ProductStatus.success,
        order: order.copyWith(
            total: (state.totalWages + state.subtotal) -
                (order.discount + order.goldToCash)),
      ));
    }
  }

  void _onCreateOrderStatusChange(
      CreateOrderStatusChange event, Emitter<OrderState> emit) async {
    emit(state.copyWith(createOrderStatus: event.status));
  }

  void _onOrderAdd(OrderAdd event, Emitter<OrderState> emit) async {
    emit(state.copyWith(createOrderStatus: CreateOrderStatus.loading));

    final res = await _createOrder(CreateOrderRequestDto(
        userId: (_userCubit.state as AppUserLoggedIn).user.id,
        order: OrderModel.fromEntity(state.order)));
    res.fold(
      (failure) => emit(state.copyWith(productStatus: ProductStatus.failure)),
      (order) => emit(state.copyWith(
          order: OrderModel.empty,
          createOrderStatus: CreateOrderStatus.success)),
    );
  }

  List<int> calculateOrder(OrderEntity order, List<GoldPriceEntity> listPrice) {
    int subtotal = 0;
    int totalWages = 0;
    Map<String, double> goldAmounts = {};

    for (OrderSaleEntity orderSale in order.orderSales) {
      String goldType = orderSale.product.goldPrice.goldType;
      double goldWeight = orderSale.product.goldWeight;
      int newWage = orderSale.newWage;
      double cutAmount = orderSale.cutAmount;

      // add wage into total wages.
      totalWages += newWage;
      // update selling gold amounts.
      if (goldAmounts.containsKey(goldType)) {
        goldAmounts[goldType] = goldAmounts[goldType]! - goldWeight + cutAmount;
        continue;
      }
      goldAmounts[goldType] = -goldWeight + cutAmount;
    }

    for (var orderExchange in order.orderExchanges) {
      String goldType = orderExchange.goldPrice.goldType;
      double amount = orderExchange.amount;

      // update selling gold amounts.
      if (goldAmounts.containsKey(goldType)) {
        goldAmounts[goldType] = goldAmounts[goldType]! + amount;
        continue;
      }
      goldAmounts[goldType] = amount;
    }

    for (GoldPriceEntity goldPrice in listPrice) {
      String goldType = goldPrice.goldType;
      if (goldAmounts.containsKey(goldType)) {
        double goldAmount = goldAmounts[goldType]!;
        subtotal += (goldAmount *
                -(goldAmount < 0 ? goldPrice.bidPrice : goldPrice.askPrice))
            .round();
      }
    }

    return [
      subtotal,
      totalWages,
      (subtotal + totalWages - order.discount - order.goldToCash)
    ];
  }
}
