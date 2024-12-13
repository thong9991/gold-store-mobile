import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/update_gold_prices_request.dart';
import '../repositories/gold_price_repository.dart';

class UpdateGoldPrices
    implements UseCase<List<GoldPriceEntity>, UpdateGoldPricesRequestDto> {
  final GoldPriceRepository goldPriceRepository;

  const UpdateGoldPrices(this.goldPriceRepository);

  @override
  Future<Either<Failure, List<GoldPriceEntity>>> call(
      UpdateGoldPricesRequestDto request) async {
    return await goldPriceRepository.updateGoldPrices(request);
  }
}
