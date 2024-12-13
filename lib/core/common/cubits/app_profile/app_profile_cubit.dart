import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../entities/profile.dart';

part 'app_profile_state.dart';

class AppProfileCubit extends Cubit<AppProfileState> {
  AppProfileCubit() : super(AppProfileInitial());

  void updateProfile(ProfileEntity? profile) {
    if (profile == null) {
      emit(AppProfileInitial());
    } else {
      emit(AppProfileLoaded(profile));
    }
  }
}
