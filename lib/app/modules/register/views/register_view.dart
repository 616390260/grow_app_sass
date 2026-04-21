import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/i18n/locale_config.dart';
import '../../../core/constants/image_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/register_controller.dart';

/// 注册页顶部语言切换下拉项。
/// 注意：选项列表需与 `LanguageSettingsController.options` 保持一致。
class _LanguageOption {
  final String label;
  final Locale locale;
  const _LanguageOption(this.label, this.locale);
}

const List<_LanguageOption> _registerLanguageOptions = <_LanguageOption>[
  _LanguageOption('简体中文', Locale('zh', 'CN')),
  _LanguageOption('English', Locale('en', 'US')),
  _LanguageOption('Indonesia', Locale('id', 'ID')),
  _LanguageOption('Bangladesh', Locale('bn', 'BD')),
  _LanguageOption('Brazil', Locale('pt', 'BR')),
  _LanguageOption('India', Locale('hi', 'IN')),
  _LanguageOption('Mexico', Locale('es', 'MX')),
  _LanguageOption('Spanish', Locale('es', 'ES')),
];

class RegisterView extends BaseView<RegisterController> {
  const RegisterView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildContent(BuildContext context) {
    // 设置沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 透明状态栏
        statusBarIconBrightness: Brightness.dark, // 状态栏图标为深色
        statusBarBrightness: Brightness.light, // iOS状态栏内容为深色
        systemNavigationBarColor: Colors.white, // 导航栏背景色
        systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标为深色
      ),
    );
    
    // 从URL参数获取邀请码并自动填充（适用于所有平台）
    controller.getInviteCodeFromUrl();

    return Scaffold(
      extendBodyBehindAppBar: true, // 让body延伸到AppBar后面
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // 顶部图标区域（背景层）
            _buildTopSection(),

            // 表单容器区域（覆盖层，带圆角和白色背景）
            Positioned(
              top: 223, // 调整位置让表单覆盖在顶部区域上
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 26), // 顶部间距
                        // 注册表单
                        _buildRegisterForm(),

                        const SizedBox(height: 43),

                        // 注册按钮
                        _buildRegisterButton(),

                        const SizedBox(height: 22),

                        // 底部登录链接
                        _buildBottomSection(),

                        const SizedBox(height: 40), // 底部额外间距
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return SizedBox(
      height: 283, // 添加状态栏高度
      child: Stack(
        children: [
          // 背景图片，延伸到状态栏
          Positioned.fill(
            child: Image.asset(ImageAssets.loginBg, fit: BoxFit.cover),
          ),
          // 注册标题
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildTitle(),
                const SizedBox(height: 11),

                // 蓝色装饰线
                _buildDecorationLine(),
              ],
            ),
          ),
          // 状态栏区域的渐变遮罩（可选，增强状态栏图标可见性）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(Get.context!).padding.top + 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          // 右上角语言切换入口
          Positioned(
            top: MediaQuery.of(Get.context!).padding.top + 8,
            right: 16,
            child: _buildLanguageSwitcher(),
          ),
        ],
      ),
    );
  }

  /// 顶部右上角的语言切换按钮（地球图标 + 当前语言名）。
  Widget _buildLanguageSwitcher() {
    final currentLocale = Get.locale ?? LocaleConfig.getInitialLocale();
    final currentLabel = _registerLanguageOptions
        .firstWhere(
          (o) =>
              o.locale.languageCode == currentLocale.languageCode &&
              o.locale.countryCode == currentLocale.countryCode,
          orElse: () => _registerLanguageOptions.first,
        )
        .label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLanguagePicker(Get.context!),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16, color: AppTheme.threeColor),
              const SizedBox(width: 4),
              Text(
                currentLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.threeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: AppTheme.threeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 弹出底部语言选择抽屉。
  void _showLanguagePicker(BuildContext context) {
    final currentLocale = Get.locale ?? LocaleConfig.getInitialLocale();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  I18nKeys.languageSettings.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.threeColor,
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEDEDED)),
              ..._registerLanguageOptions.map((opt) {
                final selected =
                    currentLocale.languageCode == opt.locale.languageCode &&
                    currentLocale.countryCode == opt.locale.countryCode;
                return InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    if (!selected) {
                      await LocaleConfig.updateLocale(opt.locale);
                    }
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt.label,
                            style: TextStyle(
                              fontSize: 15,
                              color: selected
                                  ? const Color(0xFF0B65FF)
                                  : Colors.black87,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF0B65FF),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      I18nKeys.register.tr,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.threeColor,
      ),
    );
  }

  Widget _buildDecorationLine() {
    return Container(
      width: 33,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90E2),
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 账号输入框
        _buildInputField(
          label: I18nKeys.accountField.tr,
          placeholder: I18nKeys.accountPlaceholder.tr,
          controller: controller.accountController,
          focusNode: controller.accountFocus,
          errorText: controller.accountErrorRx,
          onSubmitted: (_) => controller.passwordFocus.requestFocus(),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppTheme.lineColor),
        ),
        const SizedBox(height: 22),

        // 密码输入框
        _buildPasswordField(
          label: I18nKeys.password.tr,
          placeholder: I18nKeys.passwordPlaceholder.tr,
          controller: controller.passwordController,
          focusNode: controller.passwordFocus,
          errorText: controller.passwordErrorRx,
          isPasswordVisible: () => controller.isPasswordVisible,
          onToggleVisibility: controller.togglePasswordVisibility,
          onSubmitted: (_) => controller.confirmPasswordFocus.requestFocus(),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppTheme.lineColor),
        ),
        const SizedBox(height: 22),

        // 确认密码输入框
        _buildPasswordField(
          label: I18nKeys.confirmPassword.tr,
          placeholder: I18nKeys.confirmPasswordPlaceholder.tr,
          controller: controller.confirmPasswordController,
          focusNode: controller.confirmPasswordFocus,
          errorText: controller.confirmPasswordErrorRx,
          isPasswordVisible: () => controller.isConfirmPasswordVisible,
          onToggleVisibility: controller.toggleConfirmPasswordVisibility,
          onSubmitted: (_) => controller.inviteCodeFocus.requestFocus(),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppTheme.lineColor),
        ),
        const SizedBox(height: 22),

        // 邀请码输入框
        _buildInputField(
          label: I18nKeys.inviteCode.tr,
          placeholder: I18nKeys.inviteCodePlaceholder.tr,
          controller: controller.inviteCodeController,
          focusNode: controller.inviteCodeFocus,
          errorText: controller.inviteCodeErrorRx,
          enabled: !controller.isInviteCodeFromUrl, // 如果邀请码来自URL参数，则不可编辑
          onSubmitted: (_) => controller.register(),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppTheme.lineColor),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required FocusNode focusNode,
    required RxString errorText,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.threeColor,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  enabled: enabled,
                  onSubmitted: onSubmitted,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              // 错误信息显示在右侧，与输入框对齐
              if (errorText.value.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    errorText.value,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              // suffixIcon显示在错误信息的右边
              if (suffixIcon != null) ...[const SizedBox(width: 8), suffixIcon],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required FocusNode focusNode,
    required RxString errorText,
    required bool Function() isPasswordVisible,
    required VoidCallback onToggleVisibility,
    Function(String)? onSubmitted,
  }) {
    return Obx(
      () => _buildInputField(
        label: label,
        placeholder: placeholder,
        controller: controller,
        focusNode: focusNode,
        errorText: errorText,
        obscureText: !isPasswordVisible(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible()
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey[400],
          ),
          onPressed: onToggleVisibility,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Obx(() {
      final isLoading = controller.isLoading;
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: isLoading ? null : controller.register,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.loginColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: const Color(0xFF0B65FF).withValues(alpha: 0.6),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  I18nKeys.register.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // 登录链接
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          I18nKeys.alreadyHaveAccount.tr,
          style: const TextStyle(fontSize: 13, color: AppTheme.nineColor),
        ),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: controller.goToLogin,
          child: Text(
            I18nKeys.login.tr,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.loginColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

}
