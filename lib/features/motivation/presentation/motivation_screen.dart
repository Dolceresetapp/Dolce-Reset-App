import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/provider/motivation_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common_widget/custom_button.dart';
import '../../../constants/app_constants.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MotivationProvider>(context, listen: false).loadSavedImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MotivationProvider>(
        builder: (context, motivationProvider, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    motivationProvider.file == null
                        ? AssetImage(Assets.images.image.path)
                        : FileImage(File(motivationProvider.file!.path))
                            as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile Image
                        ClipOval(
                          child: (appData.read(kKeyAvatar) ?? "").isEmpty
                              ? Container(
                                  width: 36.w,
                                  height: 36.h,
                                  color: const Color(0xFFE5E5E5),
                                  child: Icon(
                                    Icons.person,
                                    size: 22.sp,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                )
                              : CustomCachedNetworkImage(
                                  imageUrl: appData.read(kKeyAvatar) ?? "",
                                  width: 36.w,
                                  height: 36.h,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        Text(
                          "Motivation",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(fontSize: 16.sp),
                        ),

                        // Image Icon
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(
                                  20.r,
                                ),
                              ),
                              context: context,
                              builder: (_) {
                                return Container(
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          motivationProvider.pickedImage(
                                            source: ImageSource.camera,
                                          );
                                          NavigationService.goBack;
                                        },
                                        child: ListTile(
                                          title: Text("Camera"),
                                          leading: Icon(Icons.camera),
                                        ),
                                      ),

                                      Divider(color: Colors.black),
                                      GestureDetector(
                                        onTap: () {
                                          motivationProvider.pickedImage(
                                            source: ImageSource.gallery,
                                          );
                                          NavigationService.goBack;
                                        },
                                        child: ListTile(
                                          title: Text("Gallery"),
                                          leading: Icon(Icons.photo),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: SvgPicture.asset(
                            Assets.icons.gallery,
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                      ],
                    ),

                    // Center Text & Icons
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 1.sw,

                              padding: EdgeInsets.all(20.sp),
                              decoration: BoxDecoration(
                                color: Color(0xFF8b838a).withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                appData.read(kKeyMessage) ?? "",
                                textAlign: TextAlign.center,
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),

                            UIHelper.verticalSpace(30.h),
                            CustomButton(
                              onPressed: () {
                                NavigationService.navigateTo(
                                  Routes.aICoachScreen,
                                );
                              },
                              child: Text(
                                "Talk to Your AI Coach",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ),

                            UIHelper.verticalSpace(10.h),
                            CustomButton(
                              color: Color(0xFF5d6474),
                              onPressed: () {},
                              child: Text(
                                "Join Community Now",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
