import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/gold_price_repository.dart';

class LoadGoldPrices implements UseCase<List<GoldPriceEntity>, NoParams> {
  final GoldPriceRepository goldPriceRepository;

  const LoadGoldPrices(this.goldPriceRepository);

  @override
  Future<Either<Failure, List<GoldPriceEntity>>> call(NoParams request) async {
    return await goldPriceRepository.getGoldPrices();
  }
}
