import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/environment_config.dart';
import '../../../core/services/tenant_service.dart';
import '../controllers/splash_controller.dart';

/// 金融级闪屏页
///
/// 加载阶段：深色渐变背景 + 旋转金色弧光 + 浮动粒子 — 高端金融质感
/// 品牌揭示：暗转亮过渡 + Logo 弹出 + 品牌色发光 + 名称滑入
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  static const _navyDark = Color(0xFF0A0F1E);
  static const _navyMid = Color(0xFF0F172A);
  static const _gold = Color(0xFFCA8A04);
  static const _goldLight = Color(0xFFE8B94A);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loaded = controller.isLoaded.value;
      final exitVal = controller.exitProgress.value;
      final brandColor =
          TenantService.to.effectiveBrandColor ?? const Color(0xFF059669);

      return AnimatedBuilder(
        animation: controller.revealCtrl,
        builder: (context, _) {
          final revealProgress = loaded ? controller.bgTint.value : 0.0;

          return Opacity(
            opacity: (1.0 - exitVal).clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 1.0 + exitVal * 0.05,
              child: Scaffold(
                backgroundColor: _navyDark,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    _AnimatedBackground(
                      revealProgress: revealProgress,
                      brandColor: brandColor,
                    ),

                    _GoldLoadingAnimation(visible: !loaded),

                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _BrandLogo(
                            controller: controller,
                            brandColor: brandColor,
                          ),
                          const SizedBox(height: 24),
                          _BrandName(
                            controller: controller,
                            revealProgress: revealProgress,
                          ),
                          const SizedBox(height: 16),
                          _AccentLine(
                            controller: controller,
                            brandColor: brandColor,
                            revealProgress: revealProgress,
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: MediaQuery.of(context).padding.bottom + 48,
                      child: _BottomStatus(
                        loaded: loaded,
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

/// 背景渐变 — 深色 → 品牌色浅底
class _AnimatedBackground extends StatelessWidget {
  final double revealProgress;
  final Color brandColor;
  const _AnimatedBackground({
    required this.revealProgress,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    final darkGradient = [
      SplashView._navyDark,
      SplashView._navyMid,
      const Color(0xFF162033),
    ];
    final lightGradient = [
      Colors.white,
      brandColor.withValues(alpha: 0.04),
      Colors.white,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(darkGradient[0], lightGradient[0], revealProgress)!,
            Color.lerp(darkGradient[1], lightGradient[1], revealProgress)!,
            Color.lerp(darkGradient[2], lightGradient[2], revealProgress)!,
          ],
        ),
      ),
    );
  }
}

/// 金色加载动画 — 旋转弧光 + 脉冲核心 + 浮动粒子
class _GoldLoadingAnimation extends StatefulWidget {
  final bool visible;
  const _GoldLoadingAnimation({required this.visible});

  @override
  State<_GoldLoadingAnimation> createState() => _GoldLoadingAnimationState();
}

class _GoldLoadingAnimationState extends State<_GoldLoadingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _spinCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 浮动金色粒子
              ...List.generate(6, (i) => _buildParticle(i)),
              // 旋转弧光
              _buildSpinningArc(),
              // 脉冲核心
              _buildPulseCore(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpinningArc() {
    return AnimatedBuilder(
      animation: _spinCtrl,
      builder: (context, _) {
        return Transform.rotate(
          angle: _spinCtrl.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(100, 100),
            painter: _ArcPainter(
              color: SplashView._gold,
              glowColor: SplashView._goldLight,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulseCore() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final scale = 0.8 + _pulseCtrl.value * 0.4;
        final glowAlpha = 0.15 + _pulseCtrl.value * 0.2;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SplashView._goldLight,
              boxShadow: [
                BoxShadow(
                  color: SplashView._gold.withValues(alpha: glowAlpha),
                  blurRadius: 24,
                  spreadRadius: 6,
                ),
                BoxShadow(
                  color: SplashView._goldLight.withValues(alpha: glowAlpha * 0.6),
                  blurRadius: 40,
                  spreadRadius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticle(int index) {
    final baseAngle = (index / 6) * 2 * math.pi;
    final radius = 55.0 + (index % 3) * 15;
    final size = 2.0 + (index % 3) * 1.5;

    return AnimatedBuilder(
      animation: _particleCtrl,
      builder: (context, _) {
        final angle = baseAngle + _particleCtrl.value * 2 * math.pi * 0.3;
        final wobble = math.sin(_particleCtrl.value * math.pi * 2 + index) * 8;
        final x = math.cos(angle) * (radius + wobble);
        final y = math.sin(angle) * (radius + wobble);
        final alpha = 0.2 + math.sin(_particleCtrl.value * math.pi * 2 + index * 1.5).abs() * 0.6;

        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SplashView._goldLight.withValues(alpha: alpha),
              boxShadow: [
                BoxShadow(
                  color: SplashView._gold.withValues(alpha: alpha * 0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 旋转弧光绘制
class _ArcPainter extends CustomPainter {
  final Color color;
  final Color glowColor;
  _ArcPainter({required this.color, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 外层辉光
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        colors: [
          glowColor.withValues(alpha: 0.0),
          glowColor.withValues(alpha: 0.4),
          glowColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.15, 0.3],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 0.6,
      false,
      glowPaint,
    );

    // 主弧线
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.15, 0.3],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 0.6,
      false,
      arcPaint,
    );

    // 第二条弧线（对面）
    final arc2Paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.6),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.5, 0.65, 0.8],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.75));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.75),
      math.pi,
      math.pi * 0.4,
      false,
      arc2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Logo 区域
class _BrandLogo extends StatelessWidget {
  final SplashController controller;
  final Color brandColor;
  const _BrandLogo({required this.controller, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = TenantService.to.brandInfo.value;

      return AnimatedBuilder(
        animation: controller.revealCtrl,
        builder: (context, child) {
          final opacity = controller.logoOpacity.value;
          final scale = controller.logoScale.value;
          final glowAlpha = controller.logoBorderGlow.value;

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: brandColor.withValues(alpha: glowAlpha * 0.6),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: _buildImage(),
      );
    });
  }

  Widget _buildImage() {
    // 与 H5 完全一致：有租户配置下发的 brand_logo 就用网络图，
    // 未就绪 / 加载失败时显示灰色占位（不再回落到打包内置的本地 logo）。
    final url = TenantService.to.brandLogo;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(width: 96, height: 96, color: const Color(0xFFF0F0F0));
  }
}

/// 品牌名称
class _BrandName extends StatelessWidget {
  final SplashController controller;
  final double revealProgress;
  const _BrandName({
    required this.controller,
    required this.revealProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = TenantService.to.brandInfo.value;
      final name = _getName();

      return AnimatedBuilder(
        animation: controller.revealCtrl,
        builder: (context, _) {
          final opacity = controller.nameOpacity.value;
          final slide = controller.nameSlide.value;
          final spacing = controller.nameLetterSpacing.value;

          if (name.isEmpty) return const SizedBox(height: 28);

          return FractionalTranslation(
            translation: slide,
            child: Opacity(
              opacity: opacity,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: spacing,
                  height: 1.2,
                  shadows: const [
                    Shadow(
                      color: Color(0x80000000),
                      blurRadius: 12,
                    ),
                    Shadow(
                      color: Color(0x40000000),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  String _getName() {
    if (!kIsWeb) {
      final c = EnvironmentConfig.compileAppName;
      if (c.isNotEmpty) return c;
    }
    final a = TenantService.to.appName;
    if (a.isNotEmpty && a != 'Taskgo') return a;
    return '';
  }
}

/// 装饰线
class _AccentLine extends StatelessWidget {
  final SplashController controller;
  final Color brandColor;
  final double revealProgress;
  const _AccentLine({
    required this.controller,
    required this.brandColor,
    required this.revealProgress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.revealCtrl,
      builder: (context, _) {
        final w = controller.lineWidth.value;
        final o = controller.lineOpacity.value;

        final lineColor = Color.lerp(
          SplashView._gold,
          brandColor,
          revealProgress,
        )!;

        return Opacity(
          opacity: o,
          child: Container(
            width: 60 * w,
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                colors: [
                  lineColor.withValues(alpha: 0.0),
                  lineColor.withValues(alpha: 0.6),
                  lineColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 底部状态：加载中显示 Loading，失败时显示错误文案 + 重试按钮
class _BottomStatus extends StatelessWidget {
  final bool loaded;
  final SplashController controller;
  const _BottomStatus({required this.loaded, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final failed = controller.loadFailed.value;
      final msg = controller.failureMessage.value;

      return AnimatedOpacity(
        opacity: loaded ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 400),
        child: Center(
          child: failed
              ? _buildFailure(msg)
              : const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildFailure(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '无法连接服务器',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFE5E7EB),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            msg,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: controller.retryLoad,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: SplashView._gold.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: const Text(
                '重试',
                style: TextStyle(
                  fontSize: 12,
                  color: SplashView._goldLight,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
