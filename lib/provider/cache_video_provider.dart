import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';

import '../features/ready/data/model/workout_video_response_model.dart';
import '../networks/api_acess.dart';
import '../networks/dio/dio.dart';
import '../networks/endpoints.dart';

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
  // Default: 15 seconds rest between exercises
  int _restDuration = 15;

  // Completer to synchronize getData() with startPlaying()
  Completer<void>? _dataReadyCompleter;

  // Flag to cancel pending music initialization after stopAll()
  bool _isStopped = false;

  // Timers for cleanup
  Timer? _restCallbackTimer;
  Timer? _completeCallbackTimer;

  // Text-to-Speech for voiceover instructions
  FlutterTts? _tts;
  bool _voiceoverEnabled = true;
  bool _isTtsInitialized = false;
  Timer? _voiceoverRepeatTimer;
  bool _isSpeaking = false;
  bool _voiceoverPlayedDuringRest = false;

  // Background music
  AudioPlayer? _musicPlayer;
  List<Music> _availableMusic = [];
  Music? _currentMusic;
  bool _musicEnabled = true;
  double _normalMusicVolume = 0.5;
  bool _isMusicPlayerInitialized = false;
  bool _isMusicPlaying = false;
  StreamSubscription<PlayerState>? _musicStateSubscription;
  StreamSubscription<void>? _musicCompleteSubscription;

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
    _voiceoverEnabled = value;

    if (!value) {
      // Turning OFF - stop immediately
      _stopVoiceover();
    }
    // Turning ON - just enable for future exercises, don't replay current
    _safeNotify();
  }

  /// Mark that voiceover was already played during rest preview
  void markVoiceoverPlayedDuringRest() {
    _voiceoverPlayedDuringRest = true;
  }

  // Music settings
  bool get musicEnabled => _musicEnabled;
  List<Music> get availableMusic => _availableMusic;
  Music? get currentMusic => _currentMusic;
  AudioPlayer? get musicPlayer => _musicPlayer;
  bool get isMusicPlaying => _isMusicPlaying;
  double get musicVolume => _normalMusicVolume;

  set musicVolume(double value) {
    _normalMusicVolume = value.clamp(0.0, 1.0);
    // Update player volume immediately if playing
    if (_musicPlayer != null && _isMusicPlaying) {
      _musicPlayer!.setVolume(_normalMusicVolume);
    }
    _safeNotify();
  }

  set musicEnabled(bool value) {
    debugPrint('musicEnabled set to: $value (was: $_musicEnabled)');
    _musicEnabled = value;
    if (!value) {
      debugPrint('Pausing music');
      _musicPlayer?.pause();
      _isMusicPlaying = false;
    } else if (_currentMusic != null) {
      debugPrint('Resuming music');
      _musicPlayer?.resume();
      _isMusicPlaying = true;
    }
    _safeNotify();
  }

  /// Toggle music play/pause
  void toggleMusicPlayPause() {
    if (_musicPlayer == null || _currentMusic == null) return;

    if (_isMusicPlaying) {
      _musicPlayer!.pause();
      _isMusicPlaying = false;
    } else {
      _musicPlayer!.resume();
      _isMusicPlaying = true;
    }
    _safeNotify();
  }

  /// Fetch available music from API - public to allow manual refresh
  Future<void> fetchAvailableMusic() async {
    try {
      debugPrint('Fetching music list from: ${Endpoints.musicList()}');
      final response = await getHttp(Endpoints.musicList());
      debugPrint('Music list response: ${response.statusCode} - ${response.data}');

      final isSuccess = response.data['success'] == true || response.data['status'] == true;
      if (response.statusCode == 200 && isSuccess) {
        final List<dynamic> musicData = response.data['data'] ?? [];
        _availableMusic = musicData.map((m) => Music(
          id: m['id'],
          title: m['title'],
          musicFile: m['music_file'],
          duration: m['duration'],
        )).toList();
        debugPrint('Fetched ${_availableMusic.length} music tracks');

        // Preload all music files in background for instant playback
        _preloadMusicFiles();

        _safeNotify();
      } else {
        debugPrint('Music list API returned error: ${response.data}');
      }
    } catch (e, stack) {
      debugPrint('Error fetching music: $e');
      debugPrint('Stack: $stack');
    }
  }

  /// Fetch user's preferred music (or default)
  Future<Music?> _fetchUserMusic() async {
    try {
      debugPrint('Fetching user music from: ${Endpoints.userMusic()}');
      final response = await getHttp(Endpoints.userMusic());
      debugPrint('User music response: ${response.statusCode} - ${response.data}');

      final isSuccess = response.data['success'] == true || response.data['status'] == true;
      if (response.statusCode == 200 && isSuccess) {
        final List<dynamic> musicData = response.data['data'] ?? [];
        if (musicData.isNotEmpty) {
          final m = musicData.first;
          return Music(
            id: m['id'],
            title: m['title'],
            musicFile: m['music_file'],
            duration: m['duration'],
          );
        }
      } else {
        debugPrint('User music API returned error: ${response.data}');
      }
    } catch (e, stack) {
      debugPrint('Error fetching user music: $e');
      debugPrint('Stack: $stack');
    }
    return null;
  }

  /// Initialize and start playing background music
  Future<void> _initMusic() async {
    if (_musicPlayer != null || _isStopped || _isDisposed) return;

    _musicPlayer = AudioPlayer();
    _musicPlayer!.setReleaseMode(ReleaseMode.loop);

    // Music list already fetched in getData(), just fetch if somehow empty
    if (_availableMusic.isEmpty) {
      await fetchAvailableMusic();
    }

    if (_isStopped || _isDisposed) return;

    // Play first available music by default
    if (_availableMusic.isNotEmpty) {
      _currentMusic = _availableMusic.first;
      await playMusic(_currentMusic!);
    }
  }

  /// Initialize music player
  Future<void> _initMusicPlayer() async {
    if (_isMusicPlayerInitialized) return;

    try {
      _musicPlayer = AudioPlayer();
      _musicPlayer!.setReleaseMode(ReleaseMode.loop);

      // Setup listeners only once
      _musicStateSubscription?.cancel();
      _musicStateSubscription = _musicPlayer!.onPlayerStateChanged.listen((state) {
        debugPrint('Music player state changed: $state');
      });

      _isMusicPlayerInitialized = true;
      debugPrint('Music player initialized successfully');
    } catch (e, stack) {
      debugPrint('Error initializing music player: $e');
      debugPrint('Stack: $stack');
    }
  }

  /// Preload music files into cache for instant playback
  Future<void> _preloadMusicFiles() async {
    for (final music in _availableMusic) {
      if (music.musicFile != null && music.musicFile!.isNotEmpty) {
        try {
          // Download to cache in background
          unawaited(DefaultCacheManager().getSingleFile(music.musicFile!).then((_) {
            debugPrint('Preloaded music: ${music.title}');
          }));
        } catch (e) {
          // Ignore preload errors
        }
      }
    }
  }

  /// Play a specific music track
  Future<void> playMusic(Music music) async {
    debugPrint('playMusic called: ${music.title}, url: ${music.musicFile}');

    if (_isDisposed || _isStopped || music.musicFile == null || music.musicFile!.isEmpty) {
      debugPrint('playMusic aborted: disposed=$_isDisposed, stopped=$_isStopped, musicFile=${music.musicFile}');
      return;
    }

    try {
      // Initialize player if needed
      if (!_isMusicPlayerInitialized) {
        await _initMusicPlayer();
      }

      if (_musicPlayer == null) {
        debugPrint('Music player is null after initialization');
        return;
      }

      // Stop current playback
      await _musicPlayer!.stop();
      _isMusicPlaying = false;
      _currentMusic = music;

      if (_musicEnabled) {
        await _musicPlayer!.setVolume(_normalMusicVolume);
        debugPrint('Loading music file: ${music.musicFile}');

        // Download file first, then play locally (works better on iOS)
        final file = await DefaultCacheManager().getSingleFile(music.musicFile!);
        debugPrint('File ready: ${file.path}');

        await _musicPlayer!.play(DeviceFileSource(file.path));
        _isMusicPlaying = true;
        debugPrint('Music playing');
      } else {
        debugPrint('Music disabled, not playing');
      }
      _safeNotify();
    } catch (e, stack) {
      debugPrint('Error playing music: $e');
      debugPrint('Stack: $stack');
      _isMusicPlaying = false;
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    try {
      await _musicPlayer?.stop();
      _currentMusic = null;
      _isMusicPlaying = false;
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  /// Duck music volume (for TTS) - public for external TTS (rest overlay, etc.)
  Future<void> duckMusic() async {
    if (_musicPlayer == null || !_musicEnabled) return;
    try {
      // Duck to 30% of current volume
      final duckedVolume = _normalMusicVolume * 0.3;
      await _musicPlayer!.setVolume(duckedVolume);
    } catch (e) {
      debugPrint('Error ducking music: $e');
    }
  }

  /// Restore music volume after TTS - public for external TTS
  Future<void> restoreMusic() async {
    if (_musicPlayer == null || !_musicEnabled) return;
    try {
      await _musicPlayer!.setVolume(_normalMusicVolume);
    } catch (e) {
      debugPrint('Error restoring music: $e');
    }
  }

  // Private aliases for internal use
  Future<void> _duckMusic() => duckMusic();
  Future<void> _restoreMusic() => restoreMusic();

  /// Initialize TTS with natural Italian female voice
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

      // Select the best female Italian voice available
      final voices = await _tts!.getVoices;
      if (voices != null) {
        final voiceList = List<Map<dynamic, dynamic>>.from(voices);

        // Known male Italian voice names to exclude
        const maleVoices = ['luca', 'giorgio', 'diego', 'marco', 'male'];

        // Preferred female Italian voices (in order of preference)
        // iOS enhanced/premium voices sound much more natural
        const preferredVoices = [
          'federica',  // Best Italian female voice on iOS
          'alice',
          'elsa',
          'paola',
          'francesca',
          'silvia',
          'female',
        ];

        // Filter Italian voices
        final italianVoices = voiceList.where((voice) {
          final locale = (voice['locale'] ?? '').toString().toLowerCase();
          return locale.contains('it');
        }).toList();

        if (italianVoices.isNotEmpty) {
          Map<dynamic, dynamic>? selectedVoice;

          // Priority 1: Find enhanced/premium female voice (sounds most natural)
          for (final voice in italianVoices) {
            final name = (voice['name'] ?? '').toString().toLowerCase();
            final quality = (voice['quality'] ?? '').toString().toLowerCase();

            final isEnhanced = name.contains('enhanced') ||
                               name.contains('premium') ||
                               quality.contains('enhanced') ||
                               quality.contains('premium');

            final isFemale = preferredVoices.any((f) => name.contains(f)) &&
                            !maleVoices.any((m) => name.contains(m));

            if (isEnhanced && isFemale) {
              selectedVoice = voice;
              debugPrint('Selected enhanced voice: ${voice['name']}');
              break;
            }
          }

          // Priority 2: Find any preferred female voice
          if (selectedVoice == null) {
            for (final preferred in preferredVoices) {
              for (final voice in italianVoices) {
                final name = (voice['name'] ?? '').toString().toLowerCase();
                if (name.contains(preferred) && !maleVoices.any((m) => name.contains(m))) {
                  selectedVoice = voice;
                  debugPrint('Selected preferred voice: ${voice['name']}');
                  break;
                }
              }
              if (selectedVoice != null) break;
            }
          }

          // Priority 3: Any non-male Italian voice
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
            debugPrint('TTS voice set to: ${selectedVoice['name']}');
          }
        }
      }

      // Natural speech parameters for a warm, encouraging coach voice
      await _tts!.setSpeechRate(0.42);  // Slower = more human, less rushed
      await _tts!.setVolume(0.85);      // Softer = warmer, less robotic
      await _tts!.setPitch(1.15);       // Higher = more feminine and friendly

      // Enable await speak completion so we can restore music after
      await _tts!.awaitSpeakCompletion(true);

      _isTtsInitialized = true;
      debugPrint('Exercise TTS initialized successfully');
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  /// Play voiceover for current exercise
  /// Plays once, 2 seconds after the exercise starts
  /// Skips if already played during rest preview
  Future<void> _playVoiceover() async {
    // Cancel any existing timer
    _voiceoverRepeatTimer?.cancel();
    _voiceoverRepeatTimer = null;

    if (!_voiceoverEnabled || _isDisposed) return;
    if (currentIndex < 0 || currentIndex >= data.length) return;

    // Skip if voiceover was already played during rest preview
    if (_voiceoverPlayedDuringRest) {
      _voiceoverPlayedDuringRest = false; // Reset for next exercise
      debugPrint('Skipping voiceover - already played during rest');
      return;
    }

    // Store the exercise index when voiceover started
    final startedForIndex = currentIndex;

    await _initTts();
    if (_tts == null) return;

    // Wait 2 seconds before voiceover
    await Future.delayed(const Duration(seconds: 2));

    // Check if still valid (same exercise, not disposed, enabled, playing)
    if (_isDisposed || !_voiceoverEnabled || _workoutCompleted) return;
    if (currentIndex != startedForIndex) return; // Exercise changed
    if (!isPlaying) return;

    // Get current exercise text
    final currentText = data[currentIndex].voiceoverText;
    if (currentText == null || currentText.isEmpty) return;

    // Speak once only
    await _speakText(currentText);
  }

  Future<void> _speakText(String text) async {
    if (_tts == null || _isDisposed) return;

    try {
      _isSpeaking = true;
      // Duck music before speaking
      await _duckMusic();
      debugPrint('Speaking: $text');
      await _tts!.speak(text);
      // Restore music after speaking (awaitSpeakCompletion ensures this runs after speech)
      _isSpeaking = false;
      await _restoreMusic();
    } catch (e) {
      debugPrint('Error speaking: $e');
      _isSpeaking = false;
      await _restoreMusic();
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

    // Stop music and cleanup subscriptions
    _musicStateSubscription?.cancel();
    _musicStateSubscription = null;
    _musicCompleteSubscription?.cancel();
    _musicCompleteSubscription = null;
    _musicPlayer?.stop();
    _musicPlayer?.dispose();
    _musicPlayer = null;
    _currentMusic = null;
    _availableMusic = [];
    _isMusicPlayerInitialized = false;
    _isMusicPlaying = false;

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
    _dataReadyCompleter = Completer<void>();
    _isStopped = false;
    reset();

    // Start fetching music list in parallel with video data (only if music may be needed)
    Future<void>? musicFuture;

    final response = await workoutVideoRxObj.workoutVideoRx(id: videoId);
    model = response;
    data = response.data ?? [];
    _cachedMusic = null;

    // Only fetch music if the course allows background music
    if (model.musicEnabled != false) {
      musicFuture = fetchAvailableMusic();
    }

    if (data.isNotEmpty) {
      // Preload all videos in background (fire and forget)
      unawaited(_preloadAllVideos());
      // Load first video but don't auto-play (countdown will start it)
      await _loadVideo(0, autoPlay: false);
    }

    // Wait for music list to be ready (if applicable)
    if (musicFuture != null) {
      await musicFuture;
    }

    _dataReadyCompleter?.complete();
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
    // Wait for getData() to finish loading the first video
    await _dataReadyCompleter?.future;
    await waitForInit();
    if (_controller == null || _isControllerDisposed) return;

    try {
      if (!_controller!.value.isInitialized) return;
      if (!_controller!.value.isPlaying) {
        _workoutStartTime ??= DateTime.now();
        _controller!.play();
        // Initialize background music (only if course allows it)
        if (model.musicEnabled != false) {
          unawaited(_initMusic());
        }
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
    _isStopped = true;
    _isAutoNexting = true;
    _restCallbackTimer?.cancel();
    _completeCallbackTimer?.cancel();
    _stopVoiceover();
    // Stop music
    await _musicPlayer?.stop();
    _musicPlayer?.dispose();
    _musicPlayer = null;
    _isMusicPlaying = false;
    _isMusicPlayerInitialized = false;
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
    // Stop and dispose music player with subscriptions
    _musicStateSubscription?.cancel();
    _musicCompleteSubscription?.cancel();
    _musicPlayer?.stop();
    _musicPlayer?.dispose();
    _cleanupController();
    _cleanupNextController();
    super.dispose();
  }
}

/// Helper to clearly mark fire-and-forget futures
void unawaited(Future<void>? future) {}
