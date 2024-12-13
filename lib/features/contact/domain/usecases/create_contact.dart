import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class CreateContact implements UseCase<ContactEntity, ContactEntity> {
  final ContactRepository contactRepository;

  const CreateContact(this.contactRepository);

  @override
  Future<Either<Failure, ContactEntity>> call(ContactEntity contact) async {
    return await contactRepository.createContact(contact);
  }
}
