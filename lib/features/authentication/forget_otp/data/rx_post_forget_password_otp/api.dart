import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';
import '../model/forget_password_otp_response_model.dart';

final class ForgetPasswordOtpApi {
  static final ForgetPasswordOtpApi _singleton =
      ForgetPasswordOtpApi._internal();
  ForgetPasswordOtpApi._internal();

  static ForgetPasswordOtpApi get instance => _singleton;

  Future<ForgetPasswordOtpResponseModel> forgetPasswordOtpApi({
    required String email,required String otp
  }) async {
    try {
      Map data = {"email": email, "otp" : otp};

      Response response = await postHttp(Endpoints.forgetPasswordOtp(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ForgetPasswordOtpResponseModel data =
            ForgetPasswordOtpResponseModel.fromRawJson(json.encode(response.data));
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
