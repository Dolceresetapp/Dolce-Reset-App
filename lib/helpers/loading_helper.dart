import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widget/loading_indicators.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../networks/exception_handler/data_source.dart';
import 'default_response_model.dart';
import 'navigation_service.dart';

extension Loader on Future {
  Future<dynamic> waitingForFuture() async {
    showDialog(
      context: NavigationService.context!,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => const _ElegantLoadingDialog(),
    );

    try {
      // Wait for the original future to complete
      dynamic result = await this;

      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBack;
    }
  }

  Future<dynamic> waitingForSucess() async {
    showDialog(
      context: NavigationService.context!,
      builder:
          (context) => Center(
            child: shimmer(context: context, name: Assets.lottie.loading),
          ),
    );

    try {
      // Wait for the original future to complete
      dynamic result = await this;

      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBack;
    }
  }

  Future<dynamic> waitingRemoveFromCart() async {
    showDialog(
      // barrierDismissible: false,
      // barrierColor: AppColors.cF4F4F4.withOpacity(.8),
      context: NavigationService.context!,
      builder:
          (context) => Center(
            child: shimmer(
              context: context,
              name: Assets.lottie.removeFromCart,
              size: 120.sp,
            ),
          ),
    );

    try {
      // Wait for the original future to complete
      dynamic result = await this;

      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBack;
    }
  }

  Future<dynamic> waitingForFutureWithoutBg() async {
    showDialog(
      context: NavigationService.context!,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => const _ElegantLoadingDialog(),
    );

    try {
      // Wait for the original future to complete
      dynamic result = await this;
      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBack;
    }
  }

  Future<void> waitingForFuturewithTime() async {
    try {
      showDialog(
        context: NavigationService.context!,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) => const _ElegantLoadingDialog(),
      );
      bool result = await this;
      NavigationService.goBack;
      if (result) {
        showDialog(
          context: NavigationService.context!,
          builder:
              (context) => shimmer(
                context: NavigationService.context!,
                name: Assets.lottie.success,
                size: 120.sp,
              ),
        );
        await Future.delayed(const Duration(milliseconds: 800), () {
          NavigationService.goBack;
        });
      }
    } catch (e) {
      NavigationService.goBack;
      log(e.toString());
    }
  }

  Future<void> waitingForSuccessShow() async {
    try {
      bool result = await this;
      if (result) {
        showDialog(
          context: NavigationService.context!,
          builder:
              (context) => shimmer(
                context: NavigationService.context!,
                name: Assets.lottie.success,
                size: 120.sp,
              ),
        );
        await Future.delayed(const Duration(milliseconds: 800), () {
          NavigationService.goBack;
        });
      }
    } catch (e) {
      NavigationService.goBack;
      log(e.toString());
    }
  }

  Future<bool> customeThen() async {
    bool retunValue = await then(
      (value) async {
        showDialog(
          context: NavigationService.context!,
          builder:
              (context) => shimmer(
                context: NavigationService.context!,
                name: Assets.lottie.success,
                size: 120.sp,
              ),
        );
        await Future.delayed(const Duration(milliseconds: 800), () {
          NavigationService.goBack;
        });
        DefaultResponse defaultResponse = value as DefaultResponse;
        ScaffoldMessenger.of(
          NavigationService.context!,
        ).showSnackBar(SnackBar(content: Text(defaultResponse.message!)));
        return true;
      },
      onError: (value) {
        Failure failureresponse = value as Failure;
        ScaffoldMessenger.of(NavigationService.context!).showSnackBar(
          SnackBar(content: Text(failureresponse.responseMessage)),
        );
        return false;
      },
    );
    return retunValue;
  }
}

/// Elegant loading dialog with pulsing dots
class _ElegantLoadingDialog extends StatefulWidget {
  const _ElegantLoadingDialog();

  @override
  State<_ElegantLoadingDialog> createState() => _ElegantLoadingDialogState();
}

class _ElegantLoadingDialogState extends State<_ElegantLoadingDialog>
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
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
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
      ),
    );
  }
}
