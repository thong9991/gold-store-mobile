import 'package:equatable/equatable.dart';

import '../../constants/constants.dart';

class GoldPriceEntity extends Equatable {
  final String goldType;
  final int askPrice;
  final int bidPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GoldPriceEntity({
    this.goldType = Constants.empty,
    this.askPrice = Constants.zero,
    this.bidPrice = Constants.zero,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [goldType, askPrice, bidPrice, createdAt, updatedAt];
}
