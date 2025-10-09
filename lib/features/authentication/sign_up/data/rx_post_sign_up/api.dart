import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/sign_up_response_model.dart';

final class SignupApi {
  static final SignupApi _singleton = SignupApi._internal();
  SignupApi._internal();

  static SignupApi get instance => _singleton;

  Future<SignupResponseModel> signupApi({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      Map data = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      Response response = await postHttp(Endpoints.signUp(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SignupResponseModel data = SignupResponseModel.fromRawJson(
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
