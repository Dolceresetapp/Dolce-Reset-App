import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/workour_save_response_model.dart';

final class ActiveWorkoutSaveAPi {
  static final ActiveWorkoutSaveAPi _singleton =
      ActiveWorkoutSaveAPi._internal();
  ActiveWorkoutSaveAPi._internal();

  static ActiveWorkoutSaveAPi get instance => _singleton;

  Future<ActiveWorkoutResponseModel> activeWorkoutSaveAPi({
    required int listId,
   
  }) async {
    try {
      Map data = {"list_id": listId};

      Response response = await postHttp(Endpoints.activeWorkoutSave(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ActiveWorkoutResponseModel data = ActiveWorkoutResponseModel.fromRawJson(
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
