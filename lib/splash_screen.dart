import 'package:flutter/material.dart';
import 'package:gritti_app/constants/text_font_style.dart';



final class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF566A9),
      body: Center(
        child: Text(
          'DOLCE\nRESET',
          textAlign: TextAlign.center,
          style: TextFontStyle.headLine102cF8F3EFBarlowCondensedW700
        ),
      ),
    );
  }
}
