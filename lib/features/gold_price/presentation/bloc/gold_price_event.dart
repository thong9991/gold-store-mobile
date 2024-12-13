part of 'gold_price_bloc.dart';

@immutable
sealed class GoldPriceEvent {
  const GoldPriceEvent();
}

final class GoldPriceLoad extends GoldPriceEvent {}

final class UpdatedDataChange extends GoldPriceEvent {
  final int updateAskPrice;
  final int updateBidPrice;

  const UpdatedDataChange(
      {required this.updateAskPrice, required this.updateBidPrice});
}

final class GoldPriceChangeNotification extends GoldPriceEvent {
  final Map<String, dynamic> updatedData;

  const GoldPriceChangeNotification({required this.updatedData});
}

final class GoldPricesSave extends GoldPriceEvent {}

final class UpdateIndexChange extends GoldPriceEvent {
  final int updateIndex;

  const UpdateIndexChange({required this.updateIndex});
}

final class NotificationSend extends GoldPriceEvent {}

final class UpdateGoldPriceStatusChange extends GoldPriceEvent {
  final UpdateGoldPriceStatus status;

  const UpdateGoldPriceStatusChange({required this.status});
}
