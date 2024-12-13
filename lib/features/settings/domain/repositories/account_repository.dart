import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/dtos/update_account_request.dart';
import '../../data/models/dtos/update_password_request.dart';
import '../../data/models/dtos/update_profile_request.dart';

abstract interface class AccountRepository {
  Future<Either<Failure, ProfileEntity>> updateProfile(
      UpdateProfileRequestDto request);

  Future<Either<Failure, UserEntity>> updateAccount(
      UpdateAccountRequestDto request);

  Future<Either<Failure, UserEntity>> updatePassword(
      UpdatePasswordRequestDto request);

  Future<Either<Failure, String>> deleteAccount(int id);
}
