import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

import '../../../common_widget/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/loading_helper.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';

class ShowBottomWidget extends StatelessWidget {
  const ShowBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.60, // Full screen
      minChildSize: 0.20, // Force full height
      maxChildSize: 0.60, // Prevent dragging
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10, // stronger blur
              sigmaY: 10,
            ),
            child: Container(
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.25), // Glass effect
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Drag bar
                  Container(
                    width: 60,
                    height: 6,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Your content starts here
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        UIHelper.verticalSpace(30.h),
                        Text(
                          'Hand in there! \n You got this!',
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                fontSize: 30.sp,
                              ),
                        ),
                        UIHelper.verticalSpace(30.h),

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
                                style:
                                    TextFontStyle.headLine16cFFFFFFWorkSansW600,
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

                        UIHelper.verticalSpace(20.h),

                        CustomButton(
                          color: Color(0xFFAE47FF),
                          onPressed: () {
                            activeWorkoutSaveRxObj
                                .activeWorkoutSaveRx(listId: 5) //'widget.id')
                                .waitingForFuture()
                                .then((success) {
                                  if (success) {
                                    NavigationService.navigateToWithArgs(
                                      Routes.videoCongratsScreen,
                                      {
                                        "duration": 'minutes',
                                        "kcal": 'totalCal',
                                      },
                                    );
                                  }
                                });
                          },
                          text: "Finish Workout",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
