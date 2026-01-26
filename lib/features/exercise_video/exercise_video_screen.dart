import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/features/exercise_video/full_screen_video.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:video_player/video_player.dart';

import '../../common_widget/custom_app_bar.dart';
import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../networks/api_acess.dart';
import '../ready/data/model/workout_video_response_model.dart';
import 'progress_bar_widget.dart';
import 'workout_control_bar.dart';

class ExerciseVideoScreen extends StatefulWidget {
  final int id;
  const ExerciseVideoScreen({super.key, required this.id});

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen>
    with WidgetsBindingObserver {
  // Add variables for list & index
  VideoPlayerController? _controller;
  VideoPlayerController? _nextController; // Preload next video

  int currentIndex = 0;
  List videoList = [];

  int totalCal = 0;
  int minutes = 0;

  AudioPlayer? _audioPlayer;

  // Count down
  bool _showCountdown = true;
  int _countdown = 5;
  Timer? _countdownTimer;

  // CREATE COUNTDOWN FUNCTION

  void _startCountdown() {
    _countdownTimer?.cancel();

    setState(() {
      _showCountdown = true;
      _countdown = 5;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        setState(() {
          _showCountdown = false;
        });
        _controller?.play();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  // Load API and first video inside
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _audioPlayer = AudioPlayer();
    // Start countdown
    _startCountdown();
    workoutVideoRxObj.workoutVideoRx(id: widget.id);

    workoutVideoRxObj.workoutVideoRxStream.listen((apiResult) {
      if (apiResult.data != null && mounted) {
        videoList = apiResult.data!;

        totalCal = apiResult.totalCal ?? 0;

        minutes = apiResult.minutes ?? 0;

        _initializeVideo(videoList[currentIndex].videos);
      }
    });
  }

  // Initialize video controller for any index
  void _initializeVideo(String url) {
    _controller?.dispose();

    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});

        // Do not auto play
        _controller!.pause();

        // Preload next video for smooth transition
        _preloadNextVideo();

        // auto next
        _controller!.addListener(() {
          if (_controller!.value.isInitialized &&
              _controller!.value.position >=
                  _controller!.value.duration -
                      const Duration(milliseconds: 200)) {
            _playNext();
          }
        });
      });
  }

  // Preload next video in background
  void _preloadNextVideo() {
    if (currentIndex < videoList.length - 1) {
      _nextController?.dispose();
      _nextController = VideoPlayerController.networkUrl(
        Uri.parse(videoList[currentIndex + 1].videos),
      )..initialize(); // Just initialize, don't play
    }
  }

  // void _initializeVideo(String url) {
  //   _controller?.dispose();

  //   _controller = VideoPlayerController.networkUrl(Uri.parse(url))
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller!.play();

  //       // Auto play next video when current ends
  //       _controller!.addListener(() {
  //         if (_controller!.value.position >= _controller!.value.duration) {
  //           _playNext();
  //         }
  //       });
  //     });
  // }

  // Add NEXT and PREVIOUS functions
  void _playNext() {
    if (currentIndex < videoList.length - 1) {
      setState(() {
        currentIndex++;
      });

      // Use preloaded controller if available for smooth transition
      if (_nextController != null && _nextController!.value.isInitialized) {
        _controller?.dispose();
        _controller = _nextController;
        _nextController = null;
        setState(() {});
        _controller!.pause();

        // Add listener for auto next
        _controller!.addListener(() {
          if (_controller!.value.isInitialized &&
              _controller!.value.position >=
                  _controller!.value.duration -
                      const Duration(milliseconds: 200)) {
            _playNext();
          }
        });

        // Preload the next one
        _preloadNextVideo();

        // Restart countdown for next video
        _startCountdown();
      } else {
        _initializeVideo(videoList[currentIndex].videos);
        _startCountdown();
      }
    }
  }

  void _playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _initializeVideo(videoList[currentIndex].videos);
      _startCountdown();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.pause();
    _controller?.dispose();
    _nextController?.dispose();
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause();
      _audioPlayer?.pause();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _stopAll() {
    _controller?.pause();
    _audioPlayer?.stop();
    _countdownTimer?.cancel();
  }

  void _enterFullScreen() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FullScreenVideoPlayer(
              onPrevious: _playPrevious,
              controller: _controller!,
              currentIndex: currentIndex,
              totalVideos: videoList.length,
              onVideoEnd: _playNextFullScreen,
            ),
      ),
    );
  }

  // This will be called from FullScreenVideoPlayer when video ends
  void _playNextFullScreen() {
    if (currentIndex < videoList.length - 1) {
      setState(() {
        currentIndex++;
      });

      _controller?.pause();
      _controller?.dispose();

      _controller = VideoPlayerController.networkUrl(
          Uri.parse(videoList[currentIndex].videos),
        )
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });

      // Update the fullscreen controller
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => FullScreenVideoPlayer(
                controller: _controller!,
                currentIndex: currentIndex,
                totalVideos: videoList.length,
                onVideoEnd: _playNextFullScreen,
              ),
        ),
      );
    }
  }

  //

  void showFullBlurBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Required
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.60, // Full screen
          minChildSize: 0.20, // Force full height
          maxChildSize: 0.60, // Prevent dragging
          builder: (_, controller) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10, // stronger blur
                  sigmaY: 10,
                ),
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.25), // Glass effect
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.r),
                    ),
                    // ignore: deprecated_member_use
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      // Drag bar
                      Container(
                        width: 60,
                        height: 6,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      // Your content starts here
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            UIHelper.verticalSpace(30.h),
                            Text(
                              'Hand in there! \n You got this!',
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                  ),
                            ),
                            UIHelper.verticalSpace(30.h),

                            CustomButton(
                              onPressed: () {
                                NavigationService.goBack;
                              },
                              child: Row(
                                spacing: 10.w,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Keep Exercising",
                                    style:
                                        TextFontStyle
                                            .headLine16cFFFFFFWorkSansW600,
                                  ),

                                  SvgPicture.asset(
                                    Assets.icons.arrowRight,
                                    width: 20.w,
                                    height: 20.h,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),

                            UIHelper.verticalSpace(20.h),

                            CustomButton(
                              color: Color(0xFFAE47FF),
                              onPressed: () {
                                _stopAll();
                                // Save in background (don't wait, no loading)
                                activeWorkoutSaveRxObj
                                    .activeWorkoutSaveRx(listId: widget.id)
                                    .catchError((_) => false);
                                // Navigate immediately
                                NavigationService.navigateToWithArgs(
                                  Routes.videoCongratsScreen,
                                  {
                                    "duration": "$minutes:00",
                                    "kcal": totalCal,
                                  },
                                );
                              },
                              text: "Finish Workout",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: ProgressBarWidget(
          onTap: () {
            if (_controller != null && _controller!.value.isPlaying) {
              _controller!.pause(); // Pause video before showing bottom sheet
            }
            showFullBlurBottomSheet(context);
          },
        ),
      ),

      body: StreamBuilder<WorkoutWiseVideoResponseModel>(
        stream: workoutVideoRxObj.workoutVideoRxStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "Caricamento del corso...",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return Center(child: Text("Nessun video disponibile"));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                // VIDEO AREA with stack
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      _controller == null || !_controller!.value.isInitialized
                          ? Center(
                              child: Text(
                                "Caricamento...",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: 1.sw,
                              height: .5.sh,
                              child: AspectRatio(
                                aspectRatio:
                                    (_controller!.value.isInitialized &&
                                            _controller!
                                                .value
                                                .aspectRatio
                                                .isFinite &&
                                            !_controller!
                                                .value
                                                .aspectRatio
                                                .isNaN)
                                        ? _controller!.value.aspectRatio
                                        : 16 / 9, // fallback ratio
                                child: VideoPlayer(_controller!),
                              ),
                            ),
                          ),

                      //

                      /// COUNTDOWN OVERLAY
                      if (_showCountdown)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(.6),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                '$_countdown',
                                key: ValueKey(_countdown),
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(fontSize: 80.sp),
                              ),
                            ),
                          ),
                        ),

                      // Zoom Icon
                      Positioned(
                        right: 20.w,
                        top: 20.h,
                        child: InkWell(
                          onTap: _enterFullScreen,
                          child: SvgPicture.asset(
                            Assets.icons.zoom,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Background Mucis Icon
                      Positioned(
                        right: 20.w,
                        top: 80.h,
                        child: InkWell(
                          onTap: () async {
                            if (_controller != null &&
                                _controller!.value.isPlaying) {
                              _controller!
                                  .pause(); // Pause video before showing bottom sheet
                            }

                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r),
                                ),
                              ),
                              builder: (_) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Navigator.pop(
                                            //   context,
                                            // ); // close bottom sheet
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            size: 30.sp,
                                            color: Color(0xFFF566A9),
                                          ),
                                        ),
                                      ),

                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount:
                                            snapshot
                                                .data
                                                ?.data?[currentIndex]
                                                .music
                                                ?.length ??
                                            0,
                                        itemBuilder: (_, index) {
                                          var data =
                                              snapshot
                                                  .data
                                                  ?.data?[currentIndex]
                                                  .music?[index];

                                          if (data == null) {
                                            return Text(
                                              "Music not available here",
                                              style: TextFontStyle
                                                  .headLine16cFFFFFFWorkSansW600
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            );
                                          } else {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  0xFFF566A9,
                                                ).withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: ListTile(
                                                title: Text(data.title ?? ""),
                                                trailing: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      if (_audioPlayer !=
                                                          null) {
                                                        await _audioPlayer!
                                                            .stop();
                                                      }
                                                      await _audioPlayer?.play(
                                                        UrlSource(
                                                          data.musicFile ?? '',
                                                        ),
                                                        volume: 1.0,
                                                      );
                                                    },
                                                    icon: Icon(Icons.add),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            // Resume video after closing bottom sheet
                            if (_controller != null &&
                                !_controller!.value.isPlaying) {
                              _controller!.play();
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.icons.music,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Video Info Icon
                      Positioned(
                        right: 20.w,
                        top: 140.h,
                        child: InkWell(
                          onTap: () async {
                            if (_controller != null &&
                                _controller!.value.isPlaying) {
                              _controller!
                                  .pause(); // Pause video before showing bottom sheet
                            }

                            await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r),
                                ),
                              ),
                              builder: (_) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                            ); // close bottom sheet
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            size: 30.sp,
                                            color: Color(0xFFF566A9),
                                          ),
                                        ),
                                      ),
                                      Html(
                                        data:
                                            videoList[currentIndex]
                                                .descriptions ??
                                            "",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            // Resume video after closing bottom sheet
                            if (_controller != null &&
                                !_controller!.value.isPlaying) {
                              _controller!.play();
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.icons.info,
                            width: 40.w,
                            height: 40.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                UIHelper.verticalSpace(20.sp),

                // TIMER
                ValueListenableBuilder(
                  valueListenable: _controller ?? ValueNotifier(null),
                  builder: (context, value, child) {
                    if (_controller == null || !_controller!.value.isInitialized) {
                      return Text(
                        "00:00",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 48.sp,
                        ),
                      );
                    }
                    final remaining = _controller!.value.duration - _controller!.value.position;
                    return Text(
                      _formatDuration(remaining),
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 48.sp,
                      ),
                    );
                  },
                ),

                UIHelper.verticalSpace(8.sp),

                // TITLE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    videoList[currentIndex].title ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                ),

                UIHelper.verticalSpace(4.sp),

                // STEP INDICATOR
                Text(
                  "STEP ${currentIndex + 1}/${videoList.length}",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),

                UIHelper.verticalSpace(20.sp),

                // WORKOUT CONTROL BAR WITH PROGRESS
                ValueListenableBuilder(
                  valueListenable: _controller ?? ValueNotifier(null),
                  builder: (context, value, child) {
                    double progress = 0.0;
                    bool isPlaying = false;

                    if (_controller != null && _controller!.value.isInitialized) {
                      final position = _controller!.value.position.inMilliseconds;
                      final duration = _controller!.value.duration.inMilliseconds;
                      if (duration > 0) {
                        progress = position / duration;
                      }
                      isPlaying = _controller!.value.isPlaying;
                    }

                    return WorkoutControlBar(
                      progress: progress,
                      isPlaying: isPlaying,
                      onPrevious: _playPrevious,
                      onPlayPause: () {
                        if (_controller == null) return;
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      onNext: _playNext,
                    );
                  },
                ),

                UIHelper.verticalSpace(30.h),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
