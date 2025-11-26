import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../gen/assets.gen.dart';
import '../../networks/api_acess.dart';
import 'data/model/workout_video_response_model.dart';

class ReadyScreen extends StatefulWidget {
  final int id;
  const ReadyScreen({super.key, required this.id});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  @override
  void initState() {
    super.initState();
    workoutVideoRxObj.workoutVideoRx(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,

        toolbarHeight: 30.h,

        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.images.womensBg.path),
          ),
        ),
      ),

      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
        width: 1.sw,
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: StreamBuilder<WorkoutWiseVideoResponseModel>(
          stream: workoutVideoRxObj.workoutVideoRxStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return WaitingWidget();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFFF97316),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            } else if (snapshot.data == null ||
                snapshot.data!.data == null ||
                snapshot.data!.data!.isEmpty) {
              // Empty data message
              return Center(
                child: Text(
                  "Data \n not available",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFFF97316),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Ready?",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFF27272A),
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),

                  UIHelper.verticalSpace(16.h),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 0.45.sw,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF27272A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10.w,
                        children: [
                          // icon
                          Image.asset(
                            Assets.icons.clock.path,
                            width: 12.w,
                            height: 12.h,
                          ),

                          Text(
                            "${snapshot.data?.minutes ?? ""} min",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,

                                  fontWeight: FontWeight.w500,
                                ),
                          ),

                          Image.asset(
                            Assets.icons.firePng.path,
                            width: 12.w,
                            height: 12.h,
                          ),
                          Text(
                            "${snapshot.data?.totalCal ?? ""} Kcal",
                            style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 14.sp,

                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  UIHelper.verticalSpace(24.h),

                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.data?.length,
                    itemBuilder: (_, index) {
                      var data = snapshot.data?.data?[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          spacing: 10.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: CustomCachedNetworkImage(
                                imageUrl: data?.thumbnail ?? "",
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Column(
                              spacing: 8.h,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data?.title ?? "",
                                  style: TextFontStyle
                                      .headLine16cFFFFFFWorkSansW600
                                      .copyWith(
                                        color: const Color(0xFF27272A),
                                        fontSize: 18.sp,

                                        fontWeight: FontWeight.w600,
                                      ),
                                ),

                                Text(
                                  "${data?.seconds ?? ""} seconds",
                                  style: TextFontStyle
                                      .headLine16cFFFFFFWorkSansW600
                                      .copyWith(
                                        color: const Color(0xFF27272A),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  UIHelper.verticalSpace(24.h),

                  CustomButton(
                    onPressed: () {
                      NavigationService.navigateTo(
                        Routes.downloadProgressScreen,
                      );
                    },
                    text: "Start",
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
