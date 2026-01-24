import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/theme_response_model.dart';

const String _cacheKey = 'cache_theme_data';

final class ThemeApi {
  static final ThemeApi _singleton = ThemeApi._internal();
  ThemeApi._internal();

  static ThemeApi get instance => _singleton;

  Future<ThemeResponseModel> themeApi({String? search}) async {
    // Si pas de recherche, utiliser le cache local d'abord
    if (search == null || search.isEmpty) {
      final cached = appData.read(_cacheKey);
      if (cached != null) {
        // Retourner le cache immédiatement
        final data = ThemeResponseModel.fromRawJson(cached);
        // Rafraîchir en arrière-plan (sans attendre)
        _refreshInBackground();
        return data;
      }
    }

    // Pas de cache, faire l'appel réseau
    return await _fetchFromNetwork(search: search);
  }

  Future<void> _refreshInBackground() async {
    try {
      await _fetchFromNetwork(search: null);
    } catch (_) {
      // Ignorer les erreurs de rafraîchissement
    }
  }

  Future<ThemeResponseModel> _fetchFromNetwork({String? search}) async {
    try {
      Response response = await getHttp(Endpoints.theme(search: search));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonStr = json.encode(response.data);
        ThemeResponseModel data = ThemeResponseModel.fromRawJson(jsonStr);

        // Sauvegarder en cache si pas de recherche
        if (search == null || search.isEmpty) {
          appData.write(_cacheKey, jsonStr);
        }
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
