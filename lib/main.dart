import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:toastification/toastification.dart';

import 'core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import 'core/common/cubits/app_profile/app_profile_cubit.dart';
import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/route/route.dart';
import 'core/theme/theme.dart';
import 'core/utils/language_manager.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/contact/presentation/bloc/contact_bloc.dart';
import 'features/gold_price/presentation/bloc/gold_price_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/order/presentation/bloc/order_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'init_dependencies.dart';

Future<void> _handleBackGroundMessage(RemoteMessage message) async {
  print('handleBackGroundMessage');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

void handleMessage(RemoteMessage? message) {
  print('handleMessage');
  if(message == null) return;
  print(message.data);
  var goldPriceBloc = serviceLocator<GoldPriceBloc>();
  if (message.data.keys.isNotEmpty) {
    print(message.data.keys);
    goldPriceBloc.add(GoldPriceLoad());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleBackGroundMessage);
  Timer? debounce;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage");
    var goldPriceBloc = serviceLocator<GoldPriceBloc>();
    if (message.data.keys.isNotEmpty) {
      goldPriceBloc.add(GoldPriceChangeNotification(updatedData: message.data));
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 1000), () {
        print("debounce");
        goldPriceBloc.add(GoldPriceLoad());
      });
    }
  });
  serviceLocator<Box>().clear();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AppProfileCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AppGoldPriceCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<GoldPriceBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<HomeBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<OrderBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<ContactBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<SettingsBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocListener<AppUserCubit, AppUserState>(
            listener: (context, state) {
              routers.refresh();
            },
            child: ToastificationWrapper(
              child: MaterialApp.router(
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: const [ENGLISH_LOCAL, VIETNAM_LOCAL],
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (deviceLocale != null &&
                        deviceLocale.languageCode == locale.languageCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                routerConfig: routers,
                debugShowCheckedModeBanner: false,
                title: 'Gold store',
                theme: themeData,
              ),
            ),
          );
        });
  }
}
