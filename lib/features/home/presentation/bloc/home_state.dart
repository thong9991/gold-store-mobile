part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class ProfileLoading extends HomeState {}

final class ProfileLoaded extends HomeState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);
}

final class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);
}
