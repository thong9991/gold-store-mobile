import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/cubits/app_gold_price/app_gold_price_cubit.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/gold_price.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/dtos/create_notification_request.dart';
import '../../data/models/dtos/update_gold_prices_request.dart';
import '../../data/models/gold_price.dart';
import '../../domain/usecases/create_notification.dart';
import '../../domain/usecases/load_gold_prices.dart';
import '../../domain/usecases/update_gold_prices.dart';

part 'gold_price_event.dart';

part 'gold_price_state.dart';

class GoldPriceBloc extends Bloc<GoldPriceEvent, GoldPriceState> {
  final LoadGoldPrices _loadGoldPrices;
  final UpdateGoldPrices _updateGoldPrices;
  final CreateNotification _createNotification;
  final AppGoldPriceCubit _appGoldPriceCubit;
  final AppUserCubit _appUserCubit;

  GoldPriceBloc(
      {required LoadGoldPrices loadGoldPrices,
      required UpdateGoldPrices updateGoldPrices,
      required CreateNotification createNotification,
      required AppGoldPriceCubit appGoldPriceCubit,
      required AppUserCubit appUserCubit})
      : _loadGoldPrices = loadGoldPrices,
        _updateGoldPrices = updateGoldPrices,
        _createNotification = createNotification,
        _appGoldPriceCubit = appGoldPriceCubit,
        _appUserCubit = appUserCubit,
        super(const GoldPriceState()) {
    on<GoldPriceLoad>(_onGoldPriceLoaded);
    on<GoldPriceChangeNotification>(_onGoldPriceChangeNotification);
    on<UpdateIndexChange>(_onUpdateIndexChange);
    on<UpdatedDataChange>(_onUpdatedDataChange);
    on<GoldPricesSave>(_onGoldPricesSave);
    on<NotificationSend>(_onNotificationSend);
    on<UpdateGoldPriceStatusChange>(_onUpdateGoldPriceStatusChange);
  }

  void _onGoldPriceLoaded(
    GoldPriceLoad event,
    Emitter<GoldPriceState> emit,
  ) async {
    emit(state.copyWith(
        goldPriceStatus: GoldPriceStatus.loading, updateIndex: -1));
    final res = await _loadGoldPrices(
      NoParams(),
    );

    res.fold(
      (failure) => emit(state.copyWith(
          goldPriceStatus: GoldPriceStatus.failure, message: failure.message)),
      (goldPrices) => _emitGoldPriceSuccess(goldPrices, emit, null, null),
    );
  }

  void _onGoldPriceChangeNotification(
    GoldPriceChangeNotification event,
    Emitter<GoldPriceState> emit,
  ) async {
    emit(state.copyWith(
        goldPriceStatus: GoldPriceStatus.loading, updateIndex: -1));
    List<GoldPriceEntity> goldPrices = state.goldPrices;
    Map<String, dynamic> updatedData = event.updatedData;
    int j = updatedData.keys.length;
    for (int i = 0; i < goldPrices.length; i++) {
      if (j == 0) break;

      String goldType = goldPrices[i].goldType;

      if (updatedData.containsKey(goldType)) {
        GoldPriceModel goldPrice =
            goldPriceModelFromJson(updatedData[goldType] as String);
        goldPrices[i] = goldPrice;
        j--;
      }
    }
    _emitGoldPriceSuccess(goldPrices, emit, null, null);
  }

  _onUpdateIndexChange(
    UpdateIndexChange event,
    Emitter<GoldPriceState> emit,
  ) async {
    emit(state.copyWith(
      updateIndex: event.updateIndex,
    ));
  }

