import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../entities/gold_price.dart';

part 'app_gold_price_state.dart';

class AppGoldPriceCubit extends Cubit<AppGoldPriceState> {
  AppGoldPriceCubit() : super(AppGoldPriceInitial());

  void updateGoldPrices(List<GoldPriceEntity> goldPrices) {
    if (goldPrices.isEmpty) {
      emit(AppGoldPriceInitial());
    } else {
      emit(AppGoldPriceLoaded(goldPrices));
    }
  }
}
