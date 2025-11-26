import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/my_workout_response_model.dart';

final class MyWorkoutApi {
  static final MyWorkoutApi _singleton = MyWorkoutApi._internal();
  MyWorkoutApi._internal();

  static MyWorkoutApi get instance => _singleton;

  Future<MyWorkoutResponseModel> myWorkoutApi() async {
    try {
      Response response = await getHttp(Endpoints.myWorkout());
      if (response.statusCode == 200 || response.statusCode == 201) {
        MyWorkoutResponseModel data = MyWorkoutResponseModel.fromRawJson(
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
