import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        child: Column(
          children: [
            Stack(
              children: [
                _controller.value.isInitialized
                    ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                    : SafeArea(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                Positioned(
                  child: SafeArea(
                    child: BackButton(
                      onPressed: () {
                        NavigationService.goBack;
                      },
                      color: Colors.white,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },

                      icon: Icon(
                        size: 20.sp,
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),

                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            UIHelper.verticalSpace(20.h),

            //
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: 10,

                shrinkWrap: true,

                padding: EdgeInsets.zero,

                physics: NeverScrollableScrollPhysics(),

                itemBuilder: (_, index) {
                  return Row(
                    spacing: 10.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          Assets.images.biceps.path,
                          width: 120.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Column(
                        spacing: 10.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "8-minute Abs Quick Core",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: const Color(0xFF27272A),
                                  fontSize: 13.sp,

                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          Row(
                            spacing: 10.w,
                            children: [
                              Text(
                                "11 min",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(
                                      color: const Color(0xFF27272A),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                "15 kcal",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(
                                      color: const Color(0xFFF566A9),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            UIHelper.verticalSpaceSemiLarge,
          ],
        ),
      ),
    );
  }
}
