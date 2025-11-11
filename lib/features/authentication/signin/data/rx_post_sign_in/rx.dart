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
import '../model/sign_in_response_model.dart';
import 'api.dart';

final class SignInRx extends RxResponseInt<SignInResponseModel> {
  final api = SignInApi.instance;

  SignInRx({required super.empty, required super.dataFetcher});

  ValueStream<SignInResponseModel> get signupRxStream => dataFetcher.stream;

  Future<bool> signInRx({
    required String email,
    required String password,
  }) async {
    try {
      SignInResponseModel data = await api.signInApi(
        email: email,
        password: password,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignInResponseModel data) {
    appData.write(kKeyAccessToken, data.token);
    appData.write(kKeyID, data.data?.id);
    appData.write(kKeyName, data.data?.name);
    appData.write(kKeyEmail, data.data?.email);
    appData.write(kKeyIsLoggedIn, true);
    DioSingleton.instance.update(appData.read(kKeyAccessToken));
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
