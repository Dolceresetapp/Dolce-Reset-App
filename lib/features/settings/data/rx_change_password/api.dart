import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class ChangePasswordApi {
  Future<Map<String, dynamic>> changePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await DioSingleton.instance.dio.post(
      Endpoints.updatePassword(),
      data: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return response.data;
  }
}
