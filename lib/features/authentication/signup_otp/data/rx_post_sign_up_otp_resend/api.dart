import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../rx_post_sign_up_otp/model/signup_otp_response_model.dart';

final class SignupResendOtpApi {
  static final SignupResendOtpApi _singleton = SignupResendOtpApi._internal();
  SignupResendOtpApi._internal();

  static SignupResendOtpApi get instance => _singleton;

  Future<SignupResendOtpResponseModel> signupResendOtpApi({
    required String email,
  }) async {
    try {
      Map data = {"email": email};

      Response response = await postHttp(Endpoints.signUpResendOtp(), data);
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
