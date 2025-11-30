import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../../networks/dio/dio.dart';
import '../../../../../../../networks/endpoints.dart';
import '../../../../../../../networks/exception_handler/data_source.dart';
import 'model/confirm_subscription_response_model.dart';

final class ConfirmSubscriptionApi {
  static final ConfirmSubscriptionApi _singleton =
      ConfirmSubscriptionApi._internal();
  ConfirmSubscriptionApi._internal();

  static ConfirmSubscriptionApi get instance => _singleton;

  Future<ConfirmSubscriptionResponseModel> confirmSubscriptionApi({
    required String paymentIntentId,
    required int planId,
  }) async {
    try {
      Map data = {"payment_intent_id": paymentIntentId, "plan_id": planId};
      Response response = await postHttp(Endpoints.completeSubscription(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ConfirmSubscriptionResponseModel data = ConfirmSubscriptionResponseModel.fromRawJson(
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
