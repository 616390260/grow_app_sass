import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/constants/image_assets.dart';
import '../../../core/widgets/language_switcher.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';

class TaskgoLoginView extends BaseView<LoginController> {
  const TaskgoLoginView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null; // hide app bar
  }

  @override
  Widget buildContent(BuildContext context) {
    final themeColor = TenantService.to.brandColor ?? const Color(0xFF03318C);
    final themeColorDark = HSLColor.fromColor(themeColor)
        .withLightness(
            (HSLColor.fromColor(themeColor).lightness - 0.05).clamp(0.0, 1.0))
        .toColor();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图（含金币和宝箱）
          Container(
            color: themeColor, // 品牌/默认蓝色背景
            child: Image.asset(
              'assets/images/login_coins_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(); // 错误时不显示图片，只显示底层背景色
              },
            ),
          ),
          
          // 主体内容
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30), // 顶部间距
                    
                    // Logo
                    _buildLogoSection(),
                    
                    const SizedBox(height: 12),
                    
                    // App 标题
                    Text(
                      TenantService.to.appName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // "登录" 标题
                    Text(
                      I18nKeys.loginTitle.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 标题下方的短横线
                    Container(
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 登录表单卡片
                    _buildLoginCard(context, themeColorDark),
                    
                    const SizedBox(height: 40), // 底部间距
                  ],
                ),
              ),
            ),
          ),

          // 右上角语言切换入口
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: const LanguageSwitcherButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: TenantService.to.brandLogo != null
            ? Image.network(TenantService.to.brandLogo!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(ImageAssets.logo, fit: BoxFit.cover))
            : Image.asset(ImageAssets.logo, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, Color themeColorDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 账户标题
          Text(
            I18nKeys.accountField.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          // 账户输入框
          _buildInputField(
            controller: controller.accountController,
            errorText: controller.accountError,
            icon: Icons.person_outline,
            placeholder: I18nKeys.accountPlaceholder.tr,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          
          const SizedBox(height: 24),
          
          // 密码标题
          Text(
            I18nKeys.password.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          // 密码输入框
          _buildPasswordField(),
          
          const SizedBox(height: 20),
          
          // 记住密码
          _buildRememberPassword(themeColorDark),
          
          const SizedBox(height: 32),
          
          // 登录按钮
          _buildLoginButton(themeColorDark),
          
          const SizedBox(height: 24),
          
          // 底部 注册/客服
          _buildBottomSection(themeColorDark),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required RxString errorText,
    required IconData icon,
    required String placeholder,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F9), // 浅灰背景色
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: const Color(0xFF666666), size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
        ),
        Obx(() {
          if (errorText.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                errorText.value,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => _buildInputField(
        controller: controller.passwordController,
        errorText: controller.passwordError,
        icon: Icons.lock_outline,
        placeholder: I18nKeys.passwordPlaceholder.tr,
        obscureText: !controller.isPasswordVisible.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF999999),
            size: 20,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
        onSubmitted: (_) => controller.login(),
      ),
    );
  }

  Widget _buildRememberPassword(Color themeColorDark) {
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
                    ? themeColorDark // 选中时的深色
                    : Colors.transparent,
                border: Border.all(
                  color: controller.rememberPassword.value
                      ? themeColorDark
                      : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
              child: controller.rememberPassword.value
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          I18nKeys.rememberPassword.tr,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildLoginButton(Color themeColorDark) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColorDark, // 品牌/默认深色按钮
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      I18nKeys.login.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(Color themeColorDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          I18nKeys.noAccount.tr,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: controller.goToRegister,
          child: Text(
            I18nKeys.goRegister.tr,
            style: TextStyle(
              fontSize: 14,
              color: themeColorDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => InkWell(
            onTap: controller.goToService,
            child: Image.network(
              controller.customerService.value?.icon ?? '',
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(ImageAssets.inviteTelegram, width: 32, height: 32),
              width: 32,
              height: 32,
            ),
          ),
        ),
      ],
    );
  }
}
