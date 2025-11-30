import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../../helpers/toast.dart';
import '../../../../../../../networks/rx_base.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/stream_cleaner.dart';
import 'api.dart';
import 'model/confirm_subscription_response_model.dart';

final class ConfirmSubscriptionRx
    extends RxResponseInt<ConfirmSubscriptionResponseModel> {
  final api = ConfirmSubscriptionApi.instance;

  ConfirmSubscriptionRx({required super.empty, required super.dataFetcher});

  ValueStream<ConfirmSubscriptionResponseModel> get paymentmentSheetRxStream =>
      dataFetcher.stream;

  Future<bool> confirmSubscriptionRx({
    required String paymentIntentId,
    required int planId,
  }) async {
    try {
      ConfirmSubscriptionResponseModel data = await api.confirmSubscriptionApi(
        paymentIntentId: paymentIntentId,
        planId: planId,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ConfirmSubscriptionResponseModel data) {
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
