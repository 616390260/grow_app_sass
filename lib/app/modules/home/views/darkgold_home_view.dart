import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/data/models/activity_model.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'package:do_task_project/app/modules/home/controllers/home_controller.dart';
import 'package:do_task_project/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/task_card_widget.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlParser;

/// 深色/浅色自适应首页
///
/// 当 loginTemplateCode == 'login_dark_gold' 时启用深色模式（黑底 + 主题色强调），
/// 其他登录模板下自动切换为浅色模式（白底 + 主题色强调），布局结构保持一致。
class DarkGoldHomeView extends BaseView<HomeController> {
  const DarkGoldHomeView({super.key});

  // ── 深色/浅色模式判断 ──────────
  /** 仅 login_dark_gold 且未配置 brandColor 时才启用深色背景 */
  static bool get _isDarkMode =>
      TenantService.to.loginTemplateCode == 'login_dark_gold' &&
      TenantService.to.brandColor == null;

  // ── 基础底色 ──────────
  static Color get _bgDark => _isDarkMode
      ? Color.lerp(const Color(0xFF1E1E1E), _accent, 0.06)!
      : AppTheme.primaryColor;
  static Color get _bgCard => _isDarkMode
      ? Color.lerp(const Color(0xFF2A2A2A), _accent, 0.06)!
      : Colors.white;
  static Color get _textLight => _isDarkMode
      ? const Color(0xFFEEEEEE)
      : const Color(0xFF333333);
  static const _textGray = Color(0xFF999999);
  static Color get _iconWellBlack => _isDarkMode
      ? Color.lerp(const Color(0xFF0A0A08), _accent, 0.04)!
      : const Color(0xFFF0F0F0);

  // ── 动态主题色（基于 AppTheme.primaryColor 派生） ──────────

  /** 主强调色 */
  static Color get _accent => AppTheme.primaryColor;

  /** 深色强调（用于渐变暗端、边框等） */
  static Color get _accentDark => AppTheme.primaryDark;

  /** 亮色强调（用于渐变亮端、高光） */
  static Color get _accentLight => AppTheme.primaryGradientLight;

  /** 中间色（用于渐变过渡） */
  static Color get _accentMid => AppTheme.primaryGradientMid;

  // ── 倒计时条 ──────────
  static Color get _countdownBarTop => _isDarkMode
      ? Color.lerp(const Color(0xFF1A1A1A), _accent, 0.08)!
      : AppTheme.primarySurface;
  static Color get _countdownBarMid => _isDarkMode
      ? Color.lerp(const Color(0xFF2D2D2D), _accent, 0.10)!
      : AppTheme.primaryLightest;
  static Color get _countdownBarBot => _isDarkMode
      ? Color.lerp(const Color(0xFF151515), _accent, 0.06)!
      : AppTheme.primarySurface;
  static Color get _countdownBorderBronze => _isDarkMode
      ? Color.lerp(const Color(0xFF636363), _accent, 0.35)!
      : AppTheme.primaryBorder;
  static Color get _countdownTextTan => _isDarkMode
      ? Color.lerp(const Color(0xFFDBDBDB), _accent, 0.40)!
      : AppTheme.primaryDark;
  static Color get _digitSegmentStroke =>
      _countdownTextTan.withValues(alpha: _isDarkMode ? 0.15 : 0.20);

