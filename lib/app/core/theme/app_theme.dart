import 'package:flutter/material.dart';

/// 应用主题配置
///
/// ╔══════════════════════════════════════════════╗
/// ║  只需修改下方「主题主色配置」区域即可全局换色  ║
/// ╚══════════════════════════════════════════════╝
class AppTheme {
  AppTheme._();

  // ── 主题主色配置（改这里即可全局生效）──────────
  /// 主色：AppBar、按钮、高亮等  Emerald 600
  static const Color primaryColor         = Color(0xFF059669);
  /// 深色主色：悬停/按下态          Emerald 700
  static const Color primaryDark          = Color(0xFF047857);
  /// 渐变中间色（背景渐变第二段）    Emerald 500
  static const Color primaryGradientMid   = Color(0xFF10B981);
  /// 渐变中间色2（偏亮色）           Emerald 400
  static const Color primaryGradientMid2  = Color(0xFF34D399);
  /// 浅绿渐变色（功能卡片深端）      Emerald 300
  static const Color primaryGradientLight = Color(0xFF6EE7B7);
  /// 更浅绿渐变色（功能卡片浅端）    Emerald 200
  static const Color primaryLight         = Color(0xFFA7F3D0);
  /// 绿色边框 / 下载按钮背景          Emerald 100
  static const Color primaryBorder        = Color(0xFFD1FAE5);
  /// 卡片底色（统计卡、任务区容器）   Emerald 50
  static const Color primarySurface       = Color(0xFFECFDF5);
  /// 极淡绿（页面渐变底色、条目底色） Emerald 50 lighter
  static const Color primaryLightest      = Color(0xFFF0FDF4);
  /// 渐变结束色（过渡到近白背景）
  static const Color primaryGradientEnd   = Color(0xFFF9F9F9);
  // ───────────────────────────────────────────────

  /// 兼容旧引用
  static const Color primaryColorDark = primaryDark;
  static const Color accentColor      = Color(0xFF03DAC6);
  static const Color threeColor       = Color(0xFF333333);
  static const Color sixColor         = Color(0xFF666666);
  static const Color lineColor        = Color(0xFFF4F5F9);
  /// 兼容旧引用，等价于 primaryColor
  static const Color loginColor       = primaryColor;
  static const Color nineColor        = Color(0xFF999999);
  static const Color bgColor          = Color(0xFFF4F5F9);
  static const Color dddColor         = Color(0xFFDDDDDD);
  static const Color eeeColor         = Color(0xFFEEEEEE);
  static const Color signYellowColor  = Color(0xFFECC475);
  static const Color vipOrange        = Color(0xFFF7B257);
  static const Color f9f9f9Color      = primaryGradientEnd;
  static const Color e3e3e3Color      = Color(0xFFE3E3E3);
  static const Color ff6a6aColor      = Color(0xFFFF6A6A);

  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'sans-serif', // 使用通用字体族，避免依赖特定字体文件
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
        scrolledUnderElevation: 0, // 设置为0以消除深色模式下的黑线
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
