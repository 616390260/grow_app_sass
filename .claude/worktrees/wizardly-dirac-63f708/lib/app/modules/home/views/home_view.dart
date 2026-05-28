import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/services/tenant_config_service.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/home/controllers/home_controller.dart';
import 'package:do_task_project/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/feature_card_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/task_card_widget.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => null;

  @override
  Widget buildContent(BuildContext context) {
    // 设置沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF477DF2), // #477DF2
            Color(0xFF47ABF2), // #47ABF2
            Color(0xFFF2F5FA), // #F2F5FA
          ],
          stops: [0.0, 0.2, 0.4],
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(() {
              final pa = controller.popupAnnouncement.value;
              if (pa != null && !controller.hasPopupShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showPopup(context, pa);
                  controller.markPopupShown();
                });
              }
              return const SizedBox.shrink();
            }),
            // 添加状态栏高度的间距
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildHeader(),
            _buildStatisticsCards(),
            // 使用Obx包装BannerCarouselWidget以响应数据变化
            Obx(() {
              return BannerCarouselWidget(
                bannerImages: controller.announcements
                    .map((banner) => banner.image ?? '')
                    .where((image) => image.isNotEmpty)
                    .toList(),
                onBannerTap: (index) {
                  controller.onBannerTap(index);
                },
              );
            }),
            _buildRecommendedTasks(),
            const SizedBox(height: 55),
          ],
        ),
      ),
    );
  }

  /// 构建头部信息
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          // 应用图标（优先使用租户配置 brand_logo，缺省时回落到本地 logo）
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(() {
              final url = TenantConfigService.to.brandLogo;
              Widget fallback() => Image.asset(
                    ImageAssets.logo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
              if (url == null || url.isEmpty) return fallback();
              return CachedNetworkImage(
                imageUrl: url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback(),
                errorWidget: (_, __, ___) => fallback(),
              );
            }),
          ),
          const SizedBox(width: 14),
          // 应用名称
          GestureDetector(
            onTap: controller.onVipDetailsTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18nKeys.appTitle.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => VipBadge(
                    text: controller.vipLevel.value.isEmpty
                        ? 'VIP0'
                        : controller.vipLevel.value,
                    textBackgroundColor: const Color(0xFFA7C3FF),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (kIsWeb) ...[
            // 下载APP按钮
            GestureDetector(
              onTap: controller.onDownloadAppTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      ImageAssets.homeDownload,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      I18nKeys.downloadApp.tr,
                      style: const TextStyle(
                        color: AppTheme.loginColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部三项统计
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.accountBalance.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        I18nKeys.accountBalance.tr,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.dailyEarnings.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        I18nKeys.todayEarnings.tr,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.promotionEarnings.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        I18nKeys.todayPromotionEarnings.tr,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 21),
          // 下方两项快捷功能
          Row(
            children: [
              Expanded(
                child: FeatureCardWidget(
                  title: 'lucky_wheel'.tr,
                  iconPath: ImageAssets.homeWheel,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCEDEFF), Color(0xFFF0F5FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onLuckyWheelTap,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: FeatureCardWidget(
                  title: 'sign_in_calendar'.tr,
                  iconPath: ImageAssets.homeSign,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFDFD5), Color(0xFFFFF6F3)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onSignInCalendarTap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              // if (!kIsWeb) ...[
              //   Expanded(
              //     child: FeatureCardWidget(
              //       title: I18nKeys.callCenter.tr,
              //       iconPath: ImageAssets.homePhone,
              //       gradient: const LinearGradient(
              //         colors: [Color(0xFFA6EFD1), Color(0xFFE2FAF1)],
              //         begin: Alignment.centerLeft,
              //         end: Alignment.centerRight,
              //       ),
              //       onTap: controller.onCallCenterTap,
              //     ),
              //   ),
              //   const SizedBox(width: 18),
              // ],
              Expanded(
                child: FeatureCardWidget(
                  title: I18nKeys.inviteFriend.tr,
                  iconPath: ImageAssets.homeInvite,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE4C0), Color(0xFFFFF2E0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onInviteFriendTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建推荐任务
  Widget _buildRecommendedTasks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.only(left: 12, top: 17, right: 14, bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.recommendedTasks.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 13),
          // 使用Obx包装ListView以响应数据变化
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recommendTasks.length,
              itemBuilder: (context, index) {
                final task = controller.recommendTasks[index];
                return TaskCardWidget(
                  title: task.title ?? '',
                  description: task.description ?? '',
                  buttonText: I18nKeys.startTask.tr,
                  onTap: () => controller.onRecommendTaskTap(index),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

// 解析HTML内容为TextSpan
TextSpan _parseHtmlToTextSpan(String html, TextStyle defaultStyle) {
  try {
    final document = htmlParser.parse(html);
    final children = document.body?.children ?? [];
    final spans = <TextSpan>[];

    if (children.isEmpty) {
      // 如果没有HTML标签，直接返回普通文本
      return TextSpan(text: document.body?.text ?? html, style: defaultStyle);
    }

    for (var element in children) {
      spans.add(_parseElement(element, defaultStyle));
    }

    return TextSpan(children: spans);
  } catch (e) {
    // 如果解析失败，返回原始文本
    return TextSpan(text: html, style: defaultStyle);
  }
}

// 解析单个HTML元素
TextSpan _parseElement(var element, TextStyle baseStyle) {
  TextStyle style = baseStyle;
  String text = element.text ?? '';

  // 处理常见的格式化标签
  if (element.localName == 'strong' || element.localName == 'b') {
    style = style.copyWith(fontWeight: FontWeight.bold);
  } else if (element.localName == 'em' || element.localName == 'i') {
    style = style.copyWith(fontStyle: FontStyle.italic);
  } else if (element.localName == 'u') {
    style = style.copyWith(decoration: TextDecoration.underline);
  } else if (element.localName == 's' || element.localName == 'strike') {
    style = style.copyWith(decoration: TextDecoration.lineThrough);
  }

  return TextSpan(text: text, style: style);
}

void _showPopup(BuildContext context, PopupAnnouncementModel pa) {
  Get.dialog(
    Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.82,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.only(
          left: 19,
          top: 11,
          right: 19,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 关闭按钮 - 靠右对齐
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {
                    Get.back(),
                    Get.find<HomeController>().markPopupClose(),
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppTheme.nineColor,
                  ),
                ),
              ],
            ),

            // 标题 - 左对齐
            Center(
              child: (pa.titleIsRichText == '1')
                  ? RichText(
                      text: _parseHtmlToTextSpan(
                        pa.title ?? '',
                        const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.threeColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  : RichText(
                      text: TextSpan(
                        text: pa.title ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.threeColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            const SizedBox(height: 16),
            // 内容 - 左对齐
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: (pa.contentIsRichText == '1')
                      ? RichText(
                          text: _parseHtmlToTextSpan(
                            pa.content ?? '',
                            const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.sixColor,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        )
                      : Text(
                          pa.content ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.sixColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
