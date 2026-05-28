import 'package:flutter/material.dart';
import 'app_theme.dart';

/// 可复用的文本样式类
class TextStyles {
  TextStyles._();

  /// 12号字体，threeColor颜色，fontWeight为w500的文本样式
  static TextStyle smallThreeColorW500 = const TextStyle(
    fontSize: 12,
    color: AppTheme.threeColor,
    fontWeight: FontWeight.w500,
  );

  /// 14号字体，灰色，fontWeight为w500的文本样式
  static TextStyle normalGreyW500 = TextStyle(
    fontSize: 14,
    color: Colors.grey.shade700,
    fontWeight: FontWeight.w500,
  );

  /// 14号字体，灰色，fontWeight为normal的文本样式
  static TextStyle normalGrey = TextStyle(
    fontSize: 14,
    color: Colors.grey.shade700,
  );

  /// 16号字体，fontWeight为w600的文本样式
  static TextStyle largeW600 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// 14号字体，threeColor颜色，fontWeight为w800的文本样式
  static TextStyle normalThreeColorW800 = const TextStyle(
    fontSize: 14,
    color: AppTheme.threeColor,
    fontWeight: FontWeight.w800,
  );
}