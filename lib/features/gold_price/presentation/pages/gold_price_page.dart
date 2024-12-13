import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';
import '../bloc/gold_price_bloc.dart';

class GoldPricePage extends StatelessWidget {
  const GoldPricePage({super.key});

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
      child: const GoldPriceView(),
    );
  }
}

class GoldPriceView extends StatelessWidget {
  const GoldPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: REdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            AppStrings.strGoldRates.tr(context),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 10.h,
          ),
          BlocBuilder<AppGoldPriceCubit, AppGoldPriceState>(
            builder: (context, state) {
              return (state is AppGoldPriceInitial)
                  ? SizedBox(
                      height: 0.6.sh,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DataTable(
                      showBottomBorder: true,
                      dataRowMaxHeight: 60.sp,
                      horizontalMargin: 0,
                      columns: [
                          DataColumn(
                              label: Text(
                            AppStrings.strGoldType.tr(context),
                            style: Theme.of(context).textTheme.titleSmall,
                          )),
                          DataColumn(
                              label: Text(
                                AppStrings.strAskPrice.tr(context),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              numeric: true),
                          DataColumn(
                              label: Text(
                                AppStrings.strBidPrice.tr(context),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              numeric: true),
                        ],
                      rows: [
                          if (state is AppGoldPriceLoaded)
                            for (var goldPrice in state.goldPrices) ...[
                              DataRow(
                                cells: [
                                  DataCell(
                                      Text(goldPrice.goldType.tr(context))),
                                  DataCell(Text(goldPrice.askPrice.toString())),
                                  DataCell(Text(goldPrice.bidPrice.toString())),
                                ],
                              ),
                            ],
                        ]);
            },
          )
        ]),
      ),
    );
  }
}
