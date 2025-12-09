import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/coach_response_model.dart';

final class MotivationCoachApi {
  static final MotivationCoachApi _singleton = MotivationCoachApi._internal();
  MotivationCoachApi._internal();

  static MotivationCoachApi get instance => _singleton;

  Future<CoachResponseModel> motivationCoachApi({
    required String prompt,
  }) async {
    try {
      Map data = {"prompt": prompt};
      Response response = await postHttp(Endpoints.motivationChat(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CoachResponseModel data = CoachResponseModel.fromRawJson(
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
