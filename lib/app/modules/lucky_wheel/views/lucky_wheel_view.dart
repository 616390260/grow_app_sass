import 'dart:math';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/lucky_wheel_controller.dart';

class LuckyWheelView extends BaseView<LuckyWheelController> {
  const LuckyWheelView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.wheelBg),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildWheelSection(),
                    const SizedBox(height: 10),
                    _buildSpinButton(),
                    const SizedBox(height: 33),
                    _buildRules(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text(
            '现金',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          Text(
            '大转盘',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE9CC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              I18nKeys.dailySpinChance.tr,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFAD1616),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
                '${I18nKeys.availablePoints.tr}${controller.userPoints} ${I18nKeys.points.tr}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFC27210),
                ),
              )),
        ],
      ),
    );
  }


  Widget _buildWheelSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 转盘背景装饰
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // 转盘主体
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              // 优化旋转逻辑，确保停在分区中间
              double rotationValue = controller.rotationAnimation.value * 2 * pi;
              return Transform.rotate(
                angle: rotationValue,
                child: CustomPaint(
                  size: const Size(260, 260),
                  painter: WheelPainter(controller.prizes),
                ),
              );
            },
          ),
          // 中心按钮和指针一体化设计 - 确保指针完整显示
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 指针部分 - 向上指向（位于圆圈正上方）
              // 使用Stack布局使指针和按钮完全连接在一起，并允许溢出显示
              Stack(
                clipBehavior: Clip.none, // 允许子组件超出边界显示
                alignment: Alignment.center,
                children: [
                  // 指针定位在圆圈正上方
                  Positioned(
                    top: -15, // 30(指针高度) / 2 = 15
                    child: CustomPaint(
                      size: const Size(40, 30),
                      painter: TrianglePointerPainter(),
                    ),
                  ),
                  // 中心圆圈按钮（去除白色加载指示器，使用自定义加载效果）
                  Obx(() => GestureDetector(
                    onTap: controller.canSpin() ? controller.startSpin : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: controller.isSpinning
                          ? const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'GO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpinButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
      child: Container(
        width: double.infinity,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF99726),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            I18nKeys.pointsCashable.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRules() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.rules.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF764308),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            I18nKeys.ruleOperationPrinciple.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF764308),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            I18nKeys.ruleSpinReward.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF764308),
            ),
          ),
        ],
      ),
    );
  }
}

/// 三角形指针绘制器
class TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 创建向上的三角形路径
    final path = Path()
      ..moveTo(size.width / 2, 0)  // 顶部尖端
      ..lineTo(0, size.height)     // 左下角
      ..lineTo(size.width, size.height)  // 右下角
      ..close();

    // 使用与圆圈相同的渐变色
    final gradient = const LinearGradient(
      colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WheelPainter extends CustomPainter {
  final List<Prize> prizes;

  WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sectionAngle = 2 * pi / prizes.length;

    // 绘制转盘扇形
    for (int i = 0; i < prizes.length; i++) {
      final startAngle = i * sectionAngle - pi / 2;
      final sweepAngle = sectionAngle;

      // 扇形背景
      final paint = Paint()
        ..color = i % 2 == 0 ? Colors.white : const Color(0xFFFFF5F5)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // 扇形边框
      final borderPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // 绘制奖品文字，使其根据分区角度旋转，统一对着圆心
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      // 计算文字的旋转角度，使其朝向圆心
      // 将角度转换为度数并调整方向
      double textRotation = textAngle + pi / 2; // 垂直于半径方向
      // 确保文字始终正面朝向，调整角度使文字不会倒置
      if (textRotation > pi / 2 && textRotation < 3 * pi / 2) {
        textRotation += pi; // 翻转180度
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i].value.toString(),
          style: TextStyle(
            color: prizes[i].color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      
      // 保存当前画布状态
      canvas.save();
      // 将画布原点移动到文字位置
      canvas.translate(textX, textY);
      // 根据计算的角度旋转画布
      canvas.rotate(textRotation);
      // 绘制文字（相对于新的原点）
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      // 恢复画布状态
      canvas.restore();
    }

    // 绘制外圈装饰
    final outerPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, outerPaint);

    // 绘制装饰点
    for (int i = 0; i < 12; i++) {
      final angle = i * (2 * pi / 12);
      final dotX = center.dx + (radius + 8) * cos(angle);
      final dotY = center.dy + (radius + 8) * sin(angle);

      final dotPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}