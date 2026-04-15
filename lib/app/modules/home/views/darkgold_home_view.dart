import 'dart:ui';

import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';
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

/// 黑金风格首页 —— 深色背景 + 金色强调
class DarkGoldHomeView extends BaseView<HomeController> {
  const DarkGoldHomeView({super.key});

  // ── 颜色常量 ──────────
  static const _bgDark = Color(0xFF1E1E1E);
  static const _bgCard = Color(0xFF2A2A2A);
  static const _bgCardLight = Color(0xFF333333);
  static const _gold = Color(0xFFE8C779);
  static const _goldDark = Color(0xFFBFA05A);
  static const _goldLight = Color(0xFFF5DEAA);
  static const _borderSubtle = Color(0xFF3A3A3A);
  static const _textLight = Color(0xFFEEEEEE);
  static const _textGray = Color(0xFF999999);
  static const _textMuted = Color(0xFF777777);

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => _bgDark;

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      color: _bgDark,
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
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildHeroCard(),
            const SizedBox(height: 14),
            _buildFeatureButtons(),
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
            if (TenantService.to.activityEnabled) const SizedBox(height: 10),
            if (TenantService.to.activityEnabled) _buildHotActivities(),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  Hero 卡片: 金色渐变边框，包裹 Header + Stats
  // ═══════════════════════════════════════════════

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [_goldDark, _gold, _goldLight, _gold, _goldDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _gold.withValues(alpha: 0.12),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              _buildHeaderRow(),
              const SizedBox(height: 24),
              _buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: TenantService.to.brandLogo != null
              ? Image.network(
                  TenantService.to.brandLogo!,
                  width: 48, height: 48, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                      ImageAssets.logo, width: 48, height: 48, fit: BoxFit.cover),
                )
              : Image.asset(ImageAssets.logo, width: 48, height: 48, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: TenantService.to.vipEnabled ? controller.onVipDetailsTap : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TenantService.to.appName,
                style: const TextStyle(
                  color: _textLight, fontSize: 16, fontWeight: FontWeight.w700,
                ),
              ),
              if (TenantService.to.vipEnabled) ...[
                const SizedBox(height: 3),
                Obx(() => VipBadge(
                  text: controller.vipLevel.value.isEmpty
                      ? 'VIP0' : controller.vipLevel.value,
                  badgeColor: _gold,
                  textBackgroundColor: _goldDark,
                )),
              ],
            ],
          ),
        ),
        const Spacer(),
        if (kIsWeb)
          GestureDetector(
            onTap: controller.onDownloadAppTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [_goldDark, _gold, _goldLight, _gold, _goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download_rounded, size: 16,
                    color: Color(0xFF2A2A2A)),
                  const SizedBox(width: 6),
                  Text(
                    I18nKeys.downloadApp.tr,
                    style: const TextStyle(
                      color: Color(0xFF2A2A2A), fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Obx(() => Row(
      children: [
        Expanded(child: _buildStatCol(
          controller.accountBalance.value.toString(),
          I18nKeys.accountBalance.tr,
        )),
        Expanded(child: _buildStatCol(
          controller.dailyEarnings.value.toString(),
          I18nKeys.todayEarnings.tr,
        )),
        Expanded(child: _buildStatCol(
          controller.promotionEarnings.value.toString(),
          I18nKeys.todayPromotionEarnings.tr,
        )),
      ],
    ));
  }

  Widget _buildStatCol(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(
          fontSize: 26, fontWeight: FontWeight.w800, color: _gold,
        )),
        const SizedBox(height: 6),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: _textGray)),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  功能按钮: 暗底 + 金色渐变边框
  // ═══════════════════════════════════════════════

  Widget _buildFeatureButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildGoldPill(
            label: 'lucky_wheel'.tr, emoji: '🎯',
            onTap: controller.onLuckyWheelTap,
          )),
          const SizedBox(width: 10),
          Expanded(child: _buildGoldPill(
            label: 'sign_in_calendar'.tr, emoji: '📋',
            onTap: controller.onSignInCalendarTap,
          )),
          const SizedBox(width: 10),
          Expanded(child: _buildGoldPill(
            label: I18nKeys.inviteFriend.tr, emoji: '👋',
            onTap: controller.onInviteFriendTap,
          )),
        ],
      ),
    );
  }

  /// 3D 玻璃质感金边按钮
  Widget _buildGoldPill({
    required String label, required String emoji, VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // 外围金属渐变边框
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0C6), // 顶部极亮金
              Color(0xFFD4A759), // 中部金
              Color(0xFF8F6B27), // 底部暗金
            ],
            stops: [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.8), // 边框粗细
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // 内部底色渐变
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF45361B), // 顶部微亮橄榄金
                Color(0xFF241C0C), // 中部深褐
                Color(0xFF151006), // 底部近黑
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // 顶部玻璃质感反光层
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 22,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.28),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // 文字与图标
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDE5A9), // 明亮金字
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(emoji, style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          color: _bgCardLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderSubtle, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top_rounded, size: 14, color: _gold),
            const SizedBox(width: 5),
            Text(I18nKeys.activityMidnightCountdownLabel.tr,
              style: const TextStyle(fontSize: 12, color: _textMuted)),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: _gold, letterSpacing: 1,
            )),
            if (tz.isNotEmpty) ...[
              const Spacer(),
              const Icon(Icons.public_rounded, size: 11, color: _textGray),
              const SizedBox(width: 3),
              Text(tz, style: const TextStyle(fontSize: 11, color: _textGray)),
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
          Row(children: [
            const Text('Hot Activities', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, color: _textLight,
            )),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF4D4F), Color(0xFFFF7875)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('HOT', style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold,
              )),
            ),
          ]),
          const SizedBox(height: 12),
          Obx(() {
            final data = controller.activityData.value;
            if (data == null) return const SizedBox.shrink();
            return Column(children: [
              if (data.taskActivity != null)
                _buildActivityCard(
                  cardKey: 'task', group: data.taskActivity!,
                  accentColor: _gold,
                  iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png',
                  title: I18nKeys.dailyTaskBonusTitle.tr,
                  subtitle: I18nKeys.dailyTaskBonusSubtitle.tr,
                  milestoneUnit: I18nKeys.activityTaskUnit.tr,
                  milestoneIcon: Icons.check_circle_outline_rounded,
                  onNavigate: () => Get.toNamed(Routes.tasks),
                ),
              if (data.commissionActivity != null) ...[
                const SizedBox(height: 12),
                _buildActivityCard(
                  cardKey: 'commission', group: data.commissionActivity!,
                  accentColor: const Color(0xFFD4A04A),
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
                _buildActivityCard(
                  cardKey: 'subordinate', group: data.subordinateActivity!,
                  accentColor: const Color(0xFFCDA94E),
                  iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Handshake/3D/handshake_3d.png',
                  title: I18nKeys.subordinateBonusTitle.tr,
                  subtitle: I18nKeys.subordinateBonusSubtitle.tr,
                  milestoneUnit: I18nKeys.activityMemberUnit.tr,
                  milestoneIcon: Icons.people_outline_rounded,
                  onNavigate: () => Get.toNamed(Routes.promotion),
                ),
              ],
            ]);
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  活动卡片: 金色渐变边框 + 暗底
  // ═══════════════════════════════════════════════

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
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              _goldDark.withValues(alpha: 0.6),
              _gold.withValues(alpha: 0.3),
              _goldDark.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            color: _bgCardLight,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                child: Row(children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: _bgCard,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(iconUrl, width: 52, height: 52,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.emoji_events_rounded, size: 28, color: _gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.toggleCard(cardKey),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: _textLight,
                          )),
                          const SizedBox(height: 4),
                          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: _textGray)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onNavigate,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withValues(alpha: 0.15),
                      ),
                      child: Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: accentColor),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => controller.toggleCard(cardKey),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: accentColor, size: 28),
                    ),
                  ),
                ]),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Column(children: [
                  Divider(height: 1, thickness: 1,
                    color: _borderSubtle.withValues(alpha: 0.5)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...group.items.asMap().entries.map((entry) => Column(
                          children: [
                            if (entry.key > 0) const SizedBox(height: 8),
                            _buildMilestoneRow(
                              item: entry.value,
                              accentColor: accentColor,
                              milestoneUnit: milestoneUnit,
                              milestoneIcon: milestoneIcon,
                              otherClaimed: group.isSingleClaim &&
                                  group.isGroupClaimed && !entry.value.claimed,
                            ),
                          ],
                        )),
                        if (group.description != null &&
                            group.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: accentColor.withValues(alpha: 0.25)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_rounded,
                                    size: 16, color: accentColor),
                                const SizedBox(width: 8),
                                Expanded(child: Text(group.description!,
                                  style: const TextStyle(
                                    fontSize: 12, color: _textGray, height: 1.5,
                                  ))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
                sizeCurve: Curves.easeInOut,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMilestoneRow({
    required ActivityItem item,
    required Color accentColor,
    required String milestoneUnit,
    required IconData milestoneIcon,
    bool otherClaimed = false,
  }) {
    final isReached = item.currentCount >= item.needCount;
    final iconColor = isReached ? accentColor : _textGray;
    final iconBg = isReached
        ? accentColor.withValues(alpha: 0.15)
        : const Color(0xFF3A3A3A);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(milestoneIcon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('${item.needCount} $milestoneUnit',
              style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: _textLight,
              ))),
            _buildPointsBadge(item, accentColor),
          ]),
          const SizedBox(height: 8),
          _buildProgressBar(item.progress, accentColor),
          const SizedBox(height: 6),
          Row(children: [
            Text('${item.currentCount} / ${item.needCount}',
              style: const TextStyle(fontSize: 11, color: _textGray)),
            const Spacer(),
            Obx(() {
              final isClaiming = controller.claimingId.value == item.id;
              return SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: (!otherClaimed && item.canClaim && !isClaiming)
                      ? () => controller.claim(item.id) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.claimed
                        ? const Color(0xFF2E7D32) : accentColor,
                    disabledBackgroundColor: accentColor.withValues(alpha: 0.3),
                    foregroundColor: _bgDark,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: isClaiming
                      ? SizedBox(width: 13, height: 13,
                          child: CircularProgressIndicator(strokeWidth: 2,
                            color: _bgDark.withValues(alpha: 0.9)))
                      : Text(
                          item.claimed ? I18nKeys.activityClaimed.tr
                              : otherClaimed ? I18nKeys.activityNotClaimable.tr
                              : item.canClaim ? I18nKeys.activityClaim.tr
                              : I18nKeys.activityNotReached.tr,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _buildPointsBadge(ActivityItem item, Color accentColor) {
    final text = I18nKeys.activityPoints.tr
        .replaceAll('@points', '${item.rewardPoints}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(text, style: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700, color: accentColor)),
    );
  }

  Widget _buildProgressBar(double progress, Color accentColor) {
    return Container(
      height: 12,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _bgDark,
        borderRadius: BorderRadius.circular(99),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LayoutBuilder(builder: (context, constraints) {
          final fillWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
          return Stack(children: [
            Container(width: double.infinity, color: const Color(0xFF3A3A3A)),
            Container(
              width: fillWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, _goldLight],
                ),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  弹窗公告
// ═══════════════════════════════════════════════

void _showPopup(BuildContext context, PopupAnnouncementModel pa) {
  Get.dialog(Center(child: Container(
    width: MediaQuery.of(context).size.width * 0.82,
    margin: const EdgeInsets.symmetric(horizontal: 30),
    padding: const EdgeInsets.only(left: 19, top: 11, right: 19, bottom: 30),
    decoration: BoxDecoration(
      color: const Color(0xFF333333),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () { Get.back(); Get.find<HomeController>().markPopupClose(); },
          child: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
        ),
      ]),
      Center(
        child: (pa.titleIsRichText == '1')
            ? RichText(
                text: _parseHtmlToTextSpan(pa.title ?? '', const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: Color(0xFFEEEEEE), decoration: TextDecoration.none,
                )),
                maxLines: 2, textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis)
            : RichText(
                text: TextSpan(text: pa.title ?? '', style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: Color(0xFFEEEEEE), decoration: TextDecoration.none,
                )),
                maxLines: 2, textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
      ),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(child: Align(
          alignment: Alignment.centerLeft,
          child: (pa.contentIsRichText == '1')
              ? RichText(text: _parseHtmlToTextSpan(pa.content ?? '',
                  const TextStyle(fontSize: 12, height: 1.5,
                    fontWeight: FontWeight.w500, color: Color(0xFF999999),
                    decoration: TextDecoration.none)))
              : Text(pa.content ?? '', style: const TextStyle(
                  fontSize: 12, height: 1.5, fontWeight: FontWeight.w500,
                  color: Color(0xFF999999), decoration: TextDecoration.none)),
        )),
      ),
    ]),
  )));
}

TextSpan _parseHtmlToTextSpan(String html, TextStyle defaultStyle) {
  try {
    final document = htmlParser.parse(html);
    final children = document.body?.children ?? [];
    if (children.isEmpty) {
      return TextSpan(text: document.body?.text ?? html, style: defaultStyle);
    }
    return TextSpan(
      children: children.map((e) => _parseElement(e, defaultStyle)).toList(),
    );
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
