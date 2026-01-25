import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../provider/cache_video_provider.dart';

class CacheFullScreenPlayer extends StatefulWidget {
  const CacheFullScreenPlayer({super.key});

  @override
  State<CacheFullScreenPlayer> createState() => _CacheFullScreenPlayerState();
}

class _CacheFullScreenPlayerState extends State<CacheFullScreenPlayer>
    with TickerProviderStateMixin {
  bool _showControls = true;
  bool _isReady = false;
  bool _isDisposed = false;
  bool _isExiting = false;
  bool _isTransitioning = false;
  Timer? _hideTimer;

  // Rest overlay state
  bool _showRestOverlay = false;
  int _restSecondsRemaining = 0;
  Timer? _restTimer;
  AnimationController? _restProgressController;
  VideoPlayerController? _previewController;
  bool _previewReady = false;

  static const Color _accentColor = Color(0xFFF566A9);

  CacheVideoProvider get _provider => context.read<CacheVideoProvider>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isDisposed || !mounted) return;

      // Start landscape transition
      _setLandscape();

      // Small delay then show content with fade
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted && !_isDisposed) {
        setState(() => _isReady = true);
        final controller = _provider.controller;
        if (controller != null && !controller.value.isPlaying) {
          controller.play();
        }
        _startHideTimer();
      }
    });
  }

  Future<void> _setLandscape() async {
    // First unlock ALL orientations to avoid iOS error
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Small delay to let iOS process the unlock
    await Future.delayed(const Duration(milliseconds: 50));
    // Now set landscape only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _setPortrait() async {
    // First unlock ALL orientations to avoid iOS error
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Small delay to let iOS process the unlock
    await Future.delayed(const Duration(milliseconds: 50));
    // Now set portrait only
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _closeFullscreen() async {
    if (_isDisposed || _isExiting) return;
    _isExiting = true;
    setState(() {}); // Trigger fade out animation

    // Start portrait transition while fading out
    _setPortrait();

    // Wait for fade animation
    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted && !_isDisposed) {
      Navigator.pop(context);
    }
  }

  Future<void> _handleNext() async {
    if (_isTransitioning || _showRestOverlay) return;
    final provider = _provider;
    if (provider.currentIndex >= provider.data.length - 1) {
      _closeFullscreen();
      return;
    }

    if (provider.restDuration > 0) {
      provider.controller?.pause();
      _startRestOverlay();
    } else {
      await _goToNextVideo();
    }
  }

  Future<void> _goToNextVideo() async {
    if (_isTransitioning) return;
    _isTransitioning = true;
    setState(() {});

    await _provider.next();

    if (mounted && !_isDisposed) {
      _isTransitioning = false;
      setState(() {});
      _startHideTimer();
    }
  }

  Future<void> _handlePrevious() async {
    if (_isTransitioning) return;
    final provider = _provider;
    if (provider.currentIndex <= 0) return;

    _isTransitioning = true;
    setState(() {});

    await provider.previous();

    if (mounted && !_isDisposed) {
      _isTransitioning = false;
      setState(() {});
      _startHideTimer();
    }
  }

  void _startRestOverlay() {
    final provider = _provider;
    setState(() {
      _showRestOverlay = true;
      _restSecondsRemaining = provider.restDuration;
    });

    _restProgressController = AnimationController(
      duration: Duration(seconds: provider.restDuration),
      vsync: this,
    );
    _restProgressController!.forward();

    _loadPreviewVideo();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining <= 1) {
        timer.cancel();
        _onRestComplete();
      } else {
        setState(() => _restSecondsRemaining--);
      }
    });
  }

  Future<void> _loadPreviewVideo() async {
    final provider = _provider;
    if (provider.currentIndex >= provider.data.length - 1) return;

    final nextVideoUrl = provider.data[provider.currentIndex + 1].videos;
    if (nextVideoUrl == null || nextVideoUrl.isEmpty) return;

    try {
      final file = await DefaultCacheManager().getSingleFile(nextVideoUrl);
      _previewController = VideoPlayerController.file(file);
      await _previewController!.initialize();
      _previewController!.setLooping(true);
      _previewController!.setVolume(0);
      _previewController!.play();

      if (mounted) setState(() => _previewReady = true);
    } catch (e) {
      // Ignore
    }
  }

  void _onRestComplete() {
    _cleanupRestOverlay();
    setState(() => _showRestOverlay = false);
    _goToNextVideo();
  }

  void _onRestSkip() {
    _restTimer?.cancel();
    _cleanupRestOverlay();
    setState(() => _showRestOverlay = false);
    _goToNextVideo();
  }

  void _cleanupRestOverlay() {
    _restTimer?.cancel();
    _restProgressController?.dispose();
    _restProgressController = null;
    _previewController?.dispose();
    _previewController = null;
    _previewReady = false;
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

  void _togglePlayPause() {
    final controller = _provider.controller;
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
    _startHideTimer();
  }

  String _formatRemaining(Duration remaining) {
    if (remaining.isNegative) return "0:00";
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _isDisposed = true;
    _hideTimer?.cancel();
    _restTimer?.cancel();
    _restProgressController?.dispose();
    _previewController?.dispose();
    // Only set portrait if not already exiting (closeFullscreen handles it)
    if (!_isExiting) {
      _setPortrait();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: (_isReady && !_isExiting) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Consumer<CacheVideoProvider>(
      builder: (context, provider, _) {
        final controller = provider.controller;
        final currentIndex = provider.currentIndex;
        final totalVideos = provider.data.length;

        if (controller == null || !controller.value.isInitialized) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox.expand(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _toggleControls,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Video
                Center(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ),

                // Loading overlay during transition
                if (_isTransitioning)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: CircularProgressIndicator(color: _accentColor),
                    ),
                  ),

                // Always visible: Timer and Step indicator (top left)
                Positioned(
                  top: 16,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _accentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentIndex + 1}/$totalVideos",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            final remaining = value.duration - value.position;
                            return Text(
                              _formatRemaining(remaining),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Always visible: Close button (top right)
                Positioned(
                  top: 16,
                  right: 20,
                  child: GestureDetector(
                    onTap: _closeFullscreen,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Controls overlay
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Bottom gradient
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 180,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Center play/pause button
                        Center(
                          child: GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.5),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                controller.value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                          ),
                        ),

                        // Bottom controls
                        Positioned(
                          bottom: 20,
                          left: 30,
                          right: 30,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress bar
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, VideoPlayerValue value, child) {
                                  final pos = value.position.inMilliseconds.toDouble();
                                  final dur = value.duration.inMilliseconds.toDouble();
                                  final progress = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;

                                  // Auto-next when video ends
                                  if (dur > 0 && pos >= dur - 200 && !_isTransitioning && !_showRestOverlay) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _handleNext();
                                    });
                                  }

                                  return GestureDetector(
                                    onTapDown: (details) {
                                      final width = MediaQuery.of(context).size.width - 60;
                                      final percent = (details.localPosition.dx / width).clamp(0.0, 1.0);
                                      controller.seekTo(Duration(milliseconds: (dur * percent).toInt()));
                                    },
                                    onHorizontalDragUpdate: (details) {
                                      final width = MediaQuery.of(context).size.width - 60;
                                      final percent = (details.localPosition.dx / width).clamp(0.0, 1.0);
                                      controller.seekTo(Duration(milliseconds: (dur * percent).toInt()));
                                      _hideTimer?.cancel();
                                    },
                                    onHorizontalDragEnd: (_) => _startHideTimer(),
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor: progress,
                                            child: Container(
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: _accentColor,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 12),

                              // Controls row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildControlButton(
                                    icon: Icons.skip_previous_rounded,
                                    enabled: currentIndex > 0 && !_isTransitioning,
                                    onTap: _handlePrevious,
                                  ),
                                  const SizedBox(width: 40),
                                  _buildControlButton(
                                    icon: Icons.skip_next_rounded,
                                    enabled: currentIndex < totalVideos - 1 && !_isTransitioning,
                                    onTap: _handleNext,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Horizontal Rest Overlay
                if (_showRestOverlay) _buildHorizontalRestOverlay(provider),
              ],
            ),
          ),
        );
      },
      ),
    );
  }

  Widget _buildHorizontalRestOverlay(CacheVideoProvider provider) {
    final nextTitle = provider.currentIndex < provider.data.length - 1
        ? provider.data[provider.currentIndex + 1].title ?? "Prossimo esercizio"
        : "Prossimo esercizio";

    return Container(
      color: Colors.black.withOpacity(0.9),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RIPOSO",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 6,
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          if (_restProgressController != null)
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: AnimatedBuilder(
                                animation: _restProgressController!,
                                builder: (context, child) {
                                  return CircularProgressIndicator(
                                    value: 1.0 - _restProgressController!.value,
                                    strokeWidth: 6,
                                    color: _accentColor,
                                    strokeCap: StrokeCap.round,
                                  );
                                },
                              ),
                            ),
                          Text(
                            "$_restSecondsRemaining",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_rounded, color: _accentColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "PROSSIMO",
                          style: TextStyle(
                            color: _accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nextTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: _onRestSkip,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.skip_next_rounded, color: _accentColor, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              "Salta riposo",
                              style: TextStyle(
                                color: Color(0xFF1A1A2E),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 24, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _previewReady && _previewController != null
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _previewController!.value.size.width,
                            height: _previewController!.value.size.height,
                            child: VideoPlayer(_previewController!),
                          ),
                        )
                      : Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(color: _accentColor, strokeWidth: 3),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(enabled ? 0.2 : 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(enabled ? 0.3 : 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(enabled ? 1.0 : 0.3),
          size: 30,
        ),
      ),
    );
  }
}
