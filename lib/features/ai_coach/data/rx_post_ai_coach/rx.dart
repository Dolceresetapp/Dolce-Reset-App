import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../../../../helpers/di.dart';
import '../model/coach_response_model.dart';
import 'api.dart';

final class MotivationCoachRx extends RxResponseInt<CoachResponseModel> {
  final api = MotivationCoachApi.instance;

  MotivationCoachRx({required super.empty, required super.dataFetcher});

  ValueStream<CoachResponseModel> get motivationCoachRxStream =>
      dataFetcher.stream;

  Future<bool> motivationCoachRx({required String prompt}) async {
    try {
      CoachResponseModel data = await api.motivationCoachApi(prompt: prompt);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(CoachResponseModel data) {
    appData.write(kKeyMessage, data.message ?? "");
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
      return false;
    }
    return false;
  }
}
