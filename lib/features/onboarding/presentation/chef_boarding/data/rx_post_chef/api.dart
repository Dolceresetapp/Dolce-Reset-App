import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/chef_response_model.dart';

final class ChefApi {
  static final ChefApi _singleton = ChefApi._internal();
  ChefApi._internal();

  static ChefApi get instance => _singleton;

  Future<ChefResponseModel> chefApi({
    required String goalsFor,
    required String dietaryPreferences,
    required String intolerancesa,
    required String activityLevel,
    required String dontLike,
  }) async {
    try {
      Map data = {
        "goals_for": goalsFor,
        "dietary_preferences": dietaryPreferences,

        "intolerances": intolerancesa,

        "activity_level": activityLevel,

        "dont_like": dontLike,
      };

      Response response = await postHttp(Endpoints.nutrationStore(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ChefResponseModel data = ChefResponseModel.fromRawJson(
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
