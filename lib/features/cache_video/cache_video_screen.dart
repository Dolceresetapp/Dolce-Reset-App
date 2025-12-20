import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../common_widget/custom_app_bar.dart';
import '../../provider/cache_video_provider.dart';
import '../exercise_video/progress_bar_widget.dart';
import 'widgets/show_bottom_widget.dart';

class CacheVideoScreen extends StatefulWidget {
  final int id;
  const CacheVideoScreen({super.key, required this.id});

  @override
  State<CacheVideoScreen> createState() => _CacheVideoScreenState();
}

class _CacheVideoScreenState extends State<CacheVideoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CacheVideoProvider>().getData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheVideoProvider>(
      builder: (_, provider, _) {
        final controller = provider.controller;

        if (controller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBar(
            backgroundColor: Colors.white,
            title: ProgressBarWidget(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ShowBottomWidget(),
                );
              },
            ),
          ),
          body: SafeArea(
            child: FutureBuilder(
              future: provider.waitForInit(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return  Center(child: CircularProgressIndicator());
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),

                    // // ▶️ ⏸ Play
                    // IconButton(
                    //   iconSize: 80,
                    //   color: Colors.white,
                    //   icon: Icon(
                    //     provider.isPlaying
                    //         ? Icons.pause_circle
                    //         : Icons.play_circle,
                    //   ),
                    //   onPressed: provider.playPause,
                    // ),

                    // // ⏮ ⏭ Buttons
                    // Positioned(
                    //   bottom: 40,
                    //   left: 0,
                    //   right: 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       IconButton(
                    //         iconSize: 50,
                    //         icon: const Icon(Icons.skip_previous),
                    //         color: Colors.white,
                    //         onPressed:
                    //             provider.currentIndex == 0
                    //                 ? null
                    //                 : provider.previous,
                    //       ),
                    //       IconButton(
                    //         iconSize: 50,
                    //         icon: const Icon(Icons.skip_next),
                    //         color: Colors.white,
                    //         onPressed:
                    //             provider.currentIndex ==
                    //                     provider.data.length - 1
                    //                 ? null
                    //                 : provider.next,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // // 📊 Progress
                    // Positioned(
                    //   bottom: 10,
                    //   left: 20,
                    //   right: 20,
                    //   child: VideoProgressIndicator(
                    //     controller,
                    //     allowScrubbing: true,
                    //   ),
                    // ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
