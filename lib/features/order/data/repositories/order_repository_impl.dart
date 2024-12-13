import 'package:fpdart/fpdart.dart';

import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/dtos/create_order_request.dart';
import '../models/order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const OrderRepositoryImpl(this.connectionChecker, this.apiService);

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
      CreateOrderRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.post(
          endPoint: "orders", data: request.order.toJson());
      if (response.statusCode == 201) {
        return Right(OrderModel.fromJson(response.data));
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    }
    catch (error) {
      print(error);
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
