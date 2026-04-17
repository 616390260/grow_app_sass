import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/services/tenant_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';

/// 闪屏页控制器 —— 循环加载租户配置，成功后播放品牌揭示动画再跳转
class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  /// 租户配置是否加载完成
  final isLoaded = false.obs;

  /// 退场淡出进度 0→1
  final exitProgress = 0.0.obs;

  /// 品牌揭示动画主控制器（1800ms 总时长）
  late final AnimationController revealCtrl;

  /// 退场淡出控制器
  late final AnimationController exitCtrl;

  // ── Logo 动画 ──

  /// Logo 缩放：0→60% 区间，easeOutBack 弹性
  late final Animation<double> logoScale;

  /// Logo 透明度：0→40%
  late final Animation<double> logoOpacity;

  /// Logo 发光边框透明度：20%→70%，先亮后暗
  late final Animation<double> logoBorderGlow;

  /// Logo 光泽扫过位置：30%→65%，-1.0 到 2.0
  late final Animation<double> logoShimmer;

  // ── 名称动画 ──

  /// 名称透明度：45%→75%
  late final Animation<double> nameOpacity;

  /// 名称位移：45%→75%
  late final Animation<Offset> nameSlide;

  /// 名称字间距：45%→80%，从 6.0 到 1.2
  late final Animation<double> nameLetterSpacing;

  // ── 装饰线 ──

  /// 装饰线宽度比例：60%→90%，0 到 1
  late final Animation<double> lineWidth;

  /// 装饰线透明度：60%→85%
  late final Animation<double> lineOpacity;

  // ── 背景 ──

  /// 背景色混合度：0→100%，0 到 1
  late final Animation<double> bgTint;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _loadUntilSuccess();
  }

  void _setupAnimations() {
    revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      exitProgress.value = exitCtrl.value;
    });

    // ── Logo ──
    logoScale = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));
    logoOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));
    logoBorderGlow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.6), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.15), weight: 50),
    ]).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
    ));
    logoShimmer = Tween(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.3, 0.65, curve: Curves.easeInOut),
    ));

    // ── 名称 ──
    nameOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    ));
    nameSlide = Tween(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
    ));
    nameLetterSpacing = Tween(begin: 6.0, end: 1.2).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
    ));

    // ── 装饰线 ──
    lineWidth = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
    ));
    lineOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
    ));

    // ── 背景 ──
    bgTint = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: revealCtrl,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));
  }

  /// 循环尝试加载租户配置，失败后间隔 3 秒自动重试
  Future<void> _loadUntilSuccess() async {
    while (true) {
      try {
        await TenantService.to.init().timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('[Splash] 租户配置加载失败: $e');
      }

      if (TenantService.to.hasTenant) break;

      debugPrint('[Splash] 未获取到租户信息，3 秒后重试...');
      await Future.delayed(const Duration(seconds: 3));
    }

    AppTheme.init(brandColor: TenantService.to.effectiveBrandColor);
    isLoaded.value = true;

    revealCtrl.forward();

    // 品牌揭示动画 1800ms + 停留 600ms
    await Future.delayed(const Duration(milliseconds: 2400));

    // 退场淡出
    await exitCtrl.forward().orCancel;

    final auth = Get.find<AuthService>();
    final target = auth.needLogin ? Routes.login : Routes.root;
    Get.offAllNamed(target);
  }

  @override
  void onClose() {
    revealCtrl.dispose();
    exitCtrl.dispose();
    super.onClose();
  }
}
