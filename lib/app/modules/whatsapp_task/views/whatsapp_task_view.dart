import 'dart:convert';

import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
            color: AppTheme.primaryColor,
          ),
          // 导航栏
          Container(
            height: 56, // 导航栏高度
            color: AppTheme.primaryColor, // 蓝色背景
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (Get.key.currentState!.canPop()) {
                        Get.back();
                      } else {
                        // 刷新后 fallback 到首页
                        Get.offAllNamed(Routes.root);
                      }
                    },
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
                        color: AppTheme.primaryColor, // 蓝色背景
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
              const double mediaH = WhatsappTaskController.kTutorialMediaHeight;
              if (controller.mediaKind.value == 'image' &&
                  controller.tutorialImageUrl.value.isNotEmpty) {
                return SizedBox(
                  width: double.infinity,
                  height: mediaH,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.04),
                      child: Image.network(
                        controller.tutorialImageUrl.value,
                        width: double.infinity,
                        height: mediaH,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              I18nKeys.videoUnavailable.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.5),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (controller.isVideoInitialized.value &&
                  controller.chewieController != null) {
                return SizedBox(
                  width: double.infinity, // 宽度铺满布局
                  height: mediaH,
                  child: Stack(
                    children: [
                      Chewie(controller: controller.chewieController!),
                      // 播放/暂停按钮覆盖层
                      Center(
                        child: AnimatedOpacity(
                          opacity: controller.isPlaying.value ? 0.0 : 1.0,
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
                            controller.togglePlayPause();
                          },
                        ),
                      ),
                      // 全屏/退出全屏按钮
                      // Positioned(
                      //   bottom: 10,
                      //   right: 10,
                      //   child: InkWell(
                      //     onTap: () {
                      //       // 使用chewie的全屏功能
                      //       controller.toggleFullScreen();
                      //     },
                      //     child: Container(
                      //       width: 40,
                      //       height: 40,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: Colors.black.withOpacity(0.5),
                      //       ),
                      //       child: Icon(
                      //         controller.chewieController != null && controller.chewieController!.isFullScreen
                      //             ? Icons.fullscreen_exit
                      //             : Icons.fullscreen,
                      //         size: 24,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }
              if (controller.videoLoadFinished.value) {
                return Container(
                  height: mediaH,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        size: 40,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        I18nKeys.videoUnavailable.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.55),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                height: mediaH,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      I18nKeys.videoLoading.tr,
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              );
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
          Text(
            I18nKeys.bindWhatsapp.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 14),
          _buildBindModeTabs(),
          const SizedBox(height: 20),
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              ),
              child: controller.bindMode.value == 'qr'
                  ? KeyedSubtree(
                      key: const ValueKey('qr'),
                      child: _buildQrBindingBody(),
                    )
                  : KeyedSubtree(
                      key: const ValueKey('code'),
                      child: _buildCodeBindingBody(),
                    ),
            );
          }),
        ],
      ),
    );
  }

  /// 绑定方式 Tab 切换（胶囊分段控件）
  Widget _buildBindModeTabs() {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.f9f9f9Color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dddColor, width: 0.5),
      ),
      child: Obx(() {
        final mode = controller.bindMode.value;
        return Row(
          children: [
            _buildBindTabItem(
              label: I18nKeys.bindMethodCode.tr,
              icon: Icons.sms_outlined,
              selected: mode == 'code',
              onTap: () => controller.setBindMode('code'),
            ),
            _buildBindTabItem(
              label: I18nKeys.bindMethodQr.tr,
              icon: Icons.qr_code_rounded,
              selected: mode == 'qr',
              onTap: () {
                // 切换到扫码 Tab 时不主动请求二维码，
                // 由用户点击「获取二维码 / 刷新」按钮触发。
                controller.setBindMode('qr');
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBindTabItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? AppTheme.primaryColor : AppTheme.nineColor,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppTheme.primaryColor : AppTheme.sixColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 验证码绑定内容
  Widget _buildCodeBindingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
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
              GestureDetector(
                onTap: () => _showCountryCodePicker(),
                child: Row(
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
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  controller:
                      TextEditingController(
                          text: controller.phoneNumber.value,
                        )
                        ..selection = TextSelection.collapsed(
                          offset: controller.phoneNumber.value.length,
                        ),
                  onChanged: (value) {
                    final validValue = value
                        .replaceAll(RegExp(r'[^\d]'), '')
                        .replaceAll(RegExp(r'^0+'), '');
                    controller.phoneNumber.value = validValue;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Get.find<WhatsappTaskController>().getVerificationCode(),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGradientMid2, AppTheme.primaryColor],
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
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.ff6a6aColor,
            ),
          ),
        ),
        const SizedBox(height: 15),
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
    );
  }

  /// 扫码绑定内容
  Widget _buildQrBindingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 4),
        Text(
          I18nKeys.scanQrTitle.tr,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.threeColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        _buildQrCard(),
        const SizedBox(height: 12),
        // 操作区：空态显示「获取二维码」主按钮；有二维码后显示「刷新」链接按钮（冷却期灰化 + 倒计时）
        Obx(() {
          final hasQr = controller.qrCodeContent.value.isNotEmpty;
          final loading = controller.isQrLoading.value;
          final remaining = controller.qrCooldownRemaining.value;
          if (!hasQr) {
            return _buildFetchQrButton(loading: loading);
          }
          return _buildRefreshQrButton(loading: loading, remaining: remaining);
        }),
        const SizedBox(height: 14),
        _buildQrSteps(),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            I18nKeys.scanQrExpiresTip.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppTheme.nineColor),
          ),
        ),
      ],
    );
  }

  /// 空态主按钮：点击后去请求二维码
  Widget _buildFetchQrButton({required bool loading}) {
    return GestureDetector(
      onTap: loading ? null : controller.refreshQrCode,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(
                Icons.qr_code_scanner_rounded,
                size: 18,
                color: Colors.white,
              ),
            const SizedBox(width: 6),
            Text(
              I18nKeys.scanQrFetch.tr,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 刷新按钮（冷却期间灰化 + 显示剩余秒数）
  Widget _buildRefreshQrButton({
    required bool loading,
    required int remaining,
  }) {
    final disabled = loading || remaining > 0;
    final color = disabled ? AppTheme.nineColor : AppTheme.primaryColor;
    final label = remaining > 0
        ? I18nKeys.scanQrCooldown.trParams({'s': remaining.toString()})
        : I18nKeys.scanQrRefresh.tr;
    return GestureDetector(
      onTap: disabled ? null : controller.refreshQrCode,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(
                remaining > 0
                    ? Icons.timer_outlined
                    : Icons.refresh_rounded,
                size: 16,
                color: color,
              ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 二维码卡片（柔和渐变 + 四角扫描线装饰）
  ///
  /// 支持渲染三种来源的二维码：
  /// 1. 后端返回的 `data:image/...;base64,xxx` 或纯 base64 → 用 `Image.memory`
  /// 2. 后端返回的 http(s) URL → 用 `Image.network`
  /// 3. 普通可编码字符串（兜底） → 用 `QrImageView`
  Widget _buildQrCard() {
    const double qrSize = 200;
    const double cardPadding = 20;
    return Container(
      padding: const EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.06),
            Colors.white,
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: qrSize,
        height: qrSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Obx(() {
              final content = controller.qrCodeContent.value;
              final loading = controller.isQrLoading.value;
              if (loading) {
                return const _QrStateView(
                  icon: Icons.hourglass_top_rounded,
                  showSpinner: true,
                );
              }
              if (content.isEmpty) {
                return _QrStateView(
                  icon: Icons.qr_code_2_rounded,
                  text: I18nKeys.scanQrTapToFetch.tr,
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildQrVisual(content, qrSize),
              );
            }),
            // 四角扫描框装饰
            const Positioned.fill(child: _QrCornerDecor()),
          ],
        ),
      ),
    );
  }

  /// 依据后端返回内容选择合适的渲染方式
  ///
  /// - `data:image/...;base64,xxx` → 解析 dataURI 后用 `Image.memory`
  /// - 纯 base64（长字符串 + 仅 base64 字符集） → `Image.memory`
  /// - http(s) 链接 → `Image.network`
  /// - 其它 → 兜底走 `QrImageView`
  Widget _buildQrVisual(String content, double size) {
    final trimmed = content.trim();

    // 情况 1：data URI
    if (trimmed.startsWith('data:image')) {
      final commaIdx = trimmed.indexOf(',');
      final payload = commaIdx >= 0 ? trimmed.substring(commaIdx + 1) : trimmed;
      final bytes = _tryDecodeBase64(payload);
      if (bytes != null) {
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _buildQrFallbackError(size),
        );
      }
    }

    // 情况 2：http(s) URL
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Image.network(
        trimmed,
        width: size,
        height: size,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const _QrStateView(
            icon: Icons.hourglass_top_rounded,
            showSpinner: true,
          );
        },
        errorBuilder: (_, __, ___) => _buildQrFallbackError(size),
      );
    }

    // 情况 3：疑似 base64 纯字符串（避免长文本被误当作 QR 内容重编码）
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/=\s]+$');
    if (trimmed.length > 120 && base64Pattern.hasMatch(trimmed)) {
      final bytes = _tryDecodeBase64(trimmed.replaceAll(RegExp(r'\s'), ''));
      if (bytes != null) {
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _buildQrFallbackError(size),
        );
      }
    }

    // 情况 4：普通字符串，按二维码内容本地编码生成
    return QrImageView(
      data: trimmed,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: AppTheme.threeColor,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: AppTheme.threeColor,
      ),
    );
  }

  Uint8List? _tryDecodeBase64(String raw) {
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  Widget _buildQrFallbackError(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: _QrStateView(
        icon: Icons.broken_image_rounded,
        text: I18nKeys.scanQrUnavailable.tr,
      ),
    );
  }

  /// 扫码 3 步引导
  Widget _buildQrSteps() {
    final steps = <String>[
      I18nKeys.scanQrStep1.tr,
      I18nKeys.scanQrStep2.tr,
      I18nKeys.scanQrStep3.tr,
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    steps[index],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.sixColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
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
                          // GetPlatform.isWeb
                          //     ? Row(
                          //         children: List.generate(3, (i) {
                          //           return Icon(
                          //             Icons.star,
                          //             size: 14,
                          //             color: i < (onlineNumber.rating ?? 0)
                          //                 ? Colors.orange
                          //                 : Colors.grey.shade300,
                          //           );
                          //         }),
                          //       )
                          //     :
                          GestureDetector(
                            onTap: () {
                              if (onlineNumber.canSendMsg == false) {
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(I18nKeys.newTask.tr),
                                    content: Text(I18nKeys.confirmSend.tr),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(I18nKeys.cancel.tr),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.sendWhatsAppMessage(
                                            onlineNumber.id ?? '',
                                          );
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
                                color: onlineNumber.canSendMsg == false
                                    ? Colors.grey.shade300
                                    : null,
                                gradient: onlineNumber.canSendMsg == false
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          AppTheme.primaryGradientMid2,
                                          AppTheme.primaryColor,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                I18nKeys.send.tr,
                                style: TextStyle(
                                  color: Colors.white,
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

/// 二维码占位态（加载 / 不可用）
class _QrStateView extends StatelessWidget {
  const _QrStateView({
    required this.icon,
    this.text,
    this.showSpinner = false,
  });

  final IconData icon;
  final String? text;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showSpinner)
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppTheme.primaryColor,
            ),
          )
        else
          Icon(icon, size: 46, color: AppTheme.nineColor),
        if (text != null) ...[
          const SizedBox(height: 10),
          Text(
            text!,
            style: const TextStyle(fontSize: 12, color: AppTheme.nineColor),
          ),
        ],
      ],
    );
  }
}

