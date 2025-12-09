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
      if (error.response!.statusCode == 400) {
        ToastUtil.showShortToast(error.response!.data["message"]);
      } else {
        if (error.response!.statusCode == 401) {
          ToastUtil.showShortToast(error.response!.data["message"]);
          totalDataClean();
          NavigationService.navigateToReplacement(Routes.signInScreen);
        } else {
          ToastUtil.showShortToast(error.response!.data["message"]);
        }
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
      return false;
    }
  }
}
