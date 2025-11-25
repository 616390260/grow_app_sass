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
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (Get.key.currentState!.canPop()) {
            Get.back();
          } else {
            // 刷新后 fallback 到首页
            Get.offAllNamed(Routes.root);
          }
        },
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 转出到部分
          Container(height: 10, color: AppTheme.bgColor),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
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
          spacing: 20,
          runSpacing: 10,
          children: controller.countries.map((country) {
            bool isSelected =
                controller.selectedCountry.value == country;
            return ElevatedButton(
              onPressed: () {
                controller.selectCountry(country);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bgColor,
                foregroundColor: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.sixColor,
                minimumSize: const Size(00, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.nineColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                country.payName,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.nineColor, width: 0.5),

            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Row(
                  children: [
                    Text(
                      controller.selectedCountry.value.payName,
                      style: TextStyle(fontSize: 14, color: AppTheme.threeColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.bankName.value,
                      style: TextStyle(fontSize: 14, color: AppTheme.nineColor),
                    ),
                  ]
                );
              }),
              GestureDetector(
                onTap: () async {
                  // 导航到支付方式页面并等待返回结果
                  dynamic result = await Get.toNamed(Routes.paymentMethod, arguments: {
                    'country': controller.selectedCountry.value.payName,
                    'countryId': controller.selectedCountry.value.id,
                    'minAmount': (controller.selectedCountry.value.minAmount ?? 0).toStringAsFixed(0),
                    'dailyLimit': controller.withdrawalSetting.value.oneDayNum?.toString() ?? '2',
                  });
                  
                  // 处理返回的数据
                  if (result != null) {
                    print('收到支付方式页面返回数据: $result');
                    // 这里可以处理返回的数据，例如保存到控制器中或更新UI
                    // 示例：
                    controller.bankName.value = result['bankName'] ?? '';
                    controller.phone.value = result['phone'] ?? '';
                    controller.bankCode.value = result['bankCode'] ?? 0;
                    controller.accountNumber.value = result['accountNumber'] ?? '';
                    controller.accountName.value = result['accountName'] ?? '';
                    controller.loginPassword.value = result['loginPassword'] ?? '';
                    
                  }
                },
                child: Text(
                  I18nKeys.add.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              I18nKeys.withdrawAmount.tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.threeColor,
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => Text(
              '${I18nKeys.withdrawFee.tr}${controller.selectedCountry.value.fee?.toStringAsFixed(0)}${I18nKeys.points.tr}',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.ff6a6aColor,
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.nineColor, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
            children: [
              
              Expanded(
                child: Obx(() => TextField(
                  controller: TextEditingController(),
                  onChanged: controller.setWithdrawAmount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: '${I18nKeys.maxWithdraw.tr}${controller.maxAmount.value.toStringAsFixed(0)}',
                    hintStyle: TextStyle(fontSize: 14, color: AppTheme.nineColor),
                  ),
                  style: TextStyle(fontSize: 14, color: AppTheme.threeColor),
                )),
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
            color: AppTheme.nineColor,
          ),
        ),
        Obx(() => (controller.withdrawAmount.value.toString().isEmpty || controller.withdrawAmount.value == 0)
          ? SizedBox()
          : Text(
              '${controller.withdrawAmount.value} ${I18nKeys.pointsLabel.tr}=${(double.parse(controller.withdrawAmount.value.toString()) * (controller.selectedCountry.value.exchangeRate ?? 1.0)).toStringAsFixed(2)} ${ controller.selectedCountry.value.code}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.threeColor,
              ),
            ))
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          I18nKeys.withdrawConfirm.tr,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 7),
        Obx(() => Text(
          '${I18nKeys.minWithdrawAmount.trArgs([(controller.selectedCountry.value.minAmount??0).toStringAsFixed(0)])}'
          '\n${I18nKeys.dailyWithdrawLimit.trArgs([controller.withdrawalSetting.value.oneDayNum?.toString() ?? '2'])}\n${I18nKeys.withdrawTips.tr}',
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor,fontWeight: FontWeight.w500),
        )),
      ],
    );
  }
}
