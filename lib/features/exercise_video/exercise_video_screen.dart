import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/videos_bar_widegt.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:video_player/video_player.dart';

import '../../common_widget/custom_app_bar.dart';
import '../../constants/text_font_style.dart';

class ExerciseVideoScreen extends StatefulWidget {
  const ExerciseVideoScreen({super.key});

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: VideosBarWidget(currentStep: 5, maxSteps: 10),
      ),

      body: Column(
        children: [
          // VIDEO AREA with stack (unchanged)
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                _controller.value.isInitialized
                    ? Positioned.fill(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),

          UIHelper.verticalSpace(20.sp),

          // TITLE
          Text(
            "Sei Pronta",
            style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 50.sp,
            ),
          ),

          UIHelper.verticalSpace(12.sp),

          // SUBTITLE
          Text(
            "Tonifica le Braccia",
            style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
              color: Colors.black,
              fontSize: 20.sp,
            ),
          ),

          UIHelper.verticalSpace(20.sp),

          // FIXED BUTTON ROW
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tappButton(icon: Assets.icons.previous, onTap: () {}),

                UIHelper.horizontalSpace(20.w),

                InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: Color(0xFFF566A9),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      _controller.value.isPlaying
                          ? Assets.images.pauseButton.path
                          : Assets.images.playButton.path,
                      width: 48.w,
                      height: 48.h,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 20.w),

                _tappButton(icon: Assets.icons.next, onTap: () {}),
              ],
            ),
          ),

          UIHelper.verticalSpaceMedium,
        ],
      ),

      // body: Column(
      //   children: [
      //     Expanded(
      //       flex: 2,
      //       child: Stack(
      //         children: [
      //           _controller.value.isInitialized
      //               ? AspectRatio(
      //                 aspectRatio: _controller.value.aspectRatio,
      //                 child: VideoPlayer(_controller),
      //               )
      //               : SafeArea(
      //                 child: Center(child: CircularProgressIndicator()),
      //               ),
      //         ],
      //       ),
      //     ),

      //     UIHelper.verticalSpace(20.sp),

      //     // Title
      //     Text(
      //       "Sei Pronta",
      //       style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
      //         color: Colors.black,
      //         fontWeight: FontWeight.bold,
      //         fontSize: 50.sp,
      //       ),
      //     ),

      //     UIHelper.verticalSpace(16.sp),

      //     // Title
      //     Text(
      //       "Tonifica le Braccia",
      //       style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
      //         color: Colors.black,
      //         fontSize: 20.sp,
      //       ),
      //     ),
      //     UIHelper.verticalSpace(16.sp),
      //     Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 20.w),
      //       child: Row(
      //         spacing: 16.w,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           _tappButton(icon: Assets.icons.previous, onTap: () {}),

      //           // _tappButton(icon: Assets.icons.pause, onTap: () {}),
      //           InkWell(
      //             onTap: () {
      //               setState(() {
      //                 _controller.value.isPlaying
      //                     ? _controller.pause()
      //                     : _controller.play();
      //               });
      //             },
      //             child: Container(
      //               padding: EdgeInsets.all(10.sp),
      //               decoration: BoxDecoration(
      //                 color: Color(0xFFF566A9),
      //                 shape: BoxShape.circle,
      //               ),

      //               child: Image.asset(
      //                 _controller.value.isPlaying
      //                     ? Assets.images.pauseButton.path
      //                     : Assets.images.playButton.path,
      //                 width: 48.w,
      //                 height: 48.h,
      //                 color: Colors.white,
      //                 fit: BoxFit.contain,
      //               ),
      //             ),
      //           ),
      //           _tappButton(icon: Assets.icons.next, onTap: () {}),
      //         ],
      //       ),
      //     ),

      //     UIHelper.verticalSpaceLarge,
      //   ],
      // ),
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