/// 二维码四角扫描线装饰
class _QrCornerDecor extends StatelessWidget {
  const _QrCornerDecor();

  @override
  Widget build(BuildContext context) {
    const Color color = AppTheme.primaryColor;
    const double len = 16;
    const double thickness = 2.5;
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -6,
            top: -6,
            child: _corner(color, thickness, len, topLeft: true),
          ),
          Positioned(
            right: -6,
            top: -6,
            child: _corner(color, thickness, len, topRight: true),
          ),
          Positioned(
            left: -6,
            bottom: -6,
            child: _corner(color, thickness, len, bottomLeft: true),
          ),
          Positioned(
            right: -6,
            bottom: -6,
            child: _corner(color, thickness, len, bottomRight: true),
          ),
        ],
      ),
    );
  }

  Widget _corner(
    Color color,
    double thickness,
    double len, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    BorderSide side(bool active) => active
        ? BorderSide(color: color, width: thickness)
        : BorderSide.none;
    return SizedBox(
      width: len,
      height: len,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: side(topLeft || topRight),
            left: side(topLeft || bottomLeft),
            right: side(topRight || bottomRight),
            bottom: side(bottomLeft || bottomRight),
          ),
          borderRadius: BorderRadius.only(
            topLeft: topLeft ? const Radius.circular(6) : Radius.zero,
            topRight: topRight ? const Radius.circular(6) : Radius.zero,
            bottomLeft: bottomLeft ? const Radius.circular(6) : Radius.zero,
            bottomRight: bottomRight ? const Radius.circular(6) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
