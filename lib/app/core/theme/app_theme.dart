import 'package:flutter/material.dart';

/// 应用主题配置
///
/// 调用 [AppTheme.init] 后，主色系列会根据 brandColor 自动生成。
/// 未调用 init 或未传 brandColor 时，使用默认绿色。
class AppTheme {
  AppTheme._();

  // ── 默认绿色（Emerald 系列） ──────────
  static const Color _defaultPrimary = Color(0xFF059669);

  // ── 主题主色（运行时可被 brandColor 覆盖） ──────────
  static Color primaryColor         = _defaultPrimary;
  static Color primaryDark          = const Color(0xFF047857);
  static Color primaryGradientMid   = const Color(0xFF10B981);
  static Color primaryGradientMid2  = const Color(0xFF34D399);
  static Color primaryGradientLight = const Color(0xFF6EE7B7);
  static Color primaryLight         = const Color(0xFFA7F3D0);
  static Color primaryBorder        = const Color(0xFFD1FAE5);
  static Color primarySurface       = const Color(0xFFECFDF5);
  static Color primaryLightest      = const Color(0xFFF0FDF4);
  static Color primaryGradientEnd   = const Color(0xFFF9F9F9);

  /// 极深色变体，用于深色横幅背景
  static Color primaryDarkest       = const Color(0xFF022C22);
  static Color primaryDarker        = const Color(0xFF064E3B);
  static Color primaryDarkMid       = const Color(0xFF065F46);

  /// 根据 brandColor 生成完整色阶
  static void init({Color? brandColor}) {
    if (brandColor == null) return;
    final hsl = HSLColor.fromColor(brandColor);

    primaryColor         = brandColor;
    primaryDark          = hsl.withLightness((hsl.lightness - 0.06).clamp(0.0, 1.0)).toColor();
    primaryGradientMid   = hsl.withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0)).toColor();
    primaryGradientMid2  = hsl.withLightness((hsl.lightness + 0.16).clamp(0.0, 1.0)).toColor();
    primaryGradientLight = hsl.withLightness((hsl.lightness + 0.28).clamp(0.0, 1.0)).toColor();
    primaryLight         = hsl.withLightness(0.82).withSaturation(0.60).toColor();
    primaryBorder        = hsl.withLightness(0.90).withSaturation(0.50).toColor();
    primarySurface       = hsl.withLightness(0.95).withSaturation(0.40).toColor();
    primaryLightest      = hsl.withLightness(0.97).withSaturation(0.35).toColor();
    primaryGradientEnd   = const Color(0xFFF9F9F9);

    primaryDarkest       = hsl.withLightness(0.09).toColor();
    primaryDarker        = hsl.withLightness(0.16).toColor();
    primaryDarkMid       = hsl.withLightness(0.20).toColor();

    // 同步兼容别名
    primaryColorDark = primaryDark;
    loginColor       = primaryColor;
  }

  // ── 兼容旧引用 ──────────
  static Color primaryColorDark = const Color(0xFF047857);
  static const Color accentColor      = Color(0xFF03DAC6);
  static const Color threeColor       = Color(0xFF333333);
  static const Color sixColor         = Color(0xFF666666);
  static const Color lineColor        = Color(0xFFF4F5F9);
  static Color loginColor             = _defaultPrimary;
  static const Color nineColor        = Color(0xFF999999);
  static const Color bgColor          = Color(0xFFF4F5F9);
  static const Color dddColor         = Color(0xFFDDDDDD);
  static const Color eeeColor         = Color(0xFFEEEEEE);
  static const Color signYellowColor  = Color(0xFFECC475);
  static const Color vipOrange        = Color(0xFFF7B257);
  static Color f9f9f9Color            = primaryGradientEnd;
  static const Color e3e3e3Color      = Color(0xFFE3E3E3);
  static const Color ff6a6aColor      = Color(0xFFFF6A6A);

  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }

  // 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }
}
