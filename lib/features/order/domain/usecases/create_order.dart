import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/create_order_request.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrder implements UseCase<OrderEntity, CreateOrderRequestDto> {
  final OrderRepository orderRepository;

  const CreateOrder(this.orderRepository);

  @override
  Future<Either<Failure, OrderEntity>> call(
      CreateOrderRequestDto request) async {
    return await orderRepository.createOrder(request);
  }
}
