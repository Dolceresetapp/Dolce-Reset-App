import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutControlBar extends StatefulWidget {
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

  @override
  State<WorkoutControlBar> createState() => _WorkoutControlBarState();
}

class _WorkoutControlBarState extends State<WorkoutControlBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  // Premium fitness color palette
  static const Color _progressGradientStart = Color(0xFFFF6B9D);
  static const Color _progressGradientMid = Color(0xFFF566A9);
  static const Color _progressGradientEnd = Color(0xFFE8447A);
  static const Color _trackColor = Color(0xFFEEEFF3);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = widget.progress.clamp(0.0, 1.0);
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = screenWidth - 48.w;

    return Container(
      height: 68.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(34.r),
        boxShadow: [
          // Outer shadow for depth
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          // Inner highlight (top)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 1,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34.r),
        child: Stack(
          children: [
            // Animated progress fill with gradient
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutQuart,
                width: barWidth * clampedProgress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _progressGradientStart,
                      _progressGradientMid,
                      _progressGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _progressGradientMid.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(4, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 30.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.25),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls row
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    Expanded(
                      child: _ControlButton(
                        onTap: widget.onPrevious,
                        icon: Icons.skip_previous_rounded,
                        size: 30.sp,
                        isHighlighted: clampedProgress > 0.18,
                      ),
                    ),

                    // Center play/pause button with glow effect
                    _PlayPauseButton(
                      onTap: widget.onPlayPause,
                      isPlaying: widget.isPlaying,
                      isHighlighted: clampedProgress > 0.42,
                      pulseAnimation: _pulseController,
                    ),

                    // Next button
                    Expanded(
                      child: _ControlButton(
                        onTap: widget.onNext,
                        icon: Icons.skip_next_rounded,
                        size: 30.sp,
                        isHighlighted: clampedProgress > 0.72,
                      ),
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

class _PlayPauseButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isPlaying;
  final bool isHighlighted;
  final AnimationController pulseAnimation;

  const _PlayPauseButton({
    required this.onTap,
    required this.isPlaying,
    required this.isHighlighted,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          // Subtle pulse when playing
          final pulseScale = isPlaying ? 1.0 + (pulseAnimation.value * 0.03) : 1.0;

          return Transform.scale(
            scale: pulseScale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHighlighted
                    ? Colors.white.withValues(alpha: 0.95)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isHighlighted
                        ? const Color(0xFFE8447A).withValues(alpha: 0.35)
                        : const Color(0xFF000000).withValues(alpha: 0.1),
                    blurRadius: isHighlighted ? 12 : 8,
                    offset: const Offset(0, 3),
                    spreadRadius: isHighlighted ? 2 : 0,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    key: ValueKey(isPlaying),
                    size: 32.sp,
                    color: const Color(0xFFF566A9),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final double size;
  final bool isHighlighted;

  const _ControlButton({
    required this.onTap,
    required this.icon,
    required this.size,
    required this.isHighlighted,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
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
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isHighlighted
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: widget.isHighlighted
                  ? Colors.white
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}
