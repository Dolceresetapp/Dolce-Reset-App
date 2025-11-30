import 'dart:ui';

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
import '../../helpers/loading_helper.dart';
import '../../helpers/navigation_service.dart';
import '../../networks/api_acess.dart';
import '../ready/data/model/workout_video_response_model.dart';
import 'progress_bar_widget.dart';

class ExerciseVideoScreen extends StatefulWidget {
  final int id;
  const ExerciseVideoScreen({super.key, required this.id});

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  // Add variables for list & index
  VideoPlayerController? _controller;

  int currentIndex = 0;
  List videoList = [];

  int totalCal = 0;
  int minutes = 0;

  // Load API and first video inside
  @override
  void initState() {
    super.initState();
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
        _controller!.play();

        // Auto play next video when current ends
        _controller!.addListener(() {
          if (_controller!.value.position >= _controller!.value.duration) {
            _playNext();
          }
        });
      });
  }

  // Add NEXT and PREVIOUS functions
  void _playNext() {
    if (currentIndex < videoList.length - 1) {
      setState(() {
        currentIndex++;
      });
      _initializeVideo(videoList[currentIndex].videos);
    }
  }

  void _playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _initializeVideo(videoList[currentIndex].videos);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _enterFullScreen() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    Navigator.push(
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
                                activeWorkoutSaveRxObj
                                    .activeWorkoutSaveRx(listId: widget.id)
                                    .waitingForFuture()
                                    .then((success) {
                                      if (success) {
                                        NavigationService.navigateToWithArgs(
                                          Routes.videoCongratsScreen,
                                          {
                                            "duration": minutes,
                                            "kcal": totalCal,
                                          },
                                        );
                                      }
                                    });
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
            return WaitingWidget();
          } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return Center(child: Text("No videos available"));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                // VIDEO AREA with stack (unchanged)
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      _controller == null || !_controller!.value.isInitialized
                          ? Center(child: CircularProgressIndicator())
                          : FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: 1.sw,
                              height: 0.7.sh,
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
                        child: SvgPicture.asset(
                          Assets.icons.music,
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Video Info Icon
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
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                ),

                UIHelper.verticalSpace(20.sp),

                // FIXED BUTTON ROW
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    spacing: 16.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tappButton(
                        icon: Assets.icons.previous,
                        onTap: _playPrevious,
                      ),

                      InkWell(
                        onTap: () {
                          if (_controller == null) return;

                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            color: Color(0xFFF566A9),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            _controller != null && _controller!.value.isPlaying
                                ? Assets.images.pauseButton.path
                                : Assets.images.playButton.path,
                            width: 48.w,
                            height: 48.h,
                          ),
                        ),
                      ),

                      _tappButton(icon: Assets.icons.next, onTap: _playNext),
                    ],
                  ),
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

Widget _tappButton({required VoidCallback onTap, required String icon}) {
  return InkWell(
    onTap: onTap,
    child: SvgPicture.asset(
      icon,
      width: 64.w,
      height: 64.h,
      fit: BoxFit.contain,
    ),
  );
}
