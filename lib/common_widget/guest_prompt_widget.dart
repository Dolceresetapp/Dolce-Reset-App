import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/text_font_style.dart';
import '../helpers/all_routes.dart';
import '../helpers/navigation_service.dart';
import '../helpers/ui_helpers.dart';
import 'custom_button.dart';

/// Full-screen prompt shown to guest users for account-based features.
class GuestPromptWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GuestPromptWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 64.sp,
                  color: const Color(0xFFD4D4D8),
                ),
                UIHelper.verticalSpace(24.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                UIHelper.verticalSpace(12.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF71717A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                UIHelper.verticalSpace(32.h),
                CustomButton(
                  onPressed: () {
                    NavigationService.navigateTo(
                      Routes.onboardingScreen1,
                    );
                  },
                  child: Text(
                    "Registrati",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                  ),
                ),
                UIHelper.verticalSpace(16.h),
                GestureDetector(
                  onTap: () {
                    NavigationService.navigateTo(
                      Routes.signInScreen,
                    );
                  },
                  child: Text(
                    'Hai già un account? Accedi',
                    style: TextFontStyle.headline30c27272AtyleWorkSansW700
                        .copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 14.sp,
                          color: const Color(0xFF767EFF),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small banner shown at the top of screens in guest mode.
class GuestBanner extends StatelessWidget {
  const GuestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF566A9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF566A9).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Registrati per accedere a tutti i contenuti",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          UIHelper.horizontalSpace(8.w),
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(
                Routes.onboardingScreen1,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF566A9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "Registrati",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
