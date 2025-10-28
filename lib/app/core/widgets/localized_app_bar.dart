import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? titleTextStyle;

  const LocalizedAppBar({
    Key? key,
    required this.titleKey,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      leading: leading,
      title: Text(
        titleKey.tr,
        style: titleTextStyle,
      ),
      actions: actions,
    );
  }
}