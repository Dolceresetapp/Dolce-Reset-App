import 'dart:convert';
import 'dart:developer';

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

      log("========== AI Generate API Call ==========");
      log("Prompt: $prompt");
      log("Endpoint: ${Endpoints.aiGenerate()}");

      // Use extended timeout for AI generation (can take 30-60 seconds)
      Response response = await postHttpLongRunning(Endpoints.aiGenerate(), data);

      log("Response status: ${response.statusCode}");
      log("Response data type: ${response.data.runtimeType}");
      log("Response data: ${json.encode(response.data)}");
      log("==========================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        AiGenerateResponseModel parsedData = AiGenerateResponseModel.fromRawJson(
          json.encode(response.data),
        );

        log("Parsed model - success: ${parsedData.success}");
        log("Parsed model - responseType: ${parsedData.responseType}");
        log("Parsed model - data length: ${parsedData.data?.length}");

        return parsedData;
      } else {
        // Handle non-200 status code errors
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      log("AI Generate API Error: $error");
      // Handle generic errors
      rethrow;
    }
  }
}
