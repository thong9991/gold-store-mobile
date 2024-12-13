import 'dart:convert';

import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/constants/constants.dart';

GoldPriceModel goldPriceModelFromJson(String str) =>
    GoldPriceModel.fromJson(json.decode(str));

String goldPriceModelToJson(GoldPriceModel data) => json.encode(data.toJson());

class GoldPriceModel extends GoldPriceEntity {
  const GoldPriceModel({
    super.goldType,
    super.askPrice,
    super.bidPrice,
    super.createdAt,
    super.updatedAt,
  });

  static const empty = GoldPriceModel();

  factory GoldPriceModel.fromEntity(GoldPriceEntity entity) {
    return GoldPriceModel(
        goldType: entity.goldType,
        askPrice: entity.askPrice,
        bidPrice: entity.bidPrice,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt);
  }

  factory GoldPriceModel.fromJson(Map<String, dynamic> json) {
    return GoldPriceModel(
      goldType: json["goldType"] ?? json["gold_type"] ?? Constants.empty,
      askPrice: json["askPrice"] ?? json["ask_price"] ?? Constants.zero,
      bidPrice: json["bidPrice"] ?? json["bid_price"] ?? Constants.zero,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : json["created_at"] != null
              ? DateTime.parse(json["created_at"])
              : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : json["updated_at"] != null
              ? DateTime.parse(json["updated_at"])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "goldType": goldType,
        "askPrice": askPrice,
        "bidPrice": bidPrice,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      }..removeWhere((key, value) =>
          value == null || value == Constants.empty || value == Constants.zero);

  GoldPriceModel copyWith({
    String? goldType,
    int? askPrice,
    int? bidPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      GoldPriceModel(
        goldType: goldType ?? this.goldType,
        askPrice: askPrice ?? this.askPrice,
        bidPrice: bidPrice ?? this.bidPrice,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
