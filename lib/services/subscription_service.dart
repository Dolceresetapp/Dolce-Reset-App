import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import '../constants/app_constants.dart';
import '../networks/dio/dio.dart';
import '../networks/endpoints.dart';

/// Delegate to listen for Superwall events (purchases via StoreKit/Google Play)
class AppSuperwallDelegate extends SuperwallDelegate {
  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    if (kDebugMode) {
      log('[Superwall] Subscription status changed: $newValue');
    }
    // Update local state when Superwall detects a change
    // This happens when user purchases via StoreKit or Google Play
    if (newValue is SubscriptionStatusActive) {
      subscriptionService._isActive = true;
      subscriptionService._status = 'active';
      // Save payment status to local storage
      GetStorage().write(kKeyPaymentMethod, 1);
      if (kDebugMode) {
        log('[Superwall] Saved kKeyPaymentMethod = 1');
      }
    } else {
      subscriptionService._isActive = false;
      subscriptionService._status = 'inactive';
    }
  }

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {
    if (kDebugMode) {
      log('[Superwall] Event: ${eventInfo.event}');
    }
  }

  @override
  void didDismissPaywall(PaywallInfo paywallInfo) {}

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {}

  @override
  void handleCustomPaywallAction(String name) {}

  @override
  void handleLog(String level, String scope, String? message, Map? info, String? error) {}

  @override
  void paywallWillOpenDeepLink(Uri url) {}

  @override
  void paywallWillOpenURL(Uri url) {}

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {}

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {}

  @override
  void handleSuperwallDeepLink(Uri url, List<String> pathSegments, Map<String, String> params) {}

  @override
  void willRedeemLink() {
    if (kDebugMode) {
      log('[Superwall] Will redeem link - loading...');
    }
    // You could show a loading indicator here
  }

  @override
  void didRedeemLink(RedemptionResult result) {
    if (kDebugMode) {
      log('[Superwall] Did redeem link: $result');
    }
    // Subscription status will be updated automatically by Superwall
    // via subscriptionStatusDidChange callback
  }

  @override
  void customerInfoDidChange(CustomerInfo oldInfo, CustomerInfo newInfo) {}

  @override
  void userAttributesDidChange(Map<String, dynamic> newAttributes) {}
}

/// Service to manage subscription status and sync with Superwall
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final _appData = GetStorage();
  bool _isActive = false;
  bool _isTrialing = false;
  String _status = 'inactive';

  bool get isActive => _isActive;
  bool get isTrialing => _isTrialing;
  String get status => _status;

  /// Initialize the delegate to listen for Superwall events
  void initialize() {
    Superwall.shared.setDelegate(AppSuperwallDelegate());
    if (kDebugMode) {
      log('[SubscriptionService] Initialized with delegate');
    }
  }

  /// Identify user with Superwall for analytics and targeting
  Future<void> identifyUser() async {
    final userId = _appData.read(kKeyID)?.toString();
    final email = _appData.read(kKeyEmail)?.toString();
    final name = _appData.read(kKeyName)?.toString();

    if (userId != null && userId.isNotEmpty) {
      // Identify user with Superwall
      await Superwall.shared.identify(userId);

      // Set user attributes for targeting
      await Superwall.shared.setUserAttributes({
        if (email != null) 'email': email,
        if (name != null) 'name': name,
      });

      if (kDebugMode) {
        log('[SubscriptionService] Identified user: $userId');
      }
    }
  }

  /// Fetch subscription status from backend and sync with Superwall
  /// This is for users who subscribed via WEB (Stripe) or Web2Wave
  Future<void> syncSubscriptionStatus() async {
    // First identify the user
    await identifyUser();

    try {
      final response = await DioSingleton.instance.dio.get(
        Endpoints.subscriptionInfo(),
      );

      log('[SubscriptionService] Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];
        _status = data['status'] ?? 'inactive';
        _isActive = data['is_active'] ?? false;
        _isTrialing = data['is_trialing'] ?? false;
        final paymentMethod = data['payment_method'];

        log('[SubscriptionService] Parsed: status=$_status, active=$_isActive, method=$paymentMethod');

        // Detect Web2Wave users
        if (paymentMethod == 'web2wave') {
          _appData.write('payment_source', 'web2wave');
          if (_isActive) {
            _appData.write(kKeyPaymentMethod, 1);
            _appData.write(kKeyUsrInfo, 1);
            log('[SubscriptionService] Web2Wave ACTIVE → kKeyPaymentMethod = 1');
          } else {
            _appData.write(kKeyPaymentMethod, 0);
            log('[SubscriptionService] Web2Wave NOT ACTIVE ($_status) → kKeyPaymentMethod = 0');
          }
          return;
        }

        // IAP users: if backend says active, sync with Superwall
        if (_isActive) {
          Superwall.shared.setSubscriptionStatus(
            SubscriptionStatusActive(entitlements: {Entitlement(id: 'premium')}),
          );
          _appData.write(kKeyPaymentMethod, 1);
        }

        log('[SubscriptionService] Backend status: $_status, Active: $_isActive');
      } else {
        log('[SubscriptionService] Bad response: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      if (kDebugMode) {
        log('[SubscriptionService] Error fetching status: $e');
      }
      // Don't override Superwall's status on error
      // Superwall might know the user is subscribed via StoreKit/Google Play
    }
  }

  /// Check Superwall subscription status and update local storage
  Future<bool> checkAndSaveSuperwallStatus() async {
    try {
      final status = await Superwall.shared.getSubscriptionStatus();
      if (status is SubscriptionStatusActive) {
        _isActive = true;
        _status = 'active';
        _appData.write(kKeyPaymentMethod, 1);
        if (kDebugMode) {
          log('[SubscriptionService] Superwall status: active, saved kKeyPaymentMethod = 1');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        log('[SubscriptionService] Error checking Superwall status: $e');
      }
    }
    return false;
  }

  /// Call this when user logs out
  Future<void> onLogout() async {
    _isActive = false;
    _isTrialing = false;
    _status = 'inactive';
    _appData.write(kKeyPaymentMethod, 0);
    // Reset Superwall user identity
    await Superwall.shared.reset();
  }
}

final subscriptionService = SubscriptionService();
