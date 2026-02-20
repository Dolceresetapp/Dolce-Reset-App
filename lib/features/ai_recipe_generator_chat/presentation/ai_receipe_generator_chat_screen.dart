import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/waiting_widget.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../ai_recipe_generator/data/rx_post_generate/api.dart';
import '../../chef/data/model/ai_receipe_response_model.dart';

class AiReceipeGeneratorChatScreen extends StatefulWidget {
  const AiReceipeGeneratorChatScreen({super.key});

  @override
  State<AiReceipeGeneratorChatScreen> createState() =>
      _AiReceipeGeneratorChatScreenState();
}

class _AiReceipeGeneratorChatScreenState
    extends State<AiReceipeGeneratorChatScreen> {
  final inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isGenerating = false;
  String? _error;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> _generateRecipe() async {
    final prompt = inputController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      log("========== Generating Recipe ==========");
      log("Prompt: $prompt");

      // Call API
      final response = await AiGenerateApi.instance.aiGenerateApi(prompt: prompt);

      log("Response received!");
      log("Success: ${response.success}");
      log("Response type: ${response.responseType}");
      log("Data length: ${response.data?.length}");

      if (mounted) {
        setState(() {
          _isGenerating = false;
        });

        // Navigate to recipe detail if we have data
        if (response.success == true &&
            response.responseType == "json" &&
            response.data != null &&
            response.data!.isNotEmpty) {
          final recipeData = response.data!.first;

          // Convert to AiReceipeResponseData
          final recipe = AiReceipeResponseData(
            meal: recipeData.meal,
            description: recipeData.description,
            proteinG: recipeData.proteinG,
            timeMin: recipeData.timeMin,
            calories: recipeData.calories,
            imageUrl: recipeData.imageUrl,
            ingredients: recipeData.ingredients,
            steps: recipeData.steps,
          );

          // Navigate to recipe detail screen
          log("========== NAVIGATING TO RECIPE DETAIL ==========");
          log("Recipe meal: ${recipe.meal}");
          log("Recipe imageUrl: ${recipe.imageUrl}");

          NavigationService.navigateToWithArgs(
            Routes.recipeDetailScreen,
            {"recipe": recipe},
          );
        } else {
          // Show error for text response or failed response
          setState(() {
            _error = response.message ?? "Impossibile generare la ricetta";
          });
        }
      }
    } catch (e) {
      log("Error generating recipe: $e");
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            NavigationService.navigateToReplacementWithObject(
              Routes.navigationScreen,
              {"index": 1}, // Chef screen
            );
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
        title: Text(
          "Generatore Ricette AI",
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildContent(),
          ),

          // Fixed bottom input field
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                UIHelper.horizontalSpace(10.w),

                // Input field
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
                      hintText: "Scrivi gli ingredienti che hai...",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obbligatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                UIHelper.horizontalSpace(10.w),

                // Send button
                CustomButton(
                  onPressed: _isGenerating ? () {} : () {
                    if (_formKey.currentState!.validate()) {
                      _generateRecipe();
                    }
                  },
                  minWidth: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  borderRadius: 12.r,
                  child: Text(
                    "Invia",
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

  Widget _buildContent() {
    // Loading state
    if (_isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WaitingWidget(),
            UIHelper.verticalSpace(16.h),
            Text(
              "Generazione ricetta in corso...",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              "Potrebbe richiedere fino a 60 secondi",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF9CA3AF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: const Color(0xFFF566A9),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                "Si è verificato un errore",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF52525B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                _error!,
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state (initial)
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64.sp,
              color: const Color(0xFFE5E5E5),
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              "Scrivi gli ingredienti che hai",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF52525B),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              "L'IA genererà una ricetta personalizzata per te",
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF9CA3AF),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
