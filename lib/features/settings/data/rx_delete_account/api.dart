import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class DeleteAccountApi {
  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await DioSingleton.instance.dio.delete(
      Endpoints.deleteAccount(),
    );

    return response.data;
  }
}
