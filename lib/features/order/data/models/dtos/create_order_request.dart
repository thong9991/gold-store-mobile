import '../order.dart';

class CreateOrderRequestDto {
  int userId;
  OrderModel order;

  CreateOrderRequestDto({
    required this.userId,
    required this.order,
  });
}
