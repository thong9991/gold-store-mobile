import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class LoadSearchData implements UseCase<List<ContactEntity>, NoParams> {
  final ContactRepository contactRepository;

  const LoadSearchData(this.contactRepository);

  @override
  Future<Either<Failure, List<ContactEntity>>> call(NoParams request) async {
    return await contactRepository.getSearchData();
  }
}
