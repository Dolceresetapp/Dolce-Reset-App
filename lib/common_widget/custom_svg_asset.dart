import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSvgAsset extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? semanticsLabel;
  final Color? color;
  const CustomSvgAsset({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.fit,
    this.semanticsLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width ?? 60.w,
      height: height ?? 60.h,
      color: color,
      fit: fit ?? BoxFit.contain,
      semanticsLabel: semanticsLabel,
    );
  }
}
