import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeView();
  }
}

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin<WelcomeView> {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              return previous.registerStatus != current.registerStatus;
            },
            listener: (context, state) {
              if (state.registerStatus == RegisterStatus.success) {
                showSnackBar(context, ToastificationType.success,
                    AppStrings.strRegisterSuccessful, true);
                tabController.index = 0;
              }
              if (state.registerStatus == RegisterStatus.failure) {
                showSnackBar(context, ToastificationType.error, state.message,
                    state.message.split(" ").length < 4);
              }
              context.read<AuthBloc>().add(
                  const ChangeRegisterStatus(status: RegisterStatus.initial));
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) {
              return previous.loginStatus != current.loginStatus;
            },
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.failure) {
                showSnackBar(context, ToastificationType.error, state.message,
                    state.message.split(" ").length < 4);
              }
              context
                  .read<AuthBloc>()
                  .add(const ChangeLoginStatus(status: LoginStatus.initial));
            },
          ),
        ],
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh,
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(20, -1.2),
                  child: Container(
                    height: 1.sw,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppPalette.gradient1),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-2.7, -1.2),
                  child: Container(
                    height: 0.75.sw,
                    width: 0.75.sw,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppPalette.gradient2),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(2.7, -1.2),
                  child: Container(
                    height: 0.75.sw,
                    width: 0.75.sw,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppPalette.gradient3),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 1.3.sw,
                    child: Column(
                      children: [
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 40.w),
                          child: TabBar(
                            controller: tabController,
                            unselectedLabelColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            labelColor: Theme.of(context).colorScheme.onSurface,
                            tabs: [
                              Padding(
                                padding: REdgeInsets.all(12),
                                child: SizedBox(
                                  width: (1.sw - 80.w) / 2,
                                  child: Center(
                                    child: Text(
                                      AppStrings.strSignIn.tr(context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: REdgeInsets.all(12),
                                child: SizedBox(
                                  width: (1.sw - 80.w) / 2,
                                  child: Center(
                                    child: Text(
                                      AppStrings.strSignUp.tr(context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: tabController,
                          children: const [LoginPage(), RegisterPage()],
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
