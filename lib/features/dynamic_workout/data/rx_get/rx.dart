import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/dynamic_workout_response_model.dart';
import 'api.dart';

final class DynamicWorkoutRx
    extends RxResponseInt<DynamicWorkoutResponseModel> {
  final api = DynamicWorkoutApi.instance;

  DynamicWorkoutRx({required super.empty, required super.dataFetcher});

  ValueStream<DynamicWorkoutResponseModel> get dynamicWorkoutRxStream =>
      dataFetcher.stream;

  Future<bool> dynamicWorkoutRx({
    required String type,
    int? id,
    String? levelType,
  }) async {
    try {
      DynamicWorkoutResponseModel data = await api.dynamicWorkoutApi(
        type: type,
        id: id,
        levelType: levelType,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(DynamicWorkoutResponseModel data) {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?["message"]?.toString() ?? "Errore di connessione";
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        ToastUtil.showShortToast(message);
        totalDataClean();
        NavigationService.navigateToReplacement(Routes.signInScreen);
      } else {
        ToastUtil.showShortToast(message);
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
    } else {
      log('Non-Dio error: $error');
    }
    return false;
  }
}
