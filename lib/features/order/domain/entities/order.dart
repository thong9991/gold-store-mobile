import 'package:equatable/equatable.dart';

import '../../../../core/common/entities/profile.dart';
import '../../../../core/constants/constants.dart';
import 'order_exchange.dart';
import 'order_sale.dart';

class OrderEntity extends Equatable {
  final String? id;
  final ProfileEntity? staff;
  final List<OrderExchangeEntity> orderExchanges;
  final List<OrderSaleEntity> orderSales;
  final int total;
  final int goldToCash;
  final int discount;
  final bool isChecked;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    this.id,
    this.staff,
    this.orderExchanges = const [],
    this.orderSales = const [],
    this.total = Constants.zero,
    this.goldToCash = Constants.zero,
    this.discount = Constants.zero,
    this.isChecked = false,
    this.description = Constants.empty,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        staff,
        orderExchanges,
        orderSales,
        total,
        goldToCash,
        discount,
        isChecked,
        description,
      ];
}
