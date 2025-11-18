import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/theme_wise_video_response_model.dart';
import 'api.dart';

final class ThemeWiseVideoRx
    extends RxResponseInt<ThemeWiseVideoResponseModel> {
  final api = ThemeWiseVideoApi.instance;

  ThemeWiseVideoRx({required super.empty, required super.dataFetcher});

  ValueStream<ThemeWiseVideoResponseModel> get themeWiseVideoRxStream =>
      dataFetcher.stream;

  Future<bool> themeWiseVideoRx({required int themeId}) async {
    try {
      ThemeWiseVideoResponseModel data = await api.themeWiseVideoApi(
        themeId: themeId,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ThemeWiseVideoResponseModel data) {
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
