import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/data/models/activity_model.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'package:do_task_project/app/modules/home/controllers/home_controller.dart';
import 'package:do_task_project/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlParser;

/// WorkGo 品牌首页 —— 主题色跟随租户 brandColor 配置
class WorkgoHomeView extends BaseView<HomeController> {
  const WorkgoHomeView({super.key});

  // ── 主题色：跟随 AppTheme（由 brandColor 动态生成） ──────────

  static Color get _primary => AppTheme.primaryColor;
  static Color get _bgPrimary => AppTheme.primaryColor;
  static Color get _bgGradientMid => AppTheme.primaryGradientMid;
  static Color get _pageBg => AppTheme.primaryLightest;
  static Color get _iconCircleBg => AppTheme.primarySurface;
  static Color get _iconCircleColor => AppTheme.primaryColor;
  static Color get _cardBorder => AppTheme.primaryBorder;

  // ── 中性色 ──────────
  static const _textDark = Color(0xFF1A1C2E);
  static const _textGray = Color(0xFF999999);
  static const _textMuted = Color(0xFF666666);

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => null;

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    final statusBarH = MediaQuery.of(context).padding.top;
    // 弧形背景止于统计卡片上沿附近，不能超出卡片两侧
    final arcHeight = 180.0 + statusBarH;

