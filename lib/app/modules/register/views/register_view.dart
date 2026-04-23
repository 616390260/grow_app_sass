import 'package:do_task_project/app/core/config/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/constants/image_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/language_switcher.dart';
import '../controllers/register_controller.dart';

class RegisterView extends BaseView<RegisterController> {
  const RegisterView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildContent(BuildContext context) {
    // 绿色背景顶部，使用浅色（白色）状态栏图标
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
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
              top: 265,
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
      height: 320,
      child: Stack(
        children: [
          // 绿色渐变背景
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, AppTheme.primaryGradientMid],
                ),
              ),
            ),
          ),
          // 装饰圆圈（右上）
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          // 装饰圆圈（左下）
          Positioned(
            bottom: 10,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Logo + 平台名 + 注册标题
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  _buildLogoSection(),
                  const SizedBox(height: 18),
                  _buildTitle(),
                  const SizedBox(height: 10),
                  _buildDecorationLine(),
                ],
              ),
            ),
          ),
          // 右上角语言切换入口
          Positioned(
            top: 0,
            right: 14,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: const LanguageSwitcher(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Logo 图标 + 平台名称
  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(ImageAssets.logo, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          EnvironmentConfig.instance.brandName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Color(0x40000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      I18nKeys.register.tr,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDecorationLine() {
    return Container(
      width: 33,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
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
            disabledBackgroundColor: const Color(
              0xFF0B65FF,
            ).withValues(alpha: 0.6),
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
