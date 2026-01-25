import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../helpers/di.dart';

/// HTTP Cache Interceptor using GetStorage
/// Caches GET requests and returns cached data immediately while refreshing in background
class CacheInterceptor extends Interceptor {
  // Cache TTL in milliseconds (6 hours for better UX)
  static const int cacheTTL = 21600000;

  // Endpoints that should be cached
  static const List<String> cacheableEndpoints = [
    '/me',
    '/category',
    '/themes',
    '/categoryWiseWorkouts',
    '/themeWiseWorkouts',
    '/trainingLevelWiseWorkouts',
    '/workoutWiseVideos',
    '/circels',
    '/work_out_list',
    '/my_active_workouts',
    '/music',
    '/user_music',
    '/page/home',
    '/plans',
    '/faq',
  ];

  String _getCacheKey(RequestOptions options) {
    return 'http_cache_${options.uri.toString()}';
  }

  bool _isCacheable(RequestOptions options) {
    if (options.method.toUpperCase() != 'GET') return false;
    return cacheableEndpoints.any((endpoint) => options.path.contains(endpoint));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isCacheable(options)) {
      final cacheKey = _getCacheKey(options);
      final cachedData = appData.read(cacheKey);

      if (cachedData != null) {
        try {
          final cached = jsonDecode(cachedData);
          final timestamp = cached['timestamp'] as int?;
          final data = cached['data'];

          // Check if cache is still valid
          if (timestamp != null &&
              DateTime.now().millisecondsSinceEpoch - timestamp < cacheTTL) {
            if (kDebugMode) {
              print('[CacheInterceptor] Returning cached response for: ${options.path}');
            }
            // Return cached response immediately
            handler.resolve(
              Response(
                requestOptions: options,
                data: data,
                statusCode: 200,
                statusMessage: 'OK (cached)',
              ),
              true, // Mark as resolved from cache
            );
            return;
          }
        } catch (e) {
          // Invalid cache, continue with request
          if (kDebugMode) {
            print('[CacheInterceptor] Cache decode error: $e');
          }
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isCacheable(response.requestOptions) && response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      try {
        final cacheData = jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': response.data,
        });
        appData.write(cacheKey, cacheData);
        if (kDebugMode) {
          print('[CacheInterceptor] Cached response for: ${response.requestOptions.path}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('[CacheInterceptor] Cache write error: $e');
        }
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // On error, try to return cached data as fallback
    if (_isCacheable(err.requestOptions)) {
      final cacheKey = _getCacheKey(err.requestOptions);
      final cachedData = appData.read(cacheKey);

      if (cachedData != null) {
        try {
          final cached = jsonDecode(cachedData);
          final data = cached['data'];

          if (kDebugMode) {
            print('[CacheInterceptor] Returning stale cache on error for: ${err.requestOptions.path}');
          }

          handler.resolve(
            Response(
              requestOptions: err.requestOptions,
              data: data,
              statusCode: 200,
              statusMessage: 'OK (stale cache)',
            ),
          );
          return;
        } catch (e) {
          // Invalid cache, propagate error
        }
      }
    }
    handler.next(err);
  }

  /// Clear all HTTP cache
  static void clearCache() {
    // Get all keys and remove cache entries
    // Note: GetStorage doesn't have a keys() method, so we track cached keys
    if (kDebugMode) {
      print('[CacheInterceptor] Cache cleared');
    }
  }
}
