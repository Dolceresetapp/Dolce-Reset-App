import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';

import '../features/ready/data/model/workout_video_response_model.dart';
import '../networks/api_acess.dart';

class CacheVideoProvider extends ChangeNotifier {
  List<Datum> data = [];
  WorkoutWiseVideoResponseModel model = WorkoutWiseVideoResponseModel();
  List<Music>? _cachedMusic;

  VideoPlayerController? _controller;
  VideoPlayerController? _nextController;
  Future<void>? _initializeFuture;
  int currentIndex = 0;
  bool _isControllerDisposed = true;
  VoidCallback? _videoListener;
  bool _isAutoNexting = false;
  bool _isTransitioning = false;
  bool _isDisposed = false;
  bool _isLoadingVideo = false;
  DateTime? _lastTransitionTime;
  bool _workoutCompleted = false;

  // Track actual workout progress
  DateTime? _workoutStartTime;
  int _completedExercises = 0;

  // Callbacks
  VoidCallback? onWorkoutComplete;
  VoidCallback? onRestNeeded;

  // Rest timer settings (valid values: 0, 10, 15, 20, 30)
  int _restDuration = 0;

  // Timers for cleanup
  Timer? _restCallbackTimer;
  Timer? _completeCallbackTimer;

  // Text-to-Speech for voiceover instructions
  FlutterTts? _tts;
  bool _voiceoverEnabled = true;
  bool _isTtsInitialized = false;
  Timer? _voiceoverRepeatTimer;
  bool _isSpeaking = false;

  int get restDuration => _restDuration;

  set restDuration(int value) {
    // Validate input
    const validValues = [0, 10, 15, 20, 30];
    if (validValues.contains(value)) {
      _restDuration = value;
      _safeNotify();
    }
  }

  VideoPlayerController? get controller => _controller;

  int get actualSeconds {
    if (_workoutStartTime == null) return 0;
    return DateTime.now().difference(_workoutStartTime!).inSeconds;
  }

