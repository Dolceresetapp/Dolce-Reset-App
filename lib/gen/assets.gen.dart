// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Or.svg
  String get or => 'assets/icons/Or.svg';

  /// File path: assets/icons/Vector (1).svg
  String get vector1 => 'assets/icons/Vector (1).svg';

  /// File path: assets/icons/Vector (2).svg
  String get vector2 => 'assets/icons/Vector (2).svg';

  /// File path: assets/icons/Vector (3).svg
  String get vector3 => 'assets/icons/Vector (3).svg';

  /// File path: assets/icons/Vector (4).svg
  String get vector4 => 'assets/icons/Vector (4).svg';

  /// File path: assets/icons/eye_off.svg
  String get eyeOff => 'assets/icons/eye_off.svg';

  /// File path: assets/icons/eye_on.svg
  String get eyeOn => 'assets/icons/eye_on.svg';

  /// List of all assets
  List<String> get values => [
    or,
    vector1,
    vector2,
    vector3,
    vector4,
    eyeOff,
    eyeOn,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Frame (10).png
  AssetGenImage get frame10 =>
      const AssetGenImage('assets/images/Frame (10).png');

  /// File path: assets/images/Frame (11).png
  AssetGenImage get frame11 =>
      const AssetGenImage('assets/images/Frame (11).png');

  /// File path: assets/images/Rectangle.png
  AssetGenImage get rectangle =>
      const AssetGenImage('assets/images/Rectangle.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/no_image_available.png
  AssetGenImage get noImageAvailable =>
      const AssetGenImage('assets/images/no_image_available.png');

  /// File path: assets/images/womens_bg.png
  AssetGenImage get womensBg =>
      const AssetGenImage('assets/images/womens_bg.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    frame10,
    frame11,
    rectangle,
    logo,
    noImageAvailable,
    womensBg,
  ];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/Wede_Animation.json
  String get wedeAnimation => 'assets/lottie/Wede_Animation.json';

  /// File path: assets/lottie/hamburger.json
  String get hamburger => 'assets/lottie/hamburger.json';

  /// File path: assets/lottie/image_shimmer.json
  String get imageShimmer => 'assets/lottie/image_shimmer.json';

  /// File path: assets/lottie/loading.json
  String get loading => 'assets/lottie/loading.json';

  /// File path: assets/lottie/remove_from_cart.json
  String get removeFromCart => 'assets/lottie/remove_from_cart.json';

  /// File path: assets/lottie/success.json
  String get success => 'assets/lottie/success.json';

  /// List of all assets
  List<String> get values => [
    wedeAnimation,
    hamburger,
    imageShimmer,
    loading,
    removeFromCart,
    success,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
