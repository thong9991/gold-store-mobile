import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/contact_repository.dart';

class DeleteContact implements UseCase<String, int> {
  final ContactRepository contactRepository;

  const DeleteContact(this.contactRepository);

  @override
  Future<Either<Failure, String>> call(int id) async {
    return await contactRepository.deleteContact(id);
  }
}
