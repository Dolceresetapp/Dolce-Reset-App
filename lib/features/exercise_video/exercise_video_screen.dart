import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../common_widget/app_bar_widget.dart' show AppBarWidget;
import '../../common_widget/custom_app_bar.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/navigation_service.dart';

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
        title: AppBarWidget(currentStep: 5, isBackIcon: true, maxSteps: 15),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Text(
                "Step 5 / 15",
                style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
                  fontSize: 16.sp,
                  color: Color(0xFFF566A9),
                ),
              ),
            ),
          ),
        ],
      ),

      body:  Stack(
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
    );
  }
}
