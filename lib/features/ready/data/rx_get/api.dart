import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/workout_video_response_model.dart';

final class WorkoutVideoApi {
  static final WorkoutVideoApi _singleton = WorkoutVideoApi._internal();
  WorkoutVideoApi._internal();

  static WorkoutVideoApi get instance => _singleton;

  Future<WorkoutWiseVideoResponseModel> workoutVideoApi({
    required int id,
  }) async {
    try {
      Response response = await getHttp(Endpoints.workoutVideo(id: id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        WorkoutWiseVideoResponseModel data =
            WorkoutWiseVideoResponseModel.fromRawJson(
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
