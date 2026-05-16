import 'dart:async';

import 'package:do_task_project/app/domain/entities/online_number.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../data/services/whatsapp_api_service.dart';
import '../../../core/i18n/i18n_keys.dart';

class WhatsappTaskController extends BaseController {
  final WhatsappApiService _whatsappApiService = WhatsappApiService();
  // 统计数据
  final todaySendCount = 0.obs; // 今日发送成功数（taskInfo.todaySendNum）
  final todaySendFailCount = 0.obs; // 今日发送失败数（taskInfo.todaySendFailNum）
  final todayPoints = 0.obs; // 今日积分
  final yesterdayPoints = 0.obs; // 昨日积分
  final videoUrl = ''.obs; // 视频URL（接口原始字段，可能为视频或图片地址）
  final wsDownloadUrl = ''.obs; // WhatsApp下载URL

  /// 教程区展示类型：与视频同一占位尺寸
  final mediaKind = 'video'.obs; // 'video' | 'image'
  /// 教程图片地址（来自 `imageUrl` / `guideImageUrl` 等，或由 `videoUrl` 识别为图片时复用）
  final tutorialImageUrl = ''.obs;

  /// 教程区媒体高度（与视频播放器一致）
  static const double kTutorialMediaHeight = 200;

  // 绑定状态
  final phoneNumber = ''.obs;
  final verificationCode = ''.obs;
  final isCodeSent = false.obs;
  final selectedCountryCode = '+00'.obs; // 默认阿尔及利亚区号

  /// 绑定方式：'code' = 验证码绑定；'qr' = 扫码绑定
  final bindMode = 'code'.obs;
  /// 扫码绑定使用的二维码内容（由 `app/wsNumber/getLoginQrCode` 返回）
  final qrCodeContent = ''.obs;
  /// 二维码刷新状态
  final isQrLoading = false.obs;
  /// 二维码刷新冷却剩余秒数（0 表示可刷新，>0 表示冷却中）
  final qrCooldownRemaining = 0.obs;

  /// 成功取码后，若接口未返回冷却秒数时的兜底间隔（秒）。
  static const int _defaultQrCooldownSeconds = 120;
  /// 当前这一轮冷却的总秒数（与倒计时展示一致）。
  int _cooldownTotalSeconds = _defaultQrCooldownSeconds;
  /// 上次启动二维码冷却的时间戳
  DateTime? _lastQrRefreshAt;
  /// 冷却倒计时定时器
  Timer? _qrCooldownTimer;

  // 在线号码列表 - 使用正确的类型
  final onlineNumbers = <OnlineNumber>[].obs;

  // 国家代码列表
  var countryCodes = <Map<String, dynamic>>[].obs;
  // 过滤后的国家代码列表（用于搜索）
  var filteredCountryCodes = <Map<String, dynamic>>[].obs;
  // 搜索关键词
  var searchKeyword = ''.obs;

  /// 教程视频地址（接口失败或 Web 跨域时的兜底）
  static const String _kDefaultTutorialVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  // 视频播放器控制器（可为 null：尚未就绪或加载失败）
  VideoPlayerController? _videoPlayer;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;
  /// 视频初始化已结束（成功或放弃），用于结束「加载中」占位，避免 Web 上 `initialize()` 永不返回导致页面卡死。
  final videoLoadFinished = false.obs;
  final isPlaying = false.obs;
  int _videoBootstrapGeneration = 0;

  /// 供 Chewie / 播放控制使用；仅在 [isVideoInitialized] 为 true 时安全。
  VideoPlayerController get videoController => _videoPlayer!;

  @override
  void onInit() {
    super.onInit();

    // 初始化时加载任务信息
    loadTaskInfo();

    // 初始化时加载在线号码
    loadOnlineNumbers();

    // 加载国家代码数据
    loadCountryCodes();
  }

