part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthRegister extends AuthEvent {
  final String email;
  final String username;
  final String password;

  const AuthRegister({
    required this.email,
    required this.username,
    required this.password,
  });
}

final class AuthLogin extends AuthEvent {
  final String username;
  final String password;

  const AuthLogin({
    required this.username,
    required this.password,
  });
}

final class BindFcmToken extends AuthEvent {}

final class ChangeLoginStatus extends AuthEvent {
  final LoginStatus status;

  const ChangeLoginStatus({required this.status});
}

final class ChangeRegisterStatus extends AuthEvent {
  final RegisterStatus status;

  const ChangeRegisterStatus({required this.status});
}
