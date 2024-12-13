import 'package:fpdart/fpdart.dart';

import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/dtos/create_notification_request.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const NotificationRepositoryImpl(this.connectionChecker, this.apiService);

  @override
  Future<Either<Failure, String>> createNotification(
      CreateNotificationRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.post(
          endPoint: "notifications", data: request.toJson());
      if (response.statusCode == 201) {
        return Right("send notification successful");
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
