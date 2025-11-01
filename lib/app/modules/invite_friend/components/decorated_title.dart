import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DecoratedTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final Color underlineColor;
  final double underlineWidth;
  final double underlineHeight;
  final double underlineBorderRadius;
  final double underlineTopPosition;

  const DecoratedTitle({
    Key? key,
    required this.title,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: AppTheme.threeColor,
      fontWeight: FontWeight.w800,
    ),
    this.underlineColor = const Color(0xFFDDE8FF),
    this.underlineWidth = 57,
    this.underlineHeight = 11,
    this.underlineBorderRadius = 5,
    this.underlineTopPosition = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: underlineTopPosition,
          left: 0,
          child: Container(
            width: underlineWidth,
            height: underlineHeight,
            decoration: BoxDecoration(
              color: underlineColor,
              borderRadius: BorderRadius.circular(underlineBorderRadius),
            ),
          ),
        ),
        Text(title, style: textStyle),
      ],
    );
  }
}
