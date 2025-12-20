import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

import '../features/ready/data/model/workout_video_response_model.dart';
import '../networks/api_acess.dart';

class CacheVideoProvider extends ChangeNotifier {
  List<Datum> data = [];

  VideoPlayerController? _controller;
  VideoPlayerController? get controller => _controller;

  int currentIndex = 0;

  /// Fetch API data
  Future<void> getData(int videoId) async {
    final response = await workoutVideoRxObj.workoutVideoRx(id: videoId);
    data = response.data ?? [];

    if (data.isNotEmpty) {
      await _loadVideo(0);
      _preloadNext(0);
    }

    notifyListeners();
  }

  /// Load & play current video (with cache)
  Future<void> _loadVideo(int index) async {
    _controller?.dispose();

    final String videoUrl = data[index].videos ?? '';

    File file = await DefaultCacheManager().getSingleFile(videoUrl);

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        _controller!
          ..setLooping(true)
          ..play();
        notifyListeners();
      });
  }

  /// Preload next video (cache only – no controller)
  void _preloadNext(int index) {
    if (index + 1 < data.length) {
      final nextUrl = data[index + 1].videos ?? '';
      DefaultCacheManager().getSingleFile(nextUrl);
    }
  }

  /// Call this from PageView onPageChanged
  Future<void> onPageChanged(int index) async {
    currentIndex = index;
    await _loadVideo(index);
    _preloadNext(index);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
