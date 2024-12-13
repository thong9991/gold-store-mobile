class UpdatePasswordRequestDto {
  int userId;
  String oldPassword;
  String newPassword;

  UpdatePasswordRequestDto({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };
}
