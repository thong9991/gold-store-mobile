import 'package:fpdart/fpdart.dart';

import '../../../../app_prefs.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../../../core/utils/get_unix_timestamp.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/dtos/bind_token_request.dart';
import '../models/dtos/login_request.dart';
import '../models/dtos/login_response.dart';
import '../models/dtos/register_request.dart';
import '../models/dtos/register_response.dart';
import '../models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ConnectionChecker connectionChecker;
  final AppPreferences appPreferences;
  final ApiService apiService;

  AuthRepositoryImpl(
      this.connectionChecker, this.apiService, this.appPreferences);

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response =
          await apiService.post(endPoint: "auth/login", data: request.toJson());
      if (response.statusCode == 200) {
        final data = LoginResponseDto.fromJson(response.data);
        await appPreferences.setToken(data.token);
        await appPreferences
            .setExpiresIn(getUnixTimestampAfter(Constants.expiresInTime));
        await appPreferences.setRefreshToken(data.refreshToken.id);
        return Right(UserModel.fromJson(data.user.toJson()));
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> register(RegisterRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.post(endPoint: "users", data: request);
      if (response.statusCode == 201) {
        final data = RegisterResponseDto.fromJson(response.data);
        return const Right("register successful");
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> bindToken(BindTokenRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(
          endPoint: "profile/bind_token/${request.userId}",
          data: {"fcmToken": request.fcmToken});
      if (response.statusCode == 200) {
        return const Right("bind token successful");
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
