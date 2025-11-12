import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(0, ImageAssets.home, I18nKeys.home.tr),
          _buildNavItem(1, ImageAssets.promotion, I18nKeys.promotion.tr),
          _buildNavItem(2, ImageAssets.tasks, I18nKeys.tasks.tr),
          _buildNavItem(3, ImageAssets.service, I18nKeys.service.tr),
          _buildNavItem(4, ImageAssets.account, I18nKeys.account.tr),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String imagePath, String label) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(index);
          // 在主页面中仅切换索引，不做路由跳转
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isSelected ? const Color(0xFF427AF2) : const Color(0xFFDDDDDD),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? const Color(0xFF427AF2)
                      : const Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