  String get actualTimeFormatted {
    final totalSeconds = actualSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int get actualKcal {
    if (_workoutStartTime == null || model.minutes == null || model.minutes == 0) return 0;
    final totalMinutes = model.minutes!;
    final totalCal = model.totalCal ?? 0;
    final ratio = actualSeconds / (totalMinutes * 60);
    return (totalCal * ratio).round().clamp(1, totalCal);
  }

  int get completedExercises => _completedExercises;
  bool get isTransitioning => _isTransitioning;

  bool get isPlaying {
    if (_controller == null || _isControllerDisposed) return false;
    try {
      return _controller!.value.isPlaying;
    } catch (e) {
      return false;
    }
  }

  bool get isLastExercise => currentIndex >= data.length - 1;
  bool get isLoadingVideo => _isLoadingVideo;

  List<Music>? get music {
    _cachedMusic ??= data
        .where((e) => e.music != null)
        .expand((e) => e.music!)
        .toList();
    return _cachedMusic;
  }

  // Voiceover settings
  bool get voiceoverEnabled => _voiceoverEnabled;

  set voiceoverEnabled(bool value) {
    final wasEnabled = _voiceoverEnabled;
    _voiceoverEnabled = value;

    if (!value) {
      // Turning OFF - stop immediately
      _stopVoiceover();
    } else if (!wasEnabled && value) {
      // Turning ON - restart the cycle with normal timing
      if (isPlaying && !_workoutCompleted) {
        _playVoiceover();
      }
    }
    _safeNotify();
  }

  /// Initialize TTS with Italian female voice
  Future<void> _initTts() async {
    if (_isTtsInitialized) return;

    try {
      _tts = FlutterTts();

      // Configure for iOS - important for audio to work with video
      await _tts!.setSharedInstance(true);
      await _tts!.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.duckOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      await _tts!.setLanguage("it-IT");

      // Try to set a female Italian voice
      final voices = await _tts!.getVoices;
      if (voices != null) {
        final voiceList = List<Map<dynamic, dynamic>>.from(voices);

        // Known male Italian voice names to exclude
        const maleVoices = ['luca', 'giorgio', 'diego', 'marco', 'male'];
        // Known female Italian voice names to prefer
        const femaleVoices = ['alice', 'federica', 'elsa', 'female', 'paola', 'francesca'];

        // Filter Italian voices
        final italianVoices = voiceList.where((voice) {
          final locale = (voice['locale'] ?? '').toString().toLowerCase();
          return locale.contains('it');
        }).toList();

        if (italianVoices.isNotEmpty) {
          // First try to find a known female voice
          Map<dynamic, dynamic>? selectedVoice;

          for (final voice in italianVoices) {
            final name = (voice['name'] ?? '').toString().toLowerCase();
            if (femaleVoices.any((f) => name.contains(f))) {
              selectedVoice = voice;
              break;
            }
          }

          // If no known female found, pick first non-male Italian voice
          selectedVoice ??= italianVoices.firstWhere(
            (voice) {
              final name = (voice['name'] ?? '').toString().toLowerCase();
              return !maleVoices.any((m) => name.contains(m));
            },
            orElse: () => italianVoices.first,
          );

          if (selectedVoice['name'] != null) {
            await _tts!.setVoice({
              'name': selectedVoice['name'],
              'locale': selectedVoice['locale'] ?? 'it-IT',
            });
          }
        }
      }

      await _tts!.setSpeechRate(0.45); // Slightly slower for clarity
      await _tts!.setVolume(1.0);
      await _tts!.setPitch(1.05); // Slightly higher pitch for feminine tone

      // Set completion handler
      _tts!.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _isTtsInitialized = true;
      debugPrint('Exercise TTS initialized successfully');
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  /// Play voiceover for current exercise
  /// First voiceover 3 seconds after start, then repeat every 6 seconds
  Future<void> _playVoiceover() async {
    // Cancel any existing repeat timer
    _voiceoverRepeatTimer?.cancel();
    _voiceoverRepeatTimer = null;

    if (!_voiceoverEnabled || _isDisposed) return;
    if (currentIndex < 0 || currentIndex >= data.length) return;

    // Store the exercise index when voiceover started
    final startedForIndex = currentIndex;

    await _initTts();
    if (_tts == null) return;

    // Wait 3 seconds before first voiceover
    await Future.delayed(const Duration(seconds: 3));

    // Check if still valid (same exercise, not disposed, enabled, playing)
    if (_isDisposed || !_voiceoverEnabled || _workoutCompleted) return;
    if (currentIndex != startedForIndex) return; // Exercise changed
    if (!isPlaying) return;

    // Get current exercise text (always fresh)
    final currentText = data[currentIndex].voiceoverText;
    if (currentText == null || currentText.isEmpty) return;

    // Speak first time
    await _speakText(currentText);

    // Set up repeat timer every 6 seconds
    _voiceoverRepeatTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      // Always check current state
      if (_isDisposed || !_voiceoverEnabled || _workoutCompleted) {
        timer.cancel();
        return;
      }
      // Get CURRENT exercise text (not captured text)
      if (currentIndex < 0 || currentIndex >= data.length) {
        timer.cancel();
        return;
      }
      final text = data[currentIndex].voiceoverText;
      if (text == null || text.isEmpty) return;

      // Only speak if not currently speaking and video is playing
      if (!_isSpeaking && isPlaying) {
        _speakText(text);
      }
    });
  }

  Future<void> _speakText(String text) async {
    if (_tts == null || _isDisposed) return;

    try {
      _isSpeaking = true;
      debugPrint('Speaking: $text');
      await _tts!.speak(text);
    } catch (e) {
      debugPrint('Error speaking: $e');
      _isSpeaking = false;
    }
  }

  /// Stop any ongoing voiceover and cancel repeat timer
  Future<void> _stopVoiceover() async {
    _voiceoverRepeatTimer?.cancel();
    _voiceoverRepeatTimer = null;
    _isSpeaking = false;

    if (_tts == null) return;

    try {
      await _tts!.stop();
    } catch (e) {
      // Ignore stop errors
    }
  }

  void reset() {
    // Stop voiceover
    _stopVoiceover();

    // Cancel pending timers
    _restCallbackTimer?.cancel();
    _completeCallbackTimer?.cancel();
    _restCallbackTimer = null;
    _completeCallbackTimer = null;

    _cleanupController();
    _cleanupNextController();

    data = [];
    model = WorkoutWiseVideoResponseModel();
    _cachedMusic = null;
    currentIndex = 0;
    _initializeFuture = null;
    _isTransitioning = false;
    _isDisposed = false;
    _isLoadingVideo = false;
    _lastTransitionTime = null;
    _workoutStartTime = null;
    _completedExercises = 0;
    _workoutCompleted = false;
    _isAutoNexting = false;
  }

  void _removeVideoListener() {
    if (_videoListener != null && _controller != null) {
      try {
        _controller!.removeListener(_videoListener!);
      } catch (e) {
        // Controller may already be disposed
      }
      _videoListener = null;
    }
  }

  Future<void> _cleanupController() async {
    _removeVideoListener();

    if (_controller != null && !_isControllerDisposed) {
      try {
        await _controller!.pause();
        await _controller!.dispose();
      } catch (e) {
        // Ignore disposal errors
      }
    }
    _controller = null;
    _isControllerDisposed = true;
  }

  Future<void> _cleanupNextController() async {
    if (_nextController != null) {
      try {
        await _nextController!.dispose();
      } catch (e) {
        // Ignore disposal errors
      }
      _nextController = null;
    }
  }

  Future<void> getData(int videoId) async {
    reset();

    final response = await workoutVideoRxObj.workoutVideoRx(id: videoId);
    model = response;
    data = response.data ?? [];
    _cachedMusic = null;

    if (data.isNotEmpty) {
      // Preload all videos in background (fire and forget)
      unawaited(_preloadAllVideos());
      // Load first video but don't auto-play (countdown will start it)
      await _loadVideo(0, autoPlay: false);
    }
    _safeNotify();
  }

  Future<void> _preloadAllVideos() async {
    // Preload first 3 videos in parallel for faster start
    final firstBatch = <Future<void>>[];
    for (int i = 1; i < data.length && i <= 3; i++) {
      final url = data[i].videos;
      if (url != null && url.isNotEmpty) {
        firstBatch.add(
          DefaultCacheManager().getSingleFile(url).then((_) {}).catchError((_) {}),
        );
      }
    }
    await Future.wait(firstBatch);

    // Preload remaining videos sequentially to not overload
    for (int i = 4; i < data.length; i++) {
      if (_isDisposed) return;

      try {
        final url = data[i].videos;
        if (url != null && url.isNotEmpty) {
          await DefaultCacheManager().getSingleFile(url);
        }
      } catch (e) {
        // Ignore preload errors - video will load on demand
      }
    }
  }

  Future<void> _loadVideo(int index, {bool autoPlay = true}) async {
    // Prevent concurrent loading
    if (_isLoadingVideo) return;

    // Cooldown check - 250ms between transitions (faster response)
    if (_lastTransitionTime != null) {
      final elapsed = DateTime.now().difference(_lastTransitionTime!).inMilliseconds;
      if (elapsed < 250) return;
    }

    // Bounds check
    if (index < 0 || index >= data.length) return;

    // Check video URL exists
    final url = data[index].videos;
    if (url == null || url.isEmpty) return;

    // Stop current voiceover before transitioning
    _stopVoiceover();

    // Lock loading
    _isLoadingVideo = true;
    _isTransitioning = true;
    _safeNotify();

    // Short delay for fade out animation (reduced for snappier feel)
    await Future.delayed(const Duration(milliseconds: 80));

    if (_isDisposed) {
      _isLoadingVideo = false;
      return;
    }

    // Check if preloaded controller is ready
    final usePreloaded = _nextController != null &&
        index == currentIndex + 1 &&
        _nextController!.value.isInitialized;

    if (usePreloaded) {
      await _switchToPreloadedController(index, autoPlay);
    } else {
      await _loadNewController(index, url, autoPlay);
    }
  }

  Future<void> _switchToPreloadedController(int index, bool autoPlay) async {
    // Remove listener from old controller first
    _removeVideoListener();

    await _cleanupController();

    _controller = _nextController;
    _nextController = null;
    _isControllerDisposed = false;
    _isAutoNexting = false;
    currentIndex = index;

    // Setup new listener
    _videoListener = _onVideoProgress;
    _controller!.addListener(_videoListener!);

    if (autoPlay) {
      try {
        await _controller!.play();
      } catch (e) {
        debugPrint('Error playing video: $e');
      }
    }

    _finishLoading();

    // Preload next video
    unawaited(_preloadNextController());
  }

  Future<void> _loadNewController(int index, String url, bool autoPlay) async {
    // Cleanup unusable preloaded controller
    await _cleanupNextController();
    await _cleanupController();

    try {
      final file = await DefaultCacheManager().getSingleFile(url);

      if (_isDisposed) {
        _isLoadingVideo = false;
        return;
      }

      _isControllerDisposed = false;
      _isAutoNexting = false;
      currentIndex = index;
      _controller = VideoPlayerController.file(file);

      _initializeFuture = _controller!.initialize();
      await _initializeFuture;

      if (_isControllerDisposed || _controller == null || _isDisposed) {
        _isLoadingVideo = false;
        return;
      }

      _controller!.setLooping(false);

      // Setup listener
      _videoListener = _onVideoProgress;
      _controller!.addListener(_videoListener!);

      if (autoPlay) {
        try {
          await _controller!.play();
        } catch (e) {
          debugPrint('Error playing video: $e');
        }
      }

      _finishLoading();

      // Preload next video
      unawaited(_preloadNextController());
    } catch (e) {
      debugPrint('Error loading video: $e');
      _isTransitioning = false;
      _isLoadingVideo = false;
      _safeNotify();
    }
  }

  void _finishLoading({bool playVoiceover = true}) {
    _isTransitioning = false;
    _isLoadingVideo = false;
    _lastTransitionTime = DateTime.now();
    // Play voiceover for the new exercise (skip for first load, will play on startPlaying)
    if (playVoiceover && _workoutStartTime != null) {
      _playVoiceover();
    }
    _safeNotify();
  }

  Future<void> _preloadNextController() async {
    if (currentIndex >= data.length - 1) return;
    if (_nextController != null) return;
    if (_isDisposed) return;

    try {
      final nextUrl = data[currentIndex + 1].videos;
      if (nextUrl == null || nextUrl.isEmpty) return;

      final file = await DefaultCacheManager().getSingleFile(nextUrl);

      if (_isDisposed) return;

      final nextCtrl = VideoPlayerController.file(file);
      await nextCtrl.initialize();
      nextCtrl.setLooping(false);

      if (_isDisposed) {
        await nextCtrl.dispose();
        return;
      }

      _nextController = nextCtrl;
    } catch (e) {
      // Preload failed - will load normally when needed
    }
  }

  void _onVideoProgress() {
    if (_controller == null || _isControllerDisposed) return;
    if (_isAutoNexting || _isLoadingVideo || _workoutCompleted) return;
    if (_isDisposed) return;

    try {
      final value = _controller!.value;
      if (!value.isInitialized) return;

      final position = value.position.inMilliseconds;
      final duration = value.duration.inMilliseconds;

      if (duration > 0 && position >= duration - 100) {
        _isAutoNexting = true;

        if (currentIndex < data.length - 1) {
          _handleExerciseComplete();
        } else {
          _handleWorkoutComplete();
        }
      }
    } catch (e) {
      debugPrint('Error in video progress: $e');
    }
  }

  void _handleExerciseComplete() {
    _completedExercises = currentIndex + 1;

    // Stop voiceover when exercise ends
    _stopVoiceover();

    // Pause safely
    try {
      _controller?.pause();
    } catch (e) {
      debugPrint('Error pausing controller: $e');
    }

    if (_restDuration > 0 && onRestNeeded != null) {
      _restCallbackTimer?.cancel();
      // Use SchedulerBinding to ensure callback runs after frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          _restCallbackTimer = Timer(const Duration(milliseconds: 50), () {
            if (!_isDisposed) {
              onRestNeeded?.call();
            }
          });
        }
      });
    } else {
      // Use SchedulerBinding then microtask to ensure clean state
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          Future.microtask(() {
            if (!_isDisposed && !_workoutCompleted) {
              next();
            }
          });
        }
      });
    }
  }

  void _handleWorkoutComplete() {
    _workoutCompleted = true;
    _completedExercises = data.length;
    _isAutoNexting = true; // Prevent any further auto-next

    // Stop voiceover immediately
    _stopVoiceover();

    // Pause safely
    try {
      _controller?.pause();
    } catch (e) {
      debugPrint('Error pausing controller: $e');
    }

    // Call completion callback immediately via microtask (minimal delay)
    _completeCallbackTimer?.cancel();
    Future.microtask(() {
      if (!_isDisposed && onWorkoutComplete != null) {
        onWorkoutComplete?.call();
      }
    });
  }

  void continueAfterRest() {
    _isAutoNexting = false;
    next();
  }

  void playPause() {
    if (_controller == null || _isControllerDisposed) return;

    try {
      if (!_controller!.value.isInitialized) return;

      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _safeNotify();
    } catch (e) {
      debugPrint('Error in playPause: $e');
    }
  }

  Future<void> startPlaying() async {
    await waitForInit();
    if (_controller == null || _isControllerDisposed) return;

    try {
      if (!_controller!.value.isInitialized) return;
      if (!_controller!.value.isPlaying) {
        _workoutStartTime ??= DateTime.now();
        _controller!.play();
        // Play voiceover for the first exercise
        _playVoiceover();
        _safeNotify();
      }
    } catch (e) {
      debugPrint('Error starting playback: $e');
    }
  }

  Future<void> next() async {
    if (currentIndex >= data.length - 1) return;
    _completedExercises = currentIndex + 1;
    await _loadVideo(currentIndex + 1);
  }

  Future<void> previous() async {
    if (currentIndex <= 0) return;
    await _cleanupNextController();
    await _loadVideo(currentIndex - 1);
  }

  Future<void> waitForInit() => _initializeFuture ?? Future.value();

  void _safeNotify() {
    if (_isDisposed) return;
    try {
      notifyListeners();
    } catch (e) {
      // Provider already disposed
    }
  }

  Future<void> stopAll() async {
    _isAutoNexting = true;
    _restCallbackTimer?.cancel();
    _completeCallbackTimer?.cancel();
    _stopVoiceover();
    await _cleanupController();
    await _cleanupNextController();
    _isTransitioning = false;
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _restCallbackTimer?.cancel();
    _completeCallbackTimer?.cancel();
    _voiceoverRepeatTimer?.cancel();
    _stopVoiceover();
    // Properly shutdown TTS to free resources
    _tts?.stop();
    _cleanupController();
    _cleanupNextController();
    super.dispose();
  }
}

/// Helper to clearly mark fire-and-forget futures
void unawaited(Future<void>? future) {}
