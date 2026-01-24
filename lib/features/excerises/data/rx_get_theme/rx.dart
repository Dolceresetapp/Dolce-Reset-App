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
