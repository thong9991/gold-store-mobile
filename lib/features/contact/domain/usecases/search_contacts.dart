import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class SearchContacts implements UseCase<List<ContactEntity>, List<int>> {
  final ContactRepository contactRepository;

  const SearchContacts(this.contactRepository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(List<int> idList) async {
    return await contactRepository.searchContacts(idList);
  }
}
