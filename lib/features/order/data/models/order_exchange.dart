import '../../../../core/common/entities/gold_price.dart';
import '../../../gold_price/data/models/gold_price.dart';
import '../../domain/entities/order_exchange.dart';

class OrderExchangeModel extends OrderExchangeEntity {
  const OrderExchangeModel({
    super.goldPrice,
    super.amount,
  });

  factory OrderExchangeModel.fromEntity(OrderExchangeEntity entity) =>
      OrderExchangeModel(
        goldPrice: entity.goldPrice,
        amount: entity.amount,
      );

  factory OrderExchangeModel.fromJson(Map<String, dynamic> json) =>
      OrderExchangeModel(
        goldPrice: GoldPriceModel.fromJson(json["goldPrice"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "goldPrice": GoldPriceModel.fromEntity(goldPrice).toJson(),
        "amount": amount,
      };

  OrderExchangeModel copyWith({
    GoldPriceEntity? goldPrice,
    double? amount,
  }) =>
      OrderExchangeModel(
        goldPrice: goldPrice ?? this.goldPrice,
        amount: amount ?? this.amount,
      );
}
