// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gritti_app/common_widget/custom_network_image.dart';
// import 'package:gritti_app/common_widget/waiting_widget.dart';
// import 'package:gritti_app/features/video/data/model/theme_wise_video_response_model.dart';
// import 'package:gritti_app/helpers/navigation_service.dart';
// import 'package:gritti_app/helpers/ui_helpers.dart';
// import 'package:video_player/video_player.dart';

// import '../../common_widget/custom_svg_asset.dart';
// import '../../constants/text_font_style.dart';
// import '../../gen/assets.gen.dart';
// import '../../networks/api_acess.dart';

// class VideoScreen extends StatefulWidget {
//   final int themeId;
//   const VideoScreen({super.key, required this.themeId});

//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _controller;

//   bool isVideoLoading = false; //  Track video loading
//   String? firstVideoUrl;

//   @override
//   void initState() {
//     super.initState();
//     themeWiseVideoRxObj.themeWiseVideoRx(themeId: widget.themeId);
//   }

//   // Play New Video Function
//   Future<void> _playNewVideo(String url) async {
//     if (url.isEmpty) return;

//     setState(() {
//       isVideoLoading = true; // Show loading
//     });

//     try {
//       await _controller.pause();
//       _controller.dispose();
//     } catch (_) {}

//     _controller = VideoPlayerController.networkUrl(Uri.parse(url));

//     await _controller.initialize();
//     setState(() {
//       isVideoLoading = false; // Hide loading
//     });
//     _controller.play();
//   }

//   @override
//   void dispose() {
//     try {
//       _controller.dispose();
//     } catch (_) {}
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<ThemeWiseVideoResponseModel>(
//         stream: themeWiseVideoRxObj.themeWiseVideoRxStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: WaitingWidget());
//           }

//           final model = snapshot.data!;
//           final videoList = model.data ?? [];

//           if (videoList.isEmpty) {
//             return Center(
//               child: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Back Button
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: InkWell(
//                           onTap: () => NavigationService.goBack,
//                           child: CustomSvgAsset(
//                             width: 20.w,
//                             height: 20.h,
//                             color: Color(0xFF27272A),
//                             fit: BoxFit.contain,
//                             assetName: Assets.icons.icon,
//                           ),
//                         ),
//                       ),

//                       UIHelper.verticalSpace(0.4.sh),

//                       // Center message
//                       Center(
//                         child: Text(
//                           "No video available",
//                           style: TextFontStyle.headLine16cFFFFFFWorkSansW600
//                               .copyWith(
//                                 color: Colors.orange,
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.w700,
//                               ),

//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }

//           // Default first video load
//           if (firstVideoUrl == null) {
//             firstVideoUrl = videoList.first.video ?? "";
//             _controller = VideoPlayerController.networkUrl(
//                 Uri.parse(firstVideoUrl!),
//               )
//               ..initialize().then((_) {
//                 setState(() {});
//                 _controller.play();
//               });
//           }

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // =================== VIDEO PLAYER ===================
//                 Stack(
//                   children: [
//                     Container(
//                       height: 250.h,
//                       width: double.infinity,
//                       color: Colors.black,

//                       child:
//                           isVideoLoading
//                               ? Center(child: WaitingWidget()) // Show loader
//                               : _controller.value.isInitialized
//                               ? AspectRatio(
//                                 aspectRatio: _controller.value.aspectRatio,
//                                 child: VideoPlayer(_controller),
//                               )
//                               : Center(child: WaitingWidget()),
//                     ),

//                     // Back Button
//                     Positioned(
//                       left: 20.w,
//                       child: SafeArea(
//                         child: InkWell(
//                           onTap: () {
//                             NavigationService.goBack;
//                           },
//                           child: CustomSvgAsset(
//                             width: 20.w,
//                             height: 20.h,
//                             color: Color(0xFFFFFFFF),
//                             fit: BoxFit.contain,
//                             assetName: Assets.icons.icon,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Play/Pause Button
//                     if (!isVideoLoading && _controller.value.isInitialized)
//                       Positioned.fill(
//                         child: Center(
//                           child: IconButton(
//                             iconSize: 40.sp,
//                             icon: Icon(
//                               _controller.value.isPlaying
//                                   ? Icons.pause
//                                   : Icons.play_arrow,
//                               color: Colors.white,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _controller.value.isPlaying
//                                     ? _controller.pause()
//                                     : _controller.play();
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),

//                 // =================== VIDEO LIST ===================
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 20.h,
//                   ),
//                   child: ListView.separated(
//                     itemCount: videoList.length,
//                     shrinkWrap: true,
//                     padding: EdgeInsets.zero,
//                     physics: NeverScrollableScrollPhysics(),
//                     separatorBuilder: (_, _) => Divider(),
//                     itemBuilder: (_, index) {
//                       final data = videoList[index];
//                       return InkWell(
//                         onTap: () {
//                           _playNewVideo(data.video ?? "");
//                         },
//                         child: Row(
//                           spacing: 10.w,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             // Image
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10.r),
//                               child: CustomCachedNetworkImage(
//                                 imageUrl: data.image ?? "",
//                                 width: 120.w,
//                                 height: 70.h,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),

//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               spacing: 10.h,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   data.title ?? "",
//                                   style: TextFontStyle
//                                       .headLine16cFFFFFFWorkSansW600
//                                       .copyWith(
//                                         color: const Color(0xFF27272A),

//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                 ),

//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   spacing: 10.w,
//                                   children: [
//                                     Text(
//                                       "${data.minutes} min",
//                                       style: TextFontStyle
//                                           .headLine16cFFFFFFWorkSansW600
//                                           .copyWith(
//                                             color: const Color(0xFF27272A),
//                                             fontSize: 13.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                     ),
//                                     Text(
//                                       "${data.calories} kcal",
//                                       style: TextFontStyle
//                                           .headLine16cFFFFFFWorkSansW600
//                                           .copyWith(
//                                             color: const Color(0xFFF566A9),
//                                             fontSize: 13.sp,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 UIHelper.verticalSpaceSemiLarge,
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
