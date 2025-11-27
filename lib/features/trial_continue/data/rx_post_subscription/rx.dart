import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../helpers/toast.dart';
import '../../../../../../../networks/rx_base.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/stream_cleaner.dart';
import 'api.dart';
import 'model/subscription_response_model.dart';

final class SubscriptionRx extends RxResponseInt<SubscriptionResponseModel> {
  final api = SubscriptionApi.instance;

  SubscriptionRx({required super.empty, required super.dataFetcher});

  ValueStream<SubscriptionResponseModel> get subscriptionRxStream =>
      dataFetcher.stream;

  Future<bool> paymentmentSheetRx({
    required String email,
    required String paymentMethod,
    required String setupIntentId,
  }) async {
    try {
      SubscriptionResponseModel data = await api.subscriptionApi(
        email: email,
        paymentMethod: paymentMethod,
        setupIntentId: setupIntentId,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(SubscriptionResponseModel data) {
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
          NavigationService.navigateToReplacement(Routes.signInScreen);
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
