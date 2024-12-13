import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/common/widgets/app_bar/appbar_widget.dart';
import '../../../../core/common/widgets/button/submit_cancel_button.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/gold_price_bloc.dart';

class ChangeGoldPricePage extends StatelessWidget {
  const ChangeGoldPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<GoldPriceBloc>()..add(GoldPriceLoad()),
        ),
        BlocProvider.value(
          value: context.read<AppGoldPriceCubit>(),
        ),
      ],
      child: const ChangeGoldPriceView(),
    );
  }
}

class ChangeGoldPriceView extends StatelessWidget {
  const ChangeGoldPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController askPriceController = TextEditingController();
    TextEditingController bidPriceController = TextEditingController();
    return Scaffold(
        appBar: MyAppBar(
          title: AppStrings.strGoldPriceAdjustmentPage.tr(context),
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
        ),
        body: BlocListener<GoldPriceBloc, GoldPriceState>(
          listenWhen: (previous, current) {
            return previous.updateGoldPriceStatus !=
                current.updateGoldPriceStatus;
          },
          listener: (context, state) {
            if (state.updateGoldPriceStatus != UpdateGoldPriceStatus.initial) {
              if (state.updateGoldPriceStatus ==
                  UpdateGoldPriceStatus.success) {
                showSnackBar(context, ToastificationType.success,
                    AppStrings.strEditGoldPriceSuccessful, true);
                context.read<GoldPriceBloc>().add(NotificationSend());
              }
              if (state.updateGoldPriceStatus ==
                  UpdateGoldPriceStatus.failure) {
                showSnackBar(context, ToastificationType.error, state.message,
                    state.message.split(" ").length < 4);
              }
              context.read<GoldPriceBloc>().add(
                  const UpdateGoldPriceStatusChange(
                      status: UpdateGoldPriceStatus.initial));
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: REdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.strGoldRates.tr(context),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Builder(builder: (context) {
                          final cubitState =
                              context.watch<AppGoldPriceCubit>().state;
                          final blocState =
                              context.watch<GoldPriceBloc>().state;
                          List<GoldPriceEntity> goldPrices = [];
                          List<GoldPriceEntity> updatedData =
                              blocState.updatedData;
                          if (cubitState is AppGoldPriceLoaded) {
                            goldPrices = cubitState.goldPrices;
                          }
                          switch (cubitState.runtimeType) {
                            case AppGoldPriceLoaded:
                              return DataTable(
                                  showBottomBorder: true,
                                  dataRowMaxHeight: 60.sp,
                                  columnSpacing: 0.03.sw,
                                  horizontalMargin: 0,
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 0.24.sw,
                                        child: Text(
                                          AppStrings.strGoldType.tr(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 0.21.sw,
                                        child: Text(
                                          AppStrings.strAskPrice.tr(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 0.21.sw,
                                        child: Text(
                                          AppStrings.strBidPrice.tr(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 0.2.sw,
                                        child: Text(
                                          Constants.empty,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    for (int i = 0;
                                        i < goldPrices.length;
                                        i++) ...[
                                      i != blocState.updateIndex
                                          ? DataRow(cells: [
                                              DataCell(Text(goldPrices[i]
                                                  .goldType
                                                  .tr(context))),
                                              DataCell(Text(
                                                updatedData[i].askPrice ==
                                                        Constants.zero
                                                    ? '${goldPrices[i].askPrice}'
                                                    : '${updatedData[i].askPrice}',
                                                textAlign: TextAlign.right,
                                              )),
                                              DataCell(Text(
                                                updatedData[i].bidPrice ==
                                                        Constants.zero
                                                    ? '${goldPrices[i].bidPrice}'
                                                    : '${updatedData[i].bidPrice}',
                                                textAlign: TextAlign.right,
                                              )),
                                              DataCell(
                                                IconButton(
                                                    onPressed: () {
                                                      int currentUpdateAskPrice =
                                                          blocState
                                                                      .updatedData[
                                                                          i]
                                                                      .askPrice !=
                                                                  Constants.zero
                                                              ? blocState
                                                                  .updatedData[
                                                                      i]
                                                                  .askPrice
                                                              : blocState
                                                                  .goldPrices[i]
                                                                  .askPrice;
                                                      int currentUpdateBidPrice =
                                                          blocState
                                                                      .updatedData[
                                                                          i]
                                                                      .bidPrice !=
                                                                  Constants.zero
                                                              ? blocState
                                                                  .updatedData[
                                                                      i]
                                                                  .bidPrice
                                                              : blocState
                                                                  .goldPrices[i]
                                                                  .bidPrice;
                                                      bidPriceController.text =
                                                          currentUpdateBidPrice
                                                              .toString();
                                                      askPriceController.text =
                                                          currentUpdateAskPrice
                                                              .toString();

                                                      context
                                                          .read<GoldPriceBloc>()
                                                          .add(
                                                              UpdateIndexChange(
                                                                  updateIndex:
                                                                      i));
                                                    },
                                                    icon: const Icon(
                                                        Icons.edit_rounded)),
                                              )
                                            ])
                                          : DataRow(cells: [
                                              DataCell(Text(goldPrices[i]
                                                  .goldType
                                                  .tr(context))),
                                              DataCell(TextField(
                                                controller: askPriceController,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: AppStrings
                                                      .strAskPrice
                                                      .tr(context),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (text) {
                                                  context.read<GoldPriceBloc>();
                                                },
                                              )),
                                              DataCell(TextField(
                                                controller: bidPriceController,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: AppStrings
                                                      .strBidPrice
                                                      .tr(context),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              )),
                                              DataCell(
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 0.08.sw,
                                                      child: IconButton(
                                                          padding:
                                                              REdgeInsets.all(
                                                                  0),
                                                          onPressed: () {
                                                            if (askPriceController
                                                                    .text
                                                                    .trim()
                                                                    .isEmpty ||
                                                                bidPriceController
                                                                    .text
                                                                    .trim()
                                                                    .isEmpty) {
                                                              showSnackBar(
                                                                  context,
                                                                  ToastificationType
                                                                      .error,
                                                                  AppStrings
                                                                      .strEmptyField,
                                                                  true);
                                                            } else {
                                                              context.read<GoldPriceBloc>().add(UpdatedDataChange(
                                                                  updateAskPrice:
                                                                      int.parse(
                                                                          askPriceController
                                                                              .text),
                                                                  updateBidPrice:
                                                                      int.parse(
                                                                          bidPriceController
                                                                              .text)));
                                                            }
                                                          },
                                                          icon: const Icon(Icons
                                                              .check_rounded)),
                                                    ),
                                                    SizedBox(
                                                      width: 0.08.sw,
                                                      child: IconButton(
                                                          padding:
                                                              REdgeInsets.all(
                                                                  0),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    GoldPriceBloc>()
                                                                .add(const UpdateIndexChange(
                                                                    updateIndex:
                                                                        -1));
                                                          },
                                                          icon: const Icon(Icons
                                                              .close_rounded)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                    ],
                                  ]);
                            default:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                          }
                        }),
                        SizedBox(
                          height: 10.h,
                        ),
                        SubmitCancelButton(
                          submitText: AppStrings.strSave.tr(context),
                          cancelText: AppStrings.strRefresh.tr(context),
                          onCancel: () {
                            context.read<GoldPriceBloc>().add(GoldPriceLoad());
                          },
                          onSubmit: () {
                            context.read<GoldPriceBloc>().add(GoldPricesSave());
                          },
                          cancelIcon: Icons.refresh_rounded,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
