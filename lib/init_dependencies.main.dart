part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<String> _generateSecureKey(int length) async {
  Random random = Random();
  int randomNumber = random.nextInt(900) + 100;
  return randomNumber.toString();
}

Future<void> handleBackGroundMessage(RemoteMessage message) async {
  print('handleBackGroundMessage');
}

void handleMessage(RemoteMessage? message) {
  print('handleMessage');
  if (message == null) return;
}

Future<void> initDependencies() async {
  _initAuth();
  _initProfile();
  _initGoldPrice();
  _initOrder();
  _initContact();
  _initSetting();

  usePathUrlStrategy();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Bloc.observer = const MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(provisional: true);

  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
  }
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  serviceLocator
      .registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);

  serviceLocator.registerFactory(() => InternetConnection());

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'products'),
  );

  final encryptionKey = await _generateSecureKey(3);

  //Android options for key management
  AndroidOptions androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  // iOS options for key management
  IOSOptions iosOptions = IOSOptions(
      accountName: encryptionKey,
      accessibility: KeychainAccessibility.first_unlock);

  serviceLocator.registerLazySingleton<FlutterSecureStorage>(() =>
      FlutterSecureStorage(aOptions: androidOptions, iOptions: iosOptions));

  // SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // AppPreferences instance
  serviceLocator.registerLazySingleton<AppPreferences>(
      () => AppPreferences(serviceLocator(), serviceLocator()));

  // FirebaseStorage instance
  serviceLocator.registerSingleton(() => FirebaseStorage.instance);

  //DioFactory instance
  serviceLocator
      .registerLazySingleton<DioFactory>(() => DioFactory(serviceLocator()));

  final dio = await serviceLocator<DioFactory>().getDio();

  //AppServiceClient instance
  serviceLocator.registerLazySingleton(() => ApiService(dio));

  // core
  serviceLocator.registerSingleton<AppUserCubit>(AppUserCubit());
  serviceLocator
      .registerLazySingleton<AppProfileCubit>(() => AppProfileCubit());
  serviceLocator
      .registerLazySingleton<AppGoldPriceCubit>(() => AppGoldPriceCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Repository
  serviceLocator
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        serviceLocator(), serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<UserLogin>(() => UserLogin(serviceLocator()))
    ..registerFactory<UserRegister>(() => UserRegister(serviceLocator()))
    ..registerFactory<BindToken>(() => BindToken(serviceLocator()))
    // Bloc
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(
          userRegister: serviceLocator(),
          userLogin: serviceLocator(),
          bindToken: serviceLocator(),
          appUserCubit: serviceLocator(),
          firebaseMessaging: serviceLocator(),
        ));
}

void _initGoldPrice() {
  // Repository
  serviceLocator
    ..registerFactory<GoldPriceRepository>(
        () => GoldPriceRepositoryImpl(serviceLocator(), serviceLocator()))
    ..registerFactory<NotificationRepository>(
        () => NotificationRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<LoadGoldPrices>(() => LoadGoldPrices(serviceLocator()))
    ..registerFactory<UpdateGoldPrices>(
        () => UpdateGoldPrices(serviceLocator()))
    ..registerFactory<CreateNotification>(
        () => CreateNotification(serviceLocator()))
    // Bloc
    ..registerLazySingleton<GoldPriceBloc>(() => GoldPriceBloc(
          loadGoldPrices: serviceLocator(),
          updateGoldPrices: serviceLocator(),
          createNotification: serviceLocator(),
          appGoldPriceCubit: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

void _initProfile() {
  // Repository
  serviceLocator
    ..registerFactory<ProfileRepository>(
        () => ProfileRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<LoadProfile>(() => LoadProfile(serviceLocator()))
    // Bloc
    ..registerLazySingleton<HomeBloc>(() => HomeBloc(
        loadProfile: serviceLocator(),
        appUserCubit: serviceLocator(),
        appProfileCubit: serviceLocator()));
}

void _initOrder() {
  // Data source
  serviceLocator
    ..registerFactory<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(serviceLocator()))
    // Repository
    ..registerFactory<ProductRepository>(() => ProductRepositoryImpl(
        serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerFactory<OrderRepository>(
        () => OrderRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<LoadProduct>(() => LoadProduct(serviceLocator()))
    ..registerFactory<CreateOrder>(() => CreateOrder(serviceLocator()))
    // Bloc
    ..registerLazySingleton<OrderBloc>(() => OrderBloc(
        loadProduct: serviceLocator(),
        createOrder: serviceLocator(),
        userCubit: serviceLocator(),
        goldPriceCubit: serviceLocator()));
}

void _initContact() {
  // Repository
  serviceLocator
    ..registerFactory<ContactRepository>(
        () => ContactRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<LoadSearchData>(() => LoadSearchData(serviceLocator()))
    ..registerFactory<LoadContacts>(() => LoadContacts(serviceLocator()))
    ..registerFactory<SearchContacts>(() => SearchContacts(serviceLocator()))
    ..registerFactory<CreateContact>(() => CreateContact(serviceLocator()))
    ..registerFactory<UpdateContact>(() => UpdateContact(serviceLocator()))
    ..registerFactory<DeleteContact>(() => DeleteContact(serviceLocator()))
    // Bloc
    ..registerLazySingleton<ContactBloc>(() => ContactBloc(
          loadContacts: serviceLocator(),
          searchContacts: serviceLocator(),
          loadSearchData: serviceLocator(),
          createContact: serviceLocator(),
          updateContact: serviceLocator(),
          deleteContact: serviceLocator(),
        ));
}

void _initSetting() {
  // Repository
  serviceLocator
    ..registerFactory<AccountRepository>(
        () => AccountRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecase
    ..registerFactory<UpdateProfile>(() => UpdateProfile(serviceLocator()))
    ..registerFactory<UpdateAccount>(() => UpdateAccount(serviceLocator()))
    ..registerFactory<UpdatePassword>(() => UpdatePassword(serviceLocator()))
    ..registerFactory<DeleteAccount>(() => DeleteAccount(serviceLocator()))
    // Bloc
    ..registerLazySingleton<SettingsBloc>(() => SettingsBloc(
        updateProfile: serviceLocator(),
        updateAccount: serviceLocator(),
        updatePassword: serviceLocator(),
        deleteAccount: serviceLocator(),
        appUserCubit: serviceLocator(),
        appProfileCubit: serviceLocator()));
}
