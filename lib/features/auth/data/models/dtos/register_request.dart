class RegisterRequestDto {
  String email;
  String username;
  String password;

  RegisterRequestDto({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "password": password,
      };
}
