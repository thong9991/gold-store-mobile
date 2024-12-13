import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/animations/page_transition.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/widgets.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<SettingsBloc>()..add(SettingsInit()),
        child: const ChangePasswordView());
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController oldPasswordController = TextEditingController();
  IconData iconOldPassword = CupertinoIcons.eye_fill;
  bool obscureOldPassword = true;

  final TextEditingController newPasswordController = TextEditingController();
  IconData iconNewPassword = CupertinoIcons.eye_fill;
  bool obscureNewPassword = true;

  final TextEditingController confirmPasswordController =
      TextEditingController();
  IconData iconConfirmPassword = CupertinoIcons.eye_fill;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          Constants.empty,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 20),
            child: BlocListener<SettingsBloc, SettingsState>(
                listenWhen: (previous, current) {
                  return previous.updatePasswordStatus !=
                      current.updatePasswordStatus;
                },
                listener: (context, state) {
                  if (state.updatePasswordStatus ==
                      UpdatePasswordStatus.success) {
                    context.pop();
                  }
                },
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (previous, current) {
                    return previous.updatePasswordStatus !=
                        current.updatePasswordStatus;
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Center(
                            child: ImageIcon(
                          AssetImage("assets/images/change_password.png"),
                          color: Colors.black,
                          size: 200.sp,
                        )),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 0.9.sw,
                          child: CustomTextField(
                            controller: oldPasswordController,
                            hintText: AppStrings.strOldPassword.tr(context),
                            obscureText: obscureOldPassword,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: state.updatePasswordStatus ==
                                UpdatePasswordStatus.loading,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            validator: (val) {
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureOldPassword = !obscureOldPassword;
                                  if (obscureOldPassword) {
                                    iconOldPassword = CupertinoIcons.eye_fill;
                                  } else {
                                    iconOldPassword =
                                        CupertinoIcons.eye_slash_fill;
                                  }
                                });
                              },
                              icon: Icon(iconOldPassword),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 0.9.sw,
                          child: CustomTextField(
                            controller: newPasswordController,
                            hintText: AppStrings.strNewPassword.tr(context),
                            obscureText: obscureNewPassword,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: state.updatePasswordStatus ==
                                UpdatePasswordStatus.loading,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            validator: (val) {
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureNewPassword = !obscureNewPassword;
                                  if (obscureNewPassword) {
                                    iconNewPassword = CupertinoIcons.eye_fill;
                                  } else {
                                    iconNewPassword =
                                        CupertinoIcons.eye_slash_fill;
                                  }
                                });
                              },
                              icon: Icon(iconNewPassword),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 0.9.sw,
                          child: CustomTextField(
                            controller: confirmPasswordController,
                            hintText: AppStrings.strConfirmPassword.tr(context),
                            obscureText: obscureConfirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: state.updatePasswordStatus ==
                                UpdatePasswordStatus.loading,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            validator: (val) {
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                  if (obscureConfirmPassword) {
                                    iconConfirmPassword =
                                        CupertinoIcons.eye_fill;
                                  } else {
                                    iconConfirmPassword =
                                        CupertinoIcons.eye_slash_fill;
                                  }
                                });
                              },
                              icon: Icon(iconConfirmPassword),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor: AppPalette.lightBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.r)),
                            ),
                            onPressed: () {
                              if (oldPasswordController.text.isEmpty) {
                                showSnackBar(context, ToastificationType.error,
                                    AppStrings.strPasswordRequired, true);
                                return;
                              }
                              if (newPasswordController.text.isEmpty) {
                                showSnackBar(context, ToastificationType.error,
                                    AppStrings.strNewPasswordRequired, true);
                                return;
                              }
                              if (newPasswordController.text != confirmPasswordController.text) {
                                showSnackBar(context, ToastificationType.error,
                                    AppStrings.strConfirmPasswordRequired, true);
                                return;
                              }
                              if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                showSnackBar(context, ToastificationType.error,
                                    AppStrings.strChangePassword, true);
                              }

                              context.read<SettingsBloc>().add(PasswordSave(
                                  oldPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text));
                            },
                            child: Padding(
                              padding: REdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Text(
                                AppStrings.strChangePassword.tr(context),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ))
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
