import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/theme_response_model.dart';

final class ThemeApi {
  static final ThemeApi _singleton = ThemeApi._internal();
  ThemeApi._internal();

  static ThemeApi get instance => _singleton;

  Future<ThemeResponseModel> themeApi({String? search}) async {
    try {
      Response response = await getHttp(Endpoints.theme(search: search));
      if (response.statusCode == 200 || response.statusCode == 201) {
        ThemeResponseModel data = ThemeResponseModel.fromRawJson(
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
