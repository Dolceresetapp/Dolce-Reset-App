import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../gen/assets.gen.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final String? errorImage;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.errorImage,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? 80.w,
      height: height ?? 60.h,
      fit: fit ?? BoxFit.cover,
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: width ?? 80.w,
              height: height ?? 60.h,
              decoration: BoxDecoration(color: Colors.white),
            ),
          ),
      errorWidget:
          (context, url, error) => Image.asset(
            errorImage ?? Assets.images.noImageAvailable.path,
            width: width ?? 80.w,
            height: height ?? 60.h,
            fit: fit ?? BoxFit.cover,
          ),
    );
  }
}