  // ── 活动卡片 ──────────
  static Color get _activityCardLt => _isDarkMode
      ? Color.lerp(const Color(0xFF3B3B3B), _accent, 0.15)!
      : Colors.white;
  static Color get _activityCardMd => _isDarkMode
      ? Color.lerp(const Color(0xFF2A2A2A), _accent, 0.10)!
      : const Color(0xFFFAFAFA);
  static Color get _activityCardDk => _isDarkMode
      ? Color.lerp(const Color(0xFF141414), _accent, 0.06)!
      : const Color(0xFFF5F5F5);
  static Color get _activityCardStroke => _isDarkMode
      ? _accent.withValues(alpha: 0.33)
      : AppTheme.primaryBorder;
  static Color get _activityTitleGold => _isDarkMode
      ? HSLColor.fromColor(_accent).withLightness(0.52).withSaturation(0.72).toColor()
      : AppTheme.primaryDark;
  static Color get _activitySubtitleGold => _isDarkMode
      ? HSLColor.fromColor(_accent).withLightness(0.42).withSaturation(0.25).toColor()
      : const Color(0xFF666666);
  static Color get _navCircleDark => _isDarkMode
      ? Color.lerp(const Color(0xFF4A4A4A), _accent, 0.25)!
      : AppTheme.primarySurface;
  static Color get _navCircleDeep => _isDarkMode
      ? Color.lerp(const Color(0xFF2E2E2E), _accent, 0.18)!
      : AppTheme.primaryLightest;

