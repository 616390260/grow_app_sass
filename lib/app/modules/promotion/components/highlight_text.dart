import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final Color highlightColor;
  final TextStyle? textStyle;
  final double highlightWidth;
  final double highlightHeight;
  final double highlightRadius;
  final double spacing;

  HighlightText({
    super.key,
    required this.text,
    Color? highlightColor,
    this.textStyle,
    this.highlightWidth = 3,
    this.highlightHeight = 13,
    this.highlightRadius = 3,
    this.spacing = 4,
  }) : highlightColor = highlightColor ?? AppTheme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: highlightWidth,
          height: highlightHeight,
          decoration: BoxDecoration(
            color: highlightColor,
            borderRadius: BorderRadius.circular(highlightRadius),
          ),
        ),
        SizedBox(width: spacing),
        Text(
          text,
          style: textStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
        ),
      ],
    );
  }
}