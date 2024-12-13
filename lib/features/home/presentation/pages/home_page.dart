import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/cubits/app_profile/app_profile_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../gold_price/presentation/bloc/gold_price_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<HomeBloc>()..add(ProfileLoad()),
        ),
        BlocProvider.value(
          value: context.read<GoldPriceBloc>()..add(GoldPriceLoad()),
        ),
        BlocProvider.value(
          value: context.read<AppUserCubit>(),
        ),
        BlocProvider.value(
          value: context.read<AppProfileCubit>(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppProfileCubit, AppProfileState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AppProfileLoaded) {
          context.read<AuthBloc>().add(BindFcmToken());
        }
      },
      child: Container(
          color: Colors.white,
          height: 100.h,
          child: SafeArea(
            child: Padding(
              padding: REdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: REdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/card_image.jpg"),
                                fit: BoxFit.fill),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.r,
                                offset: const Offset(4, 8), // Shadow position
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: 170.h,
                          child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.strStoreName.tr(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  BlocSelector<AppProfileCubit, AppProfileState,
                                      String>(
                                    selector: (state) {
                                      return (state is AppProfileLoaded)
                                          ? '${state.profile.firstName} ${state.profile.lastName}'
                                          : Constants.empty;
                                    },
                                    builder: (context, name) {
                                      return Text(
                                        name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      );
                                    },
                                  ),
                                  BlocSelector<AppUserCubit, AppUserState,
                                      String>(
                                    selector: (state) {
                                      return (state is AppUserLoggedIn)
                                          ? state.user.role.tr(context)
                                          : Constants.empty;
                                    },
                                    builder: (context, role) {
                                      return Text(
                                        role,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      );
                                    },
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Danh mục",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GridView.count(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                          children: [
                            FeatureIcon(
                                label: AppStrings.strJewelryTradingPage
                                    .tr(context),
                                icon: Icons.payments_outlined,
                                page: 'CreateOrderPage'),
                            FeatureIcon(
                                label: AppStrings.strPlainRingTradingPage
                                    .tr(context),
                                icon: Icons.auto_fix_high_outlined,
                                page: 'ExchangeGoldPage'),
                            FeatureIcon(
                                label:
                                    AppStrings.strReviewOrderPage.tr(context),
                                icon: Icons.manage_search_rounded,
                                page: 'CheckOrderPage'),
                            FeatureIcon(
                                label: AppStrings.strGoldPriceAdjustmentPage
                                    .tr(context),
                                icon: Icons.edit_note_rounded,
                                page: 'ChangeGoldPricePage'),
                          ]),
                      Text(
                        "Thông báo",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        padding: REdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Row(
                          children: [
                            Container(
                              width: 0.08.sh,
                              height: 0.08.sh,
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/price_chart.png')),
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            Expanded(
                                child: Container(
                                  padding: REdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Gold Price changes",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                                      "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                                      ". Ut enim ad minim veniam, Lorem ipsum dolor sit amet, , ",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis)
                                ],
                              ),
                            ))
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          )),
    );
  }
}
