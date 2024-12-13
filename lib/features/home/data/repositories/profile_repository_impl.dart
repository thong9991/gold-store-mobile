import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const ProfileRepositoryImpl(this.connectionChecker, this.apiService);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(int userId) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.get(endPoint: "profile/$userId");

      final data = ProfileModel.fromJson(response.data);
      return Right(data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
