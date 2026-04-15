import 'dart:math' show pi;
import 'dart:ui' show ImageFilter;

import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/invite_friend/components/decorated_title.dart';
import 'package:do_task_project/app/modules/promotion/components/highlight_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promotion_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class PromotionView extends BaseView<PromotionController> {
  const PromotionView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return LocalizedAppBar(
      titleKey: I18nKeys.cashReward,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2, 0.3],
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryGradientMid,
              Color(0xFFF9F9F9),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 现金奖励横幅
            _buildCashRewardBanner(),

            // 推荐链接和推荐码部分
            _buildReferralSection(),
            const SizedBox(height: 15),
            // 邀请收益统计部分
            _buildIncomeStatistics(),

            // 奖励领取部分
            _buildRewardClaim(),

            // 分享链接部分
            _buildShareLinks(),
            const SizedBox(height: 15),
            // 活动规则部分
            _buildActivityRules(),

            // 底部间距
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── 现金奖励横幅（深绿背景 + 佣金徽章 + 邀请关系树）──
  Widget _buildCashRewardBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF022C22), Color(0xFF064E3B), Color(0xFF065F46)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // 背景装饰圆圈
          Positioned(top: -50, right: -30, child: _buildDecoCircle(160)),
          Positioned(top: 80, left: -50, child: _buildDecoCircle(120)),
          Positioned(bottom: 100, right: 10, child: _buildDecoCircle(80)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 标题区 ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6EE7B7), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.40),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.monetization_on_outlined,
                        color: Color(0xFF022C22),
                        size: 15,
                      ),
                    ),
                    Text(
                      I18nKeys.inviteNewUserReward.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── 佣金卡片（真实玻璃态）──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          // 卡片顶部高光条
                          Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.55),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          _buildCommissionBadge(
                            '20%',
                            I18nKeys.level1DirectActive.tr,
                            I18nKeys.commissionRebate.tr,
                            isPrimary: true,
                          ),
                          // 渐变分割线
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.22),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _buildCommissionBadge(
                            '10%',
                            I18nKeys.level2DirectActive.tr,
                            I18nKeys.commissionRebate.tr,
                            isPrimary: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── 关系树（全宽铺满）──
              _buildReferralTree(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  /// 背景装饰圆圈
  Widget _buildDecoCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        color: Colors.white.withValues(alpha: 0.02),
      ),
    );
  }

  /// 佣金比例徽章行：胶囊百分比 + 右侧两行文字 + 右侧层级标签
  Widget _buildCommissionBadge(
    String pct,
    String line1,
    String line2, {
    required bool isPrimary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 百分比胶囊（立体感）
          Container(
            width: 66,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPrimary
                    ? const [
                        Color(0xFF6EE7B7),
                        Color(0xFF34D399),
                        Color(0xFF10B981),
                      ]
                    : const [Color(0xFF6EE7B7), Color(0xFF34D399)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF10B981,
                  ).withValues(alpha: isPrimary ? 0.50 : 0.28),
                  blurRadius: 14,
                  spreadRadius: -4,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              pct,
              style: const TextStyle(
                color: Color(0xFF022C22),
                fontWeight: FontWeight.w900,
                fontSize: 17,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // 描述文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF34D399).withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      line2,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 层级标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Text(
              isPrimary ? 'L1' : 'L2',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.70),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 邀请关系树：A → B1/B2 → C1/C2/C3/C4
  Widget _buildReferralTree() {
    const double refW = 375.0;
    const double maxS = 1.0;
    const double refH = 310.0;

    return LayoutBuilder(
      builder: (ctx, box) {
        final sW = box.maxWidth / refW;
        final s = sW < maxS ? sW : maxS;

        final cx = 187.5 * s;

        final yA = 40.0 * s;
        final yB = 152.0 * s;
        final yC = 258.0 * s;

        final xA = cx;
        final xB1 = 102.5 * s;
        final xB2 = 272.5 * s;
        final xC1 = 57.5 * s;
        final xC2 = 147.5 * s;
        final xC3 = 227.5 * s;
        final xC4 = 317.5 * s;

        return Center(
          child: SizedBox(
            width: refW * s,
            height: refH * s,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 连接线（正交折线）
                Positioned.fill(
                  child: CustomPaint(painter: _TreeLinePainter(scale: s)),
                ),

                // ── A 节点（80px）──
                Positioned(
                  left: xA - 40 * s,
                  top: yA - 40 * s,
                  child: _buildTreeNode(
                    avatarSize: 80,
                    badgeSize: 28,
                    badgeOverlap: 15,
                    label: 'A',
                    scale: s,
                  ),
                ),

                // ── B 节点（64px）──
                Positioned(
                  left: xB1 - 32 * s,
                  top: yB - 32 * s,
                  child: _buildTreeNode(
                    avatarSize: 64,
                    badgeSize: 22,
                    badgeOverlap: 12,
                    label: 'B1',
                    scale: s,
                  ),
                ),
                Positioned(
                  left: xB2 - 32 * s,
                  top: yB - 32 * s,
                  child: _buildTreeNode(
                    avatarSize: 64,
                    badgeSize: 22,
                    badgeOverlap: 12,
                    label: 'B2',
                    scale: s,
                  ),
                ),

                // ── C 节点（56px）──
                Positioned(
                  left: xC1 - 28 * s,
                  top: yC - 28 * s,
                  child: _buildTreeNode(
                    avatarSize: 56,
                    badgeSize: 18,
                    badgeOverlap: 10,
                    label: 'C1',
                    scale: s,
                  ),
                ),
                Positioned(
                  left: xC2 - 28 * s,
                  top: yC - 28 * s,
                  child: _buildTreeNode(
                    avatarSize: 56,
                    badgeSize: 18,
                    badgeOverlap: 10,
                    label: 'C2',
                    scale: s,
                  ),
                ),
                Positioned(
                  left: xC3 - 28 * s,
                  top: yC - 28 * s,
                  child: _buildTreeNode(
                    avatarSize: 56,
                    badgeSize: 18,
                    badgeOverlap: 10,
                    label: 'C3',
                    scale: s,
                  ),
                ),
                Positioned(
                  left: xC4 - 28 * s,
                  top: yC - 28 * s,
                  child: _buildTreeNode(
                    avatarSize: 56,
                    badgeSize: 18,
                    badgeOverlap: 10,
                    label: 'C4',
                    scale: s,
                  ),
                ),

                // ── 标签（绝对居中于线段）──
                _buildCenteredLabel((xA + xB1) / 2, 100 * s, '20%'),
                _buildCenteredLabel((xA + xB2) / 2, 100 * s, '20%'),

                _buildCenteredLabel((xB1 + xC1) / 2, 207 * s, '20%'),
                _buildCenteredLabel((xB1 + xC2) / 2, 207 * s, '20%'),
                _buildCenteredLabel((xB2 + xC3) / 2, 207 * s, '20%'),
                _buildCenteredLabel((xB2 + xC4) / 2, 207 * s, '20%'),

                _buildCenteredLabel(15 * s, 149 * s, '10%'),
                _buildCenteredLabel(360 * s, 149 * s, '10%'),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 居中显示的百分比标签（带暗色背景、白边框，完全压在线上）
  Widget _buildCenteredLabel(double x, double y, String text) {
    return Positioned(
      left: x,
      top: y,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3D2C), // 与背景相近的深色
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 树形节点：卡通人物头像 + 渐变字母徽章
  Widget _buildTreeNode({
    required double avatarSize,
    required double badgeSize,
    required double badgeOverlap,
    required String label,
    required double scale,
  }) {
    final sa = avatarSize * scale;
    final sb = badgeSize * scale;
    final ov = badgeOverlap * scale;

    // 使用本地 3D 卡通头像
    const imagePaths = <String, String>{
      'A': 'assets/images/avatar_a.png',
      'B1': 'assets/images/avatar_b1.png',
      'B2': 'assets/images/avatar_b2.png',
      'C1': 'assets/images/avatar_c1.png',
      'C2': 'assets/images/avatar_c2.png',
      'C3': 'assets/images/avatar_c3.png',
      'C4': 'assets/images/avatar_c4.png',
    };
    final path = imagePaths[label] ?? 'assets/images/avatar_a.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 头像圆形
        Container(
          width: sa,
          height: sa,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5 * scale),
            color: const Color(0xFFE2E8F0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: sa * 0.6, color: Colors.grey);
              },
            ),
          ),
        ),
        // 渐变字母徽章（负偏移叠在头像底部）
        Transform.translate(
          offset: Offset(0, -ov),
          child: Container(
            width: sb,
            height: sb,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4DB6AC), Color(0xFF48BB78)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: Colors.white, width: 1.5 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: label.length <= 1 ? 11.0 * scale : 8.0 * scale,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 推荐链接和推荐码部分
  Widget _buildReferralSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.fromLTRB(15, 18, 15, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 推荐链接
          Text(
            I18nKeys.referralLink.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.sixColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildCopyRow(
            valueObs: controller.inviteUrl,
            isCopiedObs: controller.isCopiedLink,
            onCopy: controller.copyInviteLink,
          ),
          const SizedBox(height: 16),

          // 推荐码
          Text(
            I18nKeys.referralCode.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.sixColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildCopyRow(
            valueObs: controller.inviteCode,
            isCopiedObs: controller.isCopiedCode,
            onCopy: controller.copyInviteCode,
          ),
        ],
      ),
    );
  }

  /// 带胶囊 Copy 按钮的行
  Widget _buildCopyRow({
    required RxString valueObs,
    required RxBool isCopiedObs,
    required VoidCallback onCopy,
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                valueObs.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.threeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onCopy,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isCopiedObs.value
                      ? AppTheme.primaryColor.withValues(alpha: 0.6)
                      : AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCopiedObs.value ? I18nKeys.copied.tr : I18nKeys.copy.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 邀请收益统计部分
  Widget _buildStatisticItem(String title, Widget value) {
    return Expanded(
      child: Container(
        height: 76,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.e3e3e3Color, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                fontSize: 12,
              ),
            ),
            const Spacer(),
            value,
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          DecoratedTitle(title: I18nKeys.inviteEarnings.tr),
          const SizedBox(height: 22),

          // 收益统计 - 三个一列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatisticItem(
                I18nKeys.totalCommission.tr,
                Obx(
                  () => Text(
                    controller.totalCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.todayCommission.tr,
                Obx(
                  () => Text(
                    controller.todayCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.yesterdayCommission.tr,
                Obx(
                  () => Text(
                    controller.yesterdayCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 活跃人数统计 - 三个一列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatisticItem(
                I18nKeys.activeUsers.tr,
                Obx(
                  () => Text(
                    controller.activeUsers.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.todayNewSubordinates.tr,
                Obx(
                  () => Text(
                    controller.todayNewSubordinates.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.directActiveUsers.tr,
                Obx(
                  () => Text(
                    controller.activeSubordinates.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 奖励领取部分
  Widget _buildRewardClaim() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  I18nKeys.inviteSubordinatesReachLevel2Reward.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Obx(
            () => Text(
              I18nKeys.currentReachLevel2RewardPoints.tr
                  .replaceFirst(
                    '%s',
                    controller.reachTwoStarUsers.value.toString(),
                  )
                  .replaceFirst(
                    '%s',
                    controller.twoStarRewardPoints.value.toString(),
                  ),
              style: const TextStyle(fontSize: 12, color: AppTheme.threeColor),
            ),
          ),
          const SizedBox(height: 17),
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              bool hasReceived = controller.isReceived.value;

              return GestureDetector(
                onTap: hasReceived
                    ? () {
                        // TODO: 实现领取奖励的逻辑
                        controller.receiveReward();
                      }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 170,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    gradient: hasReceived
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryGradientMid2,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: !hasReceived ? Color(0xFFE0E0E0) : null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    I18nKeys.claim.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 分享链接部分
  Widget _buildShareLinks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedTitle(title: I18nKeys.shareToEarn.tr),
          const SizedBox(height: 25),

          // 社交分享按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(ImageAssets.inviteTelegram),
              _buildSocialButton(ImageAssets.inviteWhatsapp),
              _buildSocialButton(ImageAssets.inviteFacebook),
            ],
          ),
        ],
      ),
    );
  }

  // 社交分享按钮
  Widget _buildSocialButton(String imagePath) {
    return GestureDetector(
      onTap: () {
        // 根据图片路径判断是哪个社交平台
        if (imagePath == ImageAssets.inviteTelegram) {
          controller.shareToTelegram();
        } else if (imagePath == ImageAssets.inviteWhatsapp) {
          controller.shareToWhatsApp();
        } else if (imagePath == ImageAssets.inviteFacebook) {
          controller.shareToFacebook();
        }
      },
      child: Image.asset(imagePath, width: 30, height: 30),
    );
  }

  // 活动规则部分
  Widget _buildActivityRules() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活动规则标题
          Center(child: DecoratedTitle(title: I18nKeys.activityRules.tr)),
          const SizedBox(height: 20),

          // 邀请步骤
          HighlightText(text: I18nKeys.invitationSteps.tr),
          const SizedBox(height: 17),
          _buildRuleItem(I18nKeys.invitationStep1.tr),
          _buildRuleItem(I18nKeys.invitationStep2.tr),
          _buildRuleItem(I18nKeys.invitationStep3.tr),

          const SizedBox(height: 30),

          // 奖励计算方式
          HighlightText(text: I18nKeys.commissionCalculationMethod.tr),
          const SizedBox(height: 17),
          _buildCommissionRuleText(),
          // _buildRuleItem(I18nKeys.directInvitationRule.tr),
          // _buildRuleItem(I18nKeys.secondaryInvitationRule.tr),
        ],
      ),
    );
  }

  // 规则项
  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppTheme.sixColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建佣金规则文本，单独设置关键部分样式，支持多语言
  Widget _buildCommissionRuleText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppTheme.sixColor,
        ),
        children: _parseAndStyleRuleText(),
      ),
    );
  }

  // 解析规则文本并应用相应样式，支持多语言
  // 采用简单直接的格式：按换行符分割，第1和3行为标题，第2和4行为内容
  List<TextSpan> _parseAndStyleRuleText() {
    final List<TextSpan> spans = [];
    final String ruleText = I18nKeys.directInvitationRule.tr;

    // 按换行符分割文本
    final List<String> lines = ruleText.split('\n\n');

    // 处理每一行，固定格式：第1和3行为标题，第2和4行为内容
    for (int i = 0; i < lines.length; i++) {
      // 跳过空行
      if (lines[i].trim().isEmpty) continue;

      // 检查是否是标题行（第1和3行，索引从0开始）
      bool isTitleLine = (i == 0 || i == 2);

      if (isTitleLine) {
        // 标题行应用特殊样式
        spans.add(
          TextSpan(
            text: '${lines[i]}\n\n',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppTheme.threeColor,
            ),
          ),
        );
      } else {
        // 内容行应用默认样式
        spans.add(TextSpan(text: '${lines[i]}\n\n'));
      }
    }

    return spans;
  }
}

/// 邀请树连接线画笔（正交折线 + 箭头）
class _TreeLinePainter extends CustomPainter {
  final double scale;

  const _TreeLinePainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final s = scale;

    final cx = 187.5 * s;
    final yA = 40.0 * s;
    final yB = 152.0 * s;
    final yC = 258.0 * s;

    final xA = cx;
    final xB1 = 102.5 * s;
    final xB2 = 272.5 * s;
    final xC1 = 57.5 * s;
    final xC2 = 147.5 * s;
    final xC3 = 227.5 * s;
    final xC4 = 317.5 * s;

    // Helper to draw 3-segment orthogonal line with arrow
    void drawTreeLine(Offset start, Offset end, double midY) {
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx, midY)
        ..lineTo(end.dx, midY)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);

      // Arrow pointing down
      final double arrowLength = 6.0 * s;
      final double arrowAngle = pi / 6;
      final Offset p1 =
          end - Offset.fromDirection(pi / 2 - arrowAngle, arrowLength);
      final Offset p2 =
          end - Offset.fromDirection(pi / 2 + arrowAngle, arrowLength);
      canvas.drawPath(
        Path()
          ..moveTo(end.dx, end.dy)
          ..lineTo(p1.dx, p1.dy)
          ..moveTo(end.dx, end.dy)
          ..lineTo(p2.dx, p2.dy),
        paint,
      );
    }

    // A -> B
    drawTreeLine(Offset(xA, yA + 40 * s), Offset(xB1, yB - 32 * s), 100 * s);
    drawTreeLine(Offset(xA, yA + 40 * s), Offset(xB2, yB - 32 * s), 100 * s);

    // B -> C
    drawTreeLine(Offset(xB1, yB + 32 * s), Offset(xC1, yC - 28 * s), 207 * s);
    drawTreeLine(Offset(xB1, yB + 32 * s), Offset(xC2, yC - 28 * s), 207 * s);
    drawTreeLine(Offset(xB2, yB + 32 * s), Offset(xC3, yC - 28 * s), 207 * s);
    drawTreeLine(Offset(xB2, yB + 32 * s), Offset(xC4, yC - 28 * s), 207 * s);

    // Outer lines (10%)
    void drawOuterLine(Offset start, double outerX, Offset end) {
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(outerX, start.dy)
        ..lineTo(outerX, end.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);

      // Arrow
      final double angle = end.dx > outerX ? 0 : pi;
      final double arrowLength = 6.0 * s;
      final double arrowAngle = pi / 6;
      final Offset p1 =
          end - Offset.fromDirection(angle - arrowAngle, arrowLength);
      final Offset p2 =
          end - Offset.fromDirection(angle + arrowAngle, arrowLength);
      canvas.drawPath(
        Path()
          ..moveTo(end.dx, end.dy)
          ..lineTo(p1.dx, p1.dy)
          ..moveTo(end.dx, end.dy)
          ..lineTo(p2.dx, p2.dy),
        paint,
      );
    }

    // C1 -> A
    drawOuterLine(Offset(xC1 - 28 * s, yC), 15 * s, Offset(xA - 40 * s, yA));
    // C4 -> A
    drawOuterLine(Offset(xC4 + 28 * s, yC), 360 * s, Offset(xA + 40 * s, yA));
  }

  @override
  bool shouldRepaint(_TreeLinePainter old) => old.scale != scale;
}
