import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/dtos/create_order_request.dart';
import '../entities/order.dart';

abstract interface class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(
      CreateOrderRequestDto request);
}
