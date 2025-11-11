import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import 'model/signup_otp_response_model.dart';

final class SignupOtpApi {
  static final SignupOtpApi _singleton = SignupOtpApi._internal();
  SignupOtpApi._internal();

  static SignupOtpApi get instance => _singleton;

  Future<SignupResendOtpResponseModel> signupOtpApi({
    required String email,
    required String otp,
  }) async {
    try {
      Map data = {"email": email, "otp": otp};

      Response response = await postHttp(Endpoints.signUpEmailVerify(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SignupResendOtpResponseModel data =
            SignupResendOtpResponseModel.fromRawJson(
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
