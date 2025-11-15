import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';


import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/onboarding_response_model.dart';

final class OnboardingApi {
  static final OnboardingApi _singleton = OnboardingApi._internal();
  OnboardingApi._internal();

  static OnboardingApi get instance => _singleton;

  Future<OnboardingResponseModel> onboardingApi({
    required String userId,
    required String age,
    required String bmi,
    required String bodyPartFocus,
    required String bodySatisfaction,
    required String celebrationPlan,
    required String currentBodyType,
    required String currentWeight,
    required String dreamBody,
    required String height,
    required String targetWeight,
    required String tryingDuration,
    required String urgentImprovement,
    required Uint8List signature,
    required String targetWeightIn,
    required String weightIn,
    required String heightIn,
  }) async {
    try {
       // Convert Uint8List -> PNG File Upload
      MultipartFile signatureFile = MultipartFile.fromBytes(
        signature,
          filename: "signature.png",
   

   
      );

      FormData formData = FormData.fromMap({
        "user_id": userId,
        "age": age,
        "bmi": bmi,
        "body_part_focus": bodyPartFocus,
        "body_satisfaction": bodySatisfaction,
        "celebration_plan": celebrationPlan,
        "current_body_type": currentBodyType,
        "current_weight": currentWeight,
        "dream_body": dreamBody,
        "height": height,
        "target_weight": targetWeight,
        "trying_duration": tryingDuration,
        "urgent_improvement": urgentImprovement,
        "signature": signatureFile,
        "target_weight_in": targetWeightIn,
        "weight_in": weightIn,
        "height_in": heightIn,
      });

      Response response = await postHttp(Endpoints.onboardUserInfo(), formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        OnboardingResponseModel data = OnboardingResponseModel.fromRawJson(
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
