import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/features/barcode/data/model/scan_response_model.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class ScanBarcodeApi {
  static final ScanBarcodeApi _singleton = ScanBarcodeApi._internal();
  ScanBarcodeApi._internal();

  static ScanBarcodeApi get instance => _singleton;

  Future<ScanResonseModel> scanBarcodeApi({required int scanCode}) async {
    try {
      Response response = await getHttp(Endpoints.scanCode(scanCode: scanCode));
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScanResonseModel data = ScanResonseModel.fromRawJson(
          json.encode(response.data),
        );
        return data;
      } else {
        // Handle non-200 status code errors
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      // Handle generic errors
      rethrow;
    }
  }
}
