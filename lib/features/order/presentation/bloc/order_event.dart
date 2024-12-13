part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {
  const OrderEvent();
}

final class InitOrder extends OrderEvent {}

final class ProductLoad extends OrderEvent {
  final int productId;

  const ProductLoad({required this.productId});
}

final class ProductStatusChange extends OrderEvent {
  final ProductStatus status;

  const ProductStatusChange({required this.status});
}

final class CutAmountChange extends OrderEvent {
  final int index;
  final double value;

  const CutAmountChange({required this.index, required this.value});
}

final class WageChange extends OrderEvent {
  final int index;
  final int value;

  const WageChange({required this.index, required this.value});
}

final class OrderExchangeAdd extends OrderEvent {
  final String goldType;
  final double amount;

  const OrderExchangeAdd({required this.goldType, required this.amount});
}

final class OrderChange extends OrderEvent {
  final OrderEntity order;

  const OrderChange({required this.order});
}

final class OrderAdd extends OrderEvent {}

final class CreateOrderStatusChange extends OrderEvent {
  final CreateOrderStatus status;

  const CreateOrderStatusChange({required this.status});
}

final class GoldPriceChange extends OrderEvent {}
