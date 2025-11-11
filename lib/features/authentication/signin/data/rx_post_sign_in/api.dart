import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/sign_in_response_model.dart';

final class SignInApi {
  static final SignInApi _singleton = SignInApi._internal();
  SignInApi._internal();

  static SignInApi get instance => _singleton;

  Future<SignInResponseModel> signInApi({
    required String email,
    required String password,
  }) async {
    try {
      Map data = {"email": email, "password": password};

      Response response = await postHttp(Endpoints.signIn(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SignInResponseModel data = SignInResponseModel.fromRawJson(
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
