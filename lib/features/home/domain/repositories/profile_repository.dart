import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/error/failure.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(int userId);
}
