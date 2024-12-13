import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';
import '../../data/models/dtos/bind_token_request.dart';
import '../../data/models/dtos/login_request.dart';
import '../../data/models/dtos/register_request.dart';
import '../../domain/usecases/bind_token.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_register.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRegister _userRegister;
  final UserLogin _userLogin;
  final BindToken _bindToken;
  final AppUserCubit _appUserCubit;
  final FirebaseMessaging _firebaseMessaging;

  AuthBloc({
    required UserRegister userRegister,
    required UserLogin userLogin,
    required BindToken bindToken,
    required AppUserCubit appUserCubit,
    required FirebaseMessaging firebaseMessaging,
  })  : _userRegister = userRegister,
        _userLogin = userLogin,
        _bindToken = bindToken,
        _appUserCubit = appUserCubit,
        _firebaseMessaging = firebaseMessaging,
        super(const AuthState()) {
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
    on<BindFcmToken>(_onBindFcmToken);
    on<ChangeLoginStatus>(_onChangeLoginStatus);
    on<ChangeRegisterStatus>(_onChangeRegisterStatus);
  }

  void _onAuthRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(registerStatus: RegisterStatus.loading));

    final res = await _userRegister(
      RegisterRequestDto(
        email: event.email,
        username: event.username,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(state.copyWith(
          registerStatus: RegisterStatus.failure, message: failure.message)),
      (message) => emit(state.copyWith(
          registerStatus: RegisterStatus.success, message: message)),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    final res = await _userLogin(
      LoginRequestDto(
        username: event.username,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(state.copyWith(
          loginStatus: LoginStatus.failure, message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onBindFcmToken(
    BindFcmToken event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    final fcmToken = await _firebaseMessaging.getToken();
    if ((_appUserCubit.state as AppUserLoggedIn).user.fcmToken == fcmToken) {
      return;
    }

    final userId = (_appUserCubit.state as AppUserLoggedIn).user.id;

    final res = await _bindToken(
        BindTokenRequestDto(userId: userId, fcmToken: fcmToken ?? ""));

    res.fold(
      (failure) => emit(state.copyWith(
          loginStatus: LoginStatus.failure, message: failure.message)),
      (result) {},
    );
  }

  void _onChangeLoginStatus(
    ChangeLoginStatus event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(loginStatus: event.status));
  }

  void _onChangeRegisterStatus(
    ChangeRegisterStatus event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(registerStatus: event.status));
  }

  void _emitAuthSuccess(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(state.copyWith(
      loginStatus: LoginStatus.success,
    ));
  }
}
