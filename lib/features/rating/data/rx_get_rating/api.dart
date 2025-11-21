import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/rating_response_model.dart';

final class RatingApi {
  static final RatingApi _singleton = RatingApi._internal();
  RatingApi._internal();

  static RatingApi get instance => _singleton;

  Future<RatingResponseModel> ratingApi() async {
    try {
      Response response = await getHttp(Endpoints.reviews());
      if (response.statusCode == 200 || response.statusCode == 201) {
        RatingResponseModel data = RatingResponseModel.fromRawJson(
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
