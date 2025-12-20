import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

class InfoWidget extends StatelessWidget {
  final String description;
  const InfoWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      width: 1.sw,
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  NavigationService.goBack;
                },
                icon: Icon(Icons.cancel, size: 30.sp, color: Color(0xFFF566A9)),
              ),
            ),
            Html(
              data: description,
            ), 
          ],
        ),
      ),
    );
  }
}
