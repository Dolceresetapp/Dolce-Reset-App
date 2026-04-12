import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/text_font_style.dart';

class RestOverlay extends StatefulWidget {
  final int restDuration;
  final String nextExerciseTitle;
  final String? nextVideoUrl;
  final String? nextVoiceoverText;
  final String? nextVoiceoverType;
  final String? nextVoiceoverAudio;
  final VoidCallback onComplete;
  final VoidCallback onSkip;
  final VoidCallback? onVoiceoverPlayed;
  final bool voiceoverEnabled;
  final VoidCallback? onVoiceoverToggle;
  final Future<void> Function()? onDuckMusic;
  final Future<void> Function()? onRestoreMusic;

  const RestOverlay({
    super.key,
    required this.restDuration,
    required this.nextExerciseTitle,
    this.nextVideoUrl,
    this.nextVoiceoverText,
    this.nextVoiceoverType,
    this.nextVoiceoverAudio,
    required this.onComplete,
    required this.onSkip,
    this.onVoiceoverPlayed,
    this.voiceoverEnabled = true,
    this.onVoiceoverToggle,
    this.onDuckMusic,
    this.onRestoreMusic,
  });

  @override
  State<RestOverlay> createState() => _RestOverlayState();
}

class _RestOverlayState extends State<RestOverlay>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  Timer? _timer;
  VideoPlayerController? _previewController;
  bool _videoReady = false;
  bool _isDisposed = false;

  // TTS for voiceover
  FlutterTts? _tts;
  AudioPlayer? _voiceoverPlayer;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  static const _accentColor = Color(0xFFF566A9);

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.restDuration;

    _progressController = AnimationController(
      duration: Duration(seconds: widget.restDuration),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _progressController.forward();
    _startTimer();
    _loadPreviewVideo();
    _playVoiceover();
  }

  Future<void> _initTts() async {
    if (_tts != null) return;

    try {
      _tts = FlutterTts();

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
      await _tts!.setSpeechRate(0.42);
      await _tts!.setVolume(0.85);
      await _tts!.setPitch(1.15);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> _playVoiceover() async {
    if (!widget.voiceoverEnabled) return;
    if (_isDisposed) return;

    // Choose between audio file or TTS
    if (widget.nextVoiceoverType == 'audio' &&
        widget.nextVoiceoverAudio != null &&
        widget.nextVoiceoverAudio!.isNotEmpty) {
      await _playVoiceoverAudioFile();
    } else {
      await _playVoiceoverTts();
    }
  }

  Future<void> _playVoiceoverTts() async {
    if (widget.nextVoiceoverText == null || widget.nextVoiceoverText!.isEmpty) return;

    try {
      await _initTts();
      if (_tts == null || _isDisposed) return;

      await _tts!.stop();
      await Future.delayed(const Duration(seconds: 1));
      if (_isDisposed || !widget.voiceoverEnabled) return;

      await widget.onDuckMusic?.call();
      _tts!.setCompletionHandler(() {
        widget.onRestoreMusic?.call();
      });

      await _tts!.speak(widget.nextVoiceoverText!);
      widget.onVoiceoverPlayed?.call();
    } catch (e) {
      debugPrint('Rest overlay TTS error: $e');
      await widget.onRestoreMusic?.call();
    }
  }

  Future<void> _playVoiceoverAudioFile() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (_isDisposed || !widget.voiceoverEnabled) return;

      await widget.onDuckMusic?.call();

      _voiceoverPlayer ??= AudioPlayer();
      _voiceoverPlayer!.setReleaseMode(ReleaseMode.stop);

      final file = await DefaultCacheManager().getSingleFile(widget.nextVoiceoverAudio!);
      if (_isDisposed) {
        await widget.onRestoreMusic?.call();
        return;
      }

      final completer = Completer<void>();
      StreamSubscription<void>? sub;
      sub = _voiceoverPlayer!.onPlayerComplete.listen((_) {
        if (!completer.isCompleted) completer.complete();
        sub?.cancel();
      });

      await _voiceoverPlayer!.setVolume(0.85);
      await _voiceoverPlayer!.play(DeviceFileSource(file.path));
      await completer.future;

      await widget.onRestoreMusic?.call();
      widget.onVoiceoverPlayed?.call();
    } catch (e) {
      debugPrint('Rest overlay audio file error: $e');
      await widget.onRestoreMusic?.call();
    }
  }

  Future<void> _loadPreviewVideo() async {
    if (widget.nextVideoUrl == null || widget.nextVideoUrl!.isEmpty) return;

    try {
      final file = await DefaultCacheManager().getSingleFile(widget.nextVideoUrl!);
      if (_isDisposed) return;

      _previewController = VideoPlayerController.file(file);
      await _previewController!.initialize();

      if (_isDisposed) {
        _previewController?.dispose();
        return;
      }

      _previewController!.setLooping(true);
      _previewController!.setVolume(0);
      _previewController!.play();

      if (mounted && !_isDisposed) {
        setState(() => _videoReady = true);
      }
    } catch (e) {
      // Ignore preview errors - just show loading indicator
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds <= 1) {
        timer.cancel();
        // Say "Via!" when timer ends
        _speakCountdown('Via!');
        if (mounted && !_isDisposed) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted && !_isDisposed) {
              widget.onComplete();
            }
          });
        }
      } else {
        if (mounted && !_isDisposed) {
          setState(() => _remainingSeconds--);
          // Say 3, 2, 1 when timer reaches those values
          if (_remainingSeconds == 3) {
            _speakCountdown('3');
          } else if (_remainingSeconds == 2) {
            _speakCountdown('2');
          } else if (_remainingSeconds == 1) {
            _speakCountdown('1');
          }
        }
      }
    });
  }

  Future<void> _speakCountdown(String text) async {
    if (_isDisposed || !widget.voiceoverEnabled) return;

    try {
      await _initTts();
      if (_tts == null) return;

      // Duck music before speaking
      await widget.onDuckMusic?.call();

      // Set completion handler to restore music
      _tts!.setCompletionHandler(() {
        widget.onRestoreMusic?.call();
      });

      // Stop any existing speech to avoid overlap
      await _tts!.stop();
      await _tts!.speak(text);
    } catch (e) {
      debugPrint('Countdown speak error: $e');
      await widget.onRestoreMusic?.call();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _tts?.stop();
    _voiceoverPlayer?.stop();
    _voiceoverPlayer?.dispose();
    _progressController.dispose();
    _previewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 30.h),
                  _buildTitle(),
                  SizedBox(height: 20.h),
                  _buildCountdown(),
                  SizedBox(height: 30.h),
                  _buildNextExerciseLabel(),
                  SizedBox(height: 12.h),
                  _buildNextExerciseTitle(),
                  SizedBox(height: 20.h),
                  Expanded(child: _buildVideoPreview()),
                  SizedBox(height: 20.h),
                  _buildSkipButton(),
                  SizedBox(height: 30.h),
                ],
              ),
              // Volume toggle button (top left)
              Positioned(
                top: 8.h,
                left: 16.w,
                child: _buildVolumeButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeButton() {
    return GestureDetector(
      onTap: widget.onVoiceoverToggle,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: widget.voiceoverEnabled
              ? _accentColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.voiceoverEnabled
              ? Icons.volume_up_rounded
              : Icons.volume_off_rounded,
          size: 24.sp,
          color: widget.voiceoverEnabled ? _accentColor : Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "RIPOSO",
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: Colors.white.withOpacity(0.7),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildCountdown() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 6.w,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Progress circle
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: CircularProgressIndicator(
                value: _progressAnimation.value,
                strokeWidth: 6.w,
                color: _accentColor,
                strokeCap: StrokeCap.round,
              ),
            ),
            // Time text
            Text(
              "$_remainingSeconds",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Colors.white,
                fontSize: 48.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextExerciseLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.arrow_forward_rounded, color: _accentColor, size: 16.sp),
        SizedBox(width: 6.w),
        Text(
          "PROSSIMO ESERCIZIO",
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: _accentColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNextExerciseTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Text(
        widget.nextExerciseTitle,
        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: _videoReady && _previewController != null
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _previewController!.value.size.width,
                  height: _previewController!.value.size.height,
                  child: VideoPlayer(_previewController!),
                ),
              )
            : Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    color: _accentColor,
                    strokeWidth: 3.w,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: widget.onSkip,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.skip_next_rounded, color: _accentColor, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              "Salta riposo",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF1A1A2E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
