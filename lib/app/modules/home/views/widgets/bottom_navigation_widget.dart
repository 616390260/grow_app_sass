import 'package:flutter/material.dart';
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
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(0, Icons.home, I18nKeys.home.tr),
          _buildNavItem(1, Icons.trending_up, I18nKeys.promotion.tr),
          _buildNavItem(2, Icons.assignment, I18nKeys.tasks.tr),
          _buildNavItem(3, Icons.psychology, I18nKeys.smart.tr),
          _buildNavItem(4, Icons.person, I18nKeys.account.tr),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
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
              Icon(
                icon,
                size: 24,
                color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF95A5A6),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF95A5A6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}