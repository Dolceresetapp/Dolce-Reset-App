import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../provider/cache_video_provider.dart';
import '../../ready/data/model/workout_video_response_model.dart';

/// Animated equalizer bars widget
class _AnimatedEqualizer extends StatefulWidget {
  final Color color;
  final double size;

  const _AnimatedEqualizer({
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedEqualizer> createState() => _AnimatedEqualizerState();
}

class _AnimatedEqualizerState extends State<_AnimatedEqualizer>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 500 + _random.nextInt(400)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 0.9).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with random delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: widget.size * 0.15,
                height: widget.size * _animations[index].value,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class MusicWidget extends StatefulWidget {
  const MusicWidget({super.key});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  static const _accentColor = Color(0xFFF566A9);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMusic();
  }

  Future<void> _loadMusic() async {
    final provider = context.read<CacheVideoProvider>();
    if (provider.availableMusic.isEmpty) {
      await provider.fetchAvailableMusic();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheVideoProvider>(
      builder: (context, provider, _) {
        final availableMusic = provider.availableMusic;
        final currentMusic = provider.currentMusic;
        final musicEnabled = provider.musicEnabled;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          width: 1.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close and toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Music toggle
                  Row(
                    children: [
                      Icon(
                        musicEnabled ? Icons.music_note : Icons.music_off,
                        color: musicEnabled ? _accentColor : Colors.grey,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Musica",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Switch(
                        value: musicEnabled,
                        onChanged: (value) {
                          provider.musicEnabled = value;
                        },
                        activeThumbColor: _accentColor,
                      ),
                    ],
                  ),
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: 28.sp, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Volume slider
              Row(
                children: [
                  Icon(
                    Icons.volume_down_rounded,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _accentColor,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        thumbColor: _accentColor,
                        overlayColor: _accentColor.withOpacity(0.2),
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                      ),
                      child: Slider(
                        value: provider.musicVolume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          provider.musicVolume = value;
                        },
                      ),
                    ),
                  ),
                  Icon(
                    Icons.volume_up_rounded,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Music list or loading/empty
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: _accentColor),
                      SizedBox(height: 16.h),
                      Text(
                        "Caricamento musica...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              else if (availableMusic.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.music_off_rounded,
                        color: Colors.grey,
                        size: 48.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Nessuna musica disponibile",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: availableMusic.length,
                    itemBuilder: (_, index) {
                      final music = availableMusic[index];
                      final isPlaying = currentMusic?.id == music.id;

                      return _MusicTile(
                        music: music,
                        isSelected: isPlaying,
                        isMusicPlaying: isPlaying && provider.isMusicPlaying,
                        onTap: () {
                          if (isPlaying) {
                            // Same music tapped - toggle pause/resume
                            provider.toggleMusicPlayPause();
                          } else {
                            // Different music - play it
                            provider.playMusic(music);
                          }
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MusicTile extends StatelessWidget {
  final Music music;
  final bool isSelected;
  final bool isMusicPlaying;
  final VoidCallback onTap;

  const _MusicTile({
    required this.music,
    required this.isSelected,
    required this.isMusicPlaying,
    required this.onTap,
  });

  static const _accentColor = Color(0xFFF566A9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? _accentColor.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: _accentColor, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // Music icon - shows pause only if this track is selected AND playing
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSelected ? _accentColor : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                isMusicPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Title and duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.title ?? "Senza titolo",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (music.duration != null)
                    Text(
                      music.duration!,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
            ),
            // Animated playing indicator
            if (isMusicPlaying)
              _AnimatedEqualizer(
                color: _accentColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
