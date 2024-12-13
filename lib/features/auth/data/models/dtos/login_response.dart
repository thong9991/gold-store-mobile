import '../user.dart';

class LoginResponseDto {
  String token;
  RefreshToken refreshToken;
  UserModel user;

  LoginResponseDto({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      LoginResponseDto(
        token: json["token"],
        refreshToken: RefreshToken.fromJson(json["refreshToken"]),
        user: UserModel.fromJson(json["user"]),
      );
}

class RefreshToken {
  int expiresIn;
  int userId;
  String id;
  DateTime createdAt;

  RefreshToken({
    required this.expiresIn,
    required this.userId,
    required this.id,
    required this.createdAt,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
        expiresIn: json["expiresIn"],
        userId: json["user_id"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}
