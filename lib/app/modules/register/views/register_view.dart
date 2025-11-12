import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/constants/image_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/register_controller.dart';

class RegisterView extends BaseView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

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
    
    // 从URL参数获取邀请码并自动填充（仅在Web平台）
    if (kIsWeb) {
      _getInviteCodeFromUrl();
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // 让body延伸到AppBar后面
      body: Container(
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
    return Container(
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
        ],
      ),
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

  /// 从URL参数获取邀请码（仅在Web平台）
  void _getInviteCodeFromUrl() {
    try {
      // 尝试从Get参数中获取邀请码（适用于所有平台）
      final inviteCode = Get.parameters['i'];
      if (inviteCode != null && inviteCode.isNotEmpty) {
        // 自动填充邀请码到控制器
        controller.inviteCodeController.text = inviteCode;
      } else if (kIsWeb) {
        // 在Web平台，尝试使用dart:html获取URL参数（运行时执行）
        try {
          // 使用dynamic避免编译时错误
          dynamic _evalJs(String js) {
            return null;
          }
          
          // 尝试获取URL中的邀请码参数
          // 注意：这部分代码在非Web平台会抛出异常但会被外层try-catch捕获
        } catch (e) {
          debugPrint('Web URL参数获取失败: $e');
        }
      }
    } catch (e) {
      // 捕获可能的错误，避免影响页面正常加载
      debugPrint('获取URL邀请码失败: $e');
    }
  }
}
