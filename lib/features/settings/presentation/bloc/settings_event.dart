part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsInit extends SettingsEvent{}

final class ProfileChange extends SettingsEvent {
  final ProfileModel updateProfile;

  const ProfileChange({required this.updateProfile});
}

final class ProfileSave extends SettingsEvent {}

final class AccountChange extends SettingsEvent {
  final UserModel updateAccount;

  const AccountChange({required this.updateAccount});
}

final class AccountSave extends SettingsEvent {
  final String oldPassword;

  const AccountSave({required this.oldPassword});
}

final class PasswordSave extends SettingsEvent {
  final String newPassword;
  final String oldPassword;

  const PasswordSave({required this.oldPassword, required this.newPassword});
}

final class AccountRemove extends SettingsEvent {}

final class Logout extends SettingsEvent {}
