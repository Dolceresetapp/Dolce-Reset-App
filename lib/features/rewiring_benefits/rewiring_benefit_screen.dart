import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../helpers/ui_helpers.dart';

class RewiringBenefitScreen extends StatefulWidget {
  const RewiringBenefitScreen({super.key});

  @override
  State<RewiringBenefitScreen> createState() => _RewiringBenefitScreenState();
}

class _RewiringBenefitScreenState extends State<RewiringBenefitScreen> {
  List<String> imageList = [
    Assets.images.card.path,
    Assets.images.card1.path,
    Assets.images.card2.path,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Rewiring Benefits",
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF000000),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: BouncingScrollPhysics(),
        child: Column(
          spacing: 20.h,
          children: [
            ListView.builder(
              itemCount: imageList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),

              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Image.asset(imageList[index]),
                );
              },
            ),

            CustomButton(
              onPressed: () {
                NavigationService.navigateTo(Routes.paymentFreeScreen);
              },
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                  ),

                  SvgPicture.asset(
                    Assets.icons.rightArrows,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                  UIHelper.verticalSpace(20.h),
                ],
              ),
            ),

            UIHelper.verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}
