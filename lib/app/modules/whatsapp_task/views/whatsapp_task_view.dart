import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/base/base_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/whatsapp_task_controller.dart';

class WhatsappTaskView extends BaseView<WhatsappTaskController> {
  const WhatsappTaskView({super.key});

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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

                      // 教程视频和步骤说明 - 只在web端显示
                      if (kIsWeb) ...[
                        _buildVideoSection(),
                        const SizedBox(height: 20),
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
                      ],

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

  // 显示国家代码选择器
  void _showCountryCodePicker() {
    final controller = Get.find<WhatsappTaskController>();

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    I18nKeys.selectCountryRegion.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.threeColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: AppTheme.nineColor,
                    ),
                  ),
                ],
              ),
            ),
            // 搜索框
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: I18nKeys.searchCountryNameCodeOrAreaCode.tr,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.nineColor,
                  ),
                  suffixIcon: Obx(() {
                    if (controller.searchKeyword.isNotEmpty) {
                      return GestureDetector(
                        onTap: () {
                          controller.searchCountryCodes('');
                        },
                        child: const Icon(
                          Icons.clear,
                          color: AppTheme.nineColor,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  filled: true,
                  fillColor: AppTheme.f9f9f9Color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  controller.searchCountryCodes(value);
                },
              ),
            ),
            // 国家列表
            Expanded(
              child: Obx(() {
                if (controller.countryCodes.isEmpty) {
                  return Center(child: Text(I18nKeys.loading.tr));
                }

                if (controller.filteredCountryCodes.isEmpty) {
                  return Center(
                    child: Text(I18nKeys.noMatchingCountryFound.tr),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredCountryCodes.length,
                  itemBuilder: (context, index) {
                    final country = controller.filteredCountryCodes[index];
                    return ListTile(
                      leading: Text(
                        country['short'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.nineColor,
                        ),
                      ),
                      title: Text(
                        '${country['en']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      trailing: Text(
                        country['code'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        controller.selectCountryCode(country);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                controller.todaySendCount.value.toString(),
              ),
              _buildStatItem(
                I18nKeys.todayPoints.tr,
                controller.todayPoints.value.toString(),
              ),
              _buildStatItem(
                I18nKeys.yesterdayPoints.tr,
                controller.yesterdayPoints.value.toString(),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
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
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() {
              if (Get.find<WhatsappTaskController>().isVideoInitialized.value) {
                return AspectRatio(
                  aspectRatio: controller.videoController.value.aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(controller.videoController),
                      // 播放/暂停按钮覆盖层
                      Center(
                        child: AnimatedOpacity(
                          opacity: controller.isPlaying.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: () {
                              controller.togglePlayPause();
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.5),
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
                            controller.togglePlayPause();
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
                        I18nKeys.videoLoading.tr,
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
          onTap: () => controller.downloadWhatsapp(),
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
                  I18nKeys.downloadWhatsapp.tr + controller.wsDownloadUrl.value,
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
            child: Text(
              I18nKeys.continueBindingSteps.tr,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
              ),
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
              // GestureDetector(
              //   onTap: () {
              //     // 收起逻辑
              //   },
              //   child: Text(
              //     I18nKeys.collapse.tr,
              //     style: const TextStyle(
              //       color: AppTheme.nineColor,
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
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
            padding: const EdgeInsets.symmetric(horizontal: 21),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.f9f9f9Color,
              border: Border.all(color: AppTheme.dddColor, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 国家代码选择器
                GestureDetector(
                  onTap: () => _showCountryCodePicker(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Text(
                          controller.selectedCountryCode.value,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.threeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: AppTheme.threeColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(width: 1, height: 20, color: AppTheme.dddColor),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
                    textAlign: TextAlign.left,
                    controller:
                        TextEditingController(
                            text: controller.phoneNumber.value,
                          )
                          ..selection = TextSelection.collapsed(
                            offset: controller.phoneNumber.value.length,
                          ),
                    onChanged: (value) {
                      // 只允许输入数字
                      final filteredValue = value.replaceAll(
                        RegExp(r'[^\d]'),
                        '',
                      );
                      controller.phoneNumber.value = filteredValue;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true, // 减少输入框的默认padding
                      contentPadding: EdgeInsets.zero, // 移除内容padding
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
                    keyboardType: TextInputType.phone, // 数字键盘
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                      LengthLimitingTextInputFormatter(15), // 限制最大长度15位
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
          Stack(
            children: [
              Center(
                child: Text(
                  I18nKeys.doNotRefresh.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.ff6a6aColor,
                  ),
                ),
              ),

              // 复制按钮
            ],
          ),
          const SizedBox(height: 15),
          // _buildVerificationCodeInput(),
          _buildVerificationCodeWithCopy(),

          const SizedBox(height: 11),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
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

  // 验证码输入区域和复制按钮
  Widget _buildVerificationCodeWithCopy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 验证码输入区域
        _buildVerificationCodeInput(),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: controller.copyVerificationCode,
          child: Icon(Icons.copy, size: 20, color: AppTheme.nineColor),
        ),
      ],
    );
  }

  // 验证码输入区域
  Widget _buildVerificationCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(8, (index) => _buildCodeDigitBox(index)),
    );
  }

  // 单个验证码输入框
  Widget _buildCodeDigitBox(int index) {
    return Obx(() {
      final code = controller.verificationCode.value;
      return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.dddColor, width: 1),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          index < code.length ? code[index] : '',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.sixColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  /// 计算相对时间（当前时间减去最后登录时间，精确到秒）
  String _formatRelativeTime(String? lastLoginTime) {
    if (lastLoginTime == null || lastLoginTime.isEmpty) {
      return '';
    }

    try {
      // 解析最后登录时间
      final loginTime = DateTime.parse(lastLoginTime);
      final now = DateTime.now();
      final difference = now.difference(loginTime);

      // 计算时间差，精确到秒
      if (difference.inDays > 0) {
        return '${difference.inDays}${I18nKeys.daysAgo.tr}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}${I18nKeys.hoursAgo.tr}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}${I18nKeys.minutesAgo.tr}';
      } else if (difference.inSeconds > 0) {
        return '${difference.inSeconds}${I18nKeys.secondsAgo.tr}';
      } else {
        return I18nKeys.justNow.tr;
      }
    } catch (e) {
      return lastLoginTime; // 如果解析失败，返回原始时间
    }
  }

  Widget _buildOnlineNumbersSection() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Container(
            padding: EdgeInsets.only(top: 16, left: 13, right: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  I18nKeys.onlineNumbers.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.threeColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.refreshOnlineNumbers(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        I18nKeys.refresh.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 号码列表
          Obx(() {
            final onlineNumbers = controller.onlineNumbers;

            if (onlineNumbers.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(ImageAssets.iconEmpty, width: 128, height: 113),
                    const SizedBox(height: 6),
                    Text(
                      I18nKeys.noOnlineNumbers.tr,
                      style: TextStyle(fontSize: 12, color: AppTheme.nineColor),
                    ),
                    const SizedBox(height: 33),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onlineNumbers.length,
              itemBuilder: (context, index) {
                final onlineNumber = onlineNumbers[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                        top: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ImageAssets.onlinePhone,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                onlineNumber.wsAppNo ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.threeColor,
                                ),
                              ),
                            ],
                          ),
                          GetPlatform.isWeb
                              ? Row(
                                  children: List.generate(3, (i) {
                                    return Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < (onlineNumber.rating ?? 0)
                                          ? Colors.orange
                                          : Colors.grey.shade300,
                                    );
                                  }),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (onlineNumber.canSendMsg == false) {
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(I18nKeys.newTask.tr),
                                          content: Text(
                                            I18nKeys.confirmSend.tr,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(I18nKeys.cancel.tr),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                controller.sendWhatsAppMessage(onlineNumber.id ?? '');
                                                Navigator.of(context).pop();
                                                // 这里可以添加发送消息的逻辑
                                              },
                                              child: Text(I18nKeys.confirm.tr),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: onlineNumber.canSendMsg == false ? Colors.grey.shade300 : null,
                                      gradient: onlineNumber.canSendMsg == false ? null : const LinearGradient(
                                        colors: [
                                          Color(0xFF47B9F2),
                                          Color(0xFF477DF2),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      I18nKeys.send.tr,
                                      style: TextStyle(
                                        color:  Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38, bottom: 15),
                      child: Text(
                        onlineNumber.hangUpTime ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.nineColor,
                        ),
                      ),
                    ),
                    // 分隔线
                    if (index != onlineNumbers.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: 0.5,
                        color: AppTheme.lineColor,
                      ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }
  
}
