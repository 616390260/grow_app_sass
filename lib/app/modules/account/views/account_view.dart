import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class AccountView extends BaseView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildContent(BuildContext context) {
    final Color primary = const Color(0xFF4A90E2);
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            // 顶部头部 + 余额卡片
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 274,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF6BB9F0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Color(0xFF4A90E2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.userName.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${I18nKeys.referralCode.tr}: ',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        controller.referralCode.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: controller.copyReferral,
                                        child: const Icon(
                                          Icons.copy,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -60,
                  child: _buildBalanceCard(context, primary),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // 功能列表
            _buildActionItem(
              context,
              icon: Icons.account_balance_wallet,
              iconBg: const Color(0xFF7B61FF),
              title: I18nKeys.accountWithdrawal.tr,
              onTap: controller.onWithdrawTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.assessment_outlined,
              iconBg: const Color(0xFF3A84FF),
              title: I18nKeys.incomeDetails.tr,
              onTap: controller.onIncomeDetailsTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.receipt_long,
              iconBg: const Color(0xFFFFA24C),
              title: I18nKeys.withdrawalOrders.tr,
              onTap: controller.onWithdrawalOrdersTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.lock_outline,
              iconBg: const Color(0xFFFF6B6B),
              title: I18nKeys.changePassword.tr,
              onTap: controller.onChangePasswordTap,
            ),
            _buildDivider(),
            _buildActionItem(
              context,
              icon: Icons.language,
              iconBg: const Color(0xFF0B65FF),
              title: I18nKeys.languageSettings.tr,
              onTap: controller.onLanguageSettingsTap,
            ),

            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: controller.onLogoutTap,
                child: Text(
                  I18nKeys.logout.tr,
                  style: const TextStyle(
                    color: Color(0xFFFF4D4F),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Color primary) {
    return Obx(() {
      final bool visible = controller.showBalance.value;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 右上角装饰标签
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 48,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(color: const Color(0xFFE3ECFF)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        I18nKeys.accountBalance.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            visible
                                ? controller.pointsBalance.value.toString()
                                : '***',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            I18nKeys.pointsLabel.tr,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            visible
                                ? controller.trxBalance.value.toStringAsFixed(2)
                                : '***',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'TRX',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}
