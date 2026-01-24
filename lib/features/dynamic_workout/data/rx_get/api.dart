import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/dynamic_workout_response_model.dart';

final class DynamicWorkoutApi {
  static final DynamicWorkoutApi _singleton = DynamicWorkoutApi._internal();
  DynamicWorkoutApi._internal();

  static DynamicWorkoutApi get instance => _singleton;

  String _cacheKey(String type, int? id, String? levelType) {
    return 'cache_dynamic_workout_${type}_${id ?? ''}_${levelType ?? ''}';
  }

  Future<DynamicWorkoutResponseModel> dynamicWorkoutApi({
    required String type,
    int? id,
    String? levelType,
  }) async {
    final cacheKey = _cacheKey(type, id, levelType);

    // Check cache first
    final cached = appData.read(cacheKey);
    if (cached != null) {
      // Return cached data immediately, refresh in background
      _refreshInBackground(type: type, id: id, levelType: levelType);
      return DynamicWorkoutResponseModel.fromRawJson(cached);
    }

    // No cache, fetch from network
    return await _fetchFromNetwork(type: type, id: id, levelType: levelType);
  }

  Future<void> _refreshInBackground({
    required String type,
    int? id,
    String? levelType,
  }) async {
    try {
      await _fetchFromNetwork(type: type, id: id, levelType: levelType);
    } catch (_) {
      // Ignore background refresh errors
    }
  }

  Future<DynamicWorkoutResponseModel> _fetchFromNetwork({
    required String type,
    int? id,
    String? levelType,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.dynamicWorkout(type: type, id: id, levelType: levelType),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonStr = json.encode(response.data);
        DynamicWorkoutResponseModel data =
            DynamicWorkoutResponseModel.fromRawJson(jsonStr);

        // Save to cache
        final cacheKey = _cacheKey(type, id, levelType);
        appData.write(cacheKey, jsonStr);

        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
