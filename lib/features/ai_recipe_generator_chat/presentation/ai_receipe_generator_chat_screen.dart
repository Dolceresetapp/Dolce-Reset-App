import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/features/ai_recipe_generator_chat/widgets/sender_widget.dart';
import 'package:gritti_app/features/ai_recipe_generator_chat/widgets/text_receiver_widget.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/navigation_service.dart';
import '../../ai_recipe_generator/data/model/ai_generate_response_model.dart';
import '../widgets/image_receiver_widget.dart';

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

  final _formKey = GlobalKey<FormState>();
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
            child: StreamBuilder<AiGenerateResponseModel>(
              stream: aiGenerateRxStreamObj.aiGenerateRxStream,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return WaitingWidget();
                } else if (asyncSnapshot.data?.responseType == "text") {
                  log(
                    "Response text 1 =============================>     ${asyncSnapshot.data?.responseType == "text"}",
                  );
                  //text
                  final message = asyncSnapshot.data?.message ?? "No message";
                  final prompt = asyncSnapshot.data?.prompt ?? "";
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: 16.h,
                      children: [
                        SenderWidget(title: prompt), // user message
                        TextReceiverWidget(message: message), // AI response
                      ],
                    ),
                  );
                } else if (asyncSnapshot.data?.responseType == "json") {
                  log(
                    "Response json 2  =========================>     ${asyncSnapshot.data?.responseType == "json"}",
                  );

                  // image
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: asyncSnapshot.data?.data?.length,
                    itemBuilder: (_, index) {
                      log(
                        "index ====================================== $index",
                      );
                      var data = asyncSnapshot.data?.data?[index];

                      // Convert to List
                      final ingredientsData =
                          data?.ingredients
                              ?.map((e) => e.toString())
                              .toList() ??
                          [];
                      final stepsData =
                          data?.steps?.map((e) => e.toString()).toList() ?? [];

                      final prompt = asyncSnapshot.data?.prompt ?? "";

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          spacing: 16.h,
                          children: [
                            SenderWidget(title: prompt), // user message
                            ImageReceiverWidget(
                              ingredientsData: ingredientsData,
                              stepData: stepsData,
                              image: data?.imageUrl ?? "",

                              title: data?.description ?? "",

                              kcal: '${data?.calories.toString()} kcal',
                              protine: '${data?.proteinG.toString()} g',
                              time: '${data?.timeMin.toString()} min',
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
          ),

          // Fixed bottom input field
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                UIHelper.horizontalSpace(10.w),

                // Input field (takes remaining space)
                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    child: CustomTextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: inputController,
                      hintStyle: TextFontStyle.text14c3B3F4BPoppinsW500
                          .copyWith(
                            color: const Color(0xFFCCCCCC),
                            fontSize: 14.sp,

                            fontWeight: FontWeight.w400,
                          ),
                      hintText: "Type ingredients you have...",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required filled";
                        }

                        return null;
                      },
                    ),
                  ),
                ),

                UIHelper.horizontalSpace(10.w),

                // Send button
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isSuccess =
                          await aiGenerateRxStreamObj
                              .aiGenerateRx(
                                prompt: inputController.text.toString(),
                              )
                              .waitingForFuture();

                      if (isSuccess) {
                        inputController.clear();
                      }
                    }
                  },
                  minWidth: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),

                  borderRadius: 12.r,

                  child: Text(
                    "Send",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 16.sp,

                      fontWeight: FontWeight.w600,
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
