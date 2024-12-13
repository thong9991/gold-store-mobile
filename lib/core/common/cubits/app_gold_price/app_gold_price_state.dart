part of 'app_gold_price_cubit.dart';

@immutable
sealed class AppGoldPriceState {}

final class AppGoldPriceInitial extends AppGoldPriceState {}

final class AppGoldPriceLoaded extends AppGoldPriceState {
  final List<GoldPriceEntity> goldPrices;

  AppGoldPriceLoaded(this.goldPrices);
}
