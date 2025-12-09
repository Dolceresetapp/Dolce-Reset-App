import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';

class AiReceipeGeneratorScreen extends StatefulWidget {
  const AiReceipeGeneratorScreen({super.key});

  @override
  State<AiReceipeGeneratorScreen> createState() =>
      _AiReceipeGeneratorScreenState();
}

class _AiReceipeGeneratorScreenState extends State<AiReceipeGeneratorScreen> {
  final textController = TextEditingController();

  List<Map<String, dynamic>> dataList = [
    {
      "icon": Assets.icons.breadToast,
      "text": "Gluten",
      "cross_icon": Assets.icons.closeX,
    },
    {
      "icon": Assets.icons.wheat,
      "text": "Wheat",
      "cross_icon": Assets.icons.closeX,
    },
    {
      "icon": Assets.icons.lactose,
      "text": "Lactose",
      "cross_icon": Assets.icons.closeX,
    },
    {
      "icon": Assets.icons.waterGlass,
      "text": "Milk",
      "cross_icon": Assets.icons.closeX,
    },
    {
      "icon": Assets.icons.eggWhole,
      "text": "Egg",
      "cross_icon": Assets.icons.closeX,
    },
    {
      "icon": Assets.icons.fish,
      "text": "Shellfish",
      "cross_icon": Assets.icons.closeX,
    },
  ];

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            NavigationService.navigateToReplacement(Routes.navigationScreen);
          },
          child: Padding(
            padding: EdgeInsets.all(14.sp),
            child: SvgPicture.asset(
              Assets.icons.icon,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ),
        elevation: 0,

        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ai Receipe Generator",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 16.sp,

                fontWeight: FontWeight.w600,
              ),
            ),

            SvgPicture.asset(Assets.icons.ques, width: 20.w, height: 20),
          ],
        ),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            UIHelper.verticalSpace(60.h),

            Text(
              "What ingredients do you have right now?",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF27272A),
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            UIHelper.verticalSpace(30.h),

            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(16.sp),
            //   clipBehavior: Clip.antiAlias,
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       side: BorderSide(width: 1.w, color: const Color(0xFFD4D4D8)),
            //       borderRadius: BorderRadius.circular(20.r),
            //     ),
            //   ),

            //   child: Text(
            //     "Enter ingredients...",
            //     textAlign: TextAlign.center,
            //     style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
            //       color: const Color(0xFF52525B).withValues(alpha: 0.6),
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),

            // UIHelper.verticalSpace(10.h),

            // GridView.builder(
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 8.w,
            //     childAspectRatio: 118 / 32,
            //     mainAxisSpacing: 8.h,
            //   ),
            //   itemCount: dataList.length,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemBuilder: (_, index) {
            //     var data = dataList[index];
            //     return InkWell(
            //       onTap: () async {
            //         bool isSuccess =
            //             await aiGenerateRxStreamObj
            //                 .aiGenerateRx(prompt: data["text"])
            //                 .waitingForFuture();

            //         if (isSuccess) {
            //           NavigationService.navigateTo(
            //             Routes.aiReceipeGeneratorChatScreen,
            //           );
            //         }
            //       },
            //       child: Container(
            //         padding: EdgeInsets.symmetric(
            //           horizontal: 12.w,
            //           vertical: 6.h,
            //         ),
            //         clipBehavior: Clip.antiAlias,
            //         decoration: ShapeDecoration(
            //           shape: RoundedRectangleBorder(
            //             side: BorderSide(width: 1.w, color: Color(0xFFD4D4D8)),
            //             borderRadius: BorderRadius.circular(12.r),
            //           ),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           spacing: 8.w,
            //           children: [
            //             SvgPicture.asset(
            //               data["icon"],
            //               width: 16.w,
            //               height: 16,
            //               fit: BoxFit.contain,
            //             ),

            //             Text(
            //               data["text"],
            //               textAlign: TextAlign.center,
            //               style: TextFontStyle.headLine16cFFFFFFWorkSansW600
            //                   .copyWith(
            //                     color: const Color(0xFF52525B),
            //                     fontSize: 14.sp,

            //                     fontWeight: FontWeight.w500,
            //                   ),
            //             ),

            //             InkWell(
            //               onTap: () {
            //                 setState(() {
            //                   dataList.removeAt(index);
            //                 });
            //               },
            //               child: SvgPicture.asset(
            //                 data["cross_icon"],
            //                 width: 16.w,
            //                 height: 16,
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),

            // dataList.isEmpty
            //     ? SizedBox(height: 10.h)
            //     : UIHelper.verticalSpace(30.h),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: CustomTextField(
                controller: textController,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please type your question??";
                  }
                  return null;
                },
                hintText: "Do you have any question about food?",
                hintStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFF52525B).withValues(alpha: 0.6),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w100,
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              bool isSuccess =
                  await aiGenerateRxStreamObj
                      .aiGenerateRx(prompt: textController.text.toString())
                      .waitingForFuture();

              if (isSuccess) {
                NavigationService.navigateTo(
                  Routes.aiReceipeGeneratorChatScreen,
                );
              }
            }
          },
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Generate Recipes",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
              ),
              SvgPicture.asset(Assets.icons.arrowRight),
            ],
          ),
        ),
      ),
    );
  }
}
