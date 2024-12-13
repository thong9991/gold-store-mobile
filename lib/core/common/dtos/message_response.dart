import '../../constants/constants.dart';

class MessageResponseDto {
  final String msg;

  const MessageResponseDto({
    this.msg = Constants.empty,
  });

  factory MessageResponseDto.fromJson(Map<String, dynamic> json) =>
      MessageResponseDto(
        msg: json["msg"],
      );
}
