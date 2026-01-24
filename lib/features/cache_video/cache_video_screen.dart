import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';
import '../../networks/api_acess.dart';
import '../../provider/cache_video_provider.dart';
import '../exercise_video/workout_control_bar.dart';
import 'cache_full_screen.dart';
import 'widgets/icon_widget.dart';
import 'widgets/info_widget.dart';
import 'widgets/music_widget.dart';
import 'widgets/countdown_overlay.dart';
import 'widgets/rest_overlay.dart';
import 'widgets/rest_timer_sheet.dart';
import 'widgets/show_bottom_widget.dart';
import 'widgets/story_progress_bar.dart';

class CacheVideoScreen extends StatefulWidget {
  final int id;
  const CacheVideoScreen({super.key, required this.id});

  @override
  State<CacheVideoScreen> createState() => _CacheVideoScreenState();
}

class _CacheVideoScreenState extends State<CacheVideoScreen>
    with WidgetsBindingObserver {
  AudioPlayer? _audioPlayer;
  bool _showCountdown = true;
  bool _showRestOverlay = false;
  bool _isFinishing = false;

  // Cache these to avoid repeated lookups
  static const _backgroundColor = Color(0xFFeae8ec);
  static const _accentColor = Color(0xFFF566A9);
  static const _textColor = Color(0xFF27272A);
  static const _grayColor = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _audioPlayer = AudioPlayer();
      final provider = context.read<CacheVideoProvider>();
      provider.onWorkoutComplete = _onWorkoutComplete;
      provider.onRestNeeded = _onRestNeeded;
      provider.getData(widget.id);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    try {
      final provider = context.read<CacheVideoProvider>();
      provider.onWorkoutComplete = null;
      provider.onRestNeeded = null;
      provider.stopAll();
    } catch (e) {
      // Provider may already be disposed
    }
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      try {
        final provider = context.read<CacheVideoProvider>();
        if (provider.isPlaying) provider.playPause();
        _audioPlayer?.pause();
      } catch (e) {
        // Ignore if provider disposed
      }
    }
  }

  void _onRestNeeded() {
    if (!mounted) return;
    setState(() => _showRestOverlay = true);
  }

  void _onRestComplete() {
    if (!mounted) return;
    setState(() => _showRestOverlay = false);
    context.read<CacheVideoProvider>().continueAfterRest();
  }

  void _onRestSkip() {
    if (!mounted) return;
    setState(() => _showRestOverlay = false);
    context.read<CacheVideoProvider>().continueAfterRest();
  }

  void _onNextPressed() {
    final provider = context.read<CacheVideoProvider>();
    if (provider.currentIndex >= provider.data.length - 1) return;

    if (provider.restDuration > 0) {
      provider.controller?.pause();
      setState(() => _showRestOverlay = true);
    } else {
      provider.next();
    }
  }

  Future<void> _onWorkoutComplete() async {
    if (_isFinishing || !mounted) return;
    _isFinishing = true;

    final provider = context.read<CacheVideoProvider>();
    final duration = provider.actualTimeFormatted;
    final kcal = provider.actualKcal;
    final listId = provider.model.listId ?? 0;

    // Stop audio player immediately
    _audioPlayer?.stop();

    // Stop provider in background (don't wait)
    provider.stopAll();

    // Save in background (don't wait)
    activeWorkoutSaveRxObj
        .activeWorkoutSaveRx(listId: listId)
        .catchError((_) => false);

    // Navigate immediately to congrats screen
    if (mounted) {
      NavigationService.navigateToWithArgs(
        Routes.videoCongratsScreen,
        {"duration": duration, "kcal": kcal},
      );
    }
  }

  Future<void> _onCountdownComplete() async {
    if (!mounted) return;
    setState(() => _showCountdown = false);
    await context.read<CacheVideoProvider>().startPlaying();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showDoneSheet(CacheVideoProvider provider) {
    if (provider.isPlaying) provider.playPause();

    final actualDuration = provider.actualTimeFormatted;
    final actualKcal = provider.actualKcal;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShowBottomWidget(
        duration: actualDuration,
        totalCal: actualKcal,
        listId: provider.model.listId ?? 0,
        onStopAll: () async {
          await provider.stopAll();
          _audioPlayer?.stop();
        },
      ),
    );
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CacheFullScreenPlayer(),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _showMusicSheet(CacheVideoProvider provider) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
      ),
      builder: (_) => MusicWidget(
        audioPlayer: _audioPlayer,
        music: provider.music,
      ),
    );
  }

  Future<void> _showInfoSheet(String description) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
      ),
      builder: (_) => InfoWidget(description: description),
    );
  }

  Future<void> _showRestTimerSheet(CacheVideoProvider provider) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
      ),
      builder: (_) => RestTimerSheet(
        currentRestDuration: provider.restDuration,
        onSelect: (duration) => provider.restDuration = duration,
      ),
    );
  }

  Widget _buildRestTimerButton(int restDuration) {
    final isActive = restDuration > 0;
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: isActive ? _accentColor : Colors.black.withValues(alpha:0.4),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isActive
            ? Text(
                "$restDuration",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            : Icon(Icons.timer_outlined, color: Colors.white, size: 24.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheVideoProvider>(
      builder: (_, provider, __) {
        final controller = provider.controller;

        // Show countdown before workout starts
        if (_showCountdown) {
          return Scaffold(
            backgroundColor: _backgroundColor,
            body: SafeArea(
              child: CountdownOverlay(onComplete: _onCountdownComplete),
            ),
          );
        }

        if (controller == null || provider.data.isEmpty) {
          return Scaffold(
            backgroundColor: _backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: _accentColor),
                  SizedBox(height: 16.h),
                  Text(
                    "Caricamento...",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: _textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: Stack(
            children: [
              SafeArea(
                child: FutureBuilder(
                  future: provider.waitForInit(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox.shrink();
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Prevent overflow during orientation transition
                        if (constraints.maxHeight < 400) {
                          return const Center(
                            child: CircularProgressIndicator(color: _accentColor),
                          );
                        }
                        return _buildMainContent(provider, controller);
                      },
                    );
                  },
                ),
              ),
              // Rest overlay
              if (_showRestOverlay && provider.currentIndex < provider.data.length - 1)
                RestOverlay(
                  restDuration: provider.restDuration,
                  nextExerciseTitle: provider.data[provider.currentIndex + 1].title ?? "Prossimo esercizio",
                  nextVideoUrl: provider.data[provider.currentIndex + 1].videos,
                  onComplete: _onRestComplete,
                  onSkip: _onRestSkip,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(CacheVideoProvider provider, VideoPlayerController controller) {
    return Column(
      children: [
        // Story progress bar
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            double currentProgress = 0.0;
            if (value.isInitialized && value.duration.inMilliseconds > 0) {
              currentProgress = value.position.inMilliseconds / value.duration.inMilliseconds;
            }
            return StoryProgressBar(
              totalSteps: provider.data.length,
              currentStep: provider.currentIndex,
              currentProgress: currentProgress,
            );
          },
        ),

        // Navigation row
        _buildNavigationRow(provider),

        // Video area
        Expanded(child: _buildVideoArea(provider, controller)),

        UIHelper.verticalSpace(16.sp),

        // Timer
        _buildTimer(controller),

        UIHelper.verticalSpace(8.sp),

        // Title
        _buildTitle(provider),

        UIHelper.verticalSpace(4.sp),

        // Step indicator
        _buildStepIndicator(provider),

        UIHelper.verticalSpace(16.sp),

        // Control bar
        _buildControlBar(provider, controller),

        UIHelper.verticalSpace(16.h),
      ],
    );
  }

  Widget _buildNavigationRow(CacheVideoProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Volume toggle button for voice instructions
          GestureDetector(
            onTap: () {
              provider.voiceoverEnabled = !provider.voiceoverEnabled;
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: provider.voiceoverEnabled
                    ? _accentColor.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                provider.voiceoverEnabled
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                size: 22.sp,
                color: provider.voiceoverEnabled ? _accentColor : _grayColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showDoneSheet(provider),
            child: Text(
              "Done",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                fontSize: 16.sp,
                color: _accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea(CacheVideoProvider provider, VideoPlayerController controller) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Video
        Center(
          child: AnimatedOpacity(
            opacity: (provider.isTransitioning || !controller.value.isInitialized) ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        // Side buttons
        _buildSideButtons(provider),
      ],
    );
  }

  Widget _buildSideButtons(CacheVideoProvider provider) {
    return Positioned(
      right: 20.w,
      top: 20.h,
      child: Column(
        children: [
          // Fullscreen button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openFullscreen,
            child: IconWidget(icon: Assets.icons.zoom),
          ),
          SizedBox(height: 16.h),
          // Music button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showMusicSheet(provider),
            child: IconWidget(icon: Assets.icons.music),
          ),
          SizedBox(height: 16.h),
          // Info button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showInfoSheet(
              provider.data[provider.currentIndex].descriptions ?? "",
            ),
            child: IconWidget(icon: Assets.icons.info),
          ),
          SizedBox(height: 16.h),
          // Rest timer button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showRestTimerSheet(provider),
            child: _buildRestTimerButton(provider.restDuration),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(VideoPlayerController controller) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final displayTime = value.isInitialized
            ? _formatDuration(value.duration - value.position)
            : "00:00";
        return Text(
          displayTime,
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 48.sp,
          ),
        );
      },
    );
  }

  Widget _buildTitle(CacheVideoProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        provider.data[provider.currentIndex].title ?? "",
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildStepIndicator(CacheVideoProvider provider) {
    return Text(
      "STEP ${provider.currentIndex + 1}/${provider.data.length}",
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: _grayColor,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildControlBar(CacheVideoProvider provider, VideoPlayerController controller) {
    return SafeArea(
      top: false,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, _) {
          double progress = 0.0;
          bool isPlaying = false;

          if (value.isInitialized && value.duration.inMilliseconds > 0) {
            progress = value.position.inMilliseconds / value.duration.inMilliseconds;
            isPlaying = value.isPlaying;
          }

          final isLoading = provider.isLoadingVideo || provider.isTransitioning;

          return WorkoutControlBar(
            progress: progress,
            isPlaying: isPlaying,
            onPrevious: (provider.currentIndex == 0 || isLoading)
                ? null
                : () => provider.previous(),
            onPlayPause: isLoading ? null : provider.playPause,
            onNext: (provider.currentIndex == provider.data.length - 1 || isLoading)
                ? null
                : _onNextPressed,
          );
        },
      ),
    );
  }
}
