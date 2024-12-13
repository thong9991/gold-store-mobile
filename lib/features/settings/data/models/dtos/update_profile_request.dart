import '../../../../../core/constants/constants.dart';

class UpdateProfileRequestDto {
  int userId;
  String firstName;
  String lastName;
  String phone;
  String address;

  UpdateProfileRequestDto({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "address": address,
      }..removeWhere((key, value) => value == null || value == Constants.empty);
}
