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

  // Premium gradient colors - coral to pink for energy
  static const Color _progressStart = Color(0xFFFF6B6B);
  static const Color _progressEnd = Color(0xFFF566A9);
  static const Color _trackColor = Color(0xFFF3F4F6);
  static const Color _iconDark = Color(0xFF1F2937);
  static const Color _iconLight = Colors.white;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barWidth = MediaQuery.of(context).size.width - 40.w;

    return Container(
      height: 64.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF566A9).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r),
        child: Stack(
          children: [
            // Progress bar with gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              width: barWidth * clampedProgress,
              height: 64.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [_progressStart, _progressEnd],
                ),
                borderRadius: BorderRadius.circular(32.r),
              ),
            ),

            // Subtle inner glow on progress
            if (clampedProgress > 0.05)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: barWidth * clampedProgress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.transparent,
                        Colors.black.withOpacity(0.05),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

            // Controls row
            Row(
              children: [
                // Previous button
                Expanded(
                  child: _ControlButton(
                    onTap: onPrevious,
                    icon: Icons.skip_previous_rounded,
                    size: 28.sp,
                    isOverProgress: clampedProgress > 0.20,
                  ),
                ),

                // Play/Pause button - larger and centered
                Expanded(
                  flex: 2,
                  child: _ControlButton(
                    onTap: onPlayPause,
                    icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 40.sp,
                    isOverProgress: clampedProgress > 0.50,
                    isMain: true,
                  ),
                ),

                // Next button
                Expanded(
                  child: _ControlButton(
                    onTap: onNext,
                    icon: Icons.skip_next_rounded,
                    size: 28.sp,
                    isOverProgress: clampedProgress > 0.80,
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

class _ControlButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final double size;
  final bool isOverProgress;
  final bool isMain;

  const _ControlButton({
    required this.onTap,
    required this.icon,
    required this.size,
    required this.isOverProgress,
    this.isMain = false,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isOverProgress
        ? Colors.white
        : const Color(0xFF374151);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedScale(
          scale: _isPressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.all(widget.isMain ? 8.w : 6.w),
            decoration: widget.isMain
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isOverProgress
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                  )
                : null,
            child: Icon(
              widget.icon,
              size: widget.size,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
