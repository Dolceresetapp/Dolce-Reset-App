import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gritti_app/features/excerises/data/rx_get_theme/model/theme_response_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import 'api.dart';

final class ThemeRx extends RxResponseInt<ThemeResponseModel> {
  final api = ThemeApi.instance;

  ThemeRx({required super.empty, required super.dataFetcher});

  ValueStream<ThemeResponseModel> get themeRxStream => dataFetcher.stream;

  Future<bool> themeRx({String? search}) async {
    try {
      ThemeResponseModel data = await api.themeApi(search: search);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ThemeResponseModel data) {
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
