import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInCalendarWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SignInCalendarWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 宽度由父布局均分控制
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFDFD5), Color(0xFFFFF6F3)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'sign_in_calendar'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.threeColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 42,
              height: 36,
              margin: const EdgeInsets.only(right: 12),

              child: Image.asset(ImageAssets.homeSign, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
