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

      // Fire dynamic workout requests one at a time with delays
      final endpoints = <String>[];

      if (categoryData != null && categoryData['data'] != null) {
        final categories = categoryData['data'] as List;
        for (int i = 0; i < categories.length && i < 3; i++) {
          final id = categories[i]['id'];
          if (id != null) {
            endpoints.add('/dynamic_work_out?type=body_part_exercise&id=$id');
          }
        }
      }

      if (themeData != null && themeData['data'] != null) {
        final themes = themeData['data'] as List;
        for (int i = 0; i < themes.length && i < 3; i++) {
          final id = themes[i]['id'];
          if (id != null) {
            endpoints.add('/dynamic_work_out?type=theme_workout&id=$id');
          }
        }
      }

      endpoints.add('/dynamic_work_out?type=training_level&level_type=beginner');
      endpoints.add('/dynamic_work_out?type=training_level&level_type=intermediate');
      endpoints.add('/dynamic_work_out?type=training_level&level_type=advance');

      // Sequential with delays to keep app responsive
      for (final endpoint in endpoints) {
        await _waitIfPaused();
        await _preloadEndpoint(endpoint);
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Preload music files after dynamic workouts (with its own delays)
      await _preloadMusicFiles();

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

      // Download one at a time with long delays — music files are large
      for (final track in tracks) {
        await _waitIfPaused();
        final url = track['music_file'];
        if (url != null && url.toString().isNotEmpty) {
          try {
            await cacheManager.getSingleFile(url.toString())
                .timeout(const Duration(seconds: 30));
            if (kDebugMode) print('[Preload] Music cached: ${track['title']}');
          } catch (_) {}
          // Long delay between music files to keep app responsive
          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
    } catch (e) {
      if (kDebugMode) print('[Preload] Music preload error: $e');
    }
  }

  /// Background image preloading — gentle, one at a time with delays
  Future<void> _preloadImages(List<String> urls) async {
    final cacheManager = DefaultCacheManager();

    // Download 2 at a time with delays to stay lightweight
    final urlList = urls.take(20).toList();
    for (int i = 0; i < urlList.length; i += 2) {
      await _waitIfPaused();
      final batch = urlList.skip(i).take(2).map((url) => _preloadSingleImage(cacheManager, url));
      await Future.wait(batch.toList(), eagerError: false);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _preloadSingleImage(BaseCacheManager cacheManager, String url) async {
    if (url.isEmpty) return;
    try {
      await cacheManager.downloadFile(url).timeout(const Duration(seconds: 10));
    } catch (_) {}
  }

  /// Full cache preload for CacheLoadingScreen — awaitable with progress callback
  /// Loads in order of appearance: workout images first, then exercise thumbnails
  Future<void> preloadFullCache({void Function(double)? onProgress}) async {
    if (kDebugMode) print('[Preload] Full cache: Starting...');
    final cacheManager = DefaultCacheManager();

    void progress(double v) => onProgress?.call(v.clamp(0.0, 1.0));

    try {
      // ── Phase 1: Fetch core API data in parallel (0% → 15%) ──
      progress(0.02);
      if (kDebugMode) print('[Preload] Phase 1: Fetching API data...');
      final results = await Future.wait([
        _preloadEndpointWithData('/category').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/themes').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/me').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/music/list').timeout(const Duration(seconds: 8), onTimeout: () => null),
        _preloadEndpointWithData('/work_out_list').timeout(const Duration(seconds: 8), onTimeout: () => null),
      ]);
      progress(0.15);

      // ── Phase 2: Collect & download WORKOUT images in app order (15% → 60%) ──
      if (kDebugMode) print('[Preload] Phase 2: Workout images (in order)...');
      final workoutImageUrls = <String>[];

      // 1. Category images (appear first on home screen)
      if (results[0] != null && results[0]!['data'] != null) {
        for (var item in results[0]!['data']) {
          _addUrlToList(workoutImageUrls, item['image']);
        }
      }
      // 2. Theme images (appear after categories)
      if (results[1] != null && results[1]!['data'] != null) {
        for (var item in results[1]!['data']) {
          _addUrlToList(workoutImageUrls, item['image']);
        }
      }
      // 3. Active workout images
      if (results[4] != null && results[4]!['active_workouts'] != null) {
        for (var item in results[4]!['active_workouts']) {
          _addUrlToList(workoutImageUrls, item['image']);
        }
      }

      // 4. Fetch dynamic workout lists and collect their images (in category/theme order)
      final dynamicEndpoints = <String>[];
      if (results[0] != null && results[0]!['data'] != null) {
        for (var item in results[0]!['data']) {
          if (item['id'] != null) {
            dynamicEndpoints.add('/dynamic_work_out?type=body_part_exercise&id=${item['id']}');
          }
        }
      }
      if (results[1] != null && results[1]!['data'] != null) {
        for (var item in results[1]!['data']) {
          if (item['id'] != null) {
            dynamicEndpoints.add('/dynamic_work_out?type=theme_workout&id=${item['id']}');
          }
        }
      }
      dynamicEndpoints.addAll([
        '/dynamic_work_out?type=training_level&level_type=beginner',
        '/dynamic_work_out?type=training_level&level_type=intermediate',
        '/dynamic_work_out?type=training_level&level_type=advance',
      ]);

      // Fetch dynamic workout data in parallel (fast, just API calls)
      final dynamicResults = await Future.wait(
        dynamicEndpoints.map((e) =>
          _preloadEndpointWithData(e).timeout(const Duration(seconds: 8), onTimeout: () => null),
        ),
      );
      // Collect workout images in order + gather workout IDs for exercise phase
      final workoutIds = <int>[];
      for (final dynResult in dynamicResults) {
        if (dynResult == null || dynResult['data'] == null) continue;
        if (dynResult['data'] is List) {
          for (var item in dynResult['data']) {
            _addUrlToList(workoutImageUrls, item['image']);
            if (item['id'] != null) workoutIds.add(item['id']);
          }
        }
      }
      progress(0.25);

      // Download all workout images in order, batches of 8
      if (kDebugMode) print('[Preload] Downloading ${workoutImageUrls.length} workout images...');
      await _downloadImagesInOrder(cacheManager, workoutImageUrls, 0.25, 0.60, progress);
      progress(0.60);

      // ── Phase 3: Collect & download EXERCISE thumbnails in order (60% → 95%) ──
      if (kDebugMode) print('[Preload] Phase 3: Exercise thumbnails (in order)...');
      final exerciseImageUrls = <String>[];

      // Deduplicate workout IDs while preserving order
      final seenIds = <int>{};
      final uniqueWorkoutIds = <int>[];
      for (final id in workoutIds) {
        if (seenIds.add(id)) uniqueWorkoutIds.add(id);
      }

      // Fetch exercise data for each workout (in order of appearance)
      for (final id in uniqueWorkoutIds) {
        try {
          final videoResult = await _preloadEndpointWithData('/workoutWiseVideos/$id')
              .timeout(const Duration(seconds: 6), onTimeout: () => null);
          if (videoResult != null && videoResult['data'] is List) {
            for (var exercise in videoResult['data']) {
              _addUrlToList(exerciseImageUrls, exercise['thumbnail']);
            }
          }
        } catch (_) {}
      }
      progress(0.65);

      // Download exercise thumbnails in order, batches of 8
      if (kDebugMode) print('[Preload] Downloading ${exerciseImageUrls.length} exercise thumbnails...');
      await _downloadImagesInOrder(cacheManager, exerciseImageUrls, 0.65, 0.95, progress);

      progress(0.95);
      if (kDebugMode) print('[Preload] ${workoutImageUrls.length} workout + ${exerciseImageUrls.length} exercise images downloaded');

      progress(1.0);
      if (kDebugMode) print('[Preload] Full cache: Complete');
    } catch (e) {
      if (kDebugMode) print('[Preload] Full cache error: $e');
    }
  }

  /// Download a list of image URLs in order, reporting progress between [startP] and [endP]
  Future<void> _downloadImagesInOrder(
    BaseCacheManager cacheManager,
    List<String> urls,
    double startP,
    double endP,
    void Function(double) progress,
  ) async {
    if (urls.isEmpty) return;
    int downloaded = 0;
    final total = urls.length;

    for (int i = 0; i < urls.length; i += 8) {
      final batch = urls.skip(i).take(8).map((url) async {
        try {
          await cacheManager.downloadFile(url).timeout(const Duration(seconds: 6));
        } catch (_) {}
        downloaded++;
        progress(startP + (downloaded / total) * (endP - startP));
      }).toList();
      await Future.wait(batch, eagerError: false);
      await Future.delayed(const Duration(milliseconds: 30));
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

      // Fetch one at a time with delays to avoid saturating the network
      for (int i = 0; i < workoutIdList.length; i++) {
        await _waitIfPaused();
        try {
          final videoResult = await _preloadEndpointWithData('/workoutWiseVideos/${workoutIdList[i]}')
              .timeout(const Duration(seconds: 8), onTimeout: () => null);
          if (videoResult != null && videoResult['data'] is List) {
            for (var exercise in videoResult['data']) {
              _addUrl(imageUrls, exercise['thumbnail']);
            }
          }
        } catch (_) {}
        // Generous delay between API calls
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Download thumbnails one at a time with generous delays
      final urlList = imageUrls.toList();
      if (kDebugMode) print('[Preload] Downloading ${urlList.length} exercise thumbnails...');

      for (int i = 0; i < urlList.length; i++) {
        await _waitIfPaused();
        try {
          await cacheManager.downloadFile(urlList[i]).timeout(const Duration(seconds: 8));
        } catch (_) {}
        // Long delay between each download to keep app fluid
        await Future.delayed(const Duration(milliseconds: 500));
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

  /// Add URL to ordered list (avoids duplicates while preserving order)
  void _addUrlToList(List<String> urls, dynamic url) {
    if (url != null && url.toString().isNotEmpty && url.toString().startsWith('http')) {
      final s = url.toString();
      if (!urls.contains(s)) urls.add(s);
    }
  }

  void reset() {
    _isPreloadingPublic = false;
    _isPreloadingAuth = false;
    _isPreloadingDeep = false;
  }
}

final preloadService = PreloadService();
