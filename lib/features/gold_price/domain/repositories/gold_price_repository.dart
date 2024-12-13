import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/dtos/update_gold_prices_request.dart';

abstract interface class GoldPriceRepository {
  Future<Either<Failure, List<GoldPriceEntity>>> getGoldPrices();

  Future<Either<Failure, List<GoldPriceEntity>>> updateGoldPrices(
      UpdateGoldPricesRequestDto request);
}
