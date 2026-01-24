import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class FaqApi {
  Future<Map<String, dynamic>> getFaqs() async {
    final response = await DioSingleton.instance.dio.get(
      Endpoints.getFaqs(),
    );

    return response.data;
  }
}
