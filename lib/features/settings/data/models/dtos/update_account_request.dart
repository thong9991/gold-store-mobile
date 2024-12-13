import '../../../../../core/constants/constants.dart';

class UpdateAccountRequestDto {
  int userId;
  String oldPassword;
  String username;
  String email;

  UpdateAccountRequestDto({
    required this.userId,
    required this.oldPassword,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "username": username,
        "email": email,
      }..removeWhere((key, value) => value == null || value == Constants.empty);
}
