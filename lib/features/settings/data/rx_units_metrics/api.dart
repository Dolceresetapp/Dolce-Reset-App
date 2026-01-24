import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class UnitsMetricsApi {
  Future<Map<String, dynamic>> updateUnits({
    required String weightUnit,
    required String heightUnit,
  }) async {
    final response = await DioSingleton.instance.dio.post(
      Endpoints.updateHeightWeight(),
      data: {
        'weight_unit': weightUnit,
        'height_unit': heightUnit,
      },
    );

    return response.data;
  }
}
