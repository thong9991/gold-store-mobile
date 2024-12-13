import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/dtos/create_notification_request.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, String>> createNotification(CreateNotificationRequestDto request);
}
