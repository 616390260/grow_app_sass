import 'package:do_task_project/app/core/theme/app_theme.dart';

import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/account_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import '../../../core/constants/image_assets.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';

class AccountView extends BaseView<AccountController> {
  const AccountView({super.key});

  @override
  Widget buildContent(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    final Color primary = AppTheme.primaryColor;
    return Obx(
      () => SingleChildScrollView(
        // 为整个滚动视图设置白色背景，确保在暗黑模式下也不会变黑
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
            // 顶部头部 + 余额卡片
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 274,
                  child: Stack(
                    children: [
                      // ── 主渐变背景（斜角三段色，避免单调）──
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.primaryGradientMid,
                                AppTheme.primaryGradientMid2,
                              ],
                              stops: [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // ── 右上角径向高光（Aurora 光晕）──
                      Positioned(
                        top: -70,
                        right: -50,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.18),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ── 左下装饰圆（深度感）──
                      Positioned(
                        bottom: 20,
                        left: -55,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      // ── 右下小圆点 ──
                      Positioned(
                        bottom: -20,
                        right: 40,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      // ── 顶部中央小亮斑 ──
                      Positioned(
                        top: 10,
                        left: MediaQuery.of(context).size.width * 0.35,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.10),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ── 内容层 ──
                      SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 26,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 9, top: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,

                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        controller.avatar.value,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                TenantService.to.brandLogo != null
                                                    ? Image.network(
                                                        TenantService.to.brandLogo!,
                                                        width: 64,
                                                        height: 64,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) =>
                                                            Image.asset(ImageAssets.error),
                                                      )
                                                    : Image.asset(ImageAssets.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 17),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(() => Text(
                                        controller.isReferralCodeVisible.value
                                            ? controller.userName.value
                                            : '••••••',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                      const SizedBox(height: 4),
                                      Obx(() => Row(
                                        children: [
                                          Text(
                                            '${I18nKeys.referralCode.tr}: ',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              controller.isReferralCodeVisible.value
                                                  ? controller.referralCode.value
                                                  : '••••••••',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: controller.toggleReferralCodeVisibility,
                                            child: Icon(
                                              controller.isReferralCodeVisible.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: controller.copyReferral,
                                            child: const Icon(
                                              Icons.copy,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: controller.switchToServiceTab,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: SvgPicture.asset(
                                            ImageAssets.mineService,
                                            width: 22,
                                            height: 22,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.messageCenter);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: SvgPicture.asset(
                                            ImageAssets.mineMsg,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            width: 23,
                                            height: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],       // Stack children
              ),         // Stack
            ),           // SizedBox
                Positioned(
                  left: 15,
                  right: 15,
                  bottom: -23,
                  child: _buildBalanceCard(context, primary),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 功能列表
            _buildActionItem(
              context,
              icon: Icons.account_balance_wallet,
              iconBg: const Color(0xFF6A5FF9),
              title: I18nKeys.accountWithdrawal.tr,
              imagePath: ImageAssets.mineAccount,
              onTap: controller.onWithdrawTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.assessment_outlined,
              iconBg: AppTheme.primaryColor,
              title: I18nKeys.incomeDetails.tr,
              imagePath: ImageAssets.mineIncome,
              onTap: controller.onIncomeDetailsTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.receipt_long,
              iconBg: const Color(0xFFF7B257),
              title: I18nKeys.withdrawalOrders.tr,
              imagePath: ImageAssets.mineWithdraw,
              onTap: controller.onWithdrawalOrdersTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.lock_outline,
              iconBg: const Color(0xFFFF8E6A),
              title: I18nKeys.changePassword.tr,
              imagePath: ImageAssets.minePsw,
              onTap: controller.onChangePasswordTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.language,
              iconBg: const Color(0xFF002F95),
              title: I18nKeys.languageSettings.tr,
              imagePath: ImageAssets.mineLanguage,
              onTap: controller.onLanguageSettingsTap,
            ),
            _buildDivider(),
            const SizedBox(height: 43),
            Center(
              child: TextButton(
                onPressed: controller.onLogoutTap,
                child: Text(
                  I18nKeys.logout.tr,
                  style: const TextStyle(
                    color: Color(0xFFFF6A6A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      )
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Color primary) {
    return Obx(() {
      final bool visible = controller.showBalance.value;
      return Container(
        height: 108,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // 右上角装饰标签
            Positioned(
              right: 0,
              top: 0,
              
              child: GestureDetector(
                onTap: controller.showExchangePop,
                child: Container(
                  width: 78,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.loginColor.withValues(alpha: 0.6),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                  child: SvgPicture.asset(
                    ImageAssets.mineSwitch,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        I18nKeys.accountBalance.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: controller.toggleBalanceVisibility,
                        child: Icon(
                          visible ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            visible
                                ? controller.pointsBalance.value.toString()
                                : '***',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            I18nKeys.pointsLabel.tr,
                            style: TextStyle(
                              color: AppTheme.nineColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            visible
                                ? (controller.isConvertedDisplay.value 
                                    ? controller.formattedCurrentAmount 
                                    : controller.trxBalance.value.toStringAsFixed(2))
                                : '***',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.isConvertedDisplay.value
                                ? (controller.currentCurrencyCode.isNotEmpty 
                                    ? controller.currentCurrencyCode 
                                    : controller.code.value)
                                : controller.code.value,
                            style: TextStyle(
                              color: AppTheme.nineColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(17),
              ),
              child: SvgPicture.asset(
                imagePath,
                width: 17,
                height: 17,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.threeColor,
                ),
              ),
            ),
            SvgPicture.asset(
              ImageAssets.rightGray,
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(
                AppTheme.nineColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 0.5,
      indent: 20,
      endIndent: 20,
      color: AppTheme.dddColor,
    );
  }
}
