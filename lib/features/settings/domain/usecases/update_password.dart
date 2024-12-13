import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/update_password_request.dart';
import '../repositories/account_repository.dart';

class UpdatePassword implements UseCase<UserEntity, UpdatePasswordRequestDto> {
  final AccountRepository accountRepository;

  const UpdatePassword(this.accountRepository);

  @override
  Future<Either<Failure, UserEntity>> call(
      UpdatePasswordRequestDto request) async {
    return await accountRepository.updatePassword(request);
  }
}
