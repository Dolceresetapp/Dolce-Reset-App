import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

import '../../../common_widget/custom_text_field.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/dio/cache_interceptor.dart';
import '../../chef/data/model/ai_receipe_response_model.dart';
import '../data/rx_post_generate/api.dart';

class AiReceipeGeneratorScreen extends StatefulWidget {
  const AiReceipeGeneratorScreen({super.key});

  @override
  State<AiReceipeGeneratorScreen> createState() =>
      _AiReceipeGeneratorScreenState();
}

class _AiReceipeGeneratorScreenState extends State<AiReceipeGeneratorScreen> {
  final textController = TextEditingController();
  bool _isGenerating = false;
  String _progressMessage = "";
  Timer? _progressTimer;
  int _progressStep = 0;

  static const _progressMessages = [
    "Analisi degli ingredienti...",
    "Creazione della ricetta...",
    "Calcolo dei valori nutrizionali...",
    "Preparazione finale...",
  ];

  void _startProgressMessages() {
    _progressStep = 0;
    _progressMessage = _progressMessages[0];
    _progressTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _progressStep++;
      if (_progressStep < _progressMessages.length) {
        setState(() {
          _progressMessage = _progressMessages[_progressStep];
        });
      }
    });
  }

  void _stopProgressMessages() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

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
    _stopProgressMessages();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

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
        elevation: 0,

        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Generatore Ricette AI",
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
              "Quali ingredienti hai a disposizione?",
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
            //       color: const Color(0xFF52525B).withOpacity(0.6),
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
                    return "Inserisci la tua domanda";
                  }
                  return null;
                },
                hintText: "Hai domande sul cibo?",
                hintStyle: TextFontStyle.headline30c27272AtyleWorkSansW700
                    .copyWith(
                      color: const Color(0xFF52525B).withOpacity(0.6),
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
          onPressed: _isGenerating ? () {} : () => _generateRecipe(),
          child: _isGenerating
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _progressMessage,
                          key: ValueKey(_progressMessage),
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  spacing: 10.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Genera Ricette",
                      style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                    ),
                    SvgPicture.asset(Assets.icons.arrowRight),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _generateRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final prompt = textController.text.trim();

    setState(() {
      _isGenerating = true;
    });
    _startProgressMessages();

    try {
      log("========== Generating Recipe ==========");
      log("Prompt: $prompt");

      final response = await AiGenerateApi.instance.aiGenerateApi(prompt: prompt);

      log("Response received!");
      log("Success: ${response.success}");
      log("Response type: ${response.responseType}");
      log("Data length: ${response.data?.length}");

      _stopProgressMessages();

      if (mounted) {
        setState(() {
          _isGenerating = false;
        });

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

          // Invalidate recipes cache so ChefScreen fetches fresh data
          CacheInterceptor.invalidate('/nutration/recipes');

          log("========== NAVIGATING TO RECIPE DETAIL ==========");
          log("Recipe: ${recipe.meal}");

          // Navigate to recipe detail screen
          NavigationService.navigateToWithArgs(
            Routes.recipeDetailScreen,
            {"recipe": recipe},
          );
        } else {
          // Show error snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message ?? "Impossibile generare la ricetta"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      log("Error generating recipe: $e");
      _stopProgressMessages();
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errore: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
