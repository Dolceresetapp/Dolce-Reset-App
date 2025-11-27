import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../../helpers/toast.dart';
import '../../../../../../../networks/rx_base.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/stream_cleaner.dart';
import 'api.dart';
import 'model/payment_sheet_response_model.dart';

final class PaymentmentSheetRx
    extends RxResponseInt<PaymentSheetResponseModel> {
  String? clientSecret;
  final api = PaymentmentSheetApi.instance;

  PaymentmentSheetRx({required super.empty, required super.dataFetcher});

  ValueStream<PaymentSheetResponseModel> get paymentmentSheetRxStream =>
      dataFetcher.stream;

  Future<bool> paymentmentSheetRx({
    required String email,
    required int planId,
  }) async {
    try {
      PaymentSheetResponseModel data = await api.paymentmentSheetApi(
        email: email,
        planId: planId,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(PaymentSheetResponseModel data) {
    clientSecret = data.data?.intent?.clientSecret ?? "";
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
