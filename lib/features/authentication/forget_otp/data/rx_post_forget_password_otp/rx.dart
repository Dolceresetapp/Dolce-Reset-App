import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/forget_password_otp_response_model.dart';
import 'api.dart';

final class ForgetPasswordOtpRx
    extends RxResponseInt<ForgetPasswordOtpResponseModel> {

      String? token;
  final api = ForgetPasswordOtpApi.instance;

  ForgetPasswordOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<ForgetPasswordOtpResponseModel> get forgetPasswordRxStream =>
      dataFetcher.stream;

  Future<bool> forgetPasswordOtpRx({required String email, required String otp}) async {
    try {
      ForgetPasswordOtpResponseModel data = await api.forgetPasswordOtpApi(
        email: email,
        otp: otp
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ForgetPasswordOtpResponseModel data) {
    token = data.token;
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
