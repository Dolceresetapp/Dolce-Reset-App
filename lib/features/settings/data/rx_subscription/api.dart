import 'package:gritti_app/networks/dio/dio.dart';
import 'package:gritti_app/networks/endpoints.dart';

class SubscriptionApi {
  Future<Map<String, dynamic>> getSubscriptionInfo() async {
    final response = await getHttp(Endpoints.subscriptionInfo());
    return response.data;
  }

  Future<Map<String, dynamic>> getBillingPortalUrl() async {
    final response = await getHttp(Endpoints.billingPortal());
    return response.data;
  }
}
