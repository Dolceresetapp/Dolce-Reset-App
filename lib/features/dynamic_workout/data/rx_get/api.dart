import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/dynamic_workout_response_model.dart';

final class DynamicWorkoutApi {
  static final DynamicWorkoutApi _singleton = DynamicWorkoutApi._internal();
  DynamicWorkoutApi._internal();

  static DynamicWorkoutApi get instance => _singleton;

  Future<DynamicWorkoutResponseModel> dynamicWorkoutApi({
    required String type,
    int? id,
    String? levelType,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.dynamicWorkout(type: type, id: id, levelType: levelType),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        DynamicWorkoutResponseModel data =
            DynamicWorkoutResponseModel.fromRawJson(json.encode(response.data));
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
