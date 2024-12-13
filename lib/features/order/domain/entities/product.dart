import 'package:equatable/equatable.dart';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/constants/constants.dart';
import '../../../gold_price/data/models/gold_price.dart';

class ProductEntity extends Equatable {
  final int id;
  final String productName;
  final GoldPriceEntity goldPrice;
  final String category;
  final double totalWeight;
  final double goldWeight;
  final double gemWeight;
  final int wage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.id = Constants.zero,
    this.productName = Constants.empty,
    this.goldPrice = GoldPriceModel.empty,
    this.category = Constants.empty,
    this.totalWeight = Constants.zeroDouble,
    this.goldWeight = Constants.zeroDouble,
    this.gemWeight = Constants.zeroDouble,
    this.wage = Constants.zero,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        productName,
        goldPrice,
        category,
        totalWeight,
        goldWeight,
        gemWeight,
        wage,
      ];
}
