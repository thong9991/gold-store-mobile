import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingView();
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        return previous.updatePasswordStatus != current.updatePasswordStatus ||
            previous.updateAccountStatus != current.updateAccountStatus;
      },
      listener: (context, state) {
        if (state.updatePasswordStatus == UpdatePasswordStatus.success) {
          showSnackBar(context, ToastificationType.success,
              AppStrings.strChangePasswordSuccessful, true);
          context.read<SettingsBloc>().add(SettingsInit());
        }
        if (state.updateAccountStatus == UpdateAccountStatus.success) {
          showSnackBar(context, ToastificationType.success,
              AppStrings.strSaveAccountSuccessful, true);
          context.read<SettingsBloc>().add(SettingsInit());
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: REdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    padding: REdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        FeatureLine(
                          page: "ChangeProfilePage",
                          featureLabel: "Change profile",
                          icon: Icons.person_rounded,
                        ),
                        Divider(color: Colors.grey.shade300, thickness: 0.5.w),
                        FeatureLine(
                          page: "ChangeAccessInformationPage",
                          featureLabel: "Change access information",
                          icon: Icons.admin_panel_settings_rounded,
                        ),
                        Divider(color: Colors.grey.shade300, thickness: 0.5.w),
                        FeatureLine(
                          page: "ChangePasswordPage",
                          featureLabel: "Change password",
                          icon: Icons.lock_reset_rounded,
                        ),
                        Divider(color: Colors.grey.shade300, thickness: 0.5.w),
                        FeatureLine(
                          onTap: () {},
                          featureLabel: "Delete account",
                          icon: Icons.person_off_rounded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Material(
                    child: Ink(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: Colors.white),
                      child: InkWell(
                        onTap: () {
                          context.read<SettingsBloc>().add(Logout());
                        },
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                              size: 25.sp,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Đăng xuất",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.redAccent),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureLine extends StatelessWidget {
  const FeatureLine({
    super.key,
    required this.featureLabel,
    required this.icon,
    this.page,
    this.onTap,
  });

  final String? page;
  final Function()? onTap;
  final String featureLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: page != null
            ? () {
                context.push("/SettingsPage/$page");
              }
            : onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 25.r,
              color: Colors.green.shade900,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              featureLabel,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.green.shade900),
            )
          ],
        ),
      ),
    );
  }
}
