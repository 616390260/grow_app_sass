import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/home/controllers/home_controller.dart';
import 'package:do_task_project/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/feature_card_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/task_card_widget.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'package:do_task_project/app/data/models/activity_model.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/widgets/rich_html_text.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});

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
            AppTheme.primaryColor,
            AppTheme.primaryGradientMid,
            AppTheme.primaryLightest,
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
            // _buildCompactCountdown(),
            // const SizedBox(height: 8),
            // _buildHotActivities(),
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
          // 应用图标
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              ImageAssets.logo,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
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
                  color: AppTheme.primaryBorder,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      ImageAssets.homeDownload,
                      width: 14,
                      height: 14,
                      color: AppTheme.primaryColor,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      I18nKeys.downloadApp.tr,
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
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGradientMid.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                          color: AppTheme.primaryColor,
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
                          color: AppTheme.primaryColor,
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
                          color: AppTheme.primaryColor,
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
          // 三项快捷功能一排
          Row(
            children: [
              Expanded(
                child: FeatureCardWidget(
                  title: 'lucky_wheel'.tr,
                  iconPath: ImageAssets.homeWheel,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGradientLight, AppTheme.primaryBorder],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onLuckyWheelTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FeatureCardWidget(
                  title: 'sign_in_calendar'.tr,
                  iconPath: ImageAssets.homeSign,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGradientMid2, AppTheme.primaryLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onSignInCalendarTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FeatureCardWidget(
                  title: I18nKeys.inviteFriend.tr,
                  iconPath: ImageAssets.homeInvite,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGradientMid, AppTheme.primaryGradientLight],
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
      padding: const EdgeInsets.only(left: 12, top: 17, right: 14, bottom: 9),
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

  /// 紧凑型倒计时条（单行，极小占位）
  // ignore: unused_element
  Widget _buildCompactCountdown() {
    return Obx(() {
      final text = controller.midnightCountdownText.value;
      final tz = controller.activityTimezone.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.primarySurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.primaryBorder, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_top_rounded,
              size: 13,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 5),
            Text(
              I18nKeys.activityMidnightCountdownLabel.tr,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.sixColor,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
                letterSpacing: 1,
              ),
            ),
            if (tz.isNotEmpty) ...[
              const Spacer(),
              Icon(Icons.public_rounded, size: 11, color: AppTheme.nineColor),
              const SizedBox(width: 3),
              Text(
                tz,
                style: const TextStyle(fontSize: 11, color: AppTheme.nineColor),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// 构建热门活动（可展开，支持领取）
  // ignore: unused_element
  Widget _buildHotActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Text(
                I18nKeys.hotActivities.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF4D4F), Color(0xFFFF7875)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'HOT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final data = controller.activityData.value;
            if (data == null) return const SizedBox.shrink();
            return Column(
              children: [
                if (data.taskActivity != null)
                  _buildHomeActivityCard(
                    cardKey: 'task',
                    group: data.taskActivity!,
                    accentColor: AppTheme.primaryColor,
                    iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png',
                    title: I18nKeys.dailyTaskBonusTitle.tr,
                    subtitle: I18nKeys.dailyTaskBonusSubtitle.tr,
                    milestoneUnit: I18nKeys.activityTaskUnit.tr,
                    milestoneIcon: Icons.check_circle_outline_rounded,
                    onNavigate: () => Get.toNamed(Routes.tasks),
                  ),
                if (data.commissionActivity != null) ...[
                  const SizedBox(height: 12),
                  _buildHomeActivityCard(
                    cardKey: 'commission',
                    group: data.commissionActivity!,
                    accentColor: const Color(0xFFB84A00),
                    iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Money%20bag/3D/money_bag_3d.png',
                    title: I18nKeys.commissionBonusTitle.tr,
                    subtitle: I18nKeys.commissionBonusSubtitle.tr,
                    milestoneUnit: I18nKeys.activityGoalUnit.tr,
                    milestoneIcon: Icons.stars_rounded,
                    onNavigate: () => Get.toNamed(Routes.promotion),
                  ),
                ],
                if (data.subordinateActivity != null) ...[
                  const SizedBox(height: 12),
                  _buildHomeActivityCard(
                    cardKey: 'subordinate',
                    group: data.subordinateActivity!,
                    accentColor: const Color(0xFF2E7D32),
                    iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Handshake/3D/handshake_3d.png',
                    title: I18nKeys.subordinateBonusTitle.tr,
                    subtitle: I18nKeys.subordinateBonusSubtitle.tr,
                    milestoneUnit: I18nKeys.activityMemberUnit.tr,
                    milestoneIcon: Icons.people_outline_rounded,
                    onNavigate: () => Get.toNamed(Routes.promotion),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHomeActivityCard({
    required String cardKey,
    required ActivityGroup group,
    required Color accentColor,
    required String iconUrl,
    required String title,
    required String subtitle,
    required String milestoneUnit,
    required IconData milestoneIcon,
    required VoidCallback onNavigate,
  }) {
    return Obx(() {
      final isExpanded = controller.isCardExpanded(cardKey);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：左侧点击展开，右侧按钮跳转
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        iconUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.emoji_events_rounded,
                          size: 28,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 标题+副标题（点击展开）
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.toggleCard(cardKey),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 跳转按钮（在展开箭头前面）
                  InkWell(
                    onTap: onNavigate,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // 展开/收起箭头
                  InkWell(
                    onTap: () => controller.toggleCard(cardKey),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 可折叠内容区
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...group.items.asMap().entries.map((entry) {
                          return Column(
                            children: [
                              if (entry.key > 0) const SizedBox(height: 8),
                              _buildHomeMilestoneRow(
                                item: entry.value,
                                accentColor: accentColor,
                                milestoneUnit: milestoneUnit,
                                milestoneIcon: milestoneIcon,
                                otherClaimed: group.isSingleClaim &&
                                    group.isGroupClaimed &&
                                    !entry.value.claimed,
                              ),
                            ],
                          );
                        }),
                        if (group.description != null && group.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_rounded, size: 16, color: accentColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    group.description!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2C2C2C),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHomeMilestoneRow({
    required ActivityItem item,
    required Color accentColor,
    required String milestoneUnit,
    required IconData milestoneIcon,
    bool otherClaimed = false,
  }) {
    final isReached = item.currentCount >= item.needCount;
    final iconColor = isReached ? accentColor : Colors.grey[400]!;
    final iconBg = isReached
        ? accentColor.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.07);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(milestoneIcon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${item.needCount} $milestoneUnit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
              ),
              _buildHomePointsBadge(item, accentColor),
            ],
          ),
          const SizedBox(height: 8),
          _buildHomeProgressBar(item.progress, accentColor),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${item.currentCount} / ${item.needCount}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const Spacer(),
              Obx(() {
                final isClaiming = controller.claimingId.value == item.id;
                return SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: (!otherClaimed && item.canClaim && !isClaiming)
                        ? () => controller.claim(item.id)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.claimed
                          ? const Color(0xFF2E7D32)
                          : accentColor,
                      disabledBackgroundColor: accentColor.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: isClaiming
                        ? SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          )
                        : Text(
                            item.claimed
                                ? I18nKeys.activityClaimed.tr
                                : otherClaimed
                                ? I18nKeys.activityNotClaimable.tr
                                : item.canClaim
                                ? I18nKeys.activityClaim.tr
                                : I18nKeys.activityNotReached.tr,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomePointsBadge(ActivityItem item, Color accentColor) {
    final text = I18nKeys.activityPoints.tr.replaceAll('@points', '${item.rewardPoints}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: accentColor),
      ),
    );
  }

  Widget _buildHomeProgressBar(double progress, Color accentColor) {
    final endColor = accentColor == AppTheme.primaryColor
        ? const Color(0xFF64B5F6)
        : accentColor == const Color(0xFFB84A00)
        ? const Color(0xFFFFAB76)
        : const Color(0xFF81C784);

    return Container(
      height: 12,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fillWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
            return Stack(
              children: [
                Container(width: double.infinity, color: const Color(0xFFE8ECF0)),
                Container(
                  width: fillWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [accentColor, endColor]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
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
                  ? RichHtmlText(
                      html: pa.title ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.threeColor,
                        decoration: TextDecoration.none,
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
                      ? RichHtmlText(
                          html: pa.content ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.sixColor,
                            decoration: TextDecoration.none,
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
