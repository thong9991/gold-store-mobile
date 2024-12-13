class BindTokenRequestDto {
  int userId;
  String fcmToken;

  BindTokenRequestDto({
    required this.userId,
    required this.fcmToken,
  });

  factory BindTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      BindTokenRequestDto(
        userId: json["userId"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fcmToken": fcmToken,
      };
}
