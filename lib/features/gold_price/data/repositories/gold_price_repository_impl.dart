import 'package:fpdart/fpdart.dart';

import '../../../../core/common/dtos/pagination_response.dart';
import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/repositories/gold_price_repository.dart';
import '../models/dtos/update_gold_prices_request.dart';
import '../models/gold_price.dart';

class GoldPriceRepositoryImpl implements GoldPriceRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const GoldPriceRepositoryImpl(this.connectionChecker, this.apiService);

  @override
  Future<Either<Failure, List<GoldPriceEntity>>> getGoldPrices() async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response =
          await apiService.get(endPoint: "prices", params: {"page": 1});
      if (response.statusCode == 200) {
        final data = PaginationResponseDto.fromJson(response.data);
        List<GoldPriceEntity> goldPriceList = [];

        for (var goldPrice in data.body) {
          goldPriceList.add(GoldPriceModel.fromJson(goldPrice));
        }
        return Right(goldPriceList);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<GoldPriceEntity>>> updateGoldPrices(
      UpdateGoldPricesRequestDto request) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(endPoint: "prices", data: {
        "goldPrices": List.generate(
            request.goldPrices.length, (i) => request.goldPrices[i].toJson())
      });
      if (response.statusCode == 200) {
        List<GoldPriceEntity> goldPriceList = [];
        for (var goldPrice in response.data) {
          goldPriceList.add(GoldPriceModel.fromJson(goldPrice));
        }
        return Right(goldPriceList);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
