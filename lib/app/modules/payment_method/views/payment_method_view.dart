import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
      ],
      // 沉浸式状态栏配置
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 国家标题
          Text(
            '尼日利亚',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // 表单字段
          _buildFormField(
            label: I18nKeys.bankName.tr,
            placeholder: '请输入开户银行',
            value: controller.bankName,
            onChanged: controller.setBankName,
          ),
          
          _buildFormField(
            label: I18nKeys.accountNumber.tr,
            placeholder: '请输入收款账号',
            value: controller.accountNumber,
            onChanged: controller.setAccountNumber,
          ),
          
          _buildFormField(
            label: I18nKeys.accountName.tr,
            placeholder: '请输入收款姓名',
            value: controller.accountName,
            onChanged: controller.setAccountName,
          ),
          
          _buildFormField(
            label: I18nKeys.loginPassword.tr,
            placeholder: '请输入登录密码',
            value: controller.loginPassword,
            onChanged: controller.setLoginPassword,
            isPassword: true,
          ),
          
          const SizedBox(height: 30),
          
          // 确定按钮
          ElevatedButton(
            onPressed: controller.submitPaymentInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              I18nKeys.confirm.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppTheme.nineColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: AppTheme.sixColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: AppTheme.sixColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 构建提现说明
  Widget _buildWithdrawalDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '提现说明：',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '最低提现金额为 1000.00',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '每天只能提现3次，请仔细核对信息是否输入正确，提现未到账，请联系客服',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}