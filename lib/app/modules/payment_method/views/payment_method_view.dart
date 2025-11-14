import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/payment_method_controller.dart';

class PaymentMethodView extends BaseView<PaymentMethodController> {
  const PaymentMethodView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        I18nKeys.paymentMethodTitle.tr,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      // 沉浸式状态栏配置
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    // 初始化时加载银行列表
    if (controller.bankList.isEmpty) {
      debugPrint('银行列表为空，开始加载银行列表...');
      controller.loadBankList();
    } else {
      debugPrint('银行列表已加载，共${controller.bankList.length}条数据');
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 国家标题
          const SizedBox(height: 10),
          Text(
            '${Get.arguments?['country']}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 17),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                // 表单字段
                InkWell(
                  onTap: () => _showBankSelectDialog(),
                  child: Container(
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 0,
                    //   vertical: 20,
                    // ),
                    child: _buildBankFormField(
                      label: I18nKeys.bankName.tr,
                      placeholder: I18nKeys.pleaseSelectBankPlaceholder.tr,
                      value: controller.bankName,
                      onChanged: controller.setBankName,
                    ),
                  ),
                ),

                Container(
                  height: 0.5,
                  color: AppTheme.lineColor,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                ),
                _buildFormField(
                  label: I18nKeys.accountNumber.tr,
                  placeholder: I18nKeys.pleaseEnterAccountNumberPlaceholder.tr,
                  value: controller.accountNumber,
                  onChanged: controller.setAccountNumber,
                ),
                Container(
                  height: 0.5,
                  color: AppTheme.lineColor,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                ),
                _buildFormField(
                  label: I18nKeys.accountName.tr,
                  placeholder: I18nKeys.pleaseEnterAccountNamePlaceholder.tr,
                  value: controller.accountName,
                  onChanged: controller.setAccountName,
                ),
                Container(
                  height: 0.5,
                  color: AppTheme.lineColor,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                ),
                _buildFormField(
                  label: I18nKeys.loginPassword.tr,
                  placeholder: I18nKeys.pleaseEnterLoginPasswordPlaceholder.tr,
                  value: controller.loginPassword,
                  onChanged: controller.setLoginPassword,
                  isPassword: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          // 确定按钮
          ElevatedButton(
            onPressed: controller.submitPaymentInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              I18nKeys.confirm.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 25),

          // 提现说明
          _buildWithdrawalDescription(),
        ],
      ),
    );
  }

  // 构建表单字段
  Widget _buildFormField({
    required String label,
    required String placeholder,
    required RxString value,
    required void Function(String) onChanged,
    bool isPassword = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(width: 19),
        Expanded(
          child: TextField(
            obscureText: isPassword,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(fontSize: 14, color: AppTheme.nineColor),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // 显示银行选择对话框
  void _showBankSelectDialog() {
    print('打开银行选择弹窗，当前银行列表数量: ${controller.bankList.length}');
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                I18nKeys.selectBank.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.threeColor,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return Container(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: controller.bankList.map((bank) {
                        return _buildBankItem(
                          bank.name,
                          controller.bankName.value,
                          () {
                            controller.setSelectedBank(bank.name, bank.id);
                            Get.back();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
  
  // 构建银行选择项
  Widget _buildBankItem(
    String bankName,
    String selectedBank,
    void Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(229, 229, 229, 1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bankName,
              style: TextStyle(
                fontSize: 14,
                color: selectedBank == bankName
                    ? AppTheme.primaryColor
                    : const Color.fromRGBO(51, 51, 51, 1),
              ),
            ),
            if (selectedBank == bankName)
              Icon(
                Icons.check,
                size: 16,
                color: AppTheme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  // 构建表单字段
  Widget _buildBankFormField({
    required String label,
    required String placeholder,
    required RxString value,
    required void Function(String) onChanged,
    bool isPassword = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(width: 19),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Text(
              '${controller.bankName.value.isEmpty ? placeholder : controller.bankName.value}',
              style: const TextStyle(fontSize: 14, color: AppTheme.nineColor),
            ),
          ),
        ),
        SvgPicture.asset(ImageAssets.rightGray, width: 14, height: 14),
      ],
    );
  }

  // 构建提现说明
  Widget _buildWithdrawalDescription() {
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
        Text(
          I18nKeys.minWithdrawAmount.trArgs([Get.arguments?['minAmount'] ?? '0']),
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor),
        ),
        const SizedBox(height: 4),
        Text(
          I18nKeys.dailyWithdrawLimit.trArgs([Get.arguments?['dailyLimit'] ?? '2']),
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor),
        ),
        const SizedBox(height: 4),
        Text(
          I18nKeys.withdrawTips.tr,
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor),
        ),
      ],
    );
  }
}
