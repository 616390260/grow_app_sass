import 'package:flutter/material.dart';

/// 响应式设计工具类
class Responsive {
  /// 最大宽度限制，确保在大屏幕上也显示手机样式
  static const double maxContentWidth = 480.0;
  
  /// 获取屏幕宽度（受限）
  static double getWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > maxContentWidth ? maxContentWidth : screenWidth;
  }
  
  /// 获取屏幕高度
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  /// 构建响应式容器，限制最大宽度
  static Widget responsiveContainer(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: maxContentWidth,
        ),
        child: child,
      ),
    );
  }
  
  /// 判断是否为小屏幕
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 375;
  }
  
  /// 根据屏幕宽度缩放尺寸
  static double scaleByScreenWidth(BuildContext context, double baseSize) {
    final width = getWidth(context);
    return baseSize * (width / 375.0); // 以375为基准宽度进行缩放
  }
}

/// 响应式布局组件
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  
  const ResponsiveLayout({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Responsive.responsiveContainer(
         MediaQuery(
          // 强制设置设备像素比，确保UI元素在web上也保持手机大小的视觉效果
          data: MediaQuery.of(context).copyWith(
            // 如果需要，可以在这里调整其他MediaQuery参数
          ),
          child: child,
        ),
      ),
    );
  }
}
