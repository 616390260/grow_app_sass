import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/base/base_controller.dart';

class WhatsappTaskController extends BaseController {
  // 统计数据
  final todaySendCount = 150.obs;
  final todayPoints = 150.obs;
  final yesterdayPoints = 150.obs;
  
  // 绑定状态
  final phoneNumber = ''.obs;
  final verificationCode = ''.obs;
  final isCodeSent = false.obs;
  
  // 视频播放器控制器
  late VideoPlayerController videoController;
  final isVideoInitialized = false.obs;
  final isPlaying = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // 初始化视频控制器 - 这里使用网络视频URL作为示例
    // 实际应用中可以替换为实际的视频URL或本地文件路径
    videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..initialize().then((_) {
        isVideoInitialized.value = true;
      })
      ..addListener(() {
        isPlaying.value = videoController.value.isPlaying;
      })
      ..setLooping(false);
  }
  
  @override
  void onClose() {
    // 释放视频资源
    videoController.dispose();
    super.onClose();
  }
  
  // 获取验证码
  void getVerificationCode() {
    if (phoneNumber.value.isEmpty) {
      showErrorMessage('请输入手机号码');
      return;
    }
    
    // 模拟发送验证码
    showSuccessMessage('验证码已发送');
    isCodeSent.value = true;
  }
  
  // 验证手机号码
  void verifyPhoneNumber() {
    if (verificationCode.value.isEmpty) {
      showErrorMessage('请输入验证码');
      return;
    }
    
    // 模拟验证
    showSuccessMessage('验证成功，WhatsApp账号已关联');
  }
  
  // 下载WhatsApp
  void downloadWhatsapp() {
    // 这里可以添加实际的下载逻辑
    showSuccessMessage('正在跳转到下载页面');
  }
  
  // 绑定WhatsApp
  void bindWhatsapp() {
    // 这里可以添加实际的绑定逻辑
    showSuccessMessage('请完成注册后继续绑定');
  }
  
  // 播放教程视频
  void playTutorialVideo() {
    if (isVideoInitialized.value) {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
    } else {
      showErrorMessage('视频加载中，请稍后再试');
    }
  }
  
  // 切换视频播放状态
  void togglePlayPause() {
    if (isVideoInitialized.value) {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
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
}