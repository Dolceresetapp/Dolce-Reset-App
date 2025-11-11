import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/logout_response_model.dart';
import 'api.dart';

final class LogoutRx
    extends RxResponseInt<LogoutResponseModel> {

  final api = LogoutApi.instance;

  LogoutRx({required super.empty, required super.dataFetcher});

  ValueStream<LogoutResponseModel> get forgetPasswordRxStream =>
      dataFetcher.stream;

  Future<bool> logoutRx() async {
    try {
      LogoutResponseModel data = await api.logoutApi();
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn( LogoutResponseModel data) {
    appData.write(kKeyIsLoggedIn, false);
    DioSingleton.instance.update('');
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
