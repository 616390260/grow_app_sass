import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/localized_app_bar.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/models/activity_model.dart';
import '../controllers/activities_controller.dart';

/// 活动页面
class ActivitiesView extends BaseView<ActivitiesController> {
  const ActivitiesView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return LocalizedAppBar(
      titleKey: I18nKeys.myActivities,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.38, 0.58],
          colors: [AppTheme.primaryColor, AppTheme.primaryGradientMid, Color(0xFFF9F9F9)],
        ),
      ),
      child: Obx(() {
        if (controller.isLoading && controller.activityData.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => controller.loadData(),
          color: AppTheme.primaryColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildMidnightCountdown(),
                const SizedBox(height: 16),
                _buildAnnouncementBanner(),
                const SizedBox(height: 16),
                if (controller.taskActivity != null)
                  _buildTaskCard(controller.taskActivity!),
                if (controller.commissionActivity != null) ...[
                  const SizedBox(height: 16),
                  _buildCommissionCard(controller.commissionActivity!),
                ],
                if (controller.subordinateActivity != null) ...[
                  const SizedBox(height: 16),
                  _buildSubordinateCard(controller.subordinateActivity!),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // ── 顶部标题区 ────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        const Text('🔥', style: TextStyle(fontSize: 28)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              I18nKeys.hotActivities.tr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              I18nKeys.hotActivitiesSubtitle.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 距今日 0 点倒计时（网站时区）────────────────────────────

  Widget _buildMidnightCountdown() {
    return Obx(() {
      final tzName = controller.activityTimezone.value;
      // 解析倒计时 HH:mm:ss
      final parts = controller.midnightCountdownText.value.split(':');
      final hh = parts.length == 3 ? parts[0] : '--';
      final mm = parts.length == 3 ? parts[1] : '--';
      final ss = parts.length == 3 ? parts[2] : '--';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: Column(
          children: [
            // 标题行
            Row(
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(
                  I18nKeys.activityMidnightCountdownLabel.tr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const Spacer(),
                if (tzName.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.public_rounded,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tzName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 分段倒计时 HH : MM : SS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountdownSegment(hh, 'H'),
                _buildCountdownSeparator(),
                _buildCountdownSegment(mm, 'M'),
                _buildCountdownSeparator(),
                _buildCountdownSegment(ss, 'S'),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// 单个时间段方块（数字 + 标签）
  Widget _buildCountdownSegment(String value, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.65),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownSeparator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 6, right: 6),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  // ── 公告横幅 ──────────────────────────────────────────────

  Widget _buildAnnouncementBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              I18nKeys.activityAnnouncementBanner.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.95),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 任务活动卡片 ──────────────────────────────────────────

  Widget _buildTaskCard(ActivityGroup group) {
    return _buildActivityCard(
      cardKey: 'task',
      group: group,
      accentColor: AppTheme.primaryColor,
      iconUrl:
          'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png',
      title: I18nKeys.dailyTaskBonusTitle.tr,
      subtitle: I18nKeys.dailyTaskBonusSubtitle.tr,
      milestoneUnit: I18nKeys.activityTaskUnit.tr,
      milestoneIcon: Icons.check_circle_outline_rounded,
    );
  }

  // ── 佣金活动卡片 ──────────────────────────────────────────

  Widget _buildCommissionCard(ActivityGroup group) {
    return _buildActivityCard(
      cardKey: 'commission',
      group: group,
      accentColor: const Color(0xFFB84A00),
      iconUrl:
          'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Money%20bag/3D/money_bag_3d.png',
      title: I18nKeys.commissionBonusTitle.tr,
      subtitle: I18nKeys.commissionBonusSubtitle.tr,
      milestoneUnit: I18nKeys.activityGoalUnit.tr,
      milestoneIcon: Icons.stars_rounded,
    );
  }

  // ── 下属活动卡片 ──────────────────────────────────────────

  Widget _buildSubordinateCard(ActivityGroup group) {
    return _buildActivityCard(
      cardKey: 'subordinate',
      group: group,
      accentColor: const Color(0xFF2E7D32),
      iconUrl:
          'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Handshake/3D/handshake_3d.png',
      title: I18nKeys.subordinateBonusTitle.tr,
      subtitle: I18nKeys.subordinateBonusSubtitle.tr,
      milestoneUnit: I18nKeys.activityMemberUnit.tr,
      milestoneIcon: Icons.people_outline_rounded,
    );
  }

  // ── 通用活动卡片（可折叠）────────────────────────────────

  Widget _buildActivityCard({
    required String cardKey,
    required ActivityGroup group,
    required Color accentColor,
    required String iconUrl,
    required String title,
    required String subtitle,
    required String milestoneUnit,
    required IconData milestoneIcon,
  }) {
    final milestoneRowBg = accentColor.withValues(alpha: 0.04);
    final milestoneRowBorder = accentColor.withValues(alpha: 0.1);

    return Obx(() {
      final isExpanded = controller.isCardExpanded(cardKey);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 可点击头部 ──────────────────────────────────
            InkWell(
              onTap: () => controller.toggleCard(cardKey),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          iconUrl,
                          width: 56,
                          height: 56,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 展开/收起箭头
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 可折叠内容区 ────────────────────────────────
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
                          final index = entry.key;
                          final item = entry.value;
                          return Column(
                            children: [
                              if (index > 0) const SizedBox(height: 8),
                              _buildMilestoneRow(
                                item: item,
                                accentColor: accentColor,
                                rowBg: milestoneRowBg,
                                rowBorder: milestoneRowBorder,
                                milestoneUnit: milestoneUnit,
                                milestoneIcon: milestoneIcon,
                                otherClaimed:
                                    group.isSingleClaim &&
                                    group.isGroupClaimed &&
                                    !item.claimed,
                              ),
                            ],
                          );
                        }),

                        // 卡片底部说明文字
                        if (group.description != null &&
                            group.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  size: 18,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    group.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF2C2C2C),
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
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

  // ── rewardType=1：整体进度条 + 里程碑列表 + 单次领取按钮 ───

  // ── 单个里程碑行 ─────────────────────────────────────────

  Widget _buildMilestoneRow({
    required ActivityItem item,
    required Color accentColor,
    required Color rowBg,
    required Color rowBorder,
    required String milestoneUnit,
    required IconData milestoneIcon,

    /// rewardType=1 时：同组其他档位已被领取，此行需禁用
    bool otherClaimed = false,
  }) {
    final isClaimed = item.claimed;
    final isReached = item.currentCount >= item.needCount;

    // 已完成：原图标主题色；未完成：原图标灰色
    final iconData = milestoneIcon;
    final iconColor = isReached ? accentColor : Colors.grey[400]!;
    final iconBg = isReached
        ? accentColor.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.07);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: rowBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部：图标 + 数量单位 + 积分badge/按钮
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${item.needCount} $milestoneUnit',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
              ),
              _buildPointsBadge(item, accentColor),
            ],
          ),

          const SizedBox(height: 10),

          // 进度条
          _buildProgressBar(item.progress, accentColor),
          const SizedBox(height: 6),

          // 进度数值 + 领取按钮
          Row(
            children: [
              Text(
                '${item.currentCount} / ${item.needCount}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Obx(() {
                final isClaiming = controller.claimingId.value == item.id;
                return SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: (!otherClaimed && item.canClaim && !isClaiming)
                        ? () => controller.claim(item.id)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isClaimed
                          ? const Color(0xFF2E7D32)
                          : accentColor,
                      disabledBackgroundColor: accentColor.withValues(
                        alpha: 0.3,
                      ),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: isClaiming
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          )
                        : Text(
                            isClaimed
                                ? I18nKeys.activityClaimed.tr
                                : otherClaimed
                                ? I18nKeys.activityNotClaimable.tr
                                : item.canClaim
                                ? I18nKeys.activityClaim.tr
                                : I18nKeys.activityNotReached.tr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
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

  /// 积分徽章（纯展示）
  Widget _buildPointsBadge(ActivityItem item, Color accentColor) {
    final pointsText = I18nKeys.activityPoints.tr.replaceAll(
      '@points',
      '${item.rewardPoints}',
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        pointsText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: accentColor,
        ),
      ),
    );
  }

  /// 渐变进度条
  Widget _buildProgressBar(double progress, Color accentColor) {
    final endColor = accentColor == AppTheme.primaryColor
        ? const Color(0xFF64B5F6)
        : accentColor == const Color(0xFFB84A00)
        ? const Color(0xFFFFAB76)
        : const Color(0xFF81C784);

    return Container(
      height: 14,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fillWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFE8ECF0),
                ),
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
