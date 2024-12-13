import 'package:equatable/equatable.dart';

import '../../../../core/constants/constants.dart';
import '../../data/models/product.dart';
import 'product.dart';

class OrderSaleEntity extends Equatable {
  final ProductEntity product;
  final int newWage;
  final double cutAmount;

  const OrderSaleEntity({
    this.product = ProductModel.empty,
    this.newWage = Constants.zero,
    this.cutAmount = Constants.zeroDouble,
  });

  @override
  List<Object?> get props => [product, newWage, cutAmount];
}
