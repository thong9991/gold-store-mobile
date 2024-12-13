part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure, loaded }

enum UpdateProfileStatus { initial, loading, success, failure }

enum UpdateAccountStatus { initial, loading, success, failure }

enum UpdatePasswordStatus { initial, loading, success, failure }

enum DeleteAccountStatus { initial, loading, success, failure }

final class SettingsState extends Equatable {
  const SettingsState({
    this.settingsStatus = SettingsStatus.initial,
    this.updateProfileStatus = UpdateProfileStatus.initial,
    this.updateAccountStatus = UpdateAccountStatus.initial,
    this.updatePasswordStatus = UpdatePasswordStatus.initial,
    this.deleteAccountStatus = DeleteAccountStatus.initial,
    this.updateProfile = ProfileModel.empty,
    this.updateUser = UserModel.empty,
    this.message = Constants.empty,
  });

  final SettingsStatus settingsStatus;
  final UpdateProfileStatus updateProfileStatus;
  final UpdateAccountStatus updateAccountStatus;
  final UpdatePasswordStatus updatePasswordStatus;
  final DeleteAccountStatus deleteAccountStatus;
  final ProfileModel updateProfile;
  final UserModel updateUser;
  final String message;

  SettingsState copyWith(
      {SettingsStatus? settingsStatus,
      UpdateProfileStatus? updateProfileStatus,
      UpdateAccountStatus? updateAccountStatus,
      UpdatePasswordStatus? updatePasswordStatus,
      DeleteAccountStatus? deleteAccountStatus,
      ProfileModel? updateProfile,
      UserModel? updateUser,
      String? message}) {
    return SettingsState(
        settingsStatus: settingsStatus ?? this.settingsStatus,
        updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
        updateAccountStatus: updateAccountStatus ?? this.updateAccountStatus,
        updatePasswordStatus: updatePasswordStatus ?? this.updatePasswordStatus,
        deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
        updateProfile: updateProfile ?? this.updateProfile,
        updateUser: updateUser ?? this.updateUser,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [
        settingsStatus,
        updateProfileStatus,
        updateAccountStatus,
        updatePasswordStatus,
        deleteAccountStatus,
        updateProfile,
        updateUser,
        message,
      ];
}
