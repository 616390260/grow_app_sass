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
            clipBehavior: Clip.antiAlias,
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
              // 图片型教程：服务器返回的是图片 URL / data URI
              if (controller.mediaKind.value == 'image' &&
                  controller.tutorialImageUrl.value.isNotEmpty) {
                return SizedBox(
                  width: double.infinity,
                  height: WhatsappTaskController.kTutorialMediaHeight,
                  child: _buildTutorialImage(
                    controller.tutorialImageUrl.value,
                  ),
                );
              }

              // 视频型教程：已就绪，渲染 Chewie + 播放覆盖层
              if (controller.isVideoInitialized.value &&
                  controller.chewieController != null) {
                return SizedBox(
                  width: double.infinity,
                  height: WhatsappTaskController.kTutorialMediaHeight,
                  child: Stack(
                    children: [
                      Chewie(controller: controller.chewieController!),
                      Center(
                        child: AnimatedOpacity(
                          opacity: controller.isPlaying.value ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: InkWell(
                            onTap: controller.togglePlayPause,
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
                      Positioned.fill(
                        child: InkWell(onTap: controller.togglePlayPause),
                      ),
                    ],
                  ),
                );
              }

              // 视频加载结束但不可用：展示「视频不可用」占位，避免永远转圈。
              if (controller.videoLoadFinished.value) {
                return Container(
                  height: WhatsappTaskController.kTutorialMediaHeight,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off_outlined,
                        size: 40,
                        color: AppTheme.nineColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        I18nKeys.videoUnavailable.tr,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 加载中占位
              return Container(
                height: WhatsappTaskController.kTutorialMediaHeight,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      I18nKeys.videoLoading.tr,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 渲染教程图片：支持 `data:image/...;base64,...` 与普通 http(s) 网络图。
  Widget _buildTutorialImage(String src) {
    final trimmed = src.trim();
    if (trimmed.startsWith('data:image/')) {
      try {
        final comma = trimmed.indexOf(',');
        final b64 = comma >= 0 ? trimmed.substring(comma + 1) : trimmed;
        final bytes = base64Decode(b64);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {
        return _buildImagePlaceholder();
      }
    }
    return Image.network(
      trimmed,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 36,
            color: AppTheme.nineColor,
          ),
          const SizedBox(height: 6),
          Text(
            I18nKeys.videoUnavailable.tr,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
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
                  style: TextStyle(
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
              style: TextStyle(
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
            ],
          ),
          const SizedBox(height: 16),
          _buildBindModeTabs(),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.bindMode.value == 'qr') {
              return _buildQrBindPanel();
            }
            return _buildCodeBindPanel(context);
          }),
        ],
      ),
    );
  }

  /// 绑定方式切换 Tab：验证码绑定 / 扫码绑定。
  Widget _buildBindModeTabs() {
    return Obx(() {
      final mode = controller.bindMode.value;
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.f9f9f9Color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.dddColor, width: 0.5),
        ),
        child: Row(
          children: [
            _buildBindModeTab(I18nKeys.bindMethodCode.tr, 'code', mode),
            _buildBindModeTab(I18nKeys.bindMethodQr.tr, 'qr', mode),
          ],
        ),
      );
    });
  }

  Widget _buildBindModeTab(String label, String value, String current) {
    final selected = current == value;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.setBindMode(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: selected ? AppTheme.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(17),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : AppTheme.sixColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 验证码绑定面板（原有逻辑，仅迁移到独立方法）。
  Widget _buildCodeBindPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      // 过滤非数字字符，并移除开头的所有0
                      final validValue = value
                          .replaceAll(RegExp(r'[^\d]'), '')
                          .replaceAll(RegExp(r'^0+'), '');
                      controller.phoneNumber.value = validValue;
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
                gradient: LinearGradient(
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
      );
  }

  // —— 扫码绑定面板尺寸规范（保持一处改全局生效） ——
  static const double _kQrFrameSize = 232;
  static const double _kQrCodeSize = 188;
  static const double _kQrCornerSize = 22;
  static const double _kQrCornerThickness = 3;

  /// 扫码绑定面板：标题 + 扫描框（带四角定位标）+ 过期提示 + 步骤 + 刷新/获取按钮。
  Widget _buildQrBindPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            I18nKeys.scanQrTitle.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.threeColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: _buildQrScanFrame()),
        const SizedBox(height: 12),
        Center(
          child: Obx(() {
            final cd = controller.qrCooldownRemaining.value;
            if (cd > 0 && controller.qrCodeContent.value.isNotEmpty) {
              return _buildCountdownPill(cd);
            }
            return Text(
              I18nKeys.scanQrExpiresTip.tr,
              style: const TextStyle(fontSize: 11, color: AppTheme.nineColor),
            );
          }),
        ),
        const SizedBox(height: 20),
        _buildQrSteps(),
        const SizedBox(height: 20),
        _buildQrRefreshButton(),
      ],
    );
  }

  /// 扫描框：白色底 + 四角定位标 + 内部 QR / 占位。
  Widget _buildQrScanFrame() {
    return Container(
      width: _kQrFrameSize,
      height: _kQrFrameSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dddColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: _kQrCodeSize,
              height: _kQrCodeSize,
              child: Obx(() => _buildQrCodeDisplay()),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: _QrCornerMark(
              color: AppTheme.primaryColor,
              size: _kQrCornerSize,
              thickness: _kQrCornerThickness,
              position: _QrCornerPosition.topLeft,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: _QrCornerMark(
              color: AppTheme.primaryColor,
              size: _kQrCornerSize,
              thickness: _kQrCornerThickness,
              position: _QrCornerPosition.topRight,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: _QrCornerMark(
              color: AppTheme.primaryColor,
              size: _kQrCornerSize,
              thickness: _kQrCornerThickness,
              position: _QrCornerPosition.bottomLeft,
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: _QrCornerMark(
              color: AppTheme.primaryColor,
              size: _kQrCornerSize,
              thickness: _kQrCornerThickness,
              position: _QrCornerPosition.bottomRight,
            ),
          ),
        ],
      ),
    );
  }

  /// 冷却中的胶囊小标签：强调"还剩多少秒可刷新"。
  Widget _buildCountdownPill(int remainingSeconds) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            I18nKeys.scanQrCooldown.trParams({
              's': remainingSeconds.toString(),
            }),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 根据 [WhatsappTaskController.qrCodeContent] 决定渲染方式：
  /// - 空：提示点击下方按钮获取
  /// - `data:image/...;base64,`：内嵌图片
  /// - http(s) 图片 URL：网络图
  /// - 其它：用 QrImageView 直接生成二维码
  Widget _buildQrCodeDisplay() {
    if (controller.isQrLoading.value) {
      return Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }
    final content = controller.qrCodeContent.value.trim();
    if (content.isEmpty) {
      return _qrEmptyStatePlaceholder();
    }

    if (content.startsWith('data:image/')) {
      try {
        final comma = content.indexOf(',');
        final b64 = comma >= 0 ? content.substring(comma + 1) : content;
        return Image.memory(base64Decode(b64), fit: BoxFit.contain);
      } catch (_) {
        return _qrUnavailablePlaceholder();
      }
    }

    final lower = content.toLowerCase();
    final isImageUrl =
        (lower.startsWith('http://') || lower.startsWith('https://')) &&
            (lower.endsWith('.png') ||
                lower.endsWith('.jpg') ||
                lower.endsWith('.jpeg') ||
                lower.endsWith('.webp') ||
                lower.endsWith('.gif'));
    if (isImageUrl) {
      return Image.network(
        content,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _qrUnavailablePlaceholder(),
      );
    }

    return QrImageView(
      data: content,
      version: QrVersions.auto,
      size: _kQrCodeSize,
      backgroundColor: Colors.white,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: AppTheme.threeColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: AppTheme.threeColor,
      ),
      errorStateBuilder: (_, __) => _qrUnavailablePlaceholder(),
    );
  }

  Widget _qrEmptyStatePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: 28,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              I18nKeys.scanQrTapToFetch.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppTheme.sixColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrUnavailablePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2_outlined,
            size: 36,
            color: AppTheme.nineColor,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              I18nKeys.scanQrUnavailable.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppTheme.nineColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrSteps() {
    final steps = <String>[
      I18nKeys.scanQrStep1.tr,
      I18nKeys.scanQrStep2.tr,
      I18nKeys.scanQrStep3.tr,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.f9f9f9Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          final isLast = i == steps.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 1, right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withValues(alpha: 0.14),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    steps[i],
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppTheme.sixColor,
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

  Widget _buildQrRefreshButton() {
    return Obx(() {
      final loading = controller.isQrLoading.value;
      final cooldown = controller.qrCooldownRemaining.value;
      final hasContent = controller.qrCodeContent.value.isNotEmpty;
      final disabled = loading || cooldown > 0;

      final String label;
      final IconData icon;
      if (loading) {
        label = I18nKeys.videoLoading.tr;
        icon = Icons.refresh_rounded;
      } else if (cooldown > 0) {
        label = I18nKeys.scanQrCooldown.trParams({'s': cooldown.toString()});
        icon = Icons.timer_outlined;
      } else if (hasContent) {
        label = I18nKeys.scanQrRefresh.tr;
        icon = Icons.refresh_rounded;
      } else {
        label = I18nKeys.scanQrFetch.tr;
        icon = Icons.qr_code_rounded;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: MouseRegion(
          cursor: disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: disabled ? null : controller.refreshQrCode,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 46,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: disabled
                    ? null
                    : LinearGradient(
                        colors: [
                          AppTheme.primaryGradientMid2,
                          AppTheme.primaryColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: disabled
                    ? AppTheme.primaryColor.withValues(alpha: 0.35)
                    : null,
                borderRadius: BorderRadius.circular(23),
                boxShadow: disabled
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 18, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
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
                                    : LinearGradient(
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

/// 扫描框四角定位标的朝向。
enum _QrCornerPosition { topLeft, topRight, bottomLeft, bottomRight }

/// 扫描器风格的 L 形角标：用 [CustomPaint] 画两条短线构成 "⌐" 形。
/// 不做连续动画（遵循 ui-ux-pro-max：装饰性元素避免 infinite animation）。
class _QrCornerMark extends StatelessWidget {
  const _QrCornerMark({
    required this.color,
    required this.size,
    required this.thickness,
    required this.position,
  });

  final Color color;
  final double size;
  final double thickness;
  final _QrCornerPosition position;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _QrCornerPainter(
          color: color,
          thickness: thickness,
          position: position,
        ),
      ),
    );
  }
}

class _QrCornerPainter extends CustomPainter {
  _QrCornerPainter({
    required this.color,
    required this.thickness,
    required this.position,
  });

  final Color color;
  final double thickness;
  final _QrCornerPosition position;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    switch (position) {
      case _QrCornerPosition.topLeft:
        canvas.drawLine(Offset(0, thickness / 2), Offset(w, thickness / 2), paint);
        canvas.drawLine(Offset(thickness / 2, 0), Offset(thickness / 2, h), paint);
        break;
      case _QrCornerPosition.topRight:
        canvas.drawLine(Offset(0, thickness / 2), Offset(w, thickness / 2), paint);
        canvas.drawLine(Offset(w - thickness / 2, 0), Offset(w - thickness / 2, h), paint);
        break;
      case _QrCornerPosition.bottomLeft:
        canvas.drawLine(Offset(0, h - thickness / 2), Offset(w, h - thickness / 2), paint);
        canvas.drawLine(Offset(thickness / 2, 0), Offset(thickness / 2, h), paint);
        break;
      case _QrCornerPosition.bottomRight:
        canvas.drawLine(Offset(0, h - thickness / 2), Offset(w, h - thickness / 2), paint);
        canvas.drawLine(Offset(w - thickness / 2, 0), Offset(w - thickness / 2, h), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _QrCornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.position != position;
}
