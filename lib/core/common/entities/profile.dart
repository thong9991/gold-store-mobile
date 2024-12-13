import 'package:equatable/equatable.dart';

import '../../constants/constants.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;

  const ProfileEntity({
    this.id = Constants.zero,
    this.firstName = Constants.empty,
    this.lastName = Constants.empty,
    this.phone = Constants.empty,
    this.address = Constants.empty,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        address,
      ];
}
