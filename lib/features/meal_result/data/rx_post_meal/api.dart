import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/meal_result_response_model.dart';

final class MealResultApi {
  static final MealResultApi _singleton = MealResultApi._internal();
  MealResultApi._internal();

  static MealResultApi get instance => _singleton;

  Future<MealResponseModel> mealResultApi({
    required String name,
    required String brands,
    required String energyKcal,
    required String fat,
    required String saturatedFat,
    required String carbohydrates,
    required String sugars,
    required String fiber,
    required String proteins,
    required String salt,
    required String image,
  }) async {
    try {
      Map data = {
        "name": name,
        "brands": brands,
        "energy_kcal": energyKcal,
        "fat": fat,
        "saturated_fat": saturatedFat,
        "carbohydrates": carbohydrates,
        "sugars": sugars,
        "fiber": fiber,
        "proteins": proteins,
        "salt": salt,
        "image": image,
      };
      Response response = await postHttp(Endpoints.checkHealth(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        MealResponseModel data = MealResponseModel.fromRawJson(
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
