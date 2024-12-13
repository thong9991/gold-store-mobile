import '../../../../core/constants/constants.dart';
import '../../../gold_price/data/models/gold_price.dart';
import '../../domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.productName,
    super.goldPrice,
    super.category,
    super.totalWeight,
    super.goldWeight,
    super.gemWeight,
    super.wage,
    super.createdAt,
    super.updatedAt,
  });

  static const empty = ProductModel();

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
        id: entity.id,
        productName: entity.productName,
        goldPrice: entity.goldPrice,
        category: entity.category,
        totalWeight: entity.totalWeight,
        goldWeight: entity.goldWeight,
        gemWeight: entity.gemWeight,
        wage: entity.wage,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? Constants.zero,
        productName: json["productName"] ?? Constants.empty,
        category: json["category"] ?? Constants.empty,
        goldPrice: json["goldPrice"] != null
            ? GoldPriceModel.fromJson(json["goldPrice"])
            : GoldPriceModel.empty,
        totalWeight: json["totalWeight"] != null
            ? double.parse(json["totalWeight"])
            : Constants.zeroDouble,
        goldWeight: json["goldWeight"] != null
            ? double.parse(json["goldWeight"])
            : Constants.zeroDouble,
        gemWeight: json["gemWeight"] != null
            ? double.parse(json["gemWeight"])
            : Constants.zeroDouble,
        wage: json["wage"] ?? Constants.zero,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "goldPrice": GoldPriceModel.fromEntity(goldPrice).toJson(),
        "category": category,
        "totalWeight": totalWeight.toString(),
        "goldWeight": goldWeight.toString(),
        "gemWeight": gemWeight.toString(),
        "wage": wage,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      }..removeWhere((key, value) =>
          value == null ||
          value == Constants.zero ||
          value == Constants.zeroDouble ||
          value == Constants.empty);
}
