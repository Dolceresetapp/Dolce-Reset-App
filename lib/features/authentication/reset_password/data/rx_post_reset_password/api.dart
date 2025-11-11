import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/reset_password_response_model.dart';

final class ResetPasswordApi {
  static final ResetPasswordApi _singleton = ResetPasswordApi._internal();
  ResetPasswordApi._internal();

  static ResetPasswordApi get instance => _singleton;

  Future<ResetPasswordResponseModel> resetPasswordApi({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      Map data = {
        "email": email,
        "token": token,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      Response response = await postHttp(Endpoints.resetPassword(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ResetPasswordResponseModel data =
            ResetPasswordResponseModel.fromRawJson(json.encode(response.data));
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