  // 加载任务信息
  Future<void> loadTaskInfo() async {
    await safeApiCall<Map<String, dynamic>>(
      () => _whatsappApiService.getTaskInfo(),
      (taskInfo) {
        // 更新状态变量
        todayPoints.value = taskInfo['todayPoints'] ?? 0;
        todaySendCount.value = taskInfo['todaySendNum'] ?? 0;
        todaySendFailCount.value = taskInfo['todaySendFailNum'] ?? 0;
        yesterdayPoints.value = taskInfo['yesterdayPoints'] ?? 0;
        wsDownloadUrl.value = taskInfo['wsDownloadUrl'] ?? '';

        _applyTaskInfoMedia(taskInfo);
      },
      onError: () {
        // 任务信息拉取失败时仍结束视频占位：仅尝试默认教程视频，避免整页卡在加载圈
        videoUrl.value = '';
        tutorialImageUrl.value = '';
        mediaKind.value = 'video';
        _initVideoController();
      },
      errorMessage: I18nKeys.loadingFailed.tr,
    );
  }

  /// 根据任务信息决定教程区展示图片或视频（同一占位尺寸）。
  void _applyTaskInfoMedia(Map<String, dynamic> taskInfo) {
    _videoBootstrapGeneration++;
    final rawVideo = (taskInfo['videoUrl'] ?? '').toString().trim();
    videoUrl.value = rawVideo;

    final explicitImage = (taskInfo['imageUrl'] ??
            taskInfo['guideImageUrl'] ??
            taskInfo['guideImage'] ??
            '')
        .toString()
        .trim();

    String? image;
    if (explicitImage.isNotEmpty) {
      image = explicitImage;
    } else if (rawVideo.isNotEmpty && _looksLikeImageUrl(rawVideo)) {
      image = rawVideo;
    }

    if (image != null && image.isNotEmpty) {
      mediaKind.value = 'image';
      tutorialImageUrl.value = image;
      isVideoInitialized.value = false;
      isPlaying.value = false;
      try {
        chewieController?.dispose();
      } catch (_) {}
      chewieController = null;
      unawaited(_disposeCurrentVideoPlayer());
      videoLoadFinished.value = true;
      return;
    }

    mediaKind.value = 'video';
    tutorialImageUrl.value = '';
    _initVideoController();
  }

  /// 判断 [url] 是否应按图片展示（含 `data:image/...` 与常见后缀）。
  static bool _looksLikeImageUrl(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase().trim();
    if (lower.startsWith('data:image/')) return true;
    final path = lower.split('?').first.split('#').first;
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp') ||
        path.endsWith('.bmp') ||
        path.endsWith('.svg');
  }

  /// 启动异步视频加载链（接口 URL → 兜底 MP4），带 [timeout] 与代际取消，防止悬挂 Future。
  void _initVideoController() {
    unawaited(_bootstrapVideoPlayback());
  }

  void _onVideoPlayingTick() {
    try {
      if (_videoPlayer == null) return;
      isPlaying.value = _videoPlayer!.value.isPlaying;
    } catch (_) {
      isPlaying.value = false;
    }
  }

  Future<void> _disposeCurrentVideoPlayer() async {
    try {
      _videoPlayer?.removeListener(_onVideoPlayingTick);
    } catch (_) {}
    try {
      await _videoPlayer?.dispose();
    } catch (e) {
      Get.log('dispose video: $e');
    }
    _videoPlayer = null;
  }

