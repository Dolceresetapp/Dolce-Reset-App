import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/helpers/di.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

const String _cacheKey = 'cache_category_data';

final class CategoryApi {
  static final CategoryApi _singleton = CategoryApi._internal();
  CategoryApi._internal();

  static CategoryApi get instance => _singleton;

  Future<CategoryResponseModel> categoryApi({String? search}) async {
    // Si pas de recherche, utiliser le cache local d'abord
    if (search == null || search.isEmpty) {
      final cached = appData.read(_cacheKey);
      if (cached != null) {
        // Retourner le cache immédiatement
        final data = CategoryResponseModel.fromRawJson(cached);
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

  Future<CategoryResponseModel> _fetchFromNetwork({String? search}) async {
    try {
      Response response = await getHttp(Endpoints.category(search: search));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonStr = json.encode(response.data);
        CategoryResponseModel data = CategoryResponseModel.fromRawJson(jsonStr);

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
