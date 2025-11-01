import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VipBadge extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color badgeColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double fontSize;
  final double height;
  final double borderRadius;
  final double iconSize;

  const VipBadge({
    Key? key,
    required this.text,
     this.imagePath=ImageAssets.vipCrown,
    this.badgeColor = AppTheme.vipOrange,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.fontSize = 12,
    this.height = 20,
    this.borderRadius = 10,
    this.iconSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, top: 1),
          height: height,
          padding: const EdgeInsets.only(
            left: 19,
            right: 9,
          ),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
        Container(
          width: 22,
          height: 22,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: badgeColor,
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: SvgPicture.asset(
            imagePath,
            width: iconSize,
            height: iconSize - 1,
            color: backgroundColor,
          ),
        ),
      ],
    );
  }
}