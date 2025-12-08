import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/ai_receipe_response_model.dart';

final class AiReceipeApi {
  static final AiReceipeApi _singleton = AiReceipeApi._internal();
  AiReceipeApi._internal();

  static AiReceipeApi get instance => _singleton;

  Future<AiReceipeResponseModel> aiReceipeApi() async {
    try {
      Response response = await getHttp(Endpoints.nutrationRecipes());
      if (response.statusCode == 200 || response.statusCode == 201) {
        AiReceipeResponseModel data = AiReceipeResponseModel.fromRawJson(
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
