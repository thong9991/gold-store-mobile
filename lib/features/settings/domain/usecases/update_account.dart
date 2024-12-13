import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/update_account_request.dart';
import '../repositories/account_repository.dart';

class UpdateAccount implements UseCase<UserEntity, UpdateAccountRequestDto> {
  final AccountRepository accountRepository;

  const UpdateAccount(this.accountRepository);

  @override
  Future<Either<Failure, UserEntity>> call(
      UpdateAccountRequestDto request) async {
    return await accountRepository.updateAccount(request);
  }
}
