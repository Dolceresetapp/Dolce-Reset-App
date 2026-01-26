import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Service to preload images progressively in background
/// Loads visible images first, then preloads others
class ImagePreloaderService {
  static final ImagePreloaderService _instance = ImagePreloaderService._internal();
  factory ImagePreloaderService() => _instance;
  ImagePreloaderService._internal();

  final Set<String> _preloadedUrls = {};
  final Set<String> _loadingUrls = {};
  bool _isPreloading = false;

  /// Preload a list of image URLs progressively
  /// First batch loads immediately, rest loads in background with delays
  Future<void> preloadImages(List<String> urls, {int firstBatchSize = 4}) async {
    if (urls.isEmpty) return;

    // Filter out already preloaded or currently loading URLs
    final urlsToLoad = urls
        .where((url) => url.isNotEmpty && !_preloadedUrls.contains(url) && !_loadingUrls.contains(url))
        .toList();

    if (urlsToLoad.isEmpty) return;

    // Split into first batch (visible) and rest (background)
    final firstBatch = urlsToLoad.take(firstBatchSize).toList();
    final restBatch = urlsToLoad.skip(firstBatchSize).toList();

    // Load first batch in parallel (visible images)
    await _loadBatch(firstBatch);

    // Load rest progressively in background
    if (restBatch.isNotEmpty) {
      _preloadInBackground(restBatch);
    }
  }

  /// Load a batch of images in parallel
  Future<void> _loadBatch(List<String> urls) async {
    await Future.wait(
      urls.map((url) => _preloadSingle(url)),
      eagerError: false,
    );
  }

  /// Preload remaining images in background with small delays
  Future<void> _preloadInBackground(List<String> urls) async {
    if (_isPreloading) return;
    _isPreloading = true;

    for (final url in urls) {
      if (!_preloadedUrls.contains(url) && !_loadingUrls.contains(url)) {
        await _preloadSingle(url);
        // Small delay between background loads to not overwhelm
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    _isPreloading = false;
  }

  /// Preload a single image
  Future<void> _preloadSingle(String url) async {
    if (url.isEmpty || _preloadedUrls.contains(url) || _loadingUrls.contains(url)) {
      return;
    }

    _loadingUrls.add(url);

    try {
      await DefaultCacheManager().downloadFile(url);
      _preloadedUrls.add(url);

      if (kDebugMode) {
        print('[ImagePreloader] Cached: ${url.substring(0, url.length.clamp(0, 50))}...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ImagePreloader] Failed: $e');
      }
    } finally {
      _loadingUrls.remove(url);
    }
  }

  /// Check if an image is already cached
  bool isCached(String url) => _preloadedUrls.contains(url);

  /// Clear preload tracking (call on logout)
  void reset() {
    _preloadedUrls.clear();
    _loadingUrls.clear();
    _isPreloading = false;
  }
}

/// Global instance
final imagePreloader = ImagePreloaderService();
