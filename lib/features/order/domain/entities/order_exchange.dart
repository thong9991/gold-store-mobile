import 'package:equatable/equatable.dart';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/constants/constants.dart';
import '../../../gold_price/data/models/gold_price.dart';

class OrderExchangeEntity extends Equatable {
  final GoldPriceEntity goldPrice;
  final double amount;

  const OrderExchangeEntity({
    this.goldPrice = GoldPriceModel.empty,
    this.amount = Constants.zeroDouble,
  });

  @override
  List<Object?> get props => [goldPrice, amount];
}