  Future<void> _bootstrapVideoPlayback() async {
    final gen = ++_videoBootstrapGeneration;
    videoLoadFinished.value = false;
    isVideoInitialized.value = false;
    isPlaying.value = false;

    try {
      chewieController?.dispose();
    } catch (_) {}
    chewieController = null;

    await _disposeCurrentVideoPlayer();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (gen != _videoBootstrapGeneration) return;

    final primary = videoUrl.value.trim();
    final urls = <String>[
      if (primary.isNotEmpty && !_looksLikeImageUrl(primary)) primary,
      _kDefaultTutorialVideoUrl,
    ];

    for (final url in urls) {
      if (gen != _videoBootstrapGeneration) return;
      VideoPlayerController? vc;
      try {
        vc = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        await vc.initialize().timeout(const Duration(seconds: 18));
        if (gen != _videoBootstrapGeneration) {
          await vc.dispose();
          return;
        }
        if (!vc.value.isInitialized) {
          await vc.dispose();
          continue;
        }
        _videoPlayer = vc;
        _videoPlayer!.addListener(_onVideoPlayingTick);
        isVideoInitialized.value = true;
        _setupChewieController();
        videoLoadFinished.value = true;
        return;
      } catch (e, st) {
        Get.log('WhatsappTaskController: video init failed for $url: $e\n$st');
        if (vc != null) {
          try {
            await vc.dispose();
          } catch (_) {}
        }
      }
    }

    if (gen != _videoBootstrapGeneration) return;
    isVideoInitialized.value = false;
    videoLoadFinished.value = true;
  }

  // 设置Chewie控制器
  void _setupChewieController() {
    final player = _videoPlayer;
    if (player == null || !player.value.isInitialized) return;
    try {
      chewieController?.dispose();

      chewieController = ChewieController(
        videoPlayerController: player,
        autoPlay: false,
        looping: false,
        aspectRatio: player.value.aspectRatio,
        showControls: false, // 隐藏默认控件，使用自定义控件
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Video playback error',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        },
      );
    } catch (e) {
      Get.log('Error setting up Chewie controller: $e');
    }
  }

  @override
  void onClose() {
    try {
      _videoBootstrapGeneration++;
      _qrCooldownTimer?.cancel();
      _qrCooldownTimer = null;
      chewieController?.dispose();
      chewieController = null;
      _videoPlayer?.removeListener(_onVideoPlayingTick);
      _videoPlayer?.dispose();
      _videoPlayer = null;
    } catch (e) {
      Get.log('Error disposing resources on close: $e');
    }
    super.onClose();
  }

  // 获取验证码
  void getVerificationCode() async {
    if (phoneNumber.value.isEmpty) {
      showErrorMessage(I18nKeys.enterPhoneNumberError.tr);
      return;
    }

    // 手机号格式验证（只包含数字）
    final phonePattern = RegExp(r'^\d{6,15}$');
    if (!phonePattern.hasMatch(phoneNumber.value)) {
      showErrorMessage(I18nKeys.enterValidPhoneNumber.tr);
      return;
    }

    // 区号安全验证
    if (selectedCountryCode.value.isEmpty ||
        selectedCountryCode.value == '+00') {
      showErrorMessage(I18nKeys.selectValidCountryCode.tr);
      return;
    }

    // 验证区号格式（必须以+开头，后面是数字）
    final countryCodePattern = RegExp(r'^\+\d{1,3}$');
    if (!countryCodePattern.hasMatch(selectedCountryCode.value)) {
      showErrorMessage(I18nKeys.selectValidCountryCode.tr);
      return;
    }

    // 拼接区号和手机号（移除区号中的+号）
    final countryCodeWithoutPlus = selectedCountryCode.value.replaceAll(
      '+',
      '',
    );
    final fullPhoneNumber = '$countryCodeWithoutPlus${phoneNumber.value}';

    await safeApiCall<String>(
      () => _whatsappApiService.getLoginCode(
        fullPhoneNumber,
        areaCode: countryCodeWithoutPlus,
      ),
      (result) {
        if (result.isNotEmpty) {
          showSuccessMessage(I18nKeys.verificationCodeSent.tr);
          setVerificationCode(result);
          isCodeSent.value = true;
        } else {
          showErrorMessage(I18nKeys.verificationCodeFailed.tr);
        }
      },
      showLoading: true,
      errorMessage: I18nKeys.verificationCodeFailed.tr,
    );
  }

  // 验证手机号码
  void verifyPhoneNumber() {
    if (verificationCode.value.isEmpty) {
      showErrorMessage(I18nKeys.enterVerificationCodeError.tr);
      return;
    }

    // 模拟验证
    showSuccessMessage(
      '${I18nKeys.verificationSuccess.tr}，${I18nKeys.whatsappAccountLinked.tr}',
    );
  }

