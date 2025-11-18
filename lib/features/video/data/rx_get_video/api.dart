import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/theme_wise_video_response_model.dart';

final class ThemeWiseVideoApi {
  static final ThemeWiseVideoApi _singleton = ThemeWiseVideoApi._internal();
  ThemeWiseVideoApi._internal();

  static ThemeWiseVideoApi get instance => _singleton;

  Future<ThemeWiseVideoResponseModel> themeWiseVideoApi({
    required int themeId,
  }) async {
    try {
      Response response = await getHttp(
        Endpoints.themeWiseVideo(themeId: themeId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ThemeWiseVideoResponseModel data =
            ThemeWiseVideoResponseModel.fromRawJson(json.encode(response.data));
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
