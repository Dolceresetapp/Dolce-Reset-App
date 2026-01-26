import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Elegant loading widget with pulsing dots
class WaitingWidget extends StatefulWidget {
  final String? message;

  const WaitingWidget({
    super.key,
    this.message,
  });

  @override
  State<WaitingWidget> createState() => _WaitingWidgetState();
}

class _WaitingWidgetState extends State<WaitingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final delay = index * 0.2;
                  final value = (_controller.value + delay) % 1.0;
                  final scale = 0.5 + (0.5 * _pulseValue(value));
                  final opacity = 0.3 + (0.7 * _pulseValue(value));

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF566A9).withOpacity(opacity),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          if (widget.message != null) ...[
            SizedBox(height: 16.h),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _pulseValue(double value) {
    // Smooth pulse curve
    if (value < 0.5) {
      return value * 2;
    } else {
      return (1 - value) * 2;
    }
  }
}