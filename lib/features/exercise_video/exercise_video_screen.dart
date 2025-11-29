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
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
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

  // Load API and first video inside
  @override
  void initState() {
    super.initState();
    workoutVideoRxObj.workoutVideoRx(id: widget.id);

    workoutVideoRxObj.workoutVideoRxStream.listen((apiResult) {
      if (apiResult.data != null && mounted) {
        videoList = apiResult.data!;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: ProgressBarWidget(
          onTap: () {
            NavigationService.navigateToWithArgs(Routes.videoSnapScreen, {
              "id": widget.id,
              "duration": videoList[currentIndex].seconds,
              "kcal": videoList[currentIndex].title ?? "",
            });
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
