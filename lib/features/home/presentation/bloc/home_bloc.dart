import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_profile/app_profile_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/profile.dart';
import '../../domain/usecases/load_profile.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LoadProfile _loadProfile;
  final AppProfileCubit _appProfileCubit;
  final AppUserCubit _appUserCubit;

  HomeBloc(
      {required LoadProfile loadProfile,
      required AppUserCubit appUserCubit,
      required AppProfileCubit appProfileCubit})
      : _loadProfile = loadProfile,
        _appProfileCubit = appProfileCubit,
        _appUserCubit = appUserCubit,
        super(HomeInitial()) {
    on<HomeEvent>((_, emit) => emit(HomeLoading()));
    on<ProfileLoad>(_onProfileLoad);
  }

  void _onProfileLoad(
    ProfileLoad event,
    Emitter<HomeState> emit,
  ) async {
    if (_appUserCubit.state is AppUserLoggedIn) {
      final res =
          await _loadProfile((_appUserCubit.state as AppUserLoggedIn).user.id);
      res.fold(
        (failure) => emit(HomeFailure(failure.message)),
        (profile) => _emitProfileSuccess(profile, emit),
      );
    } else {
      _appProfileCubit.updateProfile(null);
    }
  }

  void _emitProfileSuccess(ProfileEntity profile, Emitter<HomeState> emit) {
    _appProfileCubit.updateProfile(profile);
    emit(ProfileLoaded(profile));
  }
}
