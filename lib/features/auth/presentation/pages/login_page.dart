import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                    width: 0.9.sw,
                    child: CustomTextField(
                        controller: usernameController,
                        hintText: AppStrings.strUsername.tr(context),
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: state.loginStatus == LoginStatus.loading,
                        prefixIcon: const Icon(CupertinoIcons.person_alt),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return AppStrings.strUsernameRequired.tr(context);
                          }
                          return null;
                        })),
                SizedBox(height: 10.h),
                SizedBox(
                  width: 0.9.sw,
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: AppStrings.strPassword.tr(context),
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    readOnly: state.loginStatus == LoginStatus.loading,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppStrings.strPasswordRequired.tr(context);
                      }
                      // else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
                      //   return 'Please enter a valid password';
                      // }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          if (obscurePassword) {
                            iconPassword = CupertinoIcons.eye_fill;
                          } else {
                            iconPassword = CupertinoIcons.eye_slash_fill;
                          }
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                !signInRequired
                    ? SizedBox(
                        width: 0.5.sw,
                        child: TextButton(
                            onPressed: state.loginStatus == LoginStatus.loading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(AuthLogin(
                                          username: usernameController.text,
                                          password: passwordController.text));
                                    }
                                  },
                            style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor: AppPalette.lightBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.r)),
                            ),
                            child: Padding(
                              padding: REdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Text(
                                AppStrings.strSignIn.tr(context),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            )),
                      )
                    : const CircularProgressIndicator(),
              ],
            ));
      },
    );
  }
}
