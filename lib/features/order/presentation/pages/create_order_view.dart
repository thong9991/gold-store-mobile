import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import '../../../../core/common/widgets/app_bar/appbar_widget.dart';
import '../../../../core/common/widgets/button/submit_cancel_button.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/utils/utils.dart';
import '../../../gold_price/presentation/bloc/gold_price_bloc.dart';
import '../../data/models/order.dart';
import '../bloc/order_bloc.dart';
import '../widgets/widgets.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<OrderBloc>()..add(InitOrder())),
        BlocProvider.value(value: context.read<AppGoldPriceCubit>()),
      ],
      child: const CreateOrderView(),
    );
  }
}

class CreateOrderView extends StatelessWidget {
  const CreateOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tradeTypes = [AppStrings.strBuy, AppStrings.strSell];
    TextEditingController goldTypeController = TextEditingController();
    TextEditingController tradeTypeController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    TextEditingController descriptionController = TextEditingController();
    TextEditingController discountController = TextEditingController();

    Future openDialog() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppStrings.strGoldExchange.tr(context)),
                content: Container(
                  height: 0.15.sh,
                  child: Column(
                    children: [
                      BlocSelector<AppGoldPriceCubit, AppGoldPriceState,
                          List<String>>(
                        selector: (state) {
                          List<String> goldPriceNames =
                              state is AppGoldPriceLoaded
                                  ? List.generate(state.goldPrices.length,
                                      (i) => state.goldPrices[i].goldType)
                                  : [];
                          return goldPriceNames;
                        },
                        builder: (context, goldPriceNames) {
                          return CustomDropDownMenu(
                            controller: goldTypeController,
                            list: goldPriceNames,
                            hintText: AppStrings.strGoldType.tr(context),
                          );
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: CustomDropDownMenu(
                                controller: tradeTypeController,
                                list: tradeTypes,
                                hintText: AppStrings.strTradeType.tr(context),
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 5,
                            child: CustomTextField(
                              controller: amountController,
                              inLine: true,
                              numeric: true,
                              suffixText: AppStrings.strMace.tr(context),
                              type: InputType.GOLD_AMOUNT,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Material(
                    color: Colors.white,
                    child: Ink(
                      width: 100.w,
                      height: 40.h,
                      padding: REdgeInsets.only(left: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          border: Border.all(),
                          color: Colors.white),
                      child: InkWell(
                        onTap: () {
                          String goldType = goldTypeController.text;
                          String tradeType = tradeTypeController.text;
                          if (goldType.isEmpty ||
                              tradeType.isEmpty ||
                              amountController.text.trim().isEmpty) {
                            return;
                          }

                          double amount =
                              (tradeType == AppStrings.strBuy ? 1 : -1) *
                                  double.parse(amountController.text);

                          context.read<OrderBloc>().add(OrderExchangeAdd(
                              goldType: goldType, amount: amount));
                          amountController.text = "";
                          context.pop();
                        },
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.check,
                              size: 20.r,
                            ),
                            Text(
                              AppStrings.strAdd.tr(context),
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
    }

    return Scaffold(
      appBar: MyAppBar(
        title: AppStrings.strCreateOrderHeader.tr(context),
        secondaryAppBar: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 30.r,
          ),
        ),
        action: [
          IconButton(
              onPressed: () {
                context.push(
                  '/HomePage/CreateOrderPage/QRScanPage',
                );
              },
              icon: Icon(
                Icons.qr_code_2_rounded,
                size: 30.r,
              ))
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GoldPriceBloc, GoldPriceState>(
            listenWhen: (previous, current) {
              return previous.goldPriceStatus != current.goldPriceStatus;
            },
            listener: (context, state) {
              if (state.goldPriceStatus == GoldPriceStatus.loaded) {
                print("onGoldPriceChange");
                context.read<OrderBloc>().add(GoldPriceChange());
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listenWhen: (previous, current) {
              return previous.productStatus != current.productStatus;
            },
            listener: (context, state) {
              if (state.productStatus == ProductStatus.success) {
                context
                    .read<OrderBloc>()
                    .add(ProductStatusChange(status: ProductStatus.initial));
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listenWhen: (previous, current) {
              return previous.createOrderStatus != current.createOrderStatus;
            },
            listener: (context, state) {
              if (state.createOrderStatus == CreateOrderStatus.success) {
                showSnackBar(context, ToastificationType.success,
                    AppStrings.strAddOrderSuccessful, true);
                context.read<OrderBloc>().add(InitOrder());
              }
            },
          ),
        ],
        child: Container(
          width: double.infinity,
          color: Colors.white,
          margin: REdgeInsets.all(10),
          padding: REdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: BlocBuilder<OrderBloc, OrderState>(
              buildWhen: (previous, current) {
                return previous.order.orderSales.length !=
                        current.order.orderSales.length ||
                    previous.productStatus != current.productStatus ||
                    previous.createOrderStatus != current.createOrderStatus;
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(label: AppStrings.strOrderDetails.tr(context)),
                    Material(
                      color: Colors.white,
                      child: Ink(
                        width: AppStrings.strLangCode.tr(context) == "en"
                            ? 150.w
                            : 100.w,
                        height: 30.h,
                        padding: REdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            border: Border.all(),
                            color: Colors.white),
                        child: InkWell(
                          onTap: () {
                            openDialog();
                          },
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.compare_arrows_rounded,
                                size: 20.r,
                              ),
                              Text(
                                AppStrings.strGoldExchange.tr(context),
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Accordion(
                        maxOpenSections: 1,
                        disableScrolling: true,
                        headerBackgroundColorOpened: Colors.black54,
                        scaleWhenAnimating: true,
                        openAndCloseAnimation: true,
                        paddingListTop: 8.r,
                        paddingListBottom: 8.r,
                        headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        sectionOpeningHapticFeedback:
                            SectionHapticFeedback.heavy,
                        sectionClosingHapticFeedback:
                            SectionHapticFeedback.light,
                        children: [
                          if (state.order.orderSales.isNotEmpty)
                            for (int i = 0;
                                i < state.order.orderSales.length;
                                i++) ...[
                              AccordionSection(
                                isOpen: false,
                                leftIcon: Icon(
                                  Icons.discount_rounded,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                                header: Text(
                                  "${AppStrings.strProductLabel.tr(context)}:"
                                  " ${state.order.orderSales[i].product.id}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Column(
                                  children: [
                                    ItemInfo(
                                      label: state.order.orderSales[i].product
                                          .productName,
                                    ),
                                    ItemInfo(
                                      label:
                                          "${AppStrings.strTotalWeight.tr(context)}:",
                                      value:
                                          "${state.order.orderSales[i].product.totalWeight}"
                                          " ${AppStrings.strMace.tr(context)}",
                                    ),
                                    ItemInfo(
                                      label:
                                          "${AppStrings.strGoldWeight.tr(context)}:",
                                      value:
                                          "${state.order.orderSales[i].product.goldWeight}"
                                          " ${AppStrings.strMace.tr(context)}",
                                    ),
                                    ItemInfo(
                                      label:
                                          "${AppStrings.strGemWeight.tr(context)}:",
                                      value:
                                          "${state.order.orderSales[i].product.gemWeight}"
                                          " ${AppStrings.strMace.tr(context)}",
                                    ),
                                    AccordionTextField(
                                      label:
                                          '${AppStrings.strCutAmount.tr(context)}:',
                                      suffixText:
                                          ' ${AppStrings.strMace.tr(context)}',
                                      hint: Constants.empty,
                                      initialValue: "0",
                                      onChanged: (value) {
                                        if (value.trim().isEmpty) return;
                                        context.read<OrderBloc>().add(
                                            CutAmountChange(
                                                index: i,
                                                value: double.parse(value)));
                                      },
                                      numeric: true,
                                      isGoldAmount: true,
                                    ),
                                    AccordionTextField(
                                      label:
                                          '${AppStrings.strWage.tr(context)}:',
                                      suffixText:
                                          ',000 ${AppStrings.strVND.tr(context)}',
                                      initialValue: NumberFormat('#,###')
                                          .format(state
                                              .order.orderSales[i].newWage),
                                      onChanged: (value) {
                                        if (value.trim().isEmpty) return;
                                        context.read<OrderBloc>().add(
                                            WageChange(
                                                index: i,
                                                value: int.parse(value
                                                    .replaceAll(',', ''))));
                                      },
                                      hint: Constants.empty,
                                      isCurrency: true,
                                      numeric: true,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          if (state.order.orderExchanges.isNotEmpty &&
                              state.order.orderExchanges.first.amount > 0)
                            AccordionSection(
                              isOpen: false,
                              leftIcon: Icon(
                                Icons.auto_fix_high_outlined,
                                color: Colors.white,
                                size: 20.r,
                              ),
                              header: Text(
                                AppStrings.strBuy.tr(context),
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Column(
                                children: [
                                  const OrderExchangeHeader(),
                                  for (var orderExchange
                                      in state.order.orderExchanges) ...[
                                    if (orderExchange.amount > 0)
                                      OrderExchangeLine(
                                          goldType:
                                              orderExchange.goldPrice.goldType,
                                          amount: orderExchange.amount)
                                  ],
                                ],
                              ),
                            ),
                          if (state.order.orderExchanges.isNotEmpty &&
                              state.order.orderExchanges.last.amount < 0)
                            AccordionSection(
                              isOpen: false,
                              leftIcon: Icon(
                                Icons.payments_outlined,
                                color: Colors.white,
                                size: 20.r,
                              ),
                              header: Text(
                                AppStrings.strSell.tr(context),
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Column(
                                children: [
                                  const OrderExchangeHeader(),
                                  for (var orderExchange in state
                                      .order.orderExchanges.reversed) ...[
                                    if (orderExchange.amount < 0)
                                      OrderExchangeLine(
                                          goldType:
                                              orderExchange.goldPrice.goldType,
                                          amount: orderExchange.amount)
                                  ],
                                ],
                              ),
                            ),
                        ]),
                    Label(label: "${AppStrings.strDescription.tr(context)} :"),
                    CustomTextField(
                      hint: AppStrings.strOrderDescriptionHint.tr(context),
                      controller: descriptionController,
                      onChanged: (value) {
                        context.read<OrderBloc>().add(OrderChange(
                            order: OrderModel.fromEntity(state.order)
                                .copyWith(description: (value))));
                      },
                    ),
                    BlocSelector<OrderBloc, OrderState, int>(
                      selector: (state) {
                        return state.subtotal;
                      },
                      builder: (context, state) {
                        return LabelContent(
                          label: '${AppStrings.strSubTotal.tr(context)}:',
                          content: convertToCurrency(context, state),
                        );
                      },
                    ),
                    BlocSelector<OrderBloc, OrderState, int>(
                      selector: (state) {
                        return state.totalWages;
                      },
                      builder: (context, state) {
                        return LabelContent(
                            label: '${AppStrings.strTotalWages.tr(context)}:',
                            content: convertToCurrency(context, state));
                      },
                    ),
                    LabelTextField(
                      label: "${AppStrings.strGoldToCash.tr(context)}:",
                      hint: Constants.empty,
                      controller: discountController,
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          context.read<OrderBloc>().add(OrderChange(
                              order: OrderModel.fromEntity(state.order)
                                  .copyWith(goldToCash: (0))));
                          return;
                        }
                        context.read<OrderBloc>().add(OrderChange(
                            order: OrderModel.fromEntity(state.order).copyWith(
                                goldToCash:
                                    (int.parse(value.replaceAll(',', ''))))));
                      },
                      suffixText: ',000 ${AppStrings.strVND.tr(context)}',
                      type: InputType.CURRENCY,
                      numeric: true,
                    ),
                    LabelTextField(
                      label: "${AppStrings.strDiscount.tr(context)}:",
                      hint: Constants.empty,
                      controller: discountController,
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          context.read<OrderBloc>().add(OrderChange(
                              order: OrderModel.fromEntity(state.order)
                                  .copyWith(discount: (0))));
                          return;
                        }
                        context.read<OrderBloc>().add(OrderChange(
                            order: OrderModel.fromEntity(state.order).copyWith(
                                discount:
                                    (int.parse(value.replaceAll(',', ''))))));
                      },
                      suffixText: ',000 ${AppStrings.strVND.tr(context)}',
                      type: InputType.CURRENCY,
                      numeric: true,
                    ),
                    BlocSelector<OrderBloc, OrderState, int>(
                      selector: (state) {
                        return state.order.total;
                      },
                      builder: (context, state) {
                        return LabelContent(
                            label: '${AppStrings.strTotal.tr(context)}:',
                            content: convertToCurrency(context, state));
                      },
                    ),
                    SubmitCancelButton(
                      submitText: AppStrings.strCreateOrder.tr(context),
                      cancelText: AppStrings.strCancel.tr(context),
                      onCancel: () {
                        descriptionController.text = "";
                        discountController.text = "";
                        context.read<OrderBloc>().add(InitOrder());
                      },
                      onSubmit: () {
                        context.read<OrderBloc>().add(OrderAdd());
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
