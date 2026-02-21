import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../helpers/di.dart';

/// HTTP Cache Interceptor — in-memory cache with GetStorage persistence
/// Returns cached data instantly without disk I/O on hot path
class CacheInterceptor extends Interceptor {
  // Cache TTL (6 hours)
  static const int cacheTTL = 21600000;

  // In-memory cache — avoids sync disk reads + JSON decode on every request
  static final Map<String, _CacheEntry> _memCache = {};
  static bool _loadedFromDisk = false;

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
    '/music/list',
    '/user/music',
    '/page/home',
    '/plans',
    '/faq',
    '/nutration/recipes',
  ];

  String _getCacheKey(RequestOptions options) {
    return 'http_cache_${options.uri.toString()}';
  }

  bool _isCacheable(RequestOptions options) {
    if (options.method.toUpperCase() != 'GET') return false;
    return cacheableEndpoints.any((endpoint) => options.path.contains(endpoint));
  }

  /// Load persisted cache into memory on first use (lazy, one-time)
  void _ensureMemCacheLoaded() {
    if (_loadedFromDisk) return;
    _loadedFromDisk = true;

    // Load cached entries from GetStorage into memory
    for (final endpoint in cacheableEndpoints) {
      // We don't know the exact full URLs, so we'll load lazily on cache miss
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isCacheable(options)) {
      final cacheKey = _getCacheKey(options);

      // 1. Check in-memory cache first (zero-cost)
      final memEntry = _memCache[cacheKey];
      if (memEntry != null && !memEntry.isExpired) {
        if (kDebugMode) {
          print('[Cache] HIT (memory): ${options.path}');
        }
        handler.resolve(
          Response(
            requestOptions: options,
            data: memEntry.data,
            statusCode: 200,
            statusMessage: 'OK (cached)',
          ),
          true,
        );
        return;
      }

      // 2. Fall back to disk cache (only if not in memory)
      if (memEntry == null) {
        try {
          final cachedData = appData.read(cacheKey);
          if (cachedData != null) {
            final cached = jsonDecode(cachedData);
            final timestamp = cached['timestamp'] as int?;
            final data = cached['data'];

            if (timestamp != null) {
              // Store in memory for next time
              _memCache[cacheKey] = _CacheEntry(data: data, timestamp: timestamp);

              if (DateTime.now().millisecondsSinceEpoch - timestamp < cacheTTL) {
                if (kDebugMode) {
                  print('[Cache] HIT (disk): ${options.path}');
                }
                handler.resolve(
                  Response(
                    requestOptions: options,
                    data: data,
                    statusCode: 200,
                    statusMessage: 'OK (cached)',
                  ),
                  true,
                );
                return;
              }
            }
          }
        } catch (e) {
          if (kDebugMode) print('[Cache] Decode error: $e');
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isCacheable(response.requestOptions) && response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      final now = DateTime.now().millisecondsSinceEpoch;

      // Store in memory (instant for next read)
      _memCache[cacheKey] = _CacheEntry(data: response.data, timestamp: now);

      // Persist to disk asynchronously (non-blocking)
      try {
        final cacheData = jsonEncode({
          'timestamp': now,
          'data': response.data,
        });
        appData.write(cacheKey, cacheData);
      } catch (e) {
        if (kDebugMode) print('[Cache] Write error: $e');
      }

      // Evict oldest entries if cache is too large (keep max 50 entries)
      if (_memCache.length > 50) {
        final sorted = _memCache.entries.toList()
          ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
        for (int i = 0; i < sorted.length - 40; i++) {
          _memCache.remove(sorted[i].key);
          appData.remove(sorted[i].key);
        }
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isCacheable(err.requestOptions)) {
      final cacheKey = _getCacheKey(err.requestOptions);

      // Check memory first
      final memEntry = _memCache[cacheKey];
      if (memEntry != null) {
        if (kDebugMode) print('[Cache] Stale fallback (memory): ${err.requestOptions.path}');
        handler.resolve(Response(
          requestOptions: err.requestOptions,
          data: memEntry.data,
          statusCode: 200,
          statusMessage: 'OK (stale cache)',
        ));
        return;
      }

      // Then disk
      try {
        final cachedData = appData.read(cacheKey);
        if (cachedData != null) {
          final cached = jsonDecode(cachedData);
          final data = cached['data'];
          if (kDebugMode) print('[Cache] Stale fallback (disk): ${err.requestOptions.path}');
          handler.resolve(Response(
            requestOptions: err.requestOptions,
            data: data,
            statusCode: 200,
            statusMessage: 'OK (stale cache)',
          ));
          return;
        }
      } catch (_) {}
    }
    handler.next(err);
  }

  /// Clear all HTTP cache (memory + disk)
  static void clearCache() {
    final keys = List<String>.from(_memCache.keys);
    _memCache.clear();
    for (final key in keys) {
      appData.remove(key);
    }
    if (kDebugMode) print('[Cache] All cache cleared');
  }

  /// Invalidate cache for a specific endpoint path
  static void invalidate(String endpointPath) {
    final keysToRemove = _memCache.keys
        .where((key) => key.contains(endpointPath))
        .toList();
    for (final key in keysToRemove) {
      _memCache.remove(key);
      appData.remove(key);
    }
    if (kDebugMode) print('[Cache] Invalidated: $endpointPath (${keysToRemove.length} entries)');
  }
}

class _CacheEntry {
  final dynamic data;
  final int timestamp;

  _CacheEntry({required this.data, required this.timestamp});

  bool get isExpired =>
      DateTime.now().millisecondsSinceEpoch - timestamp > CacheInterceptor.cacheTTL;
}
