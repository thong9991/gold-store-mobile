import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/create_notification_request.dart';
import '../repositories/notification_repository.dart';

class CreateNotification
    implements UseCase<String, CreateNotificationRequestDto> {
  final NotificationRepository notificationRepository;

  const CreateNotification(this.notificationRepository);

  @override
  Future<Either<Failure, String>> call(
      CreateNotificationRequestDto request) async {
    return await notificationRepository.createNotification(request);
  }
}
