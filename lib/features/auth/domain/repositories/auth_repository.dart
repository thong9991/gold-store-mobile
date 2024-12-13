import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/dtos/bind_token_request.dart';
import '../../data/models/dtos/login_request.dart';
import '../../data/models/dtos/register_request.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> register(RegisterRequestDto request);

  Future<Either<Failure, UserEntity>> login(LoginRequestDto request);

  Future<Either<Failure, String>> bindToken(BindTokenRequestDto request);
}
