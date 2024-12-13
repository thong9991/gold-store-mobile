import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterView();
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            SizedBox(
              width: 0.9.sw,
              child: CustomTextField(
                  controller: usernameController,
                  hintText: AppStrings.strUsername.tr(context),
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.strUsernameRequired.tr(context);
                    } else if (val.length > 30) {
                      return AppStrings.strLongUsername.tr(context);
                    }
                    return null;
                  }),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 0.9.sw,
              child: CustomTextField(
                  controller: passwordController,
                  hintText: AppStrings.strPassword.tr(context),
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  onChanged: (val) {
                    if (val!.contains(RegExp(r'[A-Z]'))) {
                      setState(() {
                        containsUpperCase = true;
                      });
                    } else {
                      setState(() {
                        containsUpperCase = false;
                      });
                    }
                    if (val.contains(RegExp(r'[a-z]'))) {
                      setState(() {
                        containsLowerCase = true;
                      });
                    } else {
                      setState(() {
                        containsLowerCase = false;
                      });
                    }
                    if (val.contains(RegExp(r'[0-9]'))) {
                      setState(() {
                        containsNumber = true;
                      });
                    } else {
                      setState(() {
                        containsNumber = false;
                      });
                    }
                    if (val.contains(RegExp(
                        r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                      setState(() {
                        containsSpecialChar = true;
                      });
                    } else {
                      setState(() {
                        containsSpecialChar = false;
                      });
                    }
                    if (val.length >= 8) {
                      setState(() {
                        contains8Length = true;
                      });
                    } else {
                      setState(() {
                        contains8Length = false;
                      });
                    }
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
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.strPasswordRequired.tr(context);
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                        .hasMatch(val)) {
                      return AppStrings.strInvalidPassword.tr(context);
                    }
                    return null;
                  }),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 ${AppStrings.strUppercase.tr(context)}",
                      style: TextStyle(
                          color: containsUpperCase
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  1 ${AppStrings.strLowercase.tr(context)}",
                      style: TextStyle(
                          color: containsLowerCase
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  1 ${AppStrings.strNumber.tr(context)}",
                      style: TextStyle(
                          color: containsNumber
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 ${AppStrings.strSpecialCharacter.tr(context)}",
                      style: TextStyle(
                          color: containsSpecialChar
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  8 ${AppStrings.strMinCharacter.tr(context)}",
                      style: TextStyle(
                          color: contains8Length
                              ? Colors.green
                              : Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 0.9.sw,
              child: CustomTextField(
                  controller: emailController,
                  hintText: AppStrings.strEmail.tr(context),
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.strEmailRequired.tr(context);
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return AppStrings.strInvalidEmail.tr(context);
                    }
                    return null;
                  }),
            ),
            SizedBox(height: 0.02.sh),
            !signUpRequired
                ? SizedBox(
                    width: 0.5.sw,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthRegister(
                                email: emailController.text,
                                username: usernameController.text,
                                password: passwordController.text));
                          }
                        },
                        style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: AppPalette.lightBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.r))),
                        child: Padding(
                          padding: REdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Text(
                            AppStrings.strSignUp.tr(context),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        )),
                  )
                : const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
