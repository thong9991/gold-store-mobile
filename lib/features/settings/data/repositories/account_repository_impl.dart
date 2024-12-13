import 'package:fpdart/fpdart.dart';

import '../../../../core/common/dtos/message_response.dart';
import '../../../../core/common/entities/profile.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../../auth/data/models/user.dart';
import '../../../home/data/models/profile.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/dtos/update_account_request.dart';
import '../models/dtos/update_password_request.dart';
import '../models/dtos/update_profile_request.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const AccountRepositoryImpl(
    this.connectionChecker,
    this.apiService,
  );

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
      UpdateProfileRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(
          endPoint: "profile/update_profile/${request.userId}",
          data: request.toJson());
      if (response.statusCode == 200) {
        return Right(ProfileModel.fromJson(response.data));
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateAccount(
      UpdateAccountRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(
          endPoint: "profile/update_account/${request.userId}",
          data: request.toJson());
      if (response.statusCode == 200) {
        return Right(UserModel.fromJson(response.data));
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePassword(
      UpdatePasswordRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(
          endPoint: "profile/change_password/${request.userId}",
          data: request.toJson());
      if (response.statusCode == 200) {
        return Right(UserModel.fromJson(response.data));
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount(int id) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response =
          await apiService.delete(endPoint: "profile/delete_account/$id");
      if (response.statusCode == 200) {
        return Right(MessageResponseDto.fromJson(response.data).msg);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
