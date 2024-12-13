part of 'order_bloc.dart';

enum ProductStatus { initial, loading, success, failure }

enum CreateOrderStatus { initial, loading, success, failure }

enum UpdateOrderStatus { initial, loading, success, failure }

final class OrderState extends Equatable {
  const OrderState({
    this.createOrderStatus = CreateOrderStatus.initial,
    this.updateOrderStatus = UpdateOrderStatus.initial,
    this.productStatus = ProductStatus.initial,
    this.order = OrderModel.empty,
    this.subtotal = Constants.zero,
    this.totalWages = Constants.zero,
  });

  final ProductStatus productStatus;
  final CreateOrderStatus createOrderStatus;
  final UpdateOrderStatus updateOrderStatus;
  final OrderEntity order;
  final int subtotal;
  final int totalWages;

  OrderState copyWith({
    CreateOrderStatus? createOrderStatus,
    UpdateOrderStatus? updateOrderStatus,
    ProductStatus? productStatus,
    OrderEntity? order,
    int? subtotal,
    int? totalWages,
  }) {
    return OrderState(
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      updateOrderStatus: updateOrderStatus ?? this.updateOrderStatus,
      productStatus: productStatus ?? this.productStatus,
      order: order ?? this.order,
      subtotal: subtotal ?? this.subtotal,
      totalWages: totalWages ?? this.totalWages,
    );
  }

  @override
  List<Object?> get props => [
        createOrderStatus,
        updateOrderStatus,
        productStatus,
        order,
        subtotal,
        totalWages,
      ];
}
