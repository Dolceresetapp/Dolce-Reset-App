import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../networks/api_acess.dart';
import '../../services/preload_service.dart';

/// Screen that shows briefly while data loads in background
/// KEY: Navigate FAST, don't wait for everything
class DataLoadingScreen extends StatefulWidget {
  const DataLoadingScreen({super.key});

  @override
  State<DataLoadingScreen> createState() => _DataLoadingScreenState();
}

class _DataLoadingScreenState extends State<DataLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _loadAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadAndNavigate() async {
    // Start ALL data loading in background (fire and forget)
    _startBackgroundLoading();

    // Wait maximum 1.5 seconds then navigate NO MATTER WHAT
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      NavigationService.navigateToReplacement(Routes.navigationScreen);
    }
  }

  void _startBackgroundLoading() {
    // Fire and forget - don't await, don't block
    // These will complete in background and be cached

    // Essential data (run in parallel)
    unawaited(categoryRxObj.categoryRx().catchError((_) => false));
    unawaited(themeRxObj.themeRx().catchError((_) => false));
    unawaited(myWorkoutRxObj.myWorkoutRx().catchError((_) => false));

    // Images and deep content (lower priority)
    unawaited(preloadService.preloadAfterLogin().catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: SvgPicture.asset(
                      Assets.icons.logos,
                      width: 100.w,
                      height: 100.h,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            _PulsingDots(),
            SizedBox(height: 24.h),
            Text(
              'Benvenuto!',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
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

  double _pulseValue(double value) {
    if (value < 0.5) {
      return value * 2;
    } else {
      return (1 - value) * 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF566A9).withValues(alpha: opacity),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
