import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.role,
    super.email,
    super.username,
    super.fcmToken,
  });

  static const empty = UserModel();

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id,
        role: entity.role,
        email: entity.email,
        username: entity.username,
        fcmToken: entity.fcmToken);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? Constants.zero,
      role: json['role'] ?? Constants.empty,
      email: json['email'] ?? Constants.empty,
      username: json['username'] ?? Constants.empty,
      fcmToken: json['fcmToken'] ?? Constants.empty,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "email": email,
        "username": username,
        "fcmToken": fcmToken,
      };

  UserModel copyWith({
    int? id,
    String? role,
    String? email,
    String? username,
    String? fcmToken,
  }) =>
      UserModel(
        id: id ?? this.id,
        role: role ?? this.role,
        email: email ?? this.email,
        username: username ?? this.username,
        fcmToken: fcmToken ?? this.fcmToken,
      );
}
