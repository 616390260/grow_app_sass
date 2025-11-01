import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/base/base_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/whatsapp_task_controller.dart';

class WhatsappTaskView extends BaseView<WhatsappTaskController> {
  const WhatsappTaskView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // 设置状态栏为透明文字
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏透明
        statusBarIconBrightness: Brightness.light, // 状态栏图标为白色
        statusBarBrightness: Brightness.dark, // iOS状态栏图标为暗色
      ),
    );

    // 返回null表示不显示默认AppBar
    return null;
  }

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // 整体页面背景色
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 状态栏占位空间 - 设置为蓝色背景以匹配顶部区域
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color(0xFF477DF2),
          ),
          // 导航栏
          Container(
            height: 56, // 导航栏高度
            color: const Color(0xFF477DF2), // 蓝色背景
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        I18nKeys.whatsappTaskTitle.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // 平衡返回按钮的宽度
                ],
              ),
            ),
          ),
          // 使用SingleChildScrollView包裹所有内容，包括背景色
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  // 背景色层
                  Column(
                    children: [
                      // 上方100px蓝色背景
                      Container(
                        height: 100,
                        color: const Color(0xFF477DF2), // 蓝色背景
                      ),
                      // 下方灰色背景
                      Container(
                        color: AppTheme.bgColor, // 灰色背景
                        width: double.infinity, // 确保宽度充满
                        // 移除固定高度，让背景自适应内容高度
                      ),
                    ],
                  ),
                  // 内容层
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 任务统计部分
                      const SizedBox(height: 11),
                      _buildStatisticsSection(),
                      const SizedBox(height: 16),
                      // 教程视频
                      _buildVideoSection(),
                      const SizedBox(height: 20),
                      // 步骤说明容器
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 16,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 步骤说明
                            _buildStepsSection(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // WhatsApp绑定
                      _buildBindingSection(context),
                      // 在线号码
                      _buildOnlineNumbersSection(),
                      const SizedBox(height: 11),
                      // 底部提示
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          I18nKeys.phoneNumberTip.tr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppTheme.nineColor,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white, // 透明背景，使用外部的渐变色
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.taskStatistics.tr,
            style: const TextStyle(
              color: AppTheme.threeColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                I18nKeys.todaySendCount.tr,
                controller.todaySendCount.value,
              ),
              _buildStatItem(
                I18nKeys.todayPoints.tr,
                controller.todayPoints.value,
              ),
              _buildStatItem(
                I18nKeys.yesterdayPoints.tr,
                controller.yesterdayPoints.value,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            color: AppTheme.threeColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.sixColor,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() {
              if (Get.find<WhatsappTaskController>().isVideoInitialized.value) {
                return AspectRatio(
                  aspectRatio: Get.find<WhatsappTaskController>()
                      .videoController
                      .value
                      .aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(
                        Get.find<WhatsappTaskController>().videoController,
                      ),
                      // 播放/暂停按钮覆盖层
                      Center(
                        child: AnimatedOpacity(
                          opacity:
                              !Get.find<WhatsappTaskController>()
                                  .isPlaying
                                  .value
                              ? 1.0
                              : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () {
                              Get.find<WhatsappTaskController>()
                                  .togglePlayPause();
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 点击整个视频区域也可以播放/暂停
                      Positioned.fill(
                        child: InkWell(
                          onTap: () {
                            Get.find<WhatsappTaskController>()
                                .togglePlayPause();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(
                        '视频加载中...',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   '点击视频播放/暂停',
          //   style: TextStyle(
          //     color: Colors.black54,
          //     fontSize: 14,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.step1Download.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Get.find<WhatsappTaskController>().downloadWhatsapp(),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 0.5),
              color: AppTheme.f9f9f9Color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  I18nKeys.downloadWhatsapp.tr,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          I18nKeys.step2Bind.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Get.find<WhatsappTaskController>().bindWhatsapp(),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 0.5),
              color: AppTheme.f9f9f9Color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  I18nKeys.continueBindingSteps.tr,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBindingSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18nKeys.bindWhatsapp.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.threeColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 收起逻辑
                },
                child: Text(
                  I18nKeys.collapse.tr,
                  style: const TextStyle(
                    color: AppTheme.nineColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              I18nKeys.enterVerificationCode.tr,
              style: const TextStyle(fontSize: 13, color: AppTheme.threeColor),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              I18nKeys.onlyActiveUsers.tr,
              style: const TextStyle(fontSize: 13, color: AppTheme.ff6a6aColor),
            ),
          ),
          const SizedBox(height: 15),

          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.f9f9f9Color,
              border: Border.all(color: AppTheme.dddColor, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Text(
                  '+213',
                  style: TextStyle(fontSize: 15, color: AppTheme.threeColor),
                ),
                const SizedBox(width: 22),
                Container(width: 1, height: 20, color: AppTheme.dddColor),
                const SizedBox(width: 20),
                Flexible(
                  child: TextField(
                    controller: TextEditingController(
                      text: controller.phoneNumber.value,
                    ),
                    onChanged: (value) => controller.phoneNumber.value = value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: I18nKeys.enterPhoneNumber.tr,
                      hintStyle: TextStyle(
                        color: AppTheme.nineColor,
                        fontSize: 13,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.threeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () =>
                Get.find<WhatsappTaskController>().getVerificationCode(),
            child: Container(
              height: 44,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF47B9F2), Color(0xFF477DF2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                I18nKeys.getVerificationCode.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              I18nKeys.doNotRefresh.tr,
              style: const TextStyle(fontSize: 13, color: AppTheme.ff6a6aColor),
            ),
          ),
          const SizedBox(height: 15),
          _buildVerificationCodeInput(),
          const SizedBox(height: 11),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                textAlign: TextAlign.center,
                I18nKeys.verificationCodeTip.tr,
                style: const TextStyle(fontSize: 11, color: AppTheme.nineColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 验证码输入区域
  Widget _buildVerificationCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildCodeDigitBox(index)),
    );
  }

  // 单个验证码输入框
  Widget _buildCodeDigitBox(int index) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller:
            index <
                Get.find<WhatsappTaskController>().verificationCode.value.length
            ? TextEditingController(
                text: Get.find<WhatsappTaskController>()
                    .verificationCode
                    .value[index],
              )
            : null,
        onChanged: (value) {
          if (value.isNotEmpty) {
            // 这里可以实现验证码输入逻辑
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildOnlineNumbersSection() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 13),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.onlineNumbers.tr,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/invite_whats.png', // 使用现有的WhatsApp图标
                width: 60,
                height: 60,
                color: Colors.blue.shade100,
              ),
              const SizedBox(height: 16),
              Text(
                I18nKeys.noData.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildStatisticsSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.transparent, // 透明背景，使用外部的渐变色
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.taskStatistics.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              I18nKeys.todaySendCount.tr,
              Get.find<WhatsappTaskController>().todaySendCount.value,
            ),
            _buildStatItem(
              I18nKeys.todayPoints.tr,
              Get.find<WhatsappTaskController>().todayPoints.value,
            ),
            _buildStatItem(
              I18nKeys.yesterdayPoints.tr,
              Get.find<WhatsappTaskController>().yesterdayPoints.value,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatItem(String label, int value) {
  return Column(
    children: [
      Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    ],
  );
}

Widget _buildVideoSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.tutorialVideo.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(() {
            if (Get.find<WhatsappTaskController>().isVideoInitialized.value) {
              return AspectRatio(
                aspectRatio: Get.find<WhatsappTaskController>()
                    .videoController
                    .value
                    .aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(
                      Get.find<WhatsappTaskController>().videoController,
                    ),
                    // 播放/暂停按钮覆盖层
                    Center(
                      child: AnimatedOpacity(
                        opacity:
                            !Get.find<WhatsappTaskController>().isPlaying.value
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: InkWell(
                          onTap: () {
                            Get.find<WhatsappTaskController>()
                                .togglePlayPause();
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 点击整个视频区域也可以播放/暂停
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Get.find<WhatsappTaskController>().togglePlayPause();
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: 180,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      '视频加载中...',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '点击视频播放/暂停',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    ),
  );
}

Widget _buildStepsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.step1Download.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Get.find<WhatsappTaskController>().downloadWhatsapp(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  I18nKeys.downloadWhatsapp.tr,
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          I18nKeys.step2Bind.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Get.find<WhatsappTaskController>().bindWhatsapp(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              I18nKeys.continueBindingSteps.tr,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBindingSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18nKeys.bindWhatsapp.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 收起逻辑
                },
                child: Text(
                  I18nKeys.collapse.tr,
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            I18nKeys.enterVerificationCode.tr,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            I18nKeys.onlyActiveUsers.tr,
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: const Text(
                  '+213',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: TextField(
                    controller: TextEditingController(
                      text:
                          Get.find<WhatsappTaskController>().phoneNumber.value,
                    ),
                    onChanged: (value) =>
                        Get.find<WhatsappTaskController>().phoneNumber.value =
                            value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: I18nKeys.enterPhoneNumber.tr,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                Get.find<WhatsappTaskController>().getVerificationCode(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF477DF2),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              I18nKeys.getVerificationCode.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            I18nKeys.doNotRefresh.tr,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          const SizedBox(height: 16),
          _buildVerificationCodeInput(),
          const SizedBox(height: 16),
          Text(
            I18nKeys.verificationCodeTip.tr,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

// 验证码输入区域
Widget _buildVerificationCodeInput() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(6, (index) => _buildCodeDigitBox(index)),
  );
}

// 单个验证码输入框
Widget _buildCodeDigitBox(int index) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(4),
    ),
    alignment: Alignment.center,
    child: TextField(
      controller:
          index <
              Get.find<WhatsappTaskController>().verificationCode.value.length
          ? TextEditingController(
              text: Get.find<WhatsappTaskController>()
                  .verificationCode
                  .value[index],
            )
          : null,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // 这里可以实现验证码输入逻辑
        }
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        counterText: '',
      ),
    ),
  );
}

Widget _buildOnlineNumbersSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            I18nKeys.onlineNumbers.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              Image.asset(
                'assets/images/invite_whats.png', // 使用现有的WhatsApp图标
                width: 60,
                height: 60,
                color: Colors.blue.shade100,
              ),
              const SizedBox(height: 16),
              Text(
                I18nKeys.noData.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
