import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../../networks/dio/dio.dart';
import '../../../../../../../networks/endpoints.dart';
import '../../../../../../../networks/exception_handler/data_source.dart';
import '../model/plan_response_model.dart';

final class PlanApi {
  static final PlanApi _singleton = PlanApi._internal();
  PlanApi._internal();

  static PlanApi get instance => _singleton;

  Future<PlanResponseModel> planApi() async {
    try {
      Response response = await getHttp(Endpoints.plan());
      if (response.statusCode == 200 || response.statusCode == 201) {
        PlanResponseModel data = PlanResponseModel.fromRawJson(
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
