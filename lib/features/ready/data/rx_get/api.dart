import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/workout_video_response_model.dart';

final class WorkoutVideoApi {
  static final WorkoutVideoApi _singleton = WorkoutVideoApi._internal();
  WorkoutVideoApi._internal();

  static WorkoutVideoApi get instance => _singleton;

  String _cacheKey(int id) => 'cache_workout_video_$id';

  Future<WorkoutWiseVideoResponseModel> workoutVideoApi({
    required int id,
  }) async {
    final cacheKey = _cacheKey(id);

    // Check cache first
    final cached = appData.read(cacheKey);
    if (cached != null) {
      _refreshInBackground(id: id);
      return WorkoutWiseVideoResponseModel.fromRawJson(cached);
    }

    return await _fetchFromNetwork(id: id);
  }

  Future<void> _refreshInBackground({required int id}) async {
    try {
      await _fetchFromNetwork(id: id);
    } catch (_) {}
  }

  Future<WorkoutWiseVideoResponseModel> _fetchFromNetwork({
    required int id,
  }) async {
    try {
      Response response = await getHttp(Endpoints.workoutVideo(id: id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonStr = json.encode(response.data);
        WorkoutWiseVideoResponseModel data =
            WorkoutWiseVideoResponseModel.fromRawJson(jsonStr);

        // Save to cache
        appData.write(_cacheKey(id), jsonStr);

        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
