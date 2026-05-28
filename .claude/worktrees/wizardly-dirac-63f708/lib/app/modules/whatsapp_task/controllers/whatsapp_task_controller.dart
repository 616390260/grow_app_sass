import 'package:do_task_project/app/domain/entities/online_number.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/services/whatsapp_api_service.dart';
import '../../../core/i18n/i18n_keys.dart';

class WhatsappTaskController extends BaseController {
  final WhatsappApiService _whatsappApiService = WhatsappApiService();
  // 统计数据
  final todaySendCount = 0.obs; // 今日发送数量
  final todayPoints = 0.obs; // 今日积分
  final yesterdayPoints = 0.obs; // 昨日积分
  final videoUrl = ''.obs; // 视频URL
  final wsDownloadUrl = ''.obs; // WhatsApp下载URL

  // 绑定状态
  final phoneNumber = ''.obs;
  final verificationCode = ''.obs;
  final isCodeSent = false.obs;
  final selectedCountryCode = '+00'.obs; // 默认阿尔及利亚区号

  // 在线号码列表 - 使用正确的类型
  final onlineNumbers = <OnlineNumber>[].obs;

  // 国家代码列表
  var countryCodes = <Map<String, dynamic>>[].obs;
  // 过滤后的国家代码列表（用于搜索）
  var filteredCountryCodes = <Map<String, dynamic>>[].obs;
  // 搜索关键词
  var searchKeyword = ''.obs;

  // 视频播放器控制器
  late VideoPlayerController videoController;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;
  final isPlaying = false.obs;

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
        yesterdayPoints.value = taskInfo['yesterdayPoints'] ?? 0;
        videoUrl.value = taskInfo['videoUrl'] ?? '';
        wsDownloadUrl.value = taskInfo['wsDownloadUrl'] ?? '';

        // 初始化视频控制器
        _initVideoController();
      },
      errorMessage: I18nKeys.loadingFailed.tr,
    );
  }

  // 初始化视频控制器
  void _initVideoController() {
    if (videoUrl.value.isNotEmpty) {
      try {
        // 确保先释放旧的控制器资源
        _disposeVideoResources();

        videoController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl.value),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );

        // 延迟初始化以避免lifecycle消息问题
        Future.delayed(const Duration(milliseconds: 100), () {
          try {
            videoController.initialize().then((_) {
              isVideoInitialized.value = true;
              _setupChewieController();
            });

            videoController.addListener(() {
              try {
                isPlaying.value = videoController.value.isPlaying;
              } catch (e) {
                // 避免在控制器已释放时访问
                isPlaying.value = false;
              }
            });
          } catch (e) {
            Get.log('Error initializing video: $e');
            _initDefaultVideoController();
          }
        });
      } catch (e) {
        Get.log('Error setting up video controller: $e');
        // 如果视频URL无效，使用默认视频
        _initDefaultVideoController();
      }
    } else {
      // 如果没有视频URL，使用默认视频
      _initDefaultVideoController();
    }
  }

  // 初始化默认视频控制器
  void _initDefaultVideoController() {
    // 确保先释放旧的控制器资源
    _disposeVideoResources();

    videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    // 延迟初始化以避免lifecycle消息问题
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        videoController.initialize().then((_) {
          isVideoInitialized.value = true;
          _setupChewieController();
        });

        videoController.addListener(() {
          try {
            isPlaying.value = videoController.value.isPlaying;
          } catch (e) {
            // 避免在控制器已释放时访问
            isPlaying.value = false;
          }
        });
      } catch (e) {
        Get.log('Error initializing default video: $e');
      }
    });
  }

  // 释放视频相关资源
  void _disposeVideoResources() {
    try {
      chewieController?.dispose();
      // 不要在这里dispose videoController，因为我们会重新赋值
    } catch (e) {
      Get.log('Error disposing video resources: $e');
    }
  }

  // 设置Chewie控制器
  void _setupChewieController() {
    try {
      if (videoController.value.isInitialized) {
        // 确保先释放旧的控制器
        if (chewieController != null) {
          chewieController!.dispose();
        }

        chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          looping: false,
          aspectRatio: videoController.value.aspectRatio,
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
      }
    } catch (e) {
      // 捕获任何初始化错误
      Get.log('Error setting up Chewie controller: $e');
    }
  }

  @override
  void onClose() {
    try {
      // 安全释放视频资源
      chewieController?.dispose();
      videoController.dispose();
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
      () => _whatsappApiService.getLoginCode(fullPhoneNumber),
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
