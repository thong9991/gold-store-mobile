import '../../../../core/constants/constants.dart';
import '../../data/models/product.dart';
import '../../domain/entities/order_sale.dart';
import '../../domain/entities/product.dart';

class OrderSaleModel extends OrderSaleEntity {
  const OrderSaleModel({
    super.product,
    super.newWage,
    super.cutAmount,
  });

  factory OrderSaleModel.fromEntity(OrderSaleEntity entity) => OrderSaleModel(
        product: ProductModel.fromEntity(entity.product),
        newWage: entity.newWage,
        cutAmount: entity.cutAmount,
      );

  factory OrderSaleModel.fromJson(Map<String, dynamic> json) => OrderSaleModel(
        product: ProductModel.fromJson(json["product"]),
        newWage: json["newWage"] ?? Constants.zero,
        cutAmount: json["cutAmount"] != null
            ? json["cutAmount"]?.toDouble()
            : Constants.zeroDouble,
      );

  Map<String, dynamic> toJson() => {
        "product": ProductModel.fromEntity(product).toJson(),
        "newWage": newWage,
        "cutAmount": cutAmount,
      };

  OrderSaleModel copyWith({
    ProductEntity? product,
    int? newWage,
    double? cutAmount,
  }) =>
      OrderSaleModel(
        product: product ?? this.product,
        newWage: newWage ?? this.newWage,
        cutAmount: cutAmount ?? this.cutAmount,
      );
}
