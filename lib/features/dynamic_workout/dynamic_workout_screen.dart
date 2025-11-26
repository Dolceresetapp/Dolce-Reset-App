import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../networks/api_acess.dart';
import 'data/model/dynamic_workout_response_model.dart';

class DynamicWorkoutScreen extends StatefulWidget {
  final String type;
  final int? id;
  final String? levelType;

  const DynamicWorkoutScreen({
    super.key,
    required this.type,
    this.id,
    this.levelType,
  });

  @override
  State<DynamicWorkoutScreen> createState() => _DynamicWorkoutScreenState();
}

class _DynamicWorkoutScreenState extends State<DynamicWorkoutScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.type == "body_part_exercise" && widget.id != null) {
      dynamicWorkoutRxObj.dynamicWorkoutRx(
        type: "body_part_exercise",
        id: widget.id,
      );
    } else if (widget.type == "theme_workout" && widget.id != null) {
      dynamicWorkoutRxObj.dynamicWorkoutRx(
        type: "theme_workout",
        id: widget.id,
      );
    } else if (widget.type == "training_level" && widget.levelType != null) {
      dynamicWorkoutRxObj.dynamicWorkoutRx(
        type: "training_level",
        levelType: widget.levelType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // StreamBuilder for dynamic content
          StreamBuilder<DynamicWorkoutResponseModel>(
            stream: dynamicWorkoutRxObj.dynamicWorkoutRxStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WaitingWidget();
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
              } else {
                // Data available
                DynamicWorkoutResponseModel model = snapshot.data!;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Cover Image & Title Stack
                      Stack(
                        children: [
                          CustomCachedNetworkImage(
                            imageUrl: model.coverImage ?? "",
                            width: 1.sw,
                            height: 250.h,
                            fit: BoxFit.cover,
                          ),

                          // Title
                          Positioned(
                            left: 20.w,
                            bottom: 30.h,
                            child: SafeArea(
                              child: Text(
                                model.categoryName ?? "",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(
                                      fontSize: 30.sp,
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ),

                          // Total Workouts
                          Positioned(
                            left: 20.w,
                            bottom: 10.h,
                            child: SafeArea(
                              child: Text(
                                "${model.totalWorkouts ?? 0} Workouts",
                                style: TextFontStyle
                                    .headLine16cFFFFFFWorkSansW600
                                    .copyWith(color: const Color(0xFF999798)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      UIHelper.verticalSpace(20.h),

                      // Workout List
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView.separated(
                          itemCount: model.data!.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (_, _) => Divider(
                                color: const Color(0xFFF1F1F1),
                                thickness: 2,
                              ),
                          itemBuilder: (_, index) {
                            final data = model.data![index];
                            return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Workout Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: CustomCachedNetworkImage(
                                        imageUrl: data.image ?? "",
                                        width: 120.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    UIHelper.horizontalSpace(20.w),

                                    // Workout Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            spacing: 10.w,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  data.title ?? "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextFontStyle
                                                      .headLine16cFFFFFFWorkSansW600
                                                      .copyWith(
                                                        color: const Color(
                                                          0xFF27272A,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),

                                              // arrow
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    Icons.chevron_right,
                                                    size: 24.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              Text(
                                                "${data.minutes} min",
                                                style: TextFontStyle
                                                    .headLine16cFFFFFFWorkSansW600
                                                    .copyWith(
                                                      color: const Color(
                                                        0xFF27272A,
                                                      ),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "${data.calories} kcal",
                                                style: TextFontStyle
                                                    .headLine16cFFFFFFWorkSansW600
                                                    .copyWith(
                                                      color: const Color(
                                                        0xFFF566A9,
                                                      ),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          // Always show Back button on top
          Positioned(
            left: 16.w,
            top: 40.h,
            child: BackButton(
              color: Colors.black,
              onPressed: () {
                dynamicWorkoutRxObj.clean();
                NavigationService.goBack;
              },
            ),
          ),
        ],
      ),
    );
  }
}



// up code gpt and below code from me

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gritti_app/common_widget/custom_network_image.dart';
// import 'package:gritti_app/common_widget/waiting_widget.dart';
// import 'package:gritti_app/constants/text_font_style.dart';
// import 'package:gritti_app/helpers/navigation_service.dart';
// import 'package:gritti_app/helpers/ui_helpers.dart';

// import '../../networks/api_acess.dart';
// import 'data/model/dynamic_workout_response_model.dart';

// class DynamicWorkoutScreen extends StatefulWidget {
//   final String type;
//   int? id;
//   String? levelType;
//   DynamicWorkoutScreen({
//     super.key,
//     required this.type,
//     this.id,
//     this.levelType,
//   });

//   @override
//   State<DynamicWorkoutScreen> createState() => _DynamicWorkoutScreenState();
// }

// class _DynamicWorkoutScreenState extends State<DynamicWorkoutScreen> {
//   @override
//   void initState() {
//     super.initState();

//     if (widget.type == "body_part_exercise" && widget.id != null) {
//       dynamicWorkoutRxObj.dynamicWorkoutRx(
//         type: "body_part_exercise",
//         id: widget.id,
//       );
//     } else if (widget.type == "theme_workout" && widget.id != null) {
//       dynamicWorkoutRxObj.dynamicWorkoutRx(
//         type: "theme_workout",
//         id: widget.id,
//       );
//     } else if (widget.type == "training_level" && widget.levelType != null) {
//       dynamicWorkoutRxObj.dynamicWorkoutRx(
//         type: "training_level",
//         levelType: widget.levelType,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: StreamBuilder<DynamicWorkoutResponseModel>(
//           stream: dynamicWorkoutRxObj.dynamicWorkoutRxStream,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return WaitingWidget();
//             } else if (snapshot.hasError) {
//               return Text(
//                 "someting went wrong",
//                 style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
//                   color: const Color(0xFFF97316),
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w800,
//                 ),
//               );
//             } else if (snapshot.data == null ||
//                 snapshot.data!.data == null ||
//                 snapshot.data!.data!.isEmpty) {
//               return Center(
//                 child: Text(
//                   "Data \n not availabe",
//                   style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
//                     color: const Color(0xFFF97316),
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               );
//             } else if (snapshot.hasData) {
//               DynamicWorkoutResponseModel? model = snapshot.data;
//               return Column(
//                 children: [
//                   // Dynamic Image
//                   Stack(
//                     children: [
//                       // Dynamic Image
//                       CustomCachedNetworkImage(
//                         imageUrl: model?.coverImage ?? "",
//                         width: 1.sw,
//                         height: 250.h,
//                         fit: BoxFit.cover,
//                       ),

//                       // back Button
//                       Positioned(
//                         child: SafeArea(
//                           child: BackButton(
//                             color: Colors.black,
//                             onPressed: () {
//                               dynamicWorkoutRxObj.clean();
//                               NavigationService.goBack;
//                             },
//                           ),
//                         ),
//                       ),

//                       // Title
//                       Positioned(
//                         left: 20.w,
//                         bottom: 30.h,
//                         child: SafeArea(
//                           child: Text(
//                             model?.categoryName ?? "",
//                             style: TextFontStyle.headLine16cFFFFFFWorkSansW600
//                                 .copyWith(color: Colors.white, fontSize: 30.sp),
//                           ),
//                         ),
//                       ),

//                       // Title
//                       Positioned(
//                         left: 20.w,
//                         bottom: 10.h,
//                         child: SafeArea(
//                           child: Text(
//                             model?.totalWorkouts.toString() ?? "",
//                             style: TextFontStyle.headLine16cFFFFFFWorkSansW600
//                                 .copyWith(color: Color(0xFF999798)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   UIHelper.verticalSpace(20.h),

//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: ListView.separated(
//                       itemCount: model!.data!.length,
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       physics: NeverScrollableScrollPhysics(),

//                       separatorBuilder: (context, index) {
//                         return Divider(color: Color(0xFFF1F1F1), thickness: 2);
//                       },

//                       itemBuilder: (_, index) {
//                         var data = model.data![index];
//                         return InkWell(
//                           onTap: () {},
//                           child: Padding(
//                             padding: EdgeInsetsGeometry.symmetric(
//                               vertical: 10.h,
//                             ),

//                             child: Row(
//                               spacing: 10.w,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 // Image
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   child: CustomCachedNetworkImage(
//                                     imageUrl: data.image ?? "",
//                                     width: 120.w,
//                                     height: 70.h,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),

//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   spacing: 10.h,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       data.title ?? "",
//                                       style: TextFontStyle
//                                           .headLine16cFFFFFFWorkSansW600
//                                           .copyWith(
//                                             color: const Color(0xFF27272A),

//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                     ),

//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       spacing: 10.w,
//                                       children: [
//                                         Text(
//                                           "${data.minutes} min",
//                                           style: TextFontStyle
//                                               .headLine16cFFFFFFWorkSansW600
//                                               .copyWith(
//                                                 color: const Color(0xFF27272A),
//                                                 fontSize: 13.sp,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                         ),
//                                         Text(
//                                           "${data.calories} kcal",
//                                           style: TextFontStyle
//                                               .headLine16cFFFFFFWorkSansW600
//                                               .copyWith(
//                                                 color: const Color(0xFFF566A9),
//                                                 fontSize: 13.sp,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return SizedBox();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


