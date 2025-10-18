
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../helpers/navigation_service.dart';
import '../widgets/achivement_widget.dart';
import '../widgets/settings_title_widget.dart';
import '../widgets/user_info_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 1.sw,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      color: Color(0xFFF566A9),
                    ),
                  ),

                  // Profile text
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SafeArea(
                        child: Text(
                          "Profile",
                          style: TextFontStyle.headline30c27272AtyleWorkSansW700
                              .copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,

                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700
                            .copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -40,
                    child: Center(
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.w),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CustomCachedNetworkImage(
                          width: 80.w,
                          height: 80.h,
                          imageUrl: "",
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: -40,
                    bottom: -40,
                    child: InkWell(
                      onTap: () async {
                        await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r),
                            ),
                          ),
                          context: context,
                          builder: (_) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF1A2F20),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.r),
                                  topRight: Radius.circular(10.r),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.h,
                              ),

                              child: Column(
                                spacing: 20.h,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      NavigationService.goBack;
                                    },
                                    child: Row(
                                      spacing: 10.w,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                        Text(
                                          "Camera",
                                          style: TextFontStyle
                                              .headLine102cF8F3EFBarlowCondensedW700
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Gallery
                                  InkWell(
                                    onTap: () async {
                                      NavigationService.goBack;
                                    },
                                    child: Row(
                                      spacing: 10.w,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.photo_library,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextFontStyle
                                              .headLine102cF8F3EFBarlowCondensedW700
                                              .copyWith(fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        Assets.icons.upload,
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            UIHelper.verticalSpace(66.h),

            Align(
              alignment: Alignment.center,
              child: Text(
                "Emma Johns",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 24.sp,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "years",
                    title: "18",
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  child: VerticalDivider(
                    color: Color(0xFFD4D4D8),
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "kilograms",
                    title: "65",
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  child: VerticalDivider(
                    color: Color(0xFFD4D4D8),
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "Height",
                    title: "5'5 ",
                  ),
                ),
              ],
            ),

            UIHelper.verticalSpace(30.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Streak",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF566A9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            UIHelper.verticalSpace(10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: const Color(0xFFE4E4E7),
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Streak",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                        Text(
                          "24 days",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 24.sp,

                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),

                    UIHelper.verticalSpace(16.h),
                    Divider(color: Color(0xFFD4D4D8), thickness: 1),

                    UIHelper.verticalSpace(16.h),

                    Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.fire,
                          width: 30.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),

                        Column(
                          spacing: 8.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You're on fire!",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    color: const Color(0xFF27272A),
                                    fontSize: 16.sp,

                                    fontWeight: FontWeight.w700,
                                  ),
                            ),

                            Text(
                              "Keep using the app to get benefits!",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    color: const Color(0xFF52525B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            UIHelper.verticalSpace(32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Achivements",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF566A9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(16.h),
            // Arcivements
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: const Color(0xFFE4E4E7),
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Achievements",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                        Text(
                          "23",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 24.sp,

                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),

                    UIHelper.verticalSpace(16.h),
                    Divider(color: Color(0xFFD4D4D8), thickness: 1),

                    UIHelper.verticalSpace(16.h),

                    Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AchivementWidget(
                          icon: Assets.icons.frame2,
                          levelName: "Level 1",
                        ),
                        AchivementWidget(
                          icon: Assets.icons.frame1,
                          levelName: "Level 2",
                        ),

                        AchivementWidget(
                          icon: Assets.icons.frame,
                          levelName: "Level 3",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            UIHelper.verticalSpace(32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "General Settings",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            SettingsTitleWidget(
              icon: Assets.icons.userSingle,
              title: "Profile Settings",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.vector,
              title: "Subscription & Billing",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.activityRunningJogging,
              title: "Wellness Goals",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.ruler,
              title: "Units & Metrics",
            ),
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Notifications",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.vector1,
              title: "General Notification",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.envelopeEmail,
              title: "Email Notification",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.soundOn,
              title: "Sound Notiifcation",
            ),

            ///
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Security & Privacy",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.lockLocked,
              title: "Change password",
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.arrowRepeat,
              title: "Clear & Reset Data",
            ),
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Help & Support",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.questionMarkCircle,
              title: "FAQs",
            ),

            UIHelper.verticalSpace(32.h),

            // Danger Zone
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Danger Zone",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.trash,
              title: "Delete Account",
            ),

            UIHelper.verticalSpace(20.h),

            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                Assets.icons.frame3,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),

            UIHelper.verticalSpaceMediumLarge,
          ],
        ),
      ),
    );
  }
}
