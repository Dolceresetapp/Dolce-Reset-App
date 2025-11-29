// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gritti_app/helpers/navigation_service.dart';
// import 'package:linear_progress_bar/linear_progress_bar.dart';

// import '../constants/text_font_style.dart';
// import '../gen/assets.gen.dart';
// import 'custom_svg_asset.dart';

// class VideosBarWidget extends StatelessWidget {
//   final int currentStep;
//   final int maxSteps;

//   const VideosBarWidget({
//     super.key,
//     required this.currentStep,
//     required this.maxSteps,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       spacing: 20.w,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: () {
//             NavigationService.goBack;
//           },
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: CustomSvgAsset(
//               width: 20.w,
//               height: 20.h,
//               color: Color(0xFF27272A),
//               fit: BoxFit.contain,
//               assetName: Assets.icons.icon,
//             ),
//           ),
//         ),

//         Expanded(
//           child: LinearProgressBar(
//             minHeight: 10.h,
//             maxSteps: maxSteps,
//             progressType: LinearProgressBar.progressTypeLinear,
//             currentStep: currentStep,
//             progressColor: Color(0xFFF566A9),
//             backgroundColor: Color(0xFFE4E4E7),
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//         ),

//         Text(
//           "Step $currentStep / $maxSteps",
//           style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
//             fontSize: 16.sp,
//             color: Color(0xFFF566A9),
//           ),
//         ),
//       ],
//     );
//   }
// }
