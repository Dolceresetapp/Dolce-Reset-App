import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../common_widget/custom_app_bar.dart';
import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/ui_helpers.dart';
import '../../provider/cache_video_provider.dart';
import '../exercise_video/progress_bar_widget.dart';
import 'cache_full_screen.dart';
import 'widgets/icon_widget.dart';
import 'widgets/info_widget.dart';
import 'widgets/music_widget.dart';
import 'widgets/show_bottom_widget.dart';

class CacheVideoScreen extends StatefulWidget {
  final int id;
  const CacheVideoScreen({super.key, required this.id});

  @override
  State<CacheVideoScreen> createState() => _CacheVideoScreenState();
}

class _CacheVideoScreenState extends State<CacheVideoScreen> {
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioPlayer = AudioPlayer();
      context.read<CacheVideoProvider>().getData(widget.id);
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Consumer<CacheVideoProvider>(
      builder: (_, provider, _) {

         log("minute =====================================: ${provider.model.minutes}");
            log("totalCal =================================: ${provider.model.totalCal}");

        final controller = provider.controller;

        if (controller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Color(0xFFeae8ec),
          appBar: CustomAppBar(
            backgroundColor: Color(0xFFeae8ec),
            title: ProgressBarWidget(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder:
                      (_) => ShowBottomWidget(
                        minutes: provider.model.minutes ?? 0,
                        totalCal: provider.model.totalCal ?? 0,
                              listId: provider.model.listId ?? 0,
                      ),
                );
              },
            ),
          ),
          body: FutureBuilder(
            future: provider.waitForInit(),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child:
                              controller.value.isInitialized
                                  ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                  : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                        ),
                        //Full Icon Widget
                        Positioned(
                          right: 20.w,
                          top: 20.h,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CacheFullScreenPlayer(
                                        controller: provider.controller!,
                                        currentIndex: provider.currentIndex,
                                        totalVideos: provider.data.length,
                                        onVideoEnd: () async {
                                          await provider.next();
                                        },
                                        onPrevious: () async {
                                          await provider.previous();
                                        },
                                      ),
                                ),
                              );
                            },
                            child: IconWidget(icon: Assets.icons.zoom),
                          ),
                        ),

                        // Music Icon Widget
                        Positioned(
                          right: 20.w,
                          top: 80.h,
                          child: InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,

                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  ),
                                ),
                                builder:
                                    (_) => MusicWidget(
                                      audioPlayer: _audioPlayer,
                                      music: provider.music,
                                    ),
                              );
                            },
                            child: IconWidget(icon: Assets.icons.music),
                          ),
                        ),

                        // Info Icon Widget
                        Positioned(
                          right: 20.w,
                          top: 140.h,
                          child: InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  ),
                                ),
                                builder:
                                    (BuildContext context) => InfoWidget(
                                      description:
                                          provider
                                              .data[provider.currentIndex]
                                              .descriptions ??
                                          "",
                                    ),
                              );
                            },
                            child: IconWidget(icon: Assets.icons.info),
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
                      provider.data[provider.currentIndex].title ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                    ),
                  ),

                  UIHelper.verticalSpace(20.sp),

                  // FIXED BUTTON ROW
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        spacing: 16.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _tappButton(
                            icon: Assets.icons.previous,
                            onTap:
                                provider.currentIndex == 0
                                    ? null
                                    : () async {
                                      await provider.previous();
                                    },
                          ),
                          InkWell(
                            onTap: provider.playPause,

                            child: Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: Color(0xFFF566A9),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                provider.controller != null &&
                                        provider.controller!.value.isPlaying
                                    ? Assets.images.pauseButton.path
                                    : Assets.images.playButton.path,
                                width: 48.w,
                                height: 48.h,
                              ),
                            ),
                          ),

                          _tappButton(
                            icon: Assets.icons.next,
                            onTap:
                                provider.currentIndex ==
                                        provider.data.length - 1
                                    ? null
                                    : provider.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

Widget _tappButton({VoidCallback? onTap, required String icon}) {
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
