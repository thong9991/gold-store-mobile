class RegisterResponseDto {
  String role;
  String email;
  String username;
  String password;
  int id;

  RegisterResponseDto({
    required this.role,
    required this.email,
    required this.username,
    required this.password,
    required this.id,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      RegisterResponseDto(
        role: json["role"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        id: json["id"],
      );
}
