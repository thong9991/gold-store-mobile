import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/login_request.dart';
import '../repositories/auth_repository.dart';

class UserLogin implements UseCase<UserEntity, LoginRequestDto> {
  final AuthRepository authRepository;

  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginRequestDto request) async {
    return await authRepository.login(request);
  }
}
