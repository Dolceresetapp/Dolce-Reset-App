import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/ai_generate_response_model.dart';

final class AiGenerateApi {
  static final AiGenerateApi _singleton = AiGenerateApi._internal();
  AiGenerateApi._internal();

  static AiGenerateApi get instance => _singleton;

  Future<AiGenerateResponseModel> aiGenerateApi({
    required String prompt,
  }) async {
    try {
      Map data = {"prompt": prompt};

      Response response = await postHttp(Endpoints.aiGenerate(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AiGenerateResponseModel data = AiGenerateResponseModel.fromRawJson(
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
