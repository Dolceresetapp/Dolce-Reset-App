import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/ai_recipe_generator_chat/widgets/receiver_widget.dart';
import 'package:gritti_app/features/ai_recipe_generator_chat/widgets/sender_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/navigation_service.dart';

class AiReceipeGeneratorChatScreen extends StatefulWidget {
  const AiReceipeGeneratorChatScreen({super.key});

  @override
  State<AiReceipeGeneratorChatScreen> createState() =>
      _AiReceipeGeneratorChatScreenState();
}

class _AiReceipeGeneratorChatScreenState
    extends State<AiReceipeGeneratorChatScreen> {
  final inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            NavigationService.goBack;
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
        centerTitle: false,
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
            Spacer(),
            SvgPicture.asset(Assets.icons.frame5, width: 20.w, height: 20),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              physics: const BouncingScrollPhysics(),
              itemCount: 2,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return SenderWidget(
                    title:
                        "I have chicken, arugula, orange, lemon, olive oil, salt, pepper, ham, cottage cheese.",
                  );
                } else {
                  return const ReceiverWidget();
                }
              },
            ),
          ),

          // 🟣 Fixed bottom input field
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    Assets.icons.icRoundPlus,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),

                UIHelper.horizontalSpace(10.w),

                // Input field (takes remaining space)
                Expanded(
                  child: CustomTextField(
                    controller: inputController,
                    hintStyle: TextFontStyle.text14c3B3F4BPoppinsW500.copyWith(
                      color: const Color(0xFFCCCCCC),
                      fontSize: 14.sp,

                      fontWeight: FontWeight.w400,
                    ),
                    hintText: "Type ingredients you have...",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                ),

                UIHelper.horizontalSpace(10.w),

                // Send button
                GestureDetector(
                  onTap: () {
                    // handle send
                    debugPrint("Message sent: ${inputController.text}");
                    inputController.clear();
                  },
                  child: CustomButton(
                    onPressed: () {},
                    minWidth: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),

                    borderRadius: 12.r,

                    child: Text(
                      "Send",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                          .copyWith(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 16.sp,

                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          UIHelper.verticalSpaceSmall,
        ],
      ),
    );
  }
}
