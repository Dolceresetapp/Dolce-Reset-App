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
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignupResponseModel data) {
    // Save user data
    appData.write(kKeyID, data.data?.id);
    appData.write(kKeyAvatar, data.data?.avatar ?? "");
    appData.write(kKeyName, data.data?.name ?? "");
    appData.write(kKeyEmail, data.data?.email ?? "");

    appData.write(kKeyUsrInfo, data.data?.userInfo ?? 0);
    appData.write(kKeyPaymentMethod, data.data?.paymentMethod ?? 0);
    appData.write(kKeyIsNutration, data.data?.isNutration ?? 0);

    // Save token and login state
    appData.write(kKeyAccessToken, data.token);
    appData.write(kKeyIsLoggedIn, true);
    DioSingleton.instance.update(appData.read(kKeyAccessToken));

    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final message = error.response!.data["message"] ?? "Errore di registrazione";

        if (statusCode == 409) {
          // Email already registered - show error in red
          ToastUtil.showErrorShortToast(message);
        } else if (statusCode == 400) {
          ToastUtil.showErrorShortToast(message);
        } else if (statusCode == 401) {
          ToastUtil.showErrorShortToast(message);
          totalDataClean();
          NavigationService.navigateToReplacement(Routes.signInScreen);
        } else if (statusCode == 422) {
          ToastUtil.showErrorShortToast(message);
        } else {
          ToastUtil.showErrorShortToast(message);
        }
      } else {
        ToastUtil.showErrorShortToast("Errore di connessione");
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
    } else {
      log(error.toString());
      ToastUtil.showErrorShortToast("Si è verificato un errore");
    }
    return false;
  }
}
