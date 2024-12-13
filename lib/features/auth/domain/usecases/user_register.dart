import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/register_request.dart';
import '../repositories/auth_repository.dart';

class UserRegister implements UseCase<String, RegisterRequestDto> {
  final AuthRepository authRepository;

  const UserRegister(this.authRepository);

  @override
  Future<Either<Failure, String>> call(RegisterRequestDto request) async {
    return await authRepository.register(request);
  }
}
