import 'dart:developer';

import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class UpdateProfileApi {
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    int? age,
    double? currentWeight,
    double? height,
    double? targetWeight,
  }) async {
    final Map<String, dynamic> data = {'name': name};

    if (age != null) data['age'] = age;
    if (currentWeight != null) data['current_weight'] = currentWeight;
    if (height != null) data['height'] = height;
    if (targetWeight != null) data['target_weight'] = targetWeight;

    log('UpdateProfile API - Sending data: $data');
    log('UpdateProfile API - Endpoint: ${Endpoints.updateProfile()}');

    final response = await postHttp(Endpoints.updateProfile(), data);

    log('UpdateProfile API - Response: ${response.data}');

    return response.data;
  }
}
