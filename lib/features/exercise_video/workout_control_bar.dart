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

  // Premium fitness app color palette
  static const Color _progressStartColor = Color(0xFFFF6B8A);  // Coral pink
  static const Color _progressEndColor = Color(0xFFF566A9);    // Vibrant pink
  static const Color _trackColor = Color(0xFFEEEFF3);          // Soft gray
  static const Color _darkIconColor = Color(0xFF2D3142);       // Deep charcoal
  static const Color _lightIconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barWidth = MediaQuery.of(context).size.width - 48.w;

    // Thresholds for icon color switching
    const previousThreshold = 0.18;
    const playPauseThreshold = 0.52;
    const nextThreshold = 0.82;

    return Container(
      height: 72.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(36.r),
        boxShadow: [
          // Outer shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          // Subtle inner highlight
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 1,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36.r),
        child: Stack(
          children: [
            // Subtle track texture
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.5),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.02),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),

            // Progress fill with gradient
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                curve: Curves.easeOutCubic,
                width: barWidth * clampedProgress,
                height: 72.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_progressStartColor, _progressEndColor],
                  ),
                  borderRadius: BorderRadius.circular(36.r),
                  boxShadow: clampedProgress > 0.02
                      ? [
                          BoxShadow(
                            color: _progressEndColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(4, 0),
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    // Glossy highlight on progress
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 28.h,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.r),
                            topRight: Radius.circular(36.r),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.25),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls
            Positioned.fill(
              child: Row(
                children: [
                  // Previous button
                  Expanded(
                    child: _ControlButton(
                      onTap: onPrevious,
                      icon: Icons.skip_previous_rounded,
                      size: 32.sp,
                      useWhiteIcon: clampedProgress > previousThreshold,
                    ),
                  ),
                  // Play/Pause button (larger touch area)
                  Expanded(
                    flex: 2,
                    child: _ControlButton(
                      onTap: onPlayPause,
                      icon: isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 44.sp,
                      useWhiteIcon: clampedProgress > playPauseThreshold,
                      isCenter: true,
                    ),
                  ),
                  // Next button
                  Expanded(
                    child: _ControlButton(
                      onTap: onNext,
                      icon: Icons.skip_next_rounded,
                      size: 32.sp,
                      useWhiteIcon: clampedProgress > nextThreshold,
                    ),
                  ),
                ],
              ),
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
  final bool useWhiteIcon;
  final bool isCenter;

  const _ControlButton({
    this.onTap,
    required this.icon,
    required this.size,
    required this.useWhiteIcon,
    this.isCenter = false,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool get _isEnabled => widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (!_isEnabled) return;
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_isEnabled) return;
    widget.onTap?.call();
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.useWhiteIcon
        ? WorkoutControlBar._lightIconColor
        : WorkoutControlBar._darkIconColor;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _isEnabled ? 1.0 : 0.35,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Container(
                key: ValueKey('${widget.icon.hashCode}_${widget.useWhiteIcon}'),
                padding: widget.isCenter ? EdgeInsets.all(8.w) : EdgeInsets.zero,
                decoration: widget.isCenter
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      )
                    : null,
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: iconColor,
                  shadows: widget.useWhiteIcon
                      ? [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
