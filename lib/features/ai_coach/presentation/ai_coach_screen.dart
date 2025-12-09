import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/navigation_service.dart';
import '../data/model/coach_response_model.dart';
import '../widgets/receiver_coach_widget.dart';
import '../widgets/sender_coach_widget.dart' show SenderCoachWidget;

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    motivationCoachRxObj.motivationCoachRx(prompt: "Hello");
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
            child: StreamBuilder<CoachResponseModel>(
              stream: motivationCoachRxObj.motivationCoachRxStream,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return WaitingWidget();
                } else if (asyncSnapshot.hasData) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: 10.h,
                      children: [
                        SenderCoachWidget(
                          title: asyncSnapshot.data?.prompt ?? "",
                        ),

                        ReceiverCoachWidget(
                          message: asyncSnapshot.data?.message ?? "",
                        ),
                      ],
                    ),
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
                          await motivationCoachRxObj
                              .motivationCoachRx(
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
