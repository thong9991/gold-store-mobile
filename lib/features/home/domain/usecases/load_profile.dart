import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class LoadProfile implements UseCase<ProfileEntity, int> {
  final ProfileRepository profileRepository;

  const LoadProfile(this.profileRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(int userId) async {
    return await profileRepository.getProfile(userId);
  }
}
