import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_profile/app_profile_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/profile.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';
import '../../../auth/data/models/user.dart';
import '../../../home/data/models/profile.dart';
import '../../data/models/dtos/update_account_request.dart';
import '../../data/models/dtos/update_password_request.dart';
import '../../data/models/dtos/update_profile_request.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/update_account.dart';
import '../../domain/usecases/update_password.dart';
import '../../domain/usecases/update_profile.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UpdateProfile _updateProfile;
  final UpdateAccount _updateAccount;
  final UpdatePassword _updatePassword;
  final DeleteAccount _deleteAccount;
  final AppProfileCubit _appProfileCubit;
  final AppUserCubit _appUserCubit;

  SettingsBloc({
    required UpdateProfile updateProfile,
    required UpdateAccount updateAccount,
    required UpdatePassword updatePassword,
    required DeleteAccount deleteAccount,
    required AppProfileCubit appProfileCubit,
    required AppUserCubit appUserCubit,
  })  : _updateProfile = updateProfile,
        _updateAccount = updateAccount,
        _updatePassword = updatePassword,
        _deleteAccount = deleteAccount,
        _appProfileCubit = appProfileCubit,
        _appUserCubit = appUserCubit,
        super(SettingsState()) {
    on<SettingsInit>(_onSettingsInit);
    on<ProfileChange>(_onProfileChange);
    on<ProfileSave>(_onProfileSave);
    on<AccountChange>(_onAccountChange);
    on<AccountSave>(_onAccountSave);
    on<PasswordSave>(_onPasswordSave);
    on<AccountRemove>(_onAccountRemove);
    on<Logout>(_onLogout);
  }
  void _onSettingsInit(
      SettingsInit event,
      Emitter<SettingsState> emit,
      ) async {
    emit(const SettingsState());
  }

  void _onProfileChange(
    ProfileChange event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateProfile: event.updateProfile));
  }

  void _onProfileSave(
    ProfileSave event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));

    int userId = (_appUserCubit.state as AppUserLoggedIn).user.id;
    ProfileEntity updateProfile = state.updateProfile;

    final res = await _updateProfile(UpdateProfileRequestDto(
        userId: userId,
        firstName: updateProfile.firstName,
        lastName: updateProfile.lastName,
        phone: updateProfile.phone,
        address: updateProfile.address));

    res.fold(
      (failure) => emit(state.copyWith(
          updateProfileStatus: UpdateProfileStatus.failure,
          message: failure.message)),
      (profile) {
        _appProfileCubit.updateProfile(profile);
        emit(state.copyWith(
            updateProfileStatus: UpdateProfileStatus.success,));
      },
    );
  }

  void _onAccountChange(
    AccountChange event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateUser: event.updateAccount));
  }

  void _onAccountSave(
    AccountSave event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));

    int userId = (_appUserCubit.state as AppUserLoggedIn).user.id;
    UserEntity updateAccount = state.updateUser;

    final res = await _updateAccount(UpdateAccountRequestDto(
      userId: userId,
      oldPassword: event.oldPassword,
      username: updateAccount.username,
      email: updateAccount.email,
    ));

    res.fold(
      (failure) => emit(state.copyWith(
          updateAccountStatus: UpdateAccountStatus.failure,
          message: failure.message)),
      (user) {
        _appUserCubit.updateUser(user);
        emit(state.copyWith(updateAccountStatus: UpdateAccountStatus.success));
      },
    );
  }

  void _onPasswordSave(
    PasswordSave event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));

    int userId = (_appUserCubit.state as AppUserLoggedIn).user.id;

    final res = await _updatePassword(UpdatePasswordRequestDto(
        userId: userId,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword));

    res.fold(
      (failure) => emit(state.copyWith(
          updatePasswordStatus: UpdatePasswordStatus.failure,
          message: failure.message)),
      (user) {
        emit(
            state.copyWith(updatePasswordStatus: UpdatePasswordStatus.success));
      },
    );
  }

  void _onAccountRemove(
    AccountRemove event,
    Emitter<SettingsState> emit,
  ) async {
    if (_appUserCubit.state is AppUserLoggedIn) {
      final res = await _deleteAccount(
          (_appUserCubit.state as AppUserLoggedIn).user.id);
      res.fold(
        (failure) => emit(state.copyWith(
            settingsStatus: SettingsStatus.failure, message: failure.message)),
        (message) => {},
      );
    } else {
      _appProfileCubit.updateProfile(null);
    }
  }

  void _onLogout(
    Logout event,
    Emitter<SettingsState> emit,
  ) async {
    _appUserCubit.updateUser(null);
    _appProfileCubit.updateProfile(null);
  }
}
