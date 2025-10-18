import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class GreatJobScreen extends StatelessWidget {
  const GreatJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.images.frame.path,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),

              UIHelper.verticalSpace(24.h),
              Center(
                child: Text(
                  "Great Job!",
                 // style: TextFontSt
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  "You have successfully completed the task.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
