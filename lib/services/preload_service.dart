import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../networks/dio/dio.dart';

/// Fast preloading service - NEVER blocks the UI
/// All operations have short timeouts and run in background
class PreloadService {
  static final PreloadService _instance = PreloadService._internal();
  factory PreloadService() => _instance;
  PreloadService._internal();

  bool _isPreloadingPublic = false;
  bool _isPreloadingAuth = false;
  bool _isPreloadingDeep = false;

  /// Set to true to pause background downloads (user is loading something)
  bool _paused = false;

  /// Pause background downloads to prioritize user-visible content
  void pause() => _paused = true;

  /// Resume background downloads
  void resume() => _paused = false;

  /// Wait while paused (check every 100ms)
  Future<void> _waitIfPaused() async {
    while (_paused) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  // Short timeout for preload requests (don't wait forever)
  static const _timeout = Duration(seconds: 5);

  /// PHASE 1: Call on login/signup screen - FAST, non-blocking
  Future<void> preloadOnLoginScreen() async {
    if (_isPreloadingPublic) return;
    _isPreloadingPublic = true;

    if (kDebugMode) print('[Preload] Phase 1: Starting...');

    // Fire all requests in parallel, don't wait
    unawaited(_warmUpServer());
    unawaited(_preloadEndpoint('/page/home'));
    unawaited(_preloadEndpoint('/plans'));

    _isPreloadingPublic = false;
  }

  /// PHASE 2: Called after login - runs in background, NEVER blocks
  Future<void> preloadAfterLogin() async {
    if (_isPreloadingAuth) return;
    _isPreloadingAuth = true;

    if (kDebugMode) print('[Preload] Phase 2: Starting background load...');

    try {
      // Fire all API calls in parallel with timeout
      final results = await Future.wait([
        _preloadEndpointWithData('/category').timeout(_timeout, onTimeout: () => null),
        _preloadEndpointWithData('/themes').timeout(_timeout, onTimeout: () => null),
        _preloadEndpointWithData('/work_out_list').timeout(_timeout, onTimeout: () => null),
      ]);

      // Fire and forget other endpoints
      unawaited(_preloadEndpoint('/me'));

      // Fetch music list AND preload the actual music files
      unawaited(_preloadMusicFiles());

      // Extract and preload images in background (don't wait)
      _preloadImagesFromResults(results);

      if (kDebugMode) print('[Preload] Phase 2: API calls done');
    } catch (e) {
      if (kDebugMode) print('[Preload] Phase 2 error: $e');
    } finally {
      _isPreloadingAuth = false;
    }
  }

  void _preloadImagesFromResults(List<Map<String, dynamic>?> results) {
    final imageUrls = <String>[];

    // Categories
    if (results[0] != null && results[0]!['data'] != null) {
      for (var item in results[0]!['data']) {
        if (item['image'] != null && item['image'].toString().isNotEmpty) {
          imageUrls.add(item['image']);
        }
      }
    }

    // Themes
    if (results[1] != null && results[1]!['data'] != null) {
      for (var item in results[1]!['data']) {
        if (item['image'] != null && item['image'].toString().isNotEmpty) {
          imageUrls.add(item['image']);
        }
      }
    }

    // Workouts
    if (results[2] != null && results[2]!['active_workouts'] != null) {
      for (var item in results[2]!['active_workouts']) {
        if (item['image'] != null && item['image'].toString().isNotEmpty) {
          imageUrls.add(item['image']);
        }
      }
    }

    // Preload images in background (fire and forget)
    if (imageUrls.isNotEmpty) {
      unawaited(_preloadImages(imageUrls));
    }
  }

  /// PHASE 3: Deep preload on main screen - completely background
  Future<void> preloadDeepContent() async {
    if (_isPreloadingDeep) return;
    _isPreloadingDeep = true;

    if (kDebugMode) print('[Preload] Phase 3: Deep preload starting...');

    try {
      // Get cached data (should be instant if Phase 2 worked)
      final categoryData = await _preloadEndpointWithData('/category').timeout(_timeout, onTimeout: () => null);
      final themeData = await _preloadEndpointWithData('/themes').timeout(_timeout, onTimeout: () => null);

      // Fire all dynamic workout requests in parallel (don't wait for each)
      final futures = <Future>[];

      if (categoryData != null && categoryData['data'] != null) {
        final categories = categoryData['data'] as List;
        for (int i = 0; i < categories.length && i < 3; i++) {
          final id = categories[i]['id'];
          if (id != null) {
            futures.add(_preloadEndpoint('/dynamic_work_out?type=body_part_exercise&id=$id'));
          }
        }
      }

      if (themeData != null && themeData['data'] != null) {
        final themes = themeData['data'] as List;
        for (int i = 0; i < themes.length && i < 3; i++) {
          final id = themes[i]['id'];
          if (id != null) {
            futures.add(_preloadEndpoint('/dynamic_work_out?type=theme_workout&id=$id'));
          }
        }
      }

      // Training levels
      futures.add(_preloadEndpoint('/dynamic_work_out?type=training_level&level_type=beginner'));
      futures.add(_preloadEndpoint('/dynamic_work_out?type=training_level&level_type=intermediate'));
      futures.add(_preloadEndpoint('/dynamic_work_out?type=training_level&level_type=advance'));

      // Run all in parallel, don't wait
      unawaited(Future.wait(futures).timeout(const Duration(seconds: 10), onTimeout: () => []));

      // Also preload music files if not already cached
      unawaited(_preloadMusicFiles());

      if (kDebugMode) print('[Preload] Phase 3 complete');
    } catch (e) {
      if (kDebugMode) print('[Preload] Phase 3 error: $e');
    } finally {
      _isPreloadingDeep = false;
    }
  }

  /// Quick server ping
  Future<void> _warmUpServer() async {
    try {
      await getHttp('/up').timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  /// Preload endpoint with timeout
  Future<void> _preloadEndpoint(String endpoint) async {
    try {
      await getHttp(endpoint).timeout(_timeout);
    } catch (_) {}
  }

  /// Preload and return data
  Future<Map<String, dynamic>?> _preloadEndpointWithData(String endpoint) async {
    try {
      final response = await getHttp(endpoint).timeout(_timeout);
      if (response.statusCode == 200 && response.data != null) {
        return response.data is Map<String, dynamic> ? response.data : null;
      }
    } catch (_) {}
    return null;
  }

  /// Fetch music list and download actual music files to cache (one at a time)
  Future<void> _preloadMusicFiles() async {
    try {
      final musicData = await _preloadEndpointWithData('/music/list')
          .timeout(const Duration(seconds: 8), onTimeout: () => null);

      if (musicData == null || musicData['data'] == null) return;

      final List<dynamic> tracks = musicData['data'];
      final cacheManager = DefaultCacheManager();

      if (kDebugMode) print('[Preload] Downloading ${tracks.length} music files...');

      // Download one at a time to avoid saturating bandwidth
      for (final track in tracks) {
        await _waitIfPaused();
        final url = track['music_file'];
        if (url != null && url.toString().isNotEmpty) {
          try {
            await cacheManager.getSingleFile(url.toString())
                .timeout(const Duration(seconds: 30));
            if (kDebugMode) print('[Preload] Music cached: ${track['title']}');
          } catch (_) {}
          // Breathe between music files
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    } catch (e) {
      if (kDebugMode) print('[Preload] Music preload error: $e');
    }
  }

  /// Background image preloading
  Future<void> _preloadImages(List<String> urls) async {
    final cacheManager = DefaultCacheManager();

    // Load all in parallel (faster)
    await Future.wait(
      urls.take(20).map((url) => _preloadSingleImage(cacheManager, url)),
      eagerError: false,
    );
  }

  Future<void> _preloadSingleImage(BaseCacheManager cacheManager, String url) async {
    if (url.isEmpty) return;
    try {
      await cacheManager.downloadFile(url).timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  /// Full cache preload for CacheLoadingScreen — awaitable with progress callback
  /// Phase 1: API data (categories, themes) + dynamic workouts in parallel
  /// Phase 2: Download all images (categories + themes + courses)
  /// Exercise thumbnails + music load in background on home screen
  Future<void> preloadFullCache({void Function(double)? onProgress}) async {
    if (kDebugMode) print('[Preload] Full cache: Starting...');
    final cacheManager = DefaultCacheManager();

    void progress(double v) => onProgress?.call(v.clamp(0.0, 1.0));

    try {
      // Phase 1: Fetch core API data in parallel (0% → 20%)
      progress(0.02);
      if (kDebugMode) print('[Preload] Phase 1: Fetching API data...');
      final results = await Future.wait([
        _preloadEndpointWithData('/category').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/themes').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/me').timeout(const Duration(seconds: 8), onTimeout: () => null),
      ]);
      progress(0.20);

      // Phase 2: Fetch dynamic workouts + collect images simultaneously (20% → 40%)
      if (kDebugMode) print('[Preload] Phase 2: Fetching courses...');
      final dynamicFutures = <Future<Map<String, dynamic>?>>[];
      final imageUrls = <String>{};

      // Collect category/theme images immediately (don't wait for dynamic workouts)
      if (results[0] != null && results[0]!['data'] != null) {
        for (var item in results[0]!['data']) {
          _addUrl(imageUrls, item['image']);
          final id = item['id'];
          if (id != null) {
            dynamicFutures.add(
              _preloadEndpointWithData('/categoryWiseWorkouts/$id')
                  .timeout(const Duration(seconds: 8), onTimeout: () => null),
            );
          }
        }
      }
      if (results[1] != null && results[1]!['data'] != null) {
        for (var item in results[1]!['data']) {
          _addUrl(imageUrls, item['image']);
          final id = item['id'];
          if (id != null) {
            dynamicFutures.add(
              _preloadEndpointWithData('/themeWiseWorkouts/$id')
                  .timeout(const Duration(seconds: 8), onTimeout: () => null),
            );
          }
        }
      }
      for (final level in ['beginner', 'intermediate', 'advance']) {
        dynamicFutures.add(
          _preloadEndpointWithData('/trainingLevelWiseWorkouts?type=$level')
              .timeout(const Duration(seconds: 8), onTimeout: () => null),
        );
      }

      final dynamicResults = await Future.wait(dynamicFutures);
      progress(0.40);

      // Collect course images from dynamic workout results
      for (final dynResult in dynamicResults) {
        if (dynResult == null) continue;
        _addUrl(imageUrls, dynResult['cover_image']);
        _addUrl(imageUrls, dynResult['coverImage']);
        if (dynResult['data'] != null && dynResult['data'] is List) {
          for (var item in dynResult['data']) {
            _addUrl(imageUrls, item['image']);
          }
        }
      }

      // Phase 3: Download all images concurrently (40% → 95%)
      final urlList = imageUrls.toList();
      if (kDebugMode) print('[Preload] Phase 3: Downloading ${urlList.length} images...');

      int downloaded = 0;
      final total = urlList.length;

      // Download in larger batches of 25 with shorter timeout
      for (int i = 0; i < urlList.length; i += 25) {
        final batch = urlList.skip(i).take(25).map((url) async {
          try {
            await cacheManager.downloadFile(url).timeout(const Duration(seconds: 6));
          } catch (_) {}
          downloaded++;
          if (total > 0) {
            progress(0.40 + (downloaded / total) * 0.55);
          }
        }).toList();
        await Future.wait(batch, eagerError: false);
      }

      progress(0.95);
      if (kDebugMode) print('[Preload] ${urlList.length} images downloaded');

      progress(1.0);
      if (kDebugMode) print('[Preload] Full cache: Complete');
    } catch (e) {
      if (kDebugMode) print('[Preload] Full cache error: $e');
    }
  }

  /// Background preload for exercise thumbnails — called from NavigationScreen
  /// Ultra-lightweight: small batches with delays, pauses when user interacts
  Future<void> preloadExerciseThumbnails() async {
    if (kDebugMode) print('[Preload] Exercise thumbnails: Starting...');
    final cacheManager = DefaultCacheManager();

    try {
      await _waitIfPaused();

      // Get cached data (should be instant — already fetched during cache loading)
      final categoryData = await _preloadEndpointWithData('/category').timeout(_timeout, onTimeout: () => null);
      final themeData = await _preloadEndpointWithData('/themes').timeout(_timeout, onTimeout: () => null);

      // Collect all workout IDs from dynamic workouts
      final workoutIds = <int>{};
      final dynamicFutures = <Future<Map<String, dynamic>?>>[];

      if (categoryData != null && categoryData['data'] != null) {
        for (var item in categoryData['data']) {
          final id = item['id'];
          if (id != null) {
            dynamicFutures.add(
              _preloadEndpointWithData('/categoryWiseWorkouts/$id')
                  .timeout(const Duration(seconds: 8), onTimeout: () => null),
            );
          }
        }
      }
      if (themeData != null && themeData['data'] != null) {
        for (var item in themeData['data']) {
          final id = item['id'];
          if (id != null) {
            dynamicFutures.add(
              _preloadEndpointWithData('/themeWiseWorkouts/$id')
                  .timeout(const Duration(seconds: 8), onTimeout: () => null),
            );
          }
        }
      }

      final dynamicResults = await Future.wait(dynamicFutures);
      for (final dynResult in dynamicResults) {
        if (dynResult == null || dynResult['data'] == null) continue;
        if (dynResult['data'] is List) {
          for (var item in dynResult['data']) {
            if (item['id'] != null) workoutIds.add(item['id']);
          }
        }
      }

      // Fetch video metadata in small batches with pauses
      final imageUrls = <String>{};
      final workoutIdList = workoutIds.toList();
      if (kDebugMode) print('[Preload] Fetching thumbnails for ${workoutIdList.length} workouts...');

      for (int i = 0; i < workoutIdList.length; i += 5) {
        await _waitIfPaused();
        final batch = workoutIdList.skip(i).take(5).map((id) =>
          _preloadEndpointWithData('/workoutWiseVideos/$id')
              .timeout(const Duration(seconds: 8), onTimeout: () => null),
        ).toList();
        final videoResults = await Future.wait(batch);
        for (final videoResult in videoResults) {
          if (videoResult == null || videoResult['data'] == null) continue;
          if (videoResult['data'] is List) {
            for (var exercise in videoResult['data']) {
              _addUrl(imageUrls, exercise['thumbnail']);
            }
          }
        }
        // Small delay between API batches
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Download thumbnails in tiny batches (3 at a time) with delays
      final urlList = imageUrls.toList();
      if (kDebugMode) print('[Preload] Downloading ${urlList.length} exercise thumbnails...');

      for (int i = 0; i < urlList.length; i += 3) {
        await _waitIfPaused();
        final batch = urlList.skip(i).take(3).map((url) async {
          try {
            await cacheManager.downloadFile(url).timeout(const Duration(seconds: 5));
          } catch (_) {}
        }).toList();
        await Future.wait(batch, eagerError: false);
        // Breathe between batches so UI stays smooth
        await Future.delayed(const Duration(milliseconds: 150));
      }

      if (kDebugMode) print('[Preload] Exercise thumbnails: Complete (${urlList.length} images)');
    } catch (e) {
      if (kDebugMode) print('[Preload] Exercise thumbnails error: $e');
    }
  }

  void _addUrl(Set<String> urls, dynamic url) {
    if (url != null && url.toString().isNotEmpty && url.toString().startsWith('http')) {
      urls.add(url.toString());
    }
  }

  void reset() {
    _isPreloadingPublic = false;
    _isPreloadingAuth = false;
    _isPreloadingDeep = false;
  }
}

final preloadService = PreloadService();
