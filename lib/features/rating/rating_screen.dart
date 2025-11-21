import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/features/rating/data/model/rating_response_model.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../common_widget/custom_button.dart';
import '../../constants/text_font_style.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../networks/api_acess.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  void initState() {
    ratingRxObj.ratingRx();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Give us a rating",
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF000000),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: BouncingScrollPhysics(),

        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                width: 240.w,
                Assets.images.rating.path,
                height: 75.h,
              ),
            ),

            UIHelper.verticalSpace(16.h),

            Text(
              "This app was designed for people like you.",
              style: TextFontStyle.headLine16cFFFFFFWorkSansThinW600.copyWith(
                color: const Color(0xFF000000),
                fontSize: 16.sp,
              ),
            ),

            UIHelper.verticalSpace(16.h),

            StreamBuilder<RatingResponseModel>(
              stream: ratingRxObj.ratingRxStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return WaitingWidget();
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 0.3.sh,
                    child: Center(
                      child: Text(
                        "something went wrong",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF000000),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return SizedBox(
                    height: 0.3.sh,
                    child: Center(
                      child: Text(
                        "Data is not available",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                            .copyWith(
                              color: const Color(0xFF000000),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.data?.length,
                    shrinkWrap: true,

                    physics: NeverScrollableScrollPhysics(),

                    padding: EdgeInsets.zero,

                    itemBuilder: (_, index) {
                      var data = snapshot.data?.data?[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              spacing: 10.w,

                              children: [
                                // Avatar
                                Expanded(
                                  flex: 1,
                                  child: ClipOval(
                                    child: CustomCachedNetworkImage(
                                      imageUrl: data?.image ?? "",
                                      width: 43.w,
                                      height: 43.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //  Name
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    data?.title ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextFontStyle
                                        .headLine16cFFFFFFWorkSansW600
                                        .copyWith(
                                          color: const Color(0xFF000000),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),

                                // Rating
                                Expanded(
                                  flex: 1,
                                  child: StarRating(
                                    rating: data?.rating?.toDouble() ?? 0.0,
                                    allowHalfRating: true,
                                  ),
                                ),
                              ],
                            ),

                            UIHelper.verticalSpace(16.h),

                            Text(
                              data?.description ?? "",
                              style: TextFontStyle
                                  .headLine16cFFFFFFWorkSansThinW600
                                  .copyWith(
                                    color: const Color(0xFF000000),
                                    fontSize: 16.sp,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),

            UIHelper.verticalSpace(20.h),

            CustomButton(
              onPressed: () {
                NavigationService.navigateTo(Routes.planReadyScreen);
              },

              color: Color(0xFFF566A9),

              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: Color(0xFFFFFFFF),
              ),
              text: "Next",
            ),

            UIHelper.verticalSpaceSemiLarge,
          ],
        ),
      ),
    );
  }
}
