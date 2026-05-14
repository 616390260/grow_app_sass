import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/services/tenant_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';

/// 闪屏页控制器 —— 循环加载租户配置，成功后播放品牌揭示动画再跳转
class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  /// 最大自动重试次数（达到上限后停下来等待用户手动触发）
  static const int _maxRetry = 5;

  /// 单次请求超时
  static const Duration _requestTimeout = Duration(seconds: 8);

  /// 租户配置是否加载完成
  final isLoaded = false.obs;

  /// 加载失败状态（用于 UI 展示重试按钮 / 错误提示）
  final loadFailed = false.obs;

  /// 失败提示文本
  final failureMessage = ''.obs;

  /// 退场淡出进度 0→1
  final exitProgress = 0.0.obs;

  /// 是否已经在加载中，避免并发触发
  bool _loading = false;

  /// 是否已经成功加载过（单例复用时避免再走一次成功流程）
  bool _hasSucceeded = false;

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
    // permanent 单例：onInit 只会触发一次，启动期统一拉取一次
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

  /// 有限次重试加载租户配置：
  /// - 单次请求 8s 超时；
  /// - 指数退避 1s/2s/4s/8s/8s，最多 [_maxRetry] 次；
  /// - 全部失败后置 [loadFailed] = true，停止循环，等用户点重试；
  /// - 全程仅在「首次失败」与「最终失败」时打印日志，避免刷屏。
  Future<void> _loadUntilSuccess() async {
    if (_loading || _hasSucceeded) return;
    _loading = true;
    loadFailed.value = false;
    failureMessage.value = '';

    Object? lastError;
    var firstErrorLogged = false;

    for (var attempt = 0; attempt < _maxRetry; attempt++) {
      try {
        await TenantService.to.init().timeout(_requestTimeout);
      } catch (e) {
        lastError = e;
        if (!firstErrorLogged) {
          debugPrint('[Splash] 加载失败，将自动重试($_maxRetry 次): $e');
          firstErrorLogged = true;
        }
      }

      if (TenantService.to.hasTenant) {
        _loading = false;
        _hasSucceeded = true;
        await _onLoadSuccess();
        return;
      }

      if (attempt == _maxRetry - 1) break;
      final waitMs = 1000 * (1 << attempt).clamp(1, 8);
      await Future.delayed(Duration(milliseconds: waitMs));
    }

    _loading = false;
    failureMessage.value = lastError?.toString() ?? '租户信息获取失败';
    loadFailed.value = true;
    debugPrint('[Splash] 自动重试均失败，等待用户手动触发');
  }

  /// 加载成功后的动画与路由跳转
  Future<void> _onLoadSuccess() async {
    AppTheme.init(brandColor: TenantService.to.effectiveBrandColor);

    // 预下载品牌 logo，避免揭示动画播放时网络图还没加载完导致 logo 区域空白。
    // 失败 / 超时不阻塞启动，揭示动画照常播放（与 H5 行为对齐）。
    await _precacheBrandLogo();

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

  /// 预下载品牌 logo（最多等待 3s），让揭示动画一开始就能显示完整 logo
  Future<void> _precacheBrandLogo() async {
    final url = TenantService.to.brandLogo;
    if (url == null || url.isEmpty) return;
    final ctx = Get.context;
    if (ctx == null) return;
    try {
      await precacheImage(NetworkImage(url), ctx)
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // 预下载失败或超时：不阻塞启动流程
    }
  }

  /// 用户点击「重试」按钮时调用
  void retryLoad() {
    if (_loading) return;
    _loadUntilSuccess();
  }

  @override
  void onClose() {
    revealCtrl.dispose();
    exitCtrl.dispose();
    super.onClose();
  }
}
