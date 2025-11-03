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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 国家标题
          const SizedBox(height: 10),
          Text(
            '尼日利亚',
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
                _buildFormField(
                  label: I18nKeys.bankName.tr,
                  placeholder: '请输入开户银行',
                  value: controller.bankName,
                  onChanged: controller.setBankName,
                ),
              Container(
                height: 0.5,
                color: AppTheme.lineColor,
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
                _buildFormField(
                  label: I18nKeys.accountNumber.tr,
                  placeholder: '请输入收款账号',
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
                  placeholder: '请输入收款姓名',
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
                  placeholder: '请输入登录密码',
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

  // 构建提现说明
  Widget _buildWithdrawalDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '提现说明：',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '最低提现金额为 1000.00',
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor),
        ),
        const SizedBox(height: 4),
        Text(
          '每天只能提现3次，请仔细核对信息是否输入正确，提现未到账，请联系客服',
          style: TextStyle(fontSize: 13, color: AppTheme.sixColor),
        ),
      ],
    );
  }
}
