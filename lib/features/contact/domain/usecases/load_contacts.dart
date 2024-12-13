import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class LoadContacts implements UseCase<List<ContactEntity>, int> {
  final ContactRepository contactRepository;

  const LoadContacts(this.contactRepository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(int page) async {
    return await contactRepository.getContacts(page);
  }
}
