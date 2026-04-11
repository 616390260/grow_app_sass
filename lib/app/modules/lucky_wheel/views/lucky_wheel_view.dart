import 'dart:math';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/domain/entities/winning_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart'; // 正确导入路由配置文件
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
          alignment: Alignment.topCenter,
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
                    const SizedBox(height: 44),
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
            onTap: () {
              if (Get.key.currentState!.canPop()) { // 使用GetX推荐的方式检查
                Get.back();
              } else {
                // 刷新后 fallback 到首页
                Get.offAllNamed(Routes.root);
              }
            },
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
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
            I18nKeys.cash.tr,
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
            I18nKeys.luckyWheel.tr,
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
                color: Color(0xFFAD1616),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              '${I18nKeys.availablePoints.tr}${controller.userPoints} ${I18nKeys.points.tr} (${I18nKeys.spinCost.tr})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC27210),
              ),
            ),
          ),
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
                  color: Colors.black.withValues(alpha: 0.3),
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
              double rotationValue =
                  controller.rotationAnimation.value * 2 * pi;
              final wheelPainter = WheelPainter(controller.prizes);
              return Transform.rotate(
                angle: rotationValue,
                child: AnimatedBuilder(
                  animation: wheelPainter,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(260, 260),
                      painter: wheelPainter,
                    );
                  },
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
                  Obx(
                    () => GestureDetector(
                      // onTap: controller.canSpin() ? controller.startSpin : null,
                      onTap: controller.startSpin,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
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
                    ),
                  ),
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
              color: Colors.black.withValues(alpha: 0.2),
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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.rules.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF764308),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            I18nKeys.ruleOperationPrinciple.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF764308),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            I18nKeys.ruleSpinReward.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF764308),
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
      ..moveTo(size.width / 2, 0) // 顶部尖端
      ..lineTo(0, size.height) // 左下角
      ..lineTo(size.width, size.height) // 右下角
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

class WheelPainter extends CustomPainter with ChangeNotifier {
  final List<WinningRecord> prizes;
  final Map<String, ui.Image> _imageCache = {};

  WheelPainter(this.prizes);

  @override
  void dispose() {
    // 释放图片资源
    for (var image in _imageCache.values) {
      image.dispose();
    }
    _imageCache.clear();
    super.dispose();
  }

  // 加载网络图片
  Future<void> _loadImage(String url) async {
    if (_imageCache.containsKey(url) || url.isEmpty) return;

    final Completer<ui.Image> completer = Completer();

    final ImageStream stream = CachedNetworkImageProvider(
      url,
    ).resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (!completer.isCompleted) {
            _imageCache[url] = info.image;
            completer.complete();
          }
        },
        onError: (Object exception, StackTrace? stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(exception);
          }
        },
      ),
    );

    try {
      await completer.future;
      // 通知框架重新绘制
      notifyListeners();
    } catch (e) {
      // 图片加载失败，可以在这里处理错误
      print('Failed to load image: $e');
    }
  }

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

      // 绘制奖品图片和文字
      final textAngle = startAngle + sweepAngle / 2;
      final contentRadius = radius * 0.7;
      final contentX = center.dx + contentRadius * cos(textAngle);
      final contentY = center.dy + contentRadius * sin(textAngle);

      // 计算内容的旋转角度，使其底部朝向圆心
      double contentRotation = textAngle + pi / 2;

      // 绘制奖品图片（如果存在）
      if (prizes[i].imageUrl != null && prizes[i].imageUrl!.isNotEmpty) {
        // 尝试加载图片
        _loadImage(prizes[i].imageUrl!);

        // 如果图片已加载到缓存中，则绘制
        if (_imageCache.containsKey(prizes[i].imageUrl)) {
          // 保存当前画布状态
          canvas.save();
          // 将画布原点移动到内容位置
          canvas.translate(contentX, contentY);
          // 根据计算的角度旋转画布
          canvas.rotate(contentRotation);

          // 绘制图片（在文字上方）
          final image = _imageCache[prizes[i].imageUrl]!;
          final srcRect = Rect.fromLTWH(
            0,
            0,
            image.width.toDouble(),
            image.height.toDouble(),
          );
          final dstRect = Rect.fromLTWH(-20, -40, 40, 40);
          canvas.drawImageRect(image, srcRect, dstRect, Paint());

          // 恢复画布状态
          canvas.restore();
        }
      }

      // 绘制奖品文字
      // final colors = [
      //   const Color(0xFFFFD700), // 金色
      //   const Color(0xFFFF8C00), // 深橙色
      //   const Color(0xFFFFD700),
      //   const Color(0xFFFF8C00),
      //   const Color(0xFFFFD700),
      //   const Color(0xFFFF8C00),
      // ];

      final textPainter = TextPainter(
        text: TextSpan(
          text: prizes[i].prizeValue.toString(),
          style: TextStyle(
            color: const Color(0xFFFF8C00), // 使用%而不是~/确保正确循环使用颜色
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // 添加文字阴影增强可读性
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // 保存当前画布状态
      canvas.save();
      // 将画布原点移动到内容位置
      canvas.translate(contentX, contentY);
      // 根据计算的角度旋转画布
      canvas.rotate(contentRotation);
      // 绘制文字，调整位置使文字底部朝向圆心
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width / 2,
          prizes[i].imageUrl != null && prizes[i].imageUrl!.isNotEmpty ? 15 : 0,
        ),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
