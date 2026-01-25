import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      // Performance: Use simple placeholder instead of animated Shimmer
      placeholder: (context, url) => _ImagePlaceholder(
        width: width ?? 80.w,
        height: height ?? 60.h,
      ),
      errorWidget: (context, url, error) => Image.asset(
        errorImage ?? Assets.images.noImageAvailable.path,
        width: width ?? 80.w,
        height: height ?? 60.h,
        fit: fit ?? BoxFit.cover,
      ),
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
    );
  }
}

// Lightweight placeholder with subtle pulse animation
class _ImagePlaceholder extends StatefulWidget {
  final double width;
  final double height;

  const _ImagePlaceholder({
    required this.width,
    required this.height,
  });

  @override
  State<_ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<_ImagePlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey.withOpacity(_animation.value),
        );
      },
    );
  }
}
