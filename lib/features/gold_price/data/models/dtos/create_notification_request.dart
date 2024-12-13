class CreateNotificationRequestDto {
  String title;
  String body;
  Map<String, String> data;

  CreateNotificationRequestDto({
    required this.title,
    required this.body,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "data": data,
  };
}