    return Container(
      color: _pageBg,
      child: Stack(
        children: [
          // ── 弧形深色背景 ──
          ClipPath(
            clipper: _ArcClipper(),
            child: Container(
              height: arcHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_bgPrimary, _bgGradientMid],
                ),
              ),
            ),
          ),
          // ── 滚动内容 ──
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // 弹窗公告监听
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
                SizedBox(height: statusBarH),
                _buildHeader(),
                _buildStatisticsCard(),
                const SizedBox(height: 12),
                _buildFeatureButtons(),
                // Banner 轮播
                Obx(() {
                  return BannerCarouselWidget(
                    bannerImages: controller.announcements
                        .map((b) => b.image ?? '')
                        .where((img) => img.isNotEmpty)
                        .toList(),
                    onBannerTap: (index) => controller.onBannerTap(index),
                  );
                }),
                if (TenantService.to.activityEnabled) _buildCompactCountdown(),
                if (TenantService.to.activityEnabled)
                  const SizedBox(height: 8),
                if (TenantService.to.activityEnabled) _buildHotActivities(),
                const SizedBox(height: 55),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  Header: Logo + 品牌名 + VIP 徽章 + 下载按钮
  // ═══════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TenantService.to.brandLogo != null
                ? Image.network(
                    TenantService.to.brandLogo!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      ImageAssets.logo,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    ImageAssets.logo,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: TenantService.to.vipEnabled
                ? controller.onVipDetailsTap
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TenantService.to.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (TenantService.to.vipEnabled) ...[
                  const SizedBox(height: 3),
                  Obx(
                    () => VipBadge(
                      text: controller.vipLevel.value.isEmpty
                          ? 'VIP0'
                          : controller.vipLevel.value,
                      textBackgroundColor: const Color(0xFFA7C3FF),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          if (kIsWeb)
            GestureDetector(
              onTap: controller.onDownloadAppTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  I18nKeys.downloadApp.tr,
                  style: TextStyle(
                    color: _primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  统计区域
  // ═══════════════════════════════════════════════

  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatColumn(
                icon: Icons.account_balance_wallet_rounded,
                label: I18nKeys.accountBalance.tr,
                value: controller.accountBalance.value.toString(),
              ),
            ),
            Expanded(
              child: _buildStatColumn(
                icon: Icons.currency_rupee_rounded,
                label: I18nKeys.todayEarnings.tr,
                value: controller.dailyEarnings.value.toString(),
              ),
            ),
            Expanded(
              child: _buildStatColumn(
                icon: Icons.currency_yen_rounded,
                label: I18nKeys.todayPromotionEarnings.tr,
                value: controller.promotionEarnings.value.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 单个统计列: icon → label → number → description
  Widget _buildStatColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _iconCircleBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: _iconCircleColor),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: _textGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: _textGray,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  功能按钮行: Lucky Spin / Daily Check-in / Invite Friends
  // ═══════════════════════════════════════════════

  Widget _buildFeatureButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildPillButton(
              label: 'lucky_wheel'.tr,
              emoji: '🎯',
              onTap: controller.onLuckyWheelTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildPillButton(
              label: 'sign_in_calendar'.tr,
              emoji: '📋',
              onTap: controller.onSignInCalendarTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildPillButton(
              label: I18nKeys.inviteFriend.tr,
              emoji: '👋',
              onTap: controller.onInviteFriendTap,
            ),
          ),
        ],
      ),
    );
  }

  /// 胶囊按钮
  Widget _buildPillButton({
    required String label,
    required String emoji,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  倒计时条
  // ═══════════════════════════════════════════════

  Widget _buildCompactCountdown() {
    return Obx(() {
      final text = controller.midnightCountdownText.value;
      final tz = controller.activityTimezone.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_top_rounded,
              size: 14,
              color: _primary,
            ),
            const SizedBox(width: 5),
            Text(
              I18nKeys.activityMidnightCountdownLabel.tr,
              style: const TextStyle(fontSize: 12, color: _textMuted),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _primary,
                letterSpacing: 1,
              ),
            ),
            if (tz.isNotEmpty) ...[
              const Spacer(),
              const Icon(Icons.public_rounded, size: 11, color: _textGray),
              const SizedBox(width: 3),
              Text(
                tz,
                style: const TextStyle(fontSize: 11, color: _textGray),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  //  热门活动
  // ═══════════════════════════════════════════════

  Widget _buildHotActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Text(
                'Hot Activities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
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
                  _buildActivityCard(
                    cardKey: 'task',
                    group: data.taskActivity!,
                    accentColor: _primary,
                    iconUrl:
                        'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png',
                    title: I18nKeys.dailyTaskBonusTitle.tr,
                    subtitle: I18nKeys.dailyTaskBonusSubtitle.tr,
                    milestoneUnit: I18nKeys.activityTaskUnit.tr,
                    milestoneIcon: Icons.check_circle_outline_rounded,
                    onNavigate: () => Get.toNamed(Routes.tasks),
                  ),
                if (data.commissionActivity != null) ...[
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    cardKey: 'commission',
                    group: data.commissionActivity!,
                    accentColor: const Color(0xFFB84A00),
                    iconUrl:
                        'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Money%20bag/3D/money_bag_3d.png',
                    title: I18nKeys.commissionBonusTitle.tr,
                    subtitle: I18nKeys.commissionBonusSubtitle.tr,
                    milestoneUnit: I18nKeys.activityGoalUnit.tr,
                    milestoneIcon: Icons.stars_rounded,
                    onNavigate: () => Get.toNamed(Routes.promotion),
                  ),
                ],
                if (data.subordinateActivity != null) ...[
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    cardKey: 'subordinate',
                    group: data.subordinateActivity!,
                    accentColor: const Color(0xFF2E7D32),
                    iconUrl:
                        'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Handshake/3D/handshake_3d.png',
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

  /// 活动卡片：图标 + 标题/副标题(点击展开) + 跳转箭头 + 展开/收起箭头
  Widget _buildActivityCard({
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部行
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _iconCircleBg,
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
                    color: _primary,
                  ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 标题 + 副标题（点击展开）
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.toggleCard(cardKey),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 跳转箭头
                  InkWell(
                    onTap: onNavigate,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withValues(alpha: 0.10),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
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
                        size: 28,
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
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...group.items.asMap().entries.map((entry) {
                          return Column(
                            children: [
                              if (entry.key > 0) const SizedBox(height: 8),
                              _buildMilestoneRow(
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
                        if (group.description != null &&
                            group.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: accentColor.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_rounded,
                                    size: 16, color: accentColor),
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
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      );
    });
  }

  /// 里程碑行
  Widget _buildMilestoneRow({
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
                decoration:
                    BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(milestoneIcon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${item.needCount} $milestoneUnit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ),
              _buildPointsBadge(item, accentColor),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(item.progress, accentColor),
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
                    onPressed:
                        (!otherClaimed && item.canClaim && !isClaiming)
                            ? () => controller.claim(item.id)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          item.claimed ? const Color(0xFF2E7D32) : accentColor,
                      disabledBackgroundColor:
                          accentColor.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700),
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

  /// 积分徽章
  Widget _buildPointsBadge(ActivityItem item, Color accentColor) {
    final text = I18nKeys.activityPoints.tr
        .replaceAll('@points', '${item.rewardPoints}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700, color: accentColor),
      ),
    );
  }

  /// 进度条
  Widget _buildProgressBar(double progress, Color accentColor) {
    final endColor = accentColor == _primary
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
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fillWidth =
                constraints.maxWidth * progress.clamp(0.0, 1.0);
            return Stack(
              children: [
                Container(
                    width: double.infinity,
                    color: const Color(0xFFE8ECF0)),
                Container(
                  width: fillWidth,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [accentColor, endColor]),
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

// ═══════════════════════════════════════════════
//  弹窗公告
// ═══════════════════════════════════════════════

void _showPopup(BuildContext context, PopupAnnouncementModel pa) {
  Get.dialog(
    Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.82,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.only(left: 19, top: 11, right: 19, bottom: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.find<HomeController>().markPopupClose();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppTheme.nineColor,
                  ),
                ),
              ],
            ),
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

TextSpan _parseHtmlToTextSpan(String html, TextStyle defaultStyle) {
  try {
    final document = htmlParser.parse(html);
    final children = document.body?.children ?? [];
    final spans = <TextSpan>[];

    if (children.isEmpty) {
      return TextSpan(text: document.body?.text ?? html, style: defaultStyle);
    }

    for (var element in children) {
      spans.add(_parseElement(element, defaultStyle));
    }

    return TextSpan(children: spans);
  } catch (e) {
    return TextSpan(text: html, style: defaultStyle);
  }
}

TextSpan _parseElement(dynamic element, TextStyle baseStyle) {
  TextStyle style = baseStyle;
  String text = element.text ?? '';

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

/// 底部弧形裁切器 —— 极浅弧度，丝滑过渡
class _ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // 两侧起点稍微上抬，中间微微下凸，形成非常平缓的弧
    final curveDepth = size.height * 0.08;
    path.lineTo(0, size.height - curveDepth);
    path.cubicTo(
      size.width * 0.3, size.height,
      size.width * 0.7, size.height,
      size.width, size.height - curveDepth,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
