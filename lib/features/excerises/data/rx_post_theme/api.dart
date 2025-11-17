import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/category_wise_theme_response_model.dart';

final class CategoryWiseThemeApi {
  static final CategoryWiseThemeApi _singleton =
      CategoryWiseThemeApi._internal();
  CategoryWiseThemeApi._internal();

  static CategoryWiseThemeApi get instance => _singleton;

  Future<CategoryWiseThemeResponseModel> categoryWiseThemeApi({
 int? categoryId,
   String? type,
  }) async {
    try {
      Map data = {"category_id": categoryId, "type": type};
      Response response = await postHttp(Endpoints.categoryWiseTheme(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        CategoryWiseThemeResponseModel data =
            CategoryWiseThemeResponseModel.fromRawJson(
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
