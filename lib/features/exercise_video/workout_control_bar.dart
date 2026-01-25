import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutControlBar extends StatelessWidget {
  final double progress;
  final bool isPlaying;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;

  const WorkoutControlBar({
    super.key,
    required this.progress,
    required this.isPlaying,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
  });

  static const Color _progressColor = Color(0xFFF566A9);
  static const Color _trackColor = Color(0xFFEEEFF3);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barWidth = MediaQuery.of(context).size.width - 48.w;

    return Container(
      height: 72.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(36.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36.r),
        child: Stack(
          children: [
            // Progress bar - simple, no animation jank
            AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              width: barWidth * clampedProgress,
              height: 72.h,
              decoration: BoxDecoration(
                color: _progressColor,
                borderRadius: BorderRadius.circular(36.r),
              ),
            ),

          // Controls
          Row(
            children: [
              // Previous
              Expanded(
                child: GestureDetector(
                  onTap: onPrevious,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(
                      Icons.skip_previous_rounded,
                      size: 32.sp,
                      color: clampedProgress > 0.18 ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              // Play/Pause
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: onPlayPause,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 44.sp,
                      color: clampedProgress > 0.5 ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              // Next
              Expanded(
                child: GestureDetector(
                  onTap: onNext,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 32.sp,
                      color: clampedProgress > 0.82 ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
