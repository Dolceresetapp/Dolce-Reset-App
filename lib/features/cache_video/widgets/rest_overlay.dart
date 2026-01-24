import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/text_font_style.dart';

class RestOverlay extends StatefulWidget {
  final int restDuration;
  final String nextExerciseTitle;
  final String? nextVideoUrl;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const RestOverlay({
    super.key,
    required this.restDuration,
    required this.nextExerciseTitle,
    this.nextVideoUrl,
    required this.onComplete,
    required this.onSkip,
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
        if (mounted && !_isDisposed) {
          widget.onComplete();
        }
      } else {
        if (mounted && !_isDisposed) {
          setState(() => _remainingSeconds--);
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _progressController.dispose();
    _previewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha:0.6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: SafeArea(
          child: Column(
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
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "RIPOSO",
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: Colors.white.withValues(alpha:0.7),
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
                color: Colors.white.withValues(alpha:0.2),
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
          color: Colors.white.withValues(alpha:0.2),
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
                color: Colors.black.withValues(alpha:0.3),
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
              color: Colors.black.withValues(alpha:0.2),
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
