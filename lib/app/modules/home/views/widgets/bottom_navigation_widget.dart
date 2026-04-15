import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showActivities;
  /// 是否使用透明背景（用于毛玻璃叠加场景）
  final bool transparent;
  /// 自定义选中色（不传则用 AppTheme.primaryColor）
  final Color? activeColor;
  /// 自定义未选中图标色
  final Color? inactiveIconColor;
  /// 自定义未选中文字色
  final Color? inactiveLabelColor;

  BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    bool? showActivities,
    this.transparent = false,
    this.activeColor,
    this.inactiveIconColor,
    this.inactiveLabelColor,
  }) : showActivities = showActivities ?? TenantService.to.activityEnabled;

  Color get _activeColor => activeColor ?? AppTheme.primaryColor;
  Color get _inactiveColor => inactiveIconColor ?? const Color(0xFFDDDDDD);
  Color get _inactiveLabelColor => inactiveLabelColor ?? const Color(0xFF999999);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: transparent
          ? null
          : BoxDecoration(
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
          _buildSvgNavItem(0, ImageAssets.home, I18nKeys.home.tr),
          _buildSvgNavItem(1, ImageAssets.promotion, I18nKeys.promotion.tr),
          _buildSvgNavItem(2, ImageAssets.tasks, I18nKeys.tasks.tr),
          if (showActivities)
            _buildIconNavItem(3, Icons.local_activity_rounded, I18nKeys.activities.tr),
          _buildSvgNavItem(showActivities ? 4 : 3, ImageAssets.service, I18nKeys.service.tr),
          _buildSvgNavItem(showActivities ? 5 : 4, ImageAssets.account, I18nKeys.account.tr),
        ],
      ),
    );
  }

  /// SVG 图标导航项
  Widget _buildSvgNavItem(int index, String imagePath, String label) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
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
                  isSelected ? _activeColor : _inactiveColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              _buildLabel(label, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  /// Material Icon 导航项（用于没有 SVG 资源的 tab）
  Widget _buildIconNavItem(int index, IconData iconData, String label) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 20,
                color: isSelected ? _activeColor : _inactiveColor,
              ),
              const SizedBox(height: 4),
              _buildLabel(label, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isSelected) {
    return Text(
      label,
      maxLines: 1,
      style: TextStyle(
        fontSize: 10,
        overflow: TextOverflow.ellipsis,
        color: isSelected ? _activeColor : _inactiveLabelColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
