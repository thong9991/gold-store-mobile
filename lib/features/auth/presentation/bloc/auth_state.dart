part of 'auth_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

enum RegisterStatus { initial, loading, success, failure }

final class AuthState extends Equatable {
  const AuthState({
    this.loginStatus = LoginStatus.initial,
    this.registerStatus = RegisterStatus.initial,
    this.username = Constants.empty,
    this.password = Constants.empty,
    this.email = Constants.empty,
    this.message = Constants.empty,
  });

  final LoginStatus loginStatus;
  final RegisterStatus registerStatus;
  final String username;
  final String password;
  final String email;
  final String message;

  AuthState copyWith(
      {LoginStatus? loginStatus,
      RegisterStatus? registerStatus,
      String? username,
      String? password,
      String? email,
      String? message}) {
    return AuthState(
        loginStatus: loginStatus ?? this.loginStatus,
        registerStatus: registerStatus ?? this.registerStatus,
        username: username ?? this.username,
        password: password ?? this.password,
        email: email ?? this.email,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props =>
      [loginStatus, registerStatus, username, password, email, message];
}
