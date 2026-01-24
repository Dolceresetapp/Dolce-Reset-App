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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        toolbarHeight: 30.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image at top
          Positioned(
            top: 40.h,
            left: 0,
            right: 0,
            height: 0.45.sh,
            child: Image.asset(
              Assets.images.womensBg.path,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Draggable sheet that expands to cover the image
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.58,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.58, 1.0],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
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
                        children: [
                          // Scrollable content
                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
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

                                UIHelper.verticalSpace(8.h),

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

                                ...List.generate(
                                  snapshot.data?.data?.length ?? 0,
                                  (index) {
                                    var data = snapshot.data?.data?[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 6.h),
                                      child: Row(
                                        spacing: 10.w,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
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

                                // Space for the button
                                SizedBox(height: 80.h),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              );
            },
          ),

          // Sticky Start button at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: StreamBuilder<WorkoutWiseVideoResponseModel>(
                    stream: workoutVideoRxObj.workoutVideoRxStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data?.data == null) {
                        return const SizedBox.shrink();
                      }
                      return CustomButton(
                        onPressed: () {
                          NavigationService.navigateToWithArgs(
                            Routes.cacheVideoScreen,
                            {"id": widget.id},
                          );
                        },
                        text: "Start",
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
