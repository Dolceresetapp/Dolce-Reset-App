import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/ai_receipe_response_model.dart';
import 'api.dart';

final class AiReceipeRx extends RxResponseInt<AiReceipeResponseModel> {
  final api = AiReceipeApi.instance;

  AiReceipeRx({required super.empty, required super.dataFetcher});

  ValueStream<AiReceipeResponseModel> get aiReceipeRxStream =>
      dataFetcher.stream;

  Future<AiReceipeResponseModel> aiReceipeRx() async {
    try {
      AiReceipeResponseModel data = await api.aiReceipeApi();
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(AiReceipeResponseModel data) {
    dataFetcher.sink.add(data);
    return data;
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
