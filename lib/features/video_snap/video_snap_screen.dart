import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

import '../../constants/text_font_style.dart';
import '../../gen/assets.gen.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/loading_helper.dart';
import '../../networks/api_acess.dart';

class VideoSnapScreen extends StatefulWidget {
  final int id;

  final int duration;

  final int kcal;
  const VideoSnapScreen({super.key, required this.id, required this.duration, required this.kcal});

  @override
  State<VideoSnapScreen> createState() => _VideoSnapScreenState();
}

class _VideoSnapScreenState extends State<VideoSnapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            spacing: 10.h,
            children: [
              Text(
                'Hand in there! \n You got this!',
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 30.sp,
                ),
              ),

              CustomButton(
                onPressed: () {
                  NavigationService.goBack;
                },
                child: Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Keep Exercising",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                    ),

                    SvgPicture.asset(
                      Assets.icons.arrowRight,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              CustomButton(
                color: Color(0xFFAE47FF),
                onPressed: () {
                  activeWorkoutSaveRxObj
                      .activeWorkoutSaveRx(listId: widget.id)
                      .waitingForFuture()
                      .then((success) {
                        if (success) {
                          NavigationService.navigateTo(
                            Routes.videoCongratsScreen,
                          );
                        }
                      });
                },
                text: "Finish Workout",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
