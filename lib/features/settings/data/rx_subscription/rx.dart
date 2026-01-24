import 'dart:developer';
import 'package:gritti_app/features/settings/data/rx_subscription/api.dart';

class SubscriptionManagementRx {
  final api = SubscriptionApi();

  /// Get subscription info to determine payment method
  /// Returns: { payment_method: "stripe" | "apple" | "google" | null, has_stripe_customer: bool, has_subscription: bool }
  Future<Map<String, dynamic>?> getSubscriptionInfo() async {
    try {
      final response = await api.getSubscriptionInfo();
      log('SubscriptionInfo response: $response');

      if (response['status'] == true || response['success'] == true) {
        return response['data'];
      }
      return null;
    } catch (e) {
      log('SubscriptionInfo error: $e');
      return null;
    }
  }

  /// Get Stripe billing portal URL for web subscribers
  Future<String?> getBillingPortalUrl() async {
    try {
      final response = await api.getBillingPortalUrl();
      log('BillingPortal response: $response');

      if (response['status'] == true || response['success'] == true) {
        return response['data']?['url'];
      }
      return null;
    } catch (e) {
      log('BillingPortal error: $e');
      return null;
    }
  }
}
