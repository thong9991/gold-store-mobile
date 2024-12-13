part of 'gold_price_bloc.dart';

enum GoldPriceStatus { initial, loading, success, failure, loaded }

enum UpdateGoldPriceStatus { initial, loading, success, failure }

final class GoldPriceState extends Equatable {
  const GoldPriceState({
    this.goldPriceStatus = GoldPriceStatus.initial,
    this.updateGoldPriceStatus = UpdateGoldPriceStatus.initial,
    this.goldPrices = const [],
    this.updatedData = const [],
    this.updatedResult = const {},
    this.updateIndex = -1,
    this.message = Constants.empty,
  });

  final GoldPriceStatus goldPriceStatus;
  final UpdateGoldPriceStatus updateGoldPriceStatus;
  final List<GoldPriceEntity> goldPrices;
  final List<GoldPriceEntity> updatedData;
  final int updateIndex;
  final Map<String, String> updatedResult;
  final String message;

  GoldPriceState copyWith(
      {GoldPriceStatus? goldPriceStatus,
      UpdateGoldPriceStatus? updateGoldPriceStatus,
      List<GoldPriceEntity>? goldPrices,
      List<GoldPriceEntity>? updatedData,
      int? updateIndex,
      Map<String, String>? updatedResult,
      String? message}) {
    return GoldPriceState(
        goldPriceStatus: goldPriceStatus ?? this.goldPriceStatus,
        updateGoldPriceStatus:
            updateGoldPriceStatus ?? this.updateGoldPriceStatus,
        goldPrices: goldPrices ?? this.goldPrices,
        updatedData: updatedData ?? this.updatedData,
        updateIndex: updateIndex ?? this.updateIndex,
        updatedResult: updatedResult ?? this.updatedResult,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [
        goldPriceStatus,
        updateGoldPriceStatus,
        goldPrices,
        updatedData,
        updateIndex,
        updatedResult,
        message,
      ];
}
