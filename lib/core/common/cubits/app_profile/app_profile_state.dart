part of 'app_profile_cubit.dart';

@immutable
sealed class AppProfileState {}

final class AppProfileInitial extends AppProfileState {}

final class AppProfileLoaded extends AppProfileState {
  final ProfileEntity profile;

  AppProfileLoaded(this.profile);
}
