import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import 'api.dart';
import 'model/my_workout_response_model.dart';

final class MyWorkoutRx extends RxResponseInt<MyWorkoutResponseModel> {
  final api = MyWorkoutApi.instance;

  MyWorkoutRx({required super.empty, required super.dataFetcher});

  ValueStream<MyWorkoutResponseModel> get myWorkoutRxStream =>
      dataFetcher.stream;

  Future<bool> myWorkoutRx() async {
    try {
      MyWorkoutResponseModel data = await api.myWorkoutApi();
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(MyWorkoutResponseModel data) {
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
