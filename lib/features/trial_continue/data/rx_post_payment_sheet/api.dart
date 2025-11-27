import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../../networks/dio/dio.dart';
import '../../../../../../../networks/endpoints.dart';
import '../../../../../../../networks/exception_handler/data_source.dart';
import 'model/payment_sheet_response_model.dart';

final class PaymentmentSheetApi {
  static final PaymentmentSheetApi _singleton = PaymentmentSheetApi._internal();
  PaymentmentSheetApi._internal();

  static PaymentmentSheetApi get instance => _singleton;

  Future<PaymentSheetResponseModel> paymentmentSheetApi({
    required String email,
    required int planId,
  }) async {
    try {
      Map data = {"email": email, "plan_id": planId};
      Response response = await postHttp(Endpoints.paymentSheet(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        PaymentSheetResponseModel data = PaymentSheetResponseModel.fromRawJson(
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
