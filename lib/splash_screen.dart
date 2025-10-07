import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gen/assets.gen.dart';
import 'gen/colors.gen.dart';

final class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c051F42,
      body: Center(
        child: Container(
          width: 250.w,
          height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.images.splashBg.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