  _onUpdatedDataChange(
    UpdatedDataChange event,
    Emitter<GoldPriceState> emit,
  ) async {
    int updateIndex = state.updateIndex;
    int currentAskPrice =
        event.updateAskPrice != state.goldPrices[updateIndex].askPrice
            ? event.updateAskPrice
            : Constants.zero;
    int currentBidPrice =
        event.updateBidPrice != state.goldPrices[updateIndex].bidPrice
            ? event.updateBidPrice
            : Constants.zero;
    GoldPriceEntity updateGoldPrice =
        GoldPriceModel.fromEntity(state.updatedData[updateIndex])
            .copyWith(bidPrice: currentBidPrice, askPrice: currentAskPrice);
    List<GoldPriceEntity> newUpdatedData = [];
    for (int i = 0; i < state.updatedData.length; i++) {
      newUpdatedData
          .add(i != updateIndex ? state.updatedData[i] : updateGoldPrice);
    }
    emit(state.copyWith(updatedData: newUpdatedData, updateIndex: -1));
  }

  void _onGoldPricesSave(
    GoldPricesSave event,
    Emitter<GoldPriceState> emit,
  ) async {
    emit(state.copyWith(
        goldPriceStatus: GoldPriceStatus.loading, updateIndex: -1));

    UpdateGoldPricesRequestDto request = UpdateGoldPricesRequestDto(
        userId: (_appUserCubit.state as AppUserLoggedIn).user.id,
        goldPrices: List.generate(
            state.updatedData.length,
            (i) => GoldPriceModel.fromEntity(state.updatedData[i])
                .copyWith(goldType: state.goldPrices[i].goldType))
          ..removeWhere((value) => value.askPrice == 0 && value.bidPrice == 0));

    final res = await _updateGoldPrices(request);

    res.fold(
      (failure) {
        return emit(state.copyWith(
            goldPriceStatus: GoldPriceStatus.failure,
            message: failure.message));
      },
      (goldPrices) {
        List<GoldPriceEntity> newGoldPrices = [];
        Map<String, String> updateResult = {};

        int j = 0;
        for (int i = 0; i < state.goldPrices.length; i++) {
          if (j < goldPrices.length &&
              state.goldPrices[i].goldType == goldPrices[j].goldType) {
            newGoldPrices.add(goldPrices[j]);

            updateResult[goldPrices[j].goldType] =
                goldPriceModelToJson(GoldPriceModel.fromEntity(goldPrices[j]));

            j++;
          } else {
            newGoldPrices.add(state.goldPrices[i]);
          }
        }

        _emitGoldPriceSuccess(
          newGoldPrices,
          emit,
          UpdateGoldPriceStatus.success,
          updateResult,
        );
      },
    );
  }

  void _onNotificationSend(
    NotificationSend event,
    Emitter<GoldPriceState> emit,
  ) async {
    final res = await _createNotification(CreateNotificationRequestDto(
        title: "Update gold prices",
        body:
            "Update gold prices ${DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now())}",
        data: state.updatedResult));

    res.fold(
      (failure) {
        return emit(state.copyWith(
            goldPriceStatus: GoldPriceStatus.failure,
            message: failure.message));
      },
      (result) {
        emit(state.copyWith(updatedResult: const {}));
      },
    );
  }

  void _onUpdateGoldPriceStatusChange(
    UpdateGoldPriceStatusChange event,
    Emitter<GoldPriceState> emit,
  ) {
    emit(state.copyWith(updateGoldPriceStatus: event.status));
  }

  void _emitGoldPriceSuccess(
    List<GoldPriceEntity> goldPrices,
    Emitter<GoldPriceState> emit,
    UpdateGoldPriceStatus? updateGoldPriceStatus,
    Map<String, String>? updatedResult,
  ) {
    _appGoldPriceCubit.updateGoldPrices(goldPrices);
    List<GoldPriceEntity> updatedData =
        List.generate(goldPrices.length, (int index) => GoldPriceModel.empty);
    emit(state.copyWith(
        goldPriceStatus: GoldPriceStatus.loaded,
        updateGoldPriceStatus: updateGoldPriceStatus,
        updatedResult: updatedResult,
        goldPrices: goldPrices,
        updatedData: updatedData));
  }
}
