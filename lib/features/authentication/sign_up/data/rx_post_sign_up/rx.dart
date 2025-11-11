import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';

import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/sign_up_response_model.dart';
import 'api.dart';

final class SignupRx extends RxResponseInt<SignupResponseModel> {
  final api = SignupApi.instance;

  SignupRx({required super.empty, required super.dataFetcher});

  ValueStream<SignupResponseModel> get signupRxStream => dataFetcher.stream;

  Future<bool> signupRx({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      SignupResponseModel data = await api.signupApi(
        email: email,
        name: name,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error, stack) {

      log("Errror =======================> $stack");
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignupResponseModel data) {
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
