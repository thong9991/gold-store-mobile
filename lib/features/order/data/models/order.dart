import '../../../../core/common/entities/profile.dart';
import '../../../../core/constants/constants.dart';
import '../../../home/data/models/profile.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_exchange.dart';
import '../../domain/entities/order_sale.dart';
import 'order_exchange.dart';
import 'order_sale.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    super.staff,
    super.orderExchanges,
    super.orderSales,
    super.total,
    super.goldToCash,
    super.discount,
    super.isChecked,
    super.description,
    super.createdAt,
    super.updatedAt,
  });

  static const empty = OrderModel();

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
        id: entity.id,
        staff: entity.staff,
        orderExchanges: entity.orderExchanges,
        orderSales: entity.orderSales,
        total: entity.total,
        goldToCash: entity.goldToCash,
        discount: entity.discount,
        isChecked: entity.isChecked,
        description: entity.description,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"] ?? Constants.empty,
        staff:
            json["staff"] != null ? ProfileModel.fromJson(json["staff"]) : null,
        orderExchanges: json["orderExchanges"] != null
            ? List<OrderExchangeEntity>.from(json["orderExchanges"]
                .map((x) => OrderExchangeModel.fromJson(x)))
            : const [],
        orderSales: json["orderSales"] != null
            ? List<OrderSaleEntity>.from(
                json["orderExchanges"].map((x) => OrderSaleModel.fromJson(x)))
            : const [],
        total: json["total"],
        goldToCash: json["goldToCash"],
        discount: json["discount"],
        isChecked: json["isChecked"],
        description: json["description"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id != Constants.empty ? id : Constants.empty,
        "orderExchanges": orderExchanges.isNotEmpty
            ? List<dynamic>.from(orderExchanges
                .map((x) => OrderExchangeModel.fromEntity(x).toJson()))
            : const [],
        "orderSales": orderSales.isNotEmpty
            ? List<dynamic>.from(
                orderSales.map((x) => OrderSaleModel.fromEntity(x).toJson()))
            : const [],
        "staff":
            staff != null ? ProfileModel.fromEntity(staff!).toJson() : null,
        "total": total,
        "goldToCash": goldToCash,
        "discount": discount,
        "isChecked": isChecked,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      }..removeWhere((key, value) => value == null);

  OrderModel copyWith(
          {String? id,
          ProfileEntity? staff,
          List<OrderExchangeEntity>? orderExchanges,
          List<OrderSaleEntity>? orderSales,
          int? total,
          int? goldToCash,
          int? discount,
          bool? isChecked,
          String? description}) =>
      OrderModel(
        id: id ?? this.id,
        staff: staff ?? this.staff,
        orderExchanges: orderExchanges ?? this.orderExchanges,
        orderSales: orderSales ?? this.orderSales,
        total: total ?? this.total,
        goldToCash: goldToCash ?? this.goldToCash,
        discount: discount ?? this.discount,
        isChecked: isChecked ?? this.isChecked,
        description: description ?? this.description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
