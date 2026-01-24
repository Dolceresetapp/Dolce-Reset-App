import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double currentProgress; // 0.0 to 1.0 for current exercise

  const StoryProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.currentProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              height: 3.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: _buildSegment(index),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSegment(int index) {
    // App pink color
    const appPink = Color(0xFFF566A9);

    if (index < currentStep) {
      // Completed segments - fully filled
      return Container(
        decoration: BoxDecoration(
          color: appPink,
          borderRadius: BorderRadius.circular(2.r),
        ),
      );
    } else if (index == currentStep) {
      // Current segment - partially filled based on video progress
      return Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Progress fill
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: currentProgress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: appPink,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ],
      );
    } else {
      // Future segments - empty
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2.r),
        ),
      );
    }
  }
}
