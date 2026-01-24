import 'package:flutter/foundation.dart';
import '../networks/dio/dio.dart';
import '../helpers/di.dart';
import 'dart:convert';

/// Service to preload and cache data when the app starts
/// This runs in the background and caches API responses for faster access
class PreloadService {
  static final PreloadService _instance = PreloadService._internal();
  factory PreloadService() => _instance;
  PreloadService._internal();

  bool _isPreloading = false;
  bool _hasPreloaded = false;

  /// Preload essential data in the background
  /// Call this when the app starts, even before login
  Future<void> preloadEssentialData() async {
    if (_isPreloading || _hasPreloaded) return;
    _isPreloading = true;

    if (kDebugMode) {
      print('[PreloadService] Starting background preload...');
    }

    try {
      // Preload public endpoints that don't require auth
      await Future.wait([
        _preloadEndpoint('/page/home', 'preload_home'),
        _preloadEndpoint('/plans', 'preload_plans'),
        _preloadEndpoint('/reviews', 'preload_reviews'),
        _preloadEndpoint('/faq', 'preload_faq'),
      ]);

      _hasPreloaded = true;
      if (kDebugMode) {
        print('[PreloadService] Background preload completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[PreloadService] Preload error: $e');
      }
    } finally {
      _isPreloading = false;
    }
  }

  /// Preload authenticated data after login
  Future<void> preloadAuthenticatedData() async {
    if (kDebugMode) {
      print('[PreloadService] Starting authenticated data preload...');
    }

    try {
      await Future.wait([
        _preloadEndpoint('/category', 'preload_categories'),
        _preloadEndpoint('/themes', 'preload_themes'),
      ]);

      if (kDebugMode) {
        print('[PreloadService] Authenticated data preload completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[PreloadService] Auth preload error: $e');
      }
    }
  }

  /// Preload a single endpoint and cache the response
  Future<void> _preloadEndpoint(String endpoint, String cacheKey) async {
    try {
      final response = await getHttp(endpoint);
      if (response.statusCode == 200) {
        // Cache the response
        final cacheData = jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': response.data,
        });
        appData.write('http_cache_${DioSingleton.instance.dio.options.baseUrl}$endpoint', cacheData);

        if (kDebugMode) {
          print('[PreloadService] Cached: $endpoint');
        }
      }
    } catch (e) {
      // Silently fail - this is background preloading
      if (kDebugMode) {
        print('[PreloadService] Failed to preload $endpoint: $e');
      }
    }
  }

  /// Reset preload state (call on logout)
  void reset() {
    _hasPreloaded = false;
  }
}

/// Global instance for easy access
final preloadService = PreloadService();
