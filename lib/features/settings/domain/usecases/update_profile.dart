import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/update_profile_request.dart';
import '../repositories/account_repository.dart';

class UpdateProfile implements UseCase<ProfileEntity, UpdateProfileRequestDto> {
  final AccountRepository accountRepository;

  const UpdateProfile(this.accountRepository);

  @override
  Future<Either<Failure, ProfileEntity>> call(
      UpdateProfileRequestDto request) async {
    return await accountRepository.updateProfile(request);
  }
}
