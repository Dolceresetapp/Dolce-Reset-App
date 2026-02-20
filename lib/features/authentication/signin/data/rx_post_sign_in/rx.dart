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
    } catch (error, s) {
      log("stack ============================================: $s");
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SignInResponseModel data) {
    appData.write(kKeyAccessToken, data.token);
    appData.write(kKeyID, data.data?.id);
    appData.write(kKeyName, data.data?.name ?? "");
    appData.write(kKeyEmail, data.data?.email ?? "");
    appData.write(kKeyAvatar, data.data?.avatar ?? "");

    appData.write(kKeyIsNutration, data.data?.isNutration ?? 0);

    // Don't overwrite these values with 0 if they're already 1
    // This preserves locally completed onboarding/payment that backend doesn't know about
    int currentUserInfo = appData.read(kKeyUsrInfo) ?? 0;
    int backendUserInfo = data.data?.userInfo ?? 0;
    if (backendUserInfo == 1 || currentUserInfo == 0) {
      appData.write(kKeyUsrInfo, backendUserInfo);
    }

    int currentPayment = appData.read(kKeyPaymentMethod) ?? 0;
    int backendPayment = data.data?.paymentMethod ?? 0;
    if (backendPayment == 1 || currentPayment == 0) {
      appData.write(kKeyPaymentMethod, backendPayment);
    }

    // Save payment source so app knows if user is Web2Wave or IAP
    final paymentSource = data.data?.paymentSource;
    if (paymentSource != null && paymentSource.isNotEmpty) {
      appData.write('payment_source', paymentSource);
    }

    appData.write(kKeyIsLoggedIn, true);
    DioSingleton.instance.update(appData.read(kKeyAccessToken));
    dataFetcher.sink.add(data);
    return true;
  }

  // is_nutration
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
