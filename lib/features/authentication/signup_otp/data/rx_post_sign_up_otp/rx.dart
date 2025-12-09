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
import 'api.dart';
import 'model/signup_otp_verify_response_model.dart';

final class SignupOtpRx extends RxResponseInt<SignupOtpVerifyResponseModel> {
  final api = SignupOtpApi.instance;

  SignupOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<SignupOtpVerifyResponseModel> get signupRxStream =>
      dataFetcher.stream;

  Future<bool> signupOtpRx({required String email, required String otp}) async {
    try {
      SignupOtpVerifyResponseModel data = await api.signupOtpApi(
        email: email,
        otp: otp,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignupOtpVerifyResponseModel data) {
    appData.write(kKeyID, data.data?.id);
    appData.write(kKeyAvar, data.data?.avatar ?? "");
    appData.write(kKeyName, data.data?.name ?? "");
    appData.write(kKeyEmail, data.data?.email ?? "");

    appData.write(kKeyUsrInfo, data.data?.userInfo ?? 0);
    appData.write(kKeyPaymentMethod, data.data?.paymentMethod ?? 0);
    appData.write(kKeyIsNutration, data.data?.isNutration ?? 0);

    appData.write(kKeyAccessToken, data.token);
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
