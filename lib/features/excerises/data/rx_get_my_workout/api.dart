import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/my_workout_response_model.dart';

const String _cacheKey = 'cache_my_workout_data';

final class MyWorkoutApi {
  static final MyWorkoutApi _singleton = MyWorkoutApi._internal();
  MyWorkoutApi._internal();

  static MyWorkoutApi get instance => _singleton;

  Future<MyWorkoutResponseModel> myWorkoutApi() async {
    // Utiliser le cache local d'abord
    final cached = appData.read(_cacheKey);
    if (cached != null) {
      // Retourner le cache immédiatement
      final data = MyWorkoutResponseModel.fromRawJson(cached);
      // Rafraîchir en arrière-plan (sans attendre)
      _refreshInBackground();
      return data;
    }

    // Pas de cache, faire l'appel réseau
    return await _fetchFromNetwork();
  }

  Future<void> _refreshInBackground() async {
    try {
      await _fetchFromNetwork();
    } catch (_) {
      // Ignorer les erreurs de rafraîchissement
    }
  }

  Future<MyWorkoutResponseModel> _fetchFromNetwork() async {
    try {
      Response response = await getHttp(Endpoints.myWorkout());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonStr = json.encode(response.data);
        MyWorkoutResponseModel data = MyWorkoutResponseModel.fromRawJson(jsonStr);

        // Sauvegarder en cache
        appData.write(_cacheKey, jsonStr);
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
