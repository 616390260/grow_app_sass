import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/base/base_view.dart';
import '../../../core/constants/image_assets.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/widgets/language_switcher.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';

/**
 * 登录页 —— 深色星空+金色辉光复刻版
 */
class TaskgoGoldLoginView extends BaseView<LoginController> {
  const TaskgoGoldLoginView({super.key});

  /// 页面主背景色（深灰，避免纯黑）
  static const _bgColor = Color(0xFF2A2A2A);

  /// 卡片内背景色
  static const _cardColor = Color(0xFF333333);

  @override
  Color? get backgroundColor => _bgColor;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: _bgColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final accentColor = TenantService.to.brandColor ?? const Color(0xFFE8C779);
    final accentHsl = HSLColor.fromColor(accentColor);
    final accentDark = accentHsl
        .withLightness((accentHsl.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();
    final accentLight = accentHsl
        .withLightness((accentHsl.lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _bgColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Layer 0: 全屏背景色（图片透明区域透出此颜色）
          const Positioned.fill(
            child: ColoredBox(color: _bgColor),
          ),

          // ── Layer 1: 全屏背景图（PNG 透明区域会露出 _bgColor）
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg_gold_planet.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // ── Layer 1: 可滚动内容（安全区内）
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.10),
                      _buildLogo(accentColor, accentDark, accentLight),
                      const SizedBox(height: 12),
                      _buildBrandName(accentColor, accentDark, accentLight),
                      SizedBox(height: h * 0.08),
                      _buildGlassCard(
                        context,
                        accentColor,
                        accentDark,
                        accentLight,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
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

  /// 品牌名（带有外发光与金属渐变）
  Widget _buildBrandName(
    Color accentColor,
    Color accentDark,
    Color accentLight,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          TenantService.to.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = accentColor.withValues(alpha: 0.3),
            shadows: [
              Shadow(
                color: accentLight.withValues(alpha: 0.6),
                blurRadius: 16,
              ),
              Shadow(
                color: const Color(0xFF2A2A2A).withValues(alpha: 0.8),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentLight,
              accentDark,
            ],
            stops: const [0.2, 0.9],
          ).createShader(bounds),
          child: Text(
            TenantService.to.appName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }

  /// Logo 圆圈：带有星球面光圈与金属渐变描边
  Widget _buildLogo(Color accentColor, Color accentDark, Color accentLight) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                accentLight.withValues(alpha: 0.8),
                accentColor.withValues(alpha: 0.4),
                accentDark.withValues(alpha: 0.0),
              ],
              stops: const [0.4, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: accentLight.withValues(alpha: 0.4),
                blurRadius: 28,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: accentDark.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 16,
              ),
            ],
          ),
        ),
        Container(
          width: 88,
          height: 88,
          padding: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accentLight, accentDark],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2A2A2A).withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2E2E2E),
            ),
            child: ClipOval(
              child: TenantService.to.brandLogo != null
                  ? Image.network(TenantService.to.brandLogo!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(ImageAssets.logo, fit: BoxFit.cover))
                  : Image.asset(ImageAssets.logo, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  /// 玻璃态金边卡片
  Widget _buildGlassCard(
    BuildContext context,
    Color accentColor,
    Color accentDark,
    Color accentLight,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.85),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 48,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: accentLight.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.accountField.tr,
            style: TextStyle(fontSize: 15, color: accentColor),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.accountController,
            hintText: I18nKeys.accountPlaceholder.tr,
            isPassword: false,
            accentColor: accentColor,
          ),
          const SizedBox(height: 24),
          Text(
            I18nKeys.password.tr,
            style: TextStyle(fontSize: 15, color: accentColor),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.passwordController,
            hintText: I18nKeys.passwordPlaceholder.tr,
            isPassword: true,
            accentColor: accentColor,
          ),
          const SizedBox(height: 24),
          Obx(() {
            final err = controller.accountError.value.isNotEmpty
                ? controller.accountError.value
                : controller.passwordError.value;
            if (err.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                err,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            );
          }),
          _buildRememberRow(accentColor),
          const SizedBox(height: 36),
          _buildLoginButton(accentDark, accentLight),
          const SizedBox(height: 28),
          _buildBottomRow(accentDark, accentLight),
        ],
      ),
    );
  }

  /// 带有底部金线的输入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: isPassword
          ? Obx(
              () => TextField(
                controller: controller,
                obscureText: !this.controller.isPasswordVisible.value,
                style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 15),
                cursorColor: accentColor,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      this.controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withValues(alpha: 0.35),
                      size: 20,
                    ),
                    onPressed: this.controller.togglePasswordVisibility,
                  ),
                ),
              ),
            )
          : TextField(
              controller: controller,
              style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 15),
              cursorColor: accentColor,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
    );
  }

  /// 记住密码（圆形复选框 + 文字）
  Widget _buildRememberRow(Color accentColor) {
    return Row(
      children: [
        Obx(
          () => GestureDetector(
            onTap: controller.toggleRememberPassword,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor,
                  width: 1.5,
                ),
                color: controller.rememberPassword.value
                    ? accentColor
                    : Colors.transparent,
              ),
              child: controller.rememberPassword.value
                  ? const Icon(Icons.check, size: 12, color: Color(0xFF1A1A1A))
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          I18nKeys.rememberPassword.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  /// 登录按钮（金黄色渐变底）
  Widget _buildLoginButton(Color accentDark, Color accentLight) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [accentLight, accentDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: accentDark.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF1A1A1A),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF1A1A1A)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      I18nKeys.login.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Color(0xFF1A1A1A),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// 底部行："无账户？ 立即注册" + 小飞机
  Widget _buildBottomRow(Color accentDark, Color accentLight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          I18nKeys.noAccount.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: controller.goToRegister,
          child: Text(
            I18nKeys.goRegister.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: controller.goToService,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accentLight, accentDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.send_rounded,
                size: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
