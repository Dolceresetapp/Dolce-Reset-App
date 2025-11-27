import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../../networks/dio/dio.dart';
import '../../../../../../../networks/endpoints.dart';
import '../../../../../../../networks/exception_handler/data_source.dart';
import 'model/subscription_response_model.dart';

final class SubscriptionApi {
  static final SubscriptionApi _singleton = SubscriptionApi._internal();
  SubscriptionApi._internal();

  static SubscriptionApi get instance => _singleton;

  Future<SubscriptionResponseModel> subscriptionApi({
    required String email,
    required String paymentMethod,
    required String setupIntentId,
  }) async {
    try {
      Map data = {
        "payment_method": paymentMethod,
        "setup_intent_id": setupIntentId,
        "email": email,
      };

      Response response = await postHttp(Endpoints.subscription(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SubscriptionResponseModel data = SubscriptionResponseModel.fromRawJson(
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
