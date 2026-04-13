import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';

class LoginView extends BaseView<LoginController> {
  // 不再使用FocusNode，改为通过FocusScope管理焦点

  const LoginView({super.key});

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

    // 不再使用FocusNode，改为通过FocusScope管理焦点
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (accountFocusNode.hasFocus) {
    //     accountFocusNode.unfocus();
    //   }
    //   if (passwordFocusNode.hasFocus) {
    //     passwordFocusNode.unfocus();
    //   }
    // });

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
                        // 登录表单
                        _buildLoginForm(),

                        const SizedBox(height: 17),

                        // 记住密码
                        _buildRememberPassword(),

                        const SizedBox(height: 47),

                        // 登录按钮
                        _buildLoginButton(),

                        const SizedBox(height: 22),

                        // 底部注册链接
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
      height: 283,
      child: Stack(
        children: [
          // 深绿渐变底色
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF2E7D32),
                    Color(0xFF43A047),
                  ],
                ),
              ),
            ),
          ),
          // 大面积斜向光带
          Positioned(
            top: -60,
            left: -80,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF66BB6A).withValues(alpha: 0.45),
                      const Color(0xFF81C784).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 右上角高亮椭圆
          Positioned(
            top: -20,
            right: -40,
            child: Container(
              width: 180,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    const Color(0xFFA5D6A7).withValues(alpha: 0.35),
                    const Color(0xFF66BB6A).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // 左下装饰圆
          Positioned(
            bottom: 40,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
            ),
          ),
          // 右侧小装饰圆
          Positioned(
            top: 70,
            right: 50,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // 玻璃质感装饰条
          Positioned(
            top: 45,
            right: -15,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // 底部浅色点缀
          Positioned(
            bottom: 60,
            right: 90,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          // 登录标题
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildTitle(),
                const SizedBox(height: 11),
                _buildDecorationLine(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      I18nKeys.loginTitle.tr,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDecorationLine() {
    return Container(
      width: 33,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 账号输入框
        _buildInputField(
          label: I18nKeys.accountField.tr,
          placeholder: I18nKeys.accountPlaceholder.tr,
          controller: controller.accountController,
          errorText: controller.accountError,
          onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppTheme.lineColor),
        ),
        const SizedBox(height: 22),

        // 密码输入框
        _buildPasswordField(),
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
                    // 移除suffixIcon，改为在右侧显示
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

  Widget _buildPasswordField() {
    return Obx(
      () => _buildInputField(
        label: I18nKeys.password.tr,
        placeholder: I18nKeys.passwordPlaceholder.tr,
        controller: controller.passwordController,
        errorText: controller.passwordError,
        obscureText: !controller.isPasswordVisible.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey[400],
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
        onSubmitted: (_) => controller.login(),
      ),
    );
  }

  Widget _buildRememberPassword() {
    return Row(
      children: [
        Obx(
          () => GestureDetector(
            onTap: controller.toggleRememberPassword,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: controller.rememberPassword.value
                    ? const Color(0xFF4CAF50)
                    : Colors.transparent,
                border: Border.all(
                  color: controller.rememberPassword.value
                      ? const Color(0xFF4CAF50)
                      : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: controller.rememberPassword.value
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          I18nKeys.rememberPassword.tr,
          style: const TextStyle(fontSize: 13, color: AppTheme.threeColor),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.loginColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  I18nKeys.login.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          I18nKeys.noAccount.tr,
          style: const TextStyle(fontSize: 13, color: AppTheme.nineColor),
        ),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: controller.goToRegister,
          child: Text(
            I18nKeys.goRegister.tr,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.loginColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => InkWell(
            onTap: controller.goToService,
            child: Image.network(
              controller.customerService.value?.icon ?? '',
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(ImageAssets.inviteTelegram,width: 30,height: 30,),
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }
}
