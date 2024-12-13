import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/account_repository.dart';

class DeleteAccount implements UseCase<String, int> {
  final AccountRepository accountRepository;

  const DeleteAccount(this.accountRepository);

  @override
  Future<Either<Failure, String>> call(int id) async {
    return await accountRepository.deleteAccount(id);
  }
}