  /** 倒计时数字样式 */
  static TextStyle get _countdownDigitStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: _countdownTextTan,
    letterSpacing: 0.5,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => _isDarkMode ? _bgDark : null;

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );

    final scrollContent = SingleChildScrollView(
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
          if (!TenantService.to.activityEnabled) _buildRecommendTasks(),
          const SizedBox(height: 75),
        ],
      ),
    );

    if (_isDarkMode) {
      return Container(color: _bgDark, child: scrollContent);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryGradientMid,
            AppTheme.primaryLightest,
          ],
          stops: const [0.0, 0.2, 0.4],
        ),
      ),
      child: scrollContent,
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
          gradient: LinearGradient(
            colors: [_accentDark, _accent, _accentLight, _accent, _accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.12),
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
                style: TextStyle(
                  color: _textLight, fontSize: 16, fontWeight: FontWeight.w700,
                ),
              ),
              if (TenantService.to.vipEnabled) ...[
                const SizedBox(height: 3),
                Obx(() => VipBadge(
                  text: controller.vipLevel.value.isEmpty
                      ? 'VIP0' : controller.vipLevel.value,
                  badgeColor: _accent,
                  textBackgroundColor: _accentDark,
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
                gradient: LinearGradient(
                  colors: [_accentDark, _accent, _accentLight, _accent, _accentDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded, size: 16,
                    color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    I18nKeys.downloadApp.tr,
                    style: TextStyle(
                      color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                      fontSize: 14,
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
        Text(value, style: TextStyle(
          fontSize: 26, fontWeight: FontWeight.w800, color: _accent,
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _accentLight,
              _accent,
              _accentDark,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode
                  ? Colors.black.withValues(alpha: 0.4)
                  : _accent.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isDarkMode
                  ? [
                      Color.lerp(const Color(0xFF454545), _accent, 0.18)!,
                      Color.lerp(const Color(0xFF242424), _accent, 0.08)!,
                      Color.lerp(const Color(0xFF151515), _accent, 0.04)!,
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFFAFAFA),
                      const Color(0xFFF5F5F5),
                    ],
              stops: const [0.0, 0.5, 1.0],
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
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? _accentLight : _accent,
                            letterSpacing: 0.5,
                            shadows: _isDarkMode
                                ? const [Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(0, 1))]
                                : null,
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

  /// 午夜倒计时条：深褐纵向渐变、哑光铜边、浅金棕字、`HH:mm:ss` 三段数字格
  Widget _buildCompactCountdown() {
    return Obx(() {
      final text = controller.midnightCountdownText.value;
      final tz = controller.activityTimezone.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_countdownBarTop, _countdownBarMid, _countdownBarBot],
            stops: const [0.0, 0.45, 1.0],
          ),
          border: Border.all(color: _countdownBorderBronze, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_top_rounded,
              size: 15,
              color: _countdownTextTan.withValues(alpha: 0.95),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                I18nKeys.activityMidnightCountdownLabel.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _countdownTextTan.withValues(alpha: 0.92),
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildSegmentedHms(text),
            if (tz.isNotEmpty) ...[
              const Spacer(),
              Icon(
                Icons.public_rounded,
                size: 14,
                color: _countdownTextTan.withValues(alpha: 0.95),
              ),
              const SizedBox(width: 5),
              Text(
                tz,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _countdownTextTan.withValues(alpha: 0.95),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// 将 [hms] 解析为三段数字格；格式异常时退回整串展示
  Widget _buildSegmentedHms(String hms) {
    final parts = hms.split(':');
    if (parts.length != 3) {
      return Text(
        hms,
        style: _countdownDigitStyle.copyWith(letterSpacing: 1),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _countdownDigitPair(parts[0]),
        _countdownColon(),
        _countdownDigitPair(parts[1]),
        _countdownColon(),
        _countdownDigitPair(parts[2]),
      ],
    );
  }

  /// 两位数字半透明底格（电子表风格）
  Widget _countdownDigitPair(String twoDigits) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _digitSegmentStroke, width: 0.5),
      ),
      child: Text(twoDigits, style: _countdownDigitStyle),
    );
  }

  Widget _countdownColon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _countdownTextTan.withValues(alpha: 0.85),
          height: 1,
        ),
      ),
    );
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
            Text(I18nKeys.hotActivities.tr, style: TextStyle(
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
                  accentColor: _accent,
                  iconUrl: 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/Trophy/3D/trophy_3d.png',
                  title: I18nKeys.dailyTaskBonusTitle.tr,
                  subtitle: I18nKeys.dailyTaskBonusSubtitle.tr,
                  milestoneUnit: I18nKeys.activityTaskUnit.tr,
                  milestoneIcon: Icons.check_circle_outline_rounded,
                  onNavigate: () => Get.toNamed(Routes.tasks),
                  showDeckStack: true,
                ),
              if (data.commissionActivity != null) ...[
                const SizedBox(height: 12),
                _buildActivityCard(
                  cardKey: 'commission', group: data.commissionActivity!,
                  accentColor: _accentDark,
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
                  accentColor: _accentMid,
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

  /// 构建推荐任务列表（活动未启用时替代热门活动显示）
  Widget _buildRecommendTasks() {
    return Obx(() {
      final tasks = controller.recommendTasks;
      if (tasks.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              I18nKeys.recommendedTasks.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _textLight,
              ),
            ),
            const SizedBox(height: 12),
            ...tasks.asMap().entries.map((entry) {
              final task = entry.value;
              return TaskCardWidget(
                title: task.title ?? '',
                description: task.description ?? '',
                buttonText: I18nKeys.startTask.tr,
                onTap: () => controller.onRecommendTaskTap(entry.key),
              );
            }),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  //  活动卡片: 橄榄金渐变 + 对角高光 + 可选层叠 deck
  // ═══════════════════════════════════════════════

  /// [showDeckStack] 为 true 时在首张卡后叠多层剪影（设计稿层叠感）
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
    bool showDeckStack = false,
  }) {
    return Obx(() {
      final isExpanded = controller.isCardExpanded(cardKey);
      final surface = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _activityCardStroke, width: 1),
          boxShadow: _isDarkMode
              ? [
                  BoxShadow(color: _accent.withValues(alpha: 0.14), blurRadius: 18, offset: const Offset(0, 8)),
                  BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 12, offset: const Offset(0, 4)),
                ]
              : [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _activityCardLt,
                        _activityCardMd,
                        _activityCardDk,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.09),
                        Colors.transparent,
                      ],
                      stops: const [0.32, 0.5, 0.72],
                    ),
                  ),
                ),
              ),
              // 必须保留非 Positioned 子组件，否则在纵向无界约束（ScrollView）下 Stack 会断言失败
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _iconWellBlack,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
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
                                color: _activityTitleGold,
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
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _activityTitleGold,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: _activitySubtitleGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: onNavigate,
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [_navCircleDark, _navCircleDeep],
                              ),
                              border: Border.all(
                                color: _accent.withValues(alpha: 0.35),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: _accentLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        InkWell(
                          onTap: () => controller.toggleCard(cardKey),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _activityTitleGold,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: Column(
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...group.items.asMap().entries.map(
                                    (entry) => Column(
                                      children: [
                                        if (entry.key > 0)
                                          const SizedBox(height: 8),
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
                                    ),
                                  ),
                              if (group.description != null &&
                                  group.description!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          accentColor.withValues(alpha: 0.28),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info_rounded,
                                        size: 16,
                                        color: accentColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          group.description!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _activitySubtitleGold,
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
            ],
          ),
        ),
      );
      if (showDeckStack) {
        return _buildDeckStack(child: surface);
      }
      return surface;
    });
  }

  /// 首张活动卡背后的层叠剪影 (增加角度旋转，呈现「扇形展开」洗牌效果)
  Widget _buildDeckStack({required Widget child}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 第 3 层（最底层）
        Positioned(
          top: 0,
          left: 18,
          right: 18,
          bottom: 15,
          child: Transform.rotate(
            angle: -0.045, // 倾斜角度最大
            alignment: Alignment.bottomLeft,
            child: _buildCardBg(),
          ),
        ),
        // 第 2 层
        Positioned(
          top: 5,
          left: 12,
          right: 12,
          bottom: 10,
          child: Transform.rotate(
            angle: -0.030,
            alignment: Alignment.bottomLeft,
            child: _buildCardBg(),
          ),
        ),
        // 第 1 层（紧贴主卡）
        Positioned(
          top: 10,
          left: 6,
          right: 6,
          bottom: 5,
          child: Transform.rotate(
            angle: -0.015,
            alignment: Alignment.bottomLeft,
            child: _buildCardBg(),
          ),
        ),
        // 主卡内容
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: child,
        ),
      ],
    );
  }

  /// 纯背景（无内容），用于垫在后方形成层叠效果（与主卡背景/高光完全一致）
  Widget _buildCardBg() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _activityCardStroke, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _activityCardLt,
                      _activityCardMd,
                      _activityCardDk,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.09),
                      Colors.transparent,
                    ],
                    stops: const [0.32, 0.5, 0.72],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneRow({
    required ActivityItem item,
    required Color accentColor,
    required String milestoneUnit,
    required IconData milestoneIcon,
    bool otherClaimed = false,
  }) {
    final isReached = item.currentCount >= item.needCount;
    final iconColor =
        isReached ? accentColor : _activitySubtitleGold;
    final iconBg = isReached
        ? accentColor.withValues(alpha: 0.15)
        : Color.lerp(const Color(0xFF1E1E1E), _accent, 0.04)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _activityCardDk.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _activityTitleGold,
              ))),
            _buildPointsBadge(item, accentColor),
          ]),
          const SizedBox(height: 8),
          _buildProgressBar(item.progress, accentColor),
          const SizedBox(height: 6),
          Row(children: [
            Text('${item.currentCount} / ${item.needCount}',
              style: TextStyle(
                fontSize: 11,
                color: _activitySubtitleGold,
              )),
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
                    foregroundColor: _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
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
            Container(width: double.infinity, color: _isDarkMode
                ? Color.lerp(const Color(0xFF3A3A3A), _accent, 0.08)
                : const Color(0xFFE8E8E8)),
            Container(
              width: fillWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, _accentLight],
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
  final isDark = DarkGoldHomeView._isDarkMode;
  final titleColor = DarkGoldHomeView._textLight;
  Get.dialog(Center(child: Container(
    width: MediaQuery.of(context).size.width * 0.82,
    margin: const EdgeInsets.symmetric(horizontal: 30),
    padding: const EdgeInsets.only(left: 19, top: 11, right: 19, bottom: 30),
    decoration: BoxDecoration(
      color: isDark
          ? Color.lerp(const Color(0xFF333333), AppTheme.primaryColor, 0.06)
          : Colors.white,
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
                text: _parseHtmlToTextSpan(pa.title ?? '', TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: titleColor, decoration: TextDecoration.none,
                )),
                maxLines: 2, textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis)
            : RichText(
                text: TextSpan(text: pa.title ?? '', style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: titleColor, decoration: TextDecoration.none,
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

