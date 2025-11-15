
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../common_widget/custom_button.dart';
import '../../widgets/onetime_onbaord_widget.dart';

class OnboardScreen1 extends StatefulWidget {
  const OnboardScreen1({super.key});

  @override
  State<OnboardScreen1> createState() => _OnboardScreen1State();
}

class _OnboardScreen1State extends State<OnboardScreen1> {
  List<Map<String, dynamic>> dataList = [
    {
      "image": Assets.images.on1.path,
      "title": "Mangiare male peggiora \nla tua salute",
      "subtitle":
          "Cibi sbagliati indeboliscono il tuo corpo, accrescendo il rischio di malattie e rubandoti energia e salute, a 20 come a 50 anni.",
    },
    {
      "image": Assets.images.on2.path,
      "title": "Essere fuori forma , fa sentire invisibile",
      "subtitle":
          "La scarsa forma fisica mina la tua sicurezza, facendoti sentire meno notata, meno vista e desiderata.",
    },

    {
      "image": Assets.images.on3.path,
      "title": "Trascurare il corpo accelera l'invecchiamento",
      "subtitle":
          "Senza cura, rughe e stanchezza prendono il sopravvento, rubandoti un aspetto giovane e fresco .",
    },

    {
      "image": Assets.images.on4.path,
      "title": "DOLCE RESET è qui per te!",
      "subtitle":
          "Con Cibo Sano su Misura , Movimento Settimanale e Supporto Potrai Vedere i Risultati in Modo Piu’ Veloce e Facile grazie ad un metodo scientifico testato ",
    },

    {
      "image": Assets.images.on5.path,
      "title": "DOLCE RESET è qui per te!",
      "subtitle":
          "Con Cibo Sano su Misura , Movimento Settimanale e Supporto Potrai Vedere i Risultati in Modo Piu’ Veloce e Facile grazie ad un metodo scientifico testato ",
    },
  ];

  PageController pageController = PageController();

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (currentIndex < dataList.length - 1) {
      pageController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      appData.write(kKeyIsFirstTime, false);
      NavigationService.navigateToReplacement(Routes.signUpScreen);
    }
  }

  void goToPreviousPage() {
    if (currentIndex > 0) {
      pageController.animateToPage(
        currentIndex - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEF3E41),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              currentIndex > 0
                  ? Align(
                    alignment: Alignment.topLeft,
                    child: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        goToPreviousPage();
                      },
                    ),
                  )
                  : SizedBox.shrink(),
              currentIndex > 0
                  ? UIHelper.verticalSpace(0.h)
                  : UIHelper.verticalSpace(42.h),
              Text(
                'DOLCE\nRESET',
                textAlign: TextAlign.center,
                style: TextFontStyle.headLine16c2F1E19StyleBarlowCondensedW700,
              ),

              UIHelper.verticalSpace(80.h),
              SizedBox(
                height: 300.h,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dataList.length,
                  itemBuilder: (_, index) {
                    var data = dataList[index];

                    return OnetimeOnbaordWidget(
                      data: data,
                      index: currentIndex,
                      dataList: dataList,
                    );
                  },
                ),
              ),

              UIHelper.verticalSpace(30.h),

              // Smooth Page Indicator
              AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: dataList.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  activeDotColor: Color(0xFF7C2709),
                  dotColor: Color(0xFFDFE1E1),
                ),
              ),
              UIHelper.verticalSpace(50.h),
              CustomButton(
                onPressed: () {
                  goToNextPage();
                },
                text:
                    currentIndex == dataList.length - 1
                        ? 'Get Started'
                        : 'Next',
                //  text: "Next",
                color: Color(0xff777EFF),
                borderRadius: 50.r,
                minWidth: 190.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
