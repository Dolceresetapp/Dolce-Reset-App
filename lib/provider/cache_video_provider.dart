import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

import '../features/ready/data/model/workout_video_response_model.dart';
import '../networks/api_acess.dart';

class CacheVideoProvider extends ChangeNotifier {
  List<Datum> data = [];

  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;

  int currentIndex = 0;

  VideoPlayerController? get controller => _controller;

  bool get isPlaying => _controller?.value.isPlaying ?? false;

  // 🔥 Fetch API data
  Future<void> getData(int videoId) async {
    final response = await workoutVideoRxObj.workoutVideoRx(id: videoId);
    data = response.data ?? [];

    if (data.isNotEmpty) {
      await _loadVideo(0);
    }
    notifyListeners();
  }

  // 🎬 Load video by index
  Future<void> _loadVideo(int index) async {
    // Dispose previous
    await _controller?.pause();
    await _controller?.dispose();

    final url = data[index].videos!;
    final file = await DefaultCacheManager().getSingleFile(url);

    _controller = VideoPlayerController.file(file);
    _initializeFuture = _controller!.initialize().then((_) {
      _controller!
        ..setLooping(true)
        ..play();
    });

    currentIndex = index;
    notifyListeners();
  }

  // ▶️ ⏸ Play / Pause
  void playPause() {
    if (_controller == null) return;

    _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();

    notifyListeners();
  }

  // ⏭ Next
  Future<void> next() async {
    if (currentIndex >= data.length - 1) return;
    await _loadVideo(currentIndex + 1);
  }

  // ⏮ Previous
  Future<void> previous() async {
    if (currentIndex <= 0) return;
    await _loadVideo(currentIndex - 1);
  }

  Future<void> waitForInit() => _initializeFuture ?? Future.value();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}