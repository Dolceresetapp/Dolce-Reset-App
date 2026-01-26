import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../networks/dio/dio.dart';
import '../helpers/di.dart';
import 'dart:convert';

/// Aggressive preloading service that caches everything in background
/// Strategy: Start preloading on login screen, continue after auth
class PreloadService {
  static final PreloadService _instance = PreloadService._internal();
  factory PreloadService() => _instance;
  PreloadService._internal();

  bool _isPreloadingPublic = false;
  bool _isPreloadingAuth = false;
  bool _isPreloadingDeep = false;

  /// PHASE 1: Call on login/signup screen
  /// Warms up server and preloads public content
  Future<void> preloadOnLoginScreen() async {
    if (_isPreloadingPublic) return;
    _isPreloadingPublic = true;

    if (kDebugMode) print('[Preload] Phase 1: Login screen preload starting...');

    try {
      // Warm up server first (Railway cold start)
      await _warmUpServer();

      // Preload public data in parallel
      await Future.wait([
        _preloadEndpoint('/page/home'),
        _preloadEndpoint('/plans'),
        _preloadEndpoint('/reviews'),
        _preloadEndpoint('/faq'),
      ]);

      if (kDebugMode) print('[Preload] Phase 1 complete');
    } catch (e) {
      if (kDebugMode) print('[Preload] Phase 1 error: $e');
    } finally {
      _isPreloadingPublic = false;
    }
  }

  /// PHASE 2: Call after successful login (in DataLoadingScreen)
  /// Preloads all main screen data + images
  Future<void> preloadAfterLogin() async {
    if (_isPreloadingAuth) return;
    _isPreloadingAuth = true;

    if (kDebugMode) print('[Preload] Phase 2: Auth data preload starting...');

    try {
      // Load core data first
      final results = await Future.wait([
        _preloadEndpointWithData('/category'),
        _preloadEndpointWithData('/themes'),
        _preloadEndpointWithData('/work_out_list'),
        _preloadEndpoint('/me'),
        _preloadEndpoint('/music/list'),
      ]);

      // Extract image URLs and preload them
      final imageUrls = <String>[];

      // Categories images
      if (results[0] != null && results[0]['data'] != null) {
        for (var item in results[0]['data']) {
          if (item['image'] != null && item['image'].toString().isNotEmpty) {
            imageUrls.add(item['image']);
          }
        }
      }

      // Themes images
      if (results[1] != null && results[1]['data'] != null) {
        for (var item in results[1]['data']) {
          if (item['image'] != null && item['image'].toString().isNotEmpty) {
            imageUrls.add(item['image']);
          }
        }
      }

      // Workouts images
      if (results[2] != null && results[2]['active_workouts'] != null) {
        for (var item in results[2]['active_workouts']) {
          if (item['image'] != null && item['image'].toString().isNotEmpty) {
            imageUrls.add(item['image']);
          }
        }
      }

      // Preload all images
      if (imageUrls.isNotEmpty) {
        await _preloadImages(imageUrls);
      }

      if (kDebugMode) print('[Preload] Phase 2 complete - ${imageUrls.length} images cached');
    } catch (e) {
      if (kDebugMode) print('[Preload] Phase 2 error: $e');
    } finally {
      _isPreloadingAuth = false;
    }
  }

  /// PHASE 3: Call on main screen (NavigationScreen)
  /// Deep preloads workout details progressively in background
  Future<void> preloadDeepContent() async {
    if (_isPreloadingDeep) return;
    _isPreloadingDeep = true;

    if (kDebugMode) print('[Preload] Phase 3: Deep preload starting...');

    try {
      // Get categories and themes to preload their workout lists
      final categoryData = await _preloadEndpointWithData('/category');
      final themeData = await _preloadEndpointWithData('/themes');

      // Preload first 3 categories workout lists
      if (categoryData != null && categoryData['data'] != null) {
        final categories = categoryData['data'] as List;
        for (int i = 0; i < categories.length && i < 3; i++) {
          final id = categories[i]['id'];
          if (id != null) {
            await _preloadEndpointWithData('/dynamic_work_out?type=body_part_exercise&id=$id');
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      }

      // Preload first 3 themes workout lists
      if (themeData != null && themeData['data'] != null) {
        final themes = themeData['data'] as List;
        for (int i = 0; i < themes.length && i < 3; i++) {
          final id = themes[i]['id'];
          if (id != null) {
            await _preloadEndpointWithData('/dynamic_work_out?type=theme_workout&id=$id');
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      }

      // Preload training levels
      await Future.wait([
        _preloadEndpoint('/dynamic_work_out?type=training_level&level_type=beginner'),
        _preloadEndpoint('/dynamic_work_out?type=training_level&level_type=intermediate'),
        _preloadEndpoint('/dynamic_work_out?type=training_level&level_type=advance'),
      ]);

      if (kDebugMode) print('[Preload] Phase 3 complete');
    } catch (e) {
      if (kDebugMode) print('[Preload] Phase 3 error: $e');
    } finally {
      _isPreloadingDeep = false;
    }
  }

  /// Warm up server (Railway cold start)
  Future<void> _warmUpServer() async {
    try {
      await getHttp('/up');
      if (kDebugMode) print('[Preload] Server warm-up done');
    } catch (e) {
      // Try alternate endpoint
      try {
        await getHttp('/api/health');
      } catch (_) {}
    }
  }

  /// Preload endpoint and cache response
  Future<void> _preloadEndpoint(String endpoint) async {
    try {
      await getHttp(endpoint);
    } catch (e) {
      if (kDebugMode) print('[Preload] Failed: $endpoint');
    }
  }

  /// Preload endpoint and return data for further processing
  Future<Map<String, dynamic>?> _preloadEndpointWithData(String endpoint) async {
    try {
      final response = await getHttp(endpoint);
      if (response.statusCode == 200 && response.data != null) {
        return response.data is Map<String, dynamic>
            ? response.data
            : null;
      }
    } catch (e) {
      if (kDebugMode) print('[Preload] Failed: $endpoint');
    }
    return null;
  }

  /// Preload images using cache manager
  Future<void> _preloadImages(List<String> urls) async {
    final cacheManager = DefaultCacheManager();

    // Load first 6 immediately (visible)
    final immediate = urls.take(6).toList();
    await Future.wait(
      immediate.map((url) => _preloadSingleImage(cacheManager, url)),
      eagerError: false,
    );

    // Load rest progressively
    final rest = urls.skip(6).toList();
    for (final url in rest) {
      await _preloadSingleImage(cacheManager, url);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _preloadSingleImage(BaseCacheManager cacheManager, String url) async {
    if (url.isEmpty) return;
    try {
      await cacheManager.downloadFile(url);
    } catch (e) {
      // Ignore - background preloading
    }
  }

  /// Reset state on logout
  void reset() {
    _isPreloadingPublic = false;
    _isPreloadingAuth = false;
    _isPreloadingDeep = false;
  }
}

/// Global instance
final preloadService = PreloadService();
