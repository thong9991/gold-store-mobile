import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/animations/page_transition.dart';
import '../../../../core/common/cubits/app_profile/app_profile_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/profile.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../auth/data/models/user.dart';
import '../../../home/data/models/profile.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/widgets.dart';

class ChangeAccessInformationPage extends StatelessWidget {
  const ChangeAccessInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<SettingsBloc>()..add(SettingsInit()),
        child: const ChangeAccessInformationView());
  }
}

class ChangeAccessInformationView extends StatefulWidget {
  const ChangeAccessInformationView({super.key});

  @override
  State<ChangeAccessInformationView> createState() =>
      _ChangeAccessInformationViewState();
}

class _ChangeAccessInformationViewState
    extends State<ChangeAccessInformationView> {
  final TextEditingController oldPasswordController = TextEditingController();
  IconData iconOldPassword = CupertinoIcons.eye_fill;
  bool obscureOldPassword = true;

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
                return previous.updateAccountStatus !=
                    current.updateAccountStatus;
              },
              listener: (context, state) {
                if (state.updateAccountStatus == UpdateAccountStatus.success) {
                  context.pop();
                }
              },
              child: Builder(
                builder: (context) {
                  SettingsBloc settingsBloc = context.read<SettingsBloc>();
                  UserEntity user =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user;
                  return Column(
                    children: [
                      Center(
                          child: ImageIcon(
                        AssetImage("assets/images/change_account_info.png"),
                        color: Colors.black,
                        size: 200.sp,
                      )),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        initialValue:
                            settingsBloc.state.updateUser.email.isNotEmpty
                                ? settingsBloc.state.updateUser.email
                                : user.email,
                        hintText: AppStrings.strEmail.tr(context),
                        prefixIcon: const Icon(CupertinoIcons.mail_solid),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          settingsBloc.add(AccountChange(
                              updateAccount: UserModel.fromEntity(
                                      settingsBloc.state.updateUser)
                                  .copyWith(email: value)));
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        hintText: AppStrings.strUsername.tr(context),
                        initialValue:
                            settingsBloc.state.updateUser.username.isNotEmpty
                                ? settingsBloc.state.updateUser.username
                                : user.username,
                        prefixIcon: const Icon(CupertinoIcons.person_fill),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          settingsBloc.add(AccountChange(
                              updateAccount: UserModel.fromEntity(
                                      settingsBloc.state.updateUser)
                                  .copyWith(username: value)));
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 0.9.sw,
                        child: CustomTextField(
                          controller: oldPasswordController,
                          hintText: AppStrings.strOldPassword.tr(context),
                          obscureText: obscureOldPassword,
                          keyboardType: TextInputType.visiblePassword,
                          readOnly: settingsBloc.state.updateAccountStatus ==
                              UpdateAccountStatus.loading,
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
                            context.read<SettingsBloc>().add(AccountSave(
                                oldPassword: oldPasswordController.text));
                          },
                          child: Padding(
                            padding: REdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              AppStrings.strSaveAccount.tr(context),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ))
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
