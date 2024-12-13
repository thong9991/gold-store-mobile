import 'package:equatable/equatable.dart';

import '../../constants/constants.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String username;
  final String role;
  final String fcmToken;

  const UserEntity({
    this.id = Constants.zero,
    this.email = Constants.empty,
    this.username = Constants.empty,
    this.role = Constants.empty,
    this.fcmToken = Constants.empty,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        role,
        fcmToken,
      ];
}
