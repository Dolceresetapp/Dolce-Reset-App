import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/scan_response_model.dart';
import 'api.dart';

final class ScanBarcodeRx extends RxResponseInt<ScanResonseModel> {
  final api = ScanBarcodeApi.instance;

  ScanBarcodeRx({required super.empty, required super.dataFetcher});

  ValueStream<ScanResonseModel> get scanBarcodeRxStream => dataFetcher.stream;

  Future<ScanResonseModel> scanBarcodeRx({required int scanCode}) async {
    try {
      ScanResonseModel data = await api.scanBarcodeApi(scanCode: scanCode);
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ScanResonseModel data) {
    dataFetcher.sink.add(data);
    return data;
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
