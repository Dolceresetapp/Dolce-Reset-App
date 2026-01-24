import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CountdownOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const CountdownOverlay({
    super.key,
    required this.onComplete,
  });

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  int _count = 3;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  FlutterTts? _tts;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _initTtsAndStart();
  }

  Future<void> _initTtsAndStart() async {
    try {
      _tts = FlutterTts();

      await _tts!.setSharedInstance(true);
      await _tts!.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      await _tts!.setLanguage("it-IT");
      await _tts!.setSpeechRate(0.45); // Slightly slower for better sync
      await _tts!.setVolume(1.0);
      await _tts!.setPitch(1.1); // Slightly higher for energy

      // Enable await speak completion for sync
      await _tts!.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }

    if (mounted && !_isDisposed) {
      _runCountdown();
    }
  }

  Future<void> _speakSync(String text) async {
    if (_isDisposed || _tts == null) return;
    try {
      // This will wait until speech completes
      await _tts!.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> _runCountdown() async {
    // Show 3 and speak simultaneously
    _animController.forward();
    await _speakSync('3');
    if (_isDisposed) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isDisposed) return;

    // Show 2 and speak
    setState(() => _count = 2);
    _animController.reset();
    _animController.forward();
    await _speakSync('2');
    if (_isDisposed) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isDisposed) return;

    // Show 1 and speak
    setState(() => _count = 1);
    _animController.reset();
    _animController.forward();
    await _speakSync('1');
    if (_isDisposed) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isDisposed) return;

    // Show VIA! and speak
    setState(() => _count = 0);
    _animController.reset();
    _animController.forward();
    await _speakSync('Via!');
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted && !_isDisposed) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tts?.stop();
    _animController.dispose();
    super.dispose();
  }

  String get _displayText {
    if (_count > 0) return '$_count';
    return 'VIA!';
  }

  Color get _displayColor {
    switch (_count) {
      case 3:
        return const Color(0xFFF566A9);
      case 2:
        return const Color(0xFFFF6B6B);
      case 1:
        return const Color(0xFFFFB347);
      default:
        return const Color(0xFF4ECDC4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFeae8ec),
      child: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Opacity(
              opacity: _count == 0 ? 1.0 : (1.0 - _opacityAnimation.value * 0.5),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  _displayText,
                  style: TextStyle(
                    fontSize: _count == 0 ? 80.sp : 120.sp,
                    fontWeight: FontWeight.w900,
                    color: _displayColor,
                    letterSpacing: _count == 0 ? 8 : 0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
