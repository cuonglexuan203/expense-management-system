/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsEnvGen {
  const $AssetsEnvGen();

  /// File path: assets/env/.env.development
  String get aEnvDevelopment => 'assets/env/.env.development';

  /// File path: assets/env/.env.example
  String get aEnvExample => 'assets/env/.env.example';

  /// File path: assets/env/.env.production
  String get aEnvProduction => 'assets/env/.env.production';

  /// File path: assets/env/.env.staging
  String get aEnvStaging => 'assets/env/.env.staging';

  /// List of all assets
  List<String> get values =>
      [aEnvDevelopment, aEnvExample, aEnvProduction, aEnvStaging];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Nunito-Black.ttf
  String get nunitoBlack => 'assets/fonts/Nunito-Black.ttf';

  /// File path: assets/fonts/Nunito-BlackItalic.ttf
  String get nunitoBlackItalic => 'assets/fonts/Nunito-BlackItalic.ttf';

  /// File path: assets/fonts/Nunito-Bold.ttf
  String get nunitoBold => 'assets/fonts/Nunito-Bold.ttf';

  /// File path: assets/fonts/Nunito-BoldItalic.ttf
  String get nunitoBoldItalic => 'assets/fonts/Nunito-BoldItalic.ttf';

  /// File path: assets/fonts/Nunito-ExtraBold.ttf
  String get nunitoExtraBold => 'assets/fonts/Nunito-ExtraBold.ttf';

  /// File path: assets/fonts/Nunito-ExtraBoldItalic.ttf
  String get nunitoExtraBoldItalic => 'assets/fonts/Nunito-ExtraBoldItalic.ttf';

  /// File path: assets/fonts/Nunito-ExtraLight.ttf
  String get nunitoExtraLight => 'assets/fonts/Nunito-ExtraLight.ttf';

  /// File path: assets/fonts/Nunito-ExtraLightItalic.ttf
  String get nunitoExtraLightItalic =>
      'assets/fonts/Nunito-ExtraLightItalic.ttf';

  /// File path: assets/fonts/Nunito-Italic.ttf
  String get nunitoItalic => 'assets/fonts/Nunito-Italic.ttf';

  /// File path: assets/fonts/Nunito-Light.ttf
  String get nunitoLight => 'assets/fonts/Nunito-Light.ttf';

  /// File path: assets/fonts/Nunito-LightItalic.ttf
  String get nunitoLightItalic => 'assets/fonts/Nunito-LightItalic.ttf';

  /// File path: assets/fonts/Nunito-Medium.ttf
  String get nunitoMedium => 'assets/fonts/Nunito-Medium.ttf';

  /// File path: assets/fonts/Nunito-MediumItalic.ttf
  String get nunitoMediumItalic => 'assets/fonts/Nunito-MediumItalic.ttf';

  /// File path: assets/fonts/Nunito-Regular.ttf
  String get nunitoRegular => 'assets/fonts/Nunito-Regular.ttf';

  /// File path: assets/fonts/Nunito-SemiBold.ttf
  String get nunitoSemiBold => 'assets/fonts/Nunito-SemiBold.ttf';

  /// File path: assets/fonts/Nunito-SemiBoldItalic.ttf
  String get nunitoSemiBoldItalic => 'assets/fonts/Nunito-SemiBoldItalic.ttf';

  /// List of all assets
  List<String> get values => [
        nunitoBlack,
        nunitoBlackItalic,
        nunitoBold,
        nunitoBoldItalic,
        nunitoExtraBold,
        nunitoExtraBoldItalic,
        nunitoExtraLight,
        nunitoExtraLightItalic,
        nunitoItalic,
        nunitoLight,
        nunitoLightItalic,
        nunitoMedium,
        nunitoMediumItalic,
        nunitoRegular,
        nunitoSemiBold,
        nunitoSemiBoldItalic
      ];
}

class $AssetsLangGen {
  const $AssetsLangGen();

  /// File path: assets/lang/en.json
  String get en => 'assets/lang/en.json';

  /// List of all assets
  List<String> get values => [en];
}

class Assets {
  const Assets._();

  static const AssetGenImage appLogo = AssetGenImage('assets/app_logo.png');
  static const $AssetsEnvGen env = $AssetsEnvGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsLangGen lang = $AssetsLangGen();

  /// List of all assets
  static List<AssetGenImage> get values => [appLogo];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
