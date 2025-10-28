import 'dart:math';
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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF4757),
            Color(0xFFFF6B7A),
            Color(0xFFFFB8A3),
          ],
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
                    _buildTitle(),
                    _buildPointsInfo(),
                    _buildWheelSection(),
                    _buildSpinButton(),
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
            I18nKeys.luckyWheelTitle.tr,
            style: const TextStyle(
              fontSize: 36,
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
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              I18nKeys.dailySpinChance.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                '${I18nKeys.availablePoints.tr}${controller.userPoints} ${I18nKeys.points.tr}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPointsInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Obx(() => Text(
            '${I18nKeys.points.tr}: ${controller.userPoints}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
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
              return Transform.rotate(
                angle: controller.rotationAnimation.value * 2 * pi,
                child: CustomPaint(
                  size: const Size(260, 260),
                  painter: WheelPainter(controller.prizes),
                ),
              );
            },
          ),
          // 中心按钮
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
                  child: Center(
                    child: controller.isSpinning
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'GO',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              )),
          // 指针
          Positioned(
            top: 10,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 15, color: Colors.transparent),
                  right: BorderSide(width: 15, color: Colors.transparent),
                  bottom: BorderSide(width: 25, color: Color(0xFFFF6B35)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8E53), Color(0xFFFF6B35)],
          ),
          borderRadius: BorderRadius.circular(25),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRules() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.rules.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            I18nKeys.ruleOperationPrinciple.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            I18nKeys.ruleSpinReward.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
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

      // 绘制奖品文字
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

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
      textPainter.paint(
        canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
      );
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