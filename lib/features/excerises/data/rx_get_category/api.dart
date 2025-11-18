import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class CategoryApi {
  static final CategoryApi _singleton = CategoryApi._internal();
  CategoryApi._internal();

  static CategoryApi get instance => _singleton;

  Future<CategoryResponseModel> categoryApi({String? search}) async {
    try {
      Response response = await getHttp(Endpoints.category(search: search));
      if (response.statusCode == 200 || response.statusCode == 201) {
        CategoryResponseModel data = CategoryResponseModel.fromRawJson(
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
