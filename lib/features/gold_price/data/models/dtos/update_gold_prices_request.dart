import '../gold_price.dart';

class UpdateGoldPricesRequestDto {
  int userId;
  List<GoldPriceModel> goldPrices;

  UpdateGoldPricesRequestDto({
    required this.userId,
    required this.goldPrices,
  });
}
