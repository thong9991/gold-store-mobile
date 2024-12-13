import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/contact.dart';

abstract interface class ContactRepository {
  Future<Either<Failure, List<ContactEntity>>> getContacts(int page);

  Future<Either<Failure, List<ContactEntity>>> getSearchData();

  Future<Either<Failure, List<ContactEntity>>> searchContacts(List<int> idList);

  Future<Either<Failure, ContactEntity>> createContact(ContactEntity contact);

  Future<Either<Failure, ContactEntity>> updateContact(ContactEntity contact);

  Future<Either<Failure, String>> deleteContact(int id);
}
