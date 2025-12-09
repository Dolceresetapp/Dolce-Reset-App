import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../rx_post_sign_up_otp/model/signup_otp_verify_response_model.dart';
import 'api.dart';

final class SignupResendOtpRx
    extends RxResponseInt<SignupOtpVerifyResponseModel> {
  final api = SignupResendOtpApi.instance;

  SignupResendOtpRx({required super.empty, required super.dataFetcher});

  ValueStream<SignupOtpVerifyResponseModel> get signupRxStream =>
      dataFetcher.stream;

  Future<bool> signupResendOtpRx({required String email}) async {
    try {
      SignupOtpVerifyResponseModel data = await api.signupResendOtpApi(email: email);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignupOtpVerifyResponseModel data) {
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
