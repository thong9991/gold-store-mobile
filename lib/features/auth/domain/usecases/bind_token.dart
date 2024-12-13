import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/bind_token_request.dart';
import '../repositories/auth_repository.dart';

class BindToken implements UseCase<String, BindTokenRequestDto> {
  final AuthRepository authRepository;

  const BindToken(this.authRepository);

  @override
  Future<Either<Failure, String>> call(BindTokenRequestDto request) async {
    return await authRepository.bindToken(request);
  }
}
