import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class CacheFullScreenPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final int currentIndex;
  final int totalVideos;
  final Future<void> Function()? onVideoEnd;
  final Future<void> Function()? onPrevious;

  const CacheFullScreenPlayer({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.totalVideos,
    this.onVideoEnd,
    this.onPrevious,
  });

  @override
  State<CacheFullScreenPlayer> createState() => _CacheFullScreenPlayerState();
}

class _CacheFullScreenPlayerState extends State<CacheFullScreenPlayer> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    /// FORCE LANDSCAPE FULL SCREEN
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (!_controller.value.isPlaying) _controller.play();
    _controller.addListener(_videoListener);
    _startHideTimer();
  }

  void _videoListener() {
    if (_controller.value.isInitialized &&
        _controller.value.position >=
            _controller.value.duration - const Duration(milliseconds: 200)) {
      if (widget.currentIndex == widget.totalVideos - 1) {
        Navigator.pop(context);
      } else {
        widget.onVideoEnd?.call();
      }
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeListener(_videoListener);

    /// RESTORE PORTRAIT
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            /// VIDEO
            Center(
              child:
                  _controller.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : const CircularProgressIndicator(color: Colors.white),
            ),

            /// PLAY / PAUSE
            if (_showControls)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                    _startHideTimer();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),

            /// BACK BUTTON
            if (_showControls)
              Positioned(
                top: 10.h,
                left: 20.w,
                child: SafeArea(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

            /// BOTTOM CONTROLS
            if (_showControls)
              Positioned(
                bottom: 20.h,
                left: 0.w,
                right: 0.w,
                child: SafeArea(
                  child: Column(
                    children: [
                      /// SEEK BAR
                      ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, VideoPlayerValue value, child) {
                          final pos = value.position.inMilliseconds.toDouble();
                          final dur = value.duration.inMilliseconds.toDouble();
                          return Slider(
                            value: pos.clamp(0, dur),
                            min: 0,
                            max: dur > 0 ? dur : 1,
                            onChanged: (v) {
                              _controller.seekTo(
                                Duration(milliseconds: v.toInt()),
                              );
                            },
                            onChangeStart: (_) => _hideTimer?.cancel(),
                            onChangeEnd: (_) => _startHideTimer(),
                          );
                        },
                      ),

                      /// PREV / TIME / NEXT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// PREVIOUS
                          IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              size: 20.sp,
                              color:
                                  widget.currentIndex == 0
                                      ? Colors.grey
                                      : Colors.white,
                            ),
                            onPressed:
                                widget.currentIndex == 0
                                    ? null
                                    : () async {
                                      _controller.pause();
                                      _controller.seekTo(Duration.zero);
                                      if (widget.onPrevious != null)
                                        await widget.onPrevious!();
                                    },
                          ),

                          /// TIME
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, VideoPlayerValue value, child) {
                              return Text(
                                "${_format(value.position)} / ${_format(value.duration)}",
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          ),

                          /// NEXT
                          IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              size: 20.sp,
                              color:
                                  widget.currentIndex == widget.totalVideos - 1
                                      ? Colors.grey
                                      : Colors.white,
                            ),
                            onPressed:
                                widget.currentIndex == widget.totalVideos - 1
                                    ? null
                                    : () async {
                                      _controller.pause();
                                      _controller.seekTo(Duration.zero);
                                      if (widget.onVideoEnd != null)
                                        await widget.onVideoEnd!();
                                    },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