  // 设置验证码（从接口接收）
  void setVerificationCode(String code) {
    if (code.isNotEmpty && code.length <= 8) {
      verificationCode.value = code;
    }
  }

  // 复制验证码到剪贴板
  void copyVerificationCode() {
    if (verificationCode.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: verificationCode.value));
      showSuccessMessage(I18nKeys.verificationCodeCopied.tr);
    } else {
      showErrorMessage(I18nKeys.noVerificationCodeToCopy.tr);
    }
  }

  // 下载WhatsApp
  void downloadWhatsapp() async {
    if (wsDownloadUrl.value.isNotEmpty) {
      // 使用API返回的下载URL，打开新窗口跳转
      try {
        final Uri url = Uri.parse(wsDownloadUrl.value);
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication, // 使用外部应用打开，会打开新窗口
          );
        } else {
          showErrorMessage(I18nKeys.cannotOpenDownloadLink.tr);
        }
      } catch (e) {
        showErrorMessage(I18nKeys.failedToOpenDownloadLink.tr);
      }
    } else {
      showErrorMessage(I18nKeys.downloadLinkNotAvailable.tr);
    }
  }

  // 绑定WhatsApp
  void bindWhatsapp() {
    // 这里可以添加实际的绑定逻辑
    showSuccessMessage(I18nKeys.pleaseCompleteRegistration.tr);
  }

  /// 切换绑定方式
  /// @param mode 'code' | 'qr'
  void setBindMode(String mode) {
    if (mode != 'code' && mode != 'qr') return;
    bindMode.value = mode;
  }

  /// 获取/刷新二维码
  ///
  /// 业务规则：
  /// - 切换到扫码 Tab 时不会自动触发，必须由用户主动点击按钮调用本方法；
  /// - 不在点击时固定启动 120s 本地冷却，避免与后端限流窗口错位；仅在成功拿到二维码
  ///   （使用接口返回的 [LoginQrCodeResult.cooldownSeconds]，缺省则用 [_defaultQrCooldownSeconds]）
  ///   或捕获到带 [ApiException.retryAfterSeconds] 的限流响应时再启动倒计时；
  /// - 业务错误由 `HttpService` 统一 toast 展示，此处不再重复弹错误提示。
  Future<void> refreshQrCode() async {
    if (isQrLoading.value) return;
    if (qrCooldownRemaining.value > 0) {
      showErrorMessage(
        I18nKeys.scanQrCooldown.trParams({
          's': qrCooldownRemaining.value.toString(),
        }),
      );
      return;
    }

    isQrLoading.value = true;
    try {
      final result = await _whatsappApiService.getLoginQrCodeResult();
      if (result.content.isNotEmpty) {
        qrCodeContent.value = result.content;
        final sec = result.cooldownSeconds ?? _defaultQrCooldownSeconds;
        _startQrCooldown(seconds: sec);
      }
      // 若内容为空/请求失败：错误提示已由全局 HttpService 处理，这里不重复弹 toast。
    } on ApiException catch (e) {
      final wait = e.retryAfterSeconds;
      if (wait != null && wait > 0) {
        _startQrCooldown(seconds: wait);
      }
    } catch (_) {
      // 其它异常不启动本地冷却，避免后端已放行时按钮仍被锁死
    } finally {
      isQrLoading.value = false;
    }
  }

  /// 启动二维码冷却倒计时（每秒更新一次剩余秒数）
  ///
  /// @param seconds 本轮冷却总时长（秒），与后端返回或成功响应中的间隔一致
  void _startQrCooldown({required int seconds}) {
    final total = seconds.clamp(1, 3600);
    _cooldownTotalSeconds = total;
    _lastQrRefreshAt = DateTime.now();
    qrCooldownRemaining.value = total;
    _qrCooldownTimer?.cancel();
    _qrCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final startedAt = _lastQrRefreshAt;
      if (startedAt == null) {
        timer.cancel();
        qrCooldownRemaining.value = 0;
        return;
      }
      final passed = DateTime.now().difference(startedAt).inSeconds;
      final remaining = _cooldownTotalSeconds - passed;
      if (remaining <= 0) {
        qrCooldownRemaining.value = 0;
        timer.cancel();
      } else {
        qrCooldownRemaining.value = remaining;
      }
    });
  }

  // 加载在线号码列表 - 使用safeApiCall方法
  Future<void> loadOnlineNumbers() async {
    await safeApiCall<List<OnlineNumber>>(
      () => _whatsappApiService.getOnlineNumbers(),
      (numbers) {
        onlineNumbers.assignAll(numbers);
      },
      showLoading: true,
      errorMessage: I18nKeys.loadingOnlineNumbersFailed.tr,
      onError: () {
        onlineNumbers.assignAll([]);
      },
    );
  }

  // 刷新在线号码列表
  void refreshOnlineNumbers() {
    loadOnlineNumbers();
  }

  // 加载国家代码数据
  Future<void> loadCountryCodes() async {
    await safeApiCall<List<Map<String, dynamic>>>(
      () => _whatsappApiService.getAreaCodes(),
      (codes) {
        codes.sort(
          (a, b) =>
              (a['en'] ?? '').toString().compareTo((b['en'] ?? '').toString()),
        );
        countryCodes.assignAll(codes);
        filteredCountryCodes.assignAll(codes);
      },
      showLoading: true,
      errorMessage: I18nKeys.loadCountriesFailed.tr,
      onError: () {
        countryCodes.assignAll([]);
      },
    );
  }

  // 选择国家代码
  void selectCountryCode(Map<String, dynamic> country) {
    selectedCountryCode.value = country['code'];
  }

  // 搜索国家代码
  void searchCountryCodes(String keyword) {
    searchKeyword.value = keyword.trim();

    if (searchKeyword.isEmpty) {
      // 如果搜索关键词为空，显示所有国家
      filteredCountryCodes.assignAll(countryCodes);
    } else {
      // 按名称或区号搜索（支持中文名称、英文名称、国家代码、电话区号）
      final filtered = countryCodes.where((country) {
        // final name = country['name']?.toString().toLowerCase() ?? '';
        final en = country['en']?.toString().toLowerCase() ?? '';
        final short = country['short']?.toString().toLowerCase() ?? '';
        final code = country['code']?.toString().toLowerCase() ?? '';
        final searchLower = searchKeyword.value.toLowerCase();

        return en.contains(searchLower) ||
            short.contains(searchLower) ||
            code.contains(searchLower);
      }).toList();

      filteredCountryCodes.assignAll(filtered);
    }
  }

  // 切换视频播放/暂停状态
  void togglePlayPause() {
    if (isVideoInitialized.value) {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
    } else {
      showErrorMessage(I18nKeys.videoLoadingPleaseWait.tr);
    }
  }

  // 切换全屏模式
  void toggleFullScreen() async {
    // 切换全屏状态
    if (chewieController != null) {
      if (chewieController!.isFullScreen) {
        chewieController!.exitFullScreen();
      } else {
        chewieController!.enterFullScreen();
      }
    }
  }

  // 重新播放视频
  void replayVideo() {
    if (isVideoInitialized.value) {
      videoController.seekTo(const Duration(seconds: 0));
      videoController.play();
    }
  }

  void sendWhatsAppMessage(String id) {
    if (id.isEmpty) {
      showErrorMessage(I18nKeys.invalidIdError.tr);
      return;
    }

    safeApiCall<Map<String, dynamic>>(
      () => _whatsappApiService.sendMessage(id),
      (result) {
        // 处理成功响应
        showSuccessMessage(I18nKeys.sendMessageSuccess.tr);
      },
      showLoading: true,
      errorMessage: I18nKeys.sendMessageFailed.tr,
    );
  }
}
