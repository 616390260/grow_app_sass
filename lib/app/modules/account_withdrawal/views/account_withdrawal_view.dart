import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/core/theme/text_styles.dart';
import '../controllers/account_withdrawal_controller.dart';

class AccountWithdrawalView extends BaseView<AccountWithdrawalController> {
  const AccountWithdrawalView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        I18nKeys.accountWithdrawal.tr,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      leading: const BackButton(),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.threeColor,
    );
  }

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 转出到部分
          _buildCountrySelectionSection(),
          
          const SizedBox(height: 20),
          
          // 地址部分
          _buildAddressSection(),
          
          const SizedBox(height: 20),
          
          // 转出金额部分
          _buildAmountSection(),
          
          const SizedBox(height: 20),
          
          // 确定按钮
          _buildConfirmButton(),
          
          const SizedBox(height: 20),
          
          // 提现说明部分
          _buildDescriptionSection(),
        ],
      ),
    );
  }

  // 国家选择部分
  Widget _buildCountrySelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.withdrawTo.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.countries.map((country) {
            bool isSelected = controller.selectedCountry.value == country['key'];
            return ElevatedButton(
              onPressed: () {
                controller.selectCountry(country['key']!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected 
                  ? AppTheme.primaryColor 
                  : Colors.white,
                foregroundColor: isSelected 
                  ? Colors.white 
                  : AppTheme.sixColor,
                minimumSize: const Size(80, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: isSelected 
                      ? AppTheme.primaryColor 
                      : AppTheme.sixColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                country['label']!,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 地址部分
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.address.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dddColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${I18nKeys.nigeria.tr} ${I18nKeys.addNigeria.tr}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.nineColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.PAYMENT_METHOD);
                },
                child: Text(
                  I18nKeys.add.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // 金额部分
  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              I18nKeys.withdrawAmount.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.threeColor,
              ),
            ),
            Text(
              '${I18nKeys.withdrawFee.tr}${controller.withdrawalFee.toStringAsFixed(2)}${I18nKeys.points.tr}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dddColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                '${I18nKeys.maxWithdraw.tr} ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.nineColor,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: TextEditingController(),
                  onChanged: controller.setWithdrawAmount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.threeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          I18nKeys.youWillWithdraw.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
      ],
    );
  }

  // 确定按钮
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: controller.handleWithdraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
              I18nKeys.withdrawConfirm.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }

  // 提现说明部分
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.withdrawDescription.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${I18nKeys.minWithdrawAmount.tr}\n${I18nKeys.dailyWithdrawLimit.tr}\n${I18nKeys.withdrawTips.tr}',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.sixColor,
          ),
        ),
      ],
    );
  }
}