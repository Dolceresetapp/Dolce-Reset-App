import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class UpdateAvatarApi {
  static final UpdateAvatarApi _singleton = UpdateAvatarApi._internal();
  UpdateAvatarApi._internal();

  static UpdateAvatarApi get instance => _singleton;

  Future<Map<String, dynamic>> updateAvatarApi({
    required File avatarFile,
  }) async {
    try {
      String fileName = avatarFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          avatarFile.path,
          filename: fileName,
        ),
      });

      Response response = await postHttp(Endpoints.updateAvatar(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
