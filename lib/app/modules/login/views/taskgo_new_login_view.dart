import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/constants/image_assets.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';

/// 登录页 —— 严格复刻 UI 参考图
///
/// 布局层次（从下到上 Stack）：
///   Layer 0: 全屏绿色背景图（coins/diamonds）
///   Layer 1: 白色卡片（从屏幕 44% 处开始，顶部大圆角）
///   Layer 2: Logo 圆圈（精确悬挂在绿/白交界中心）
///   Layer 3: 安全区内的文字 + 可滚动表单
class TaskgoNewLoginView extends BaseView<LoginController> {
  const TaskgoNewLoginView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF097A45),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          // 白色卡片顶边所在位置（约屏幕44%）
          final cardTop = h * 0.44;
          // Logo 圆圈直径 88，让圆心恰好落在绿/白交界线上
          const logoSize = 88.0;
          final logoTop = cardTop - logoSize / 2;

          return Stack(
            children: [
              // ── Layer 0: 全屏背景图（绿色底 + coins/diamonds）
              Positioned.fill(
                child: Image.asset(
                  'assets/images/login_bg_diamonds.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/login_coins_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: Color(0xFF097A45)),
                  ),
                ),
              ),

              // ── Layer 1: 白色卡片背景（顶部圆角覆盖下半屏）
              Positioned(
                top: cardTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                ),
              ),

              // ── Layer 2: 品牌名（居中于绿色区域）
              Positioned(
                top: h * 0.12,
                left: 0,
                right: 0,
                height: h * 0.28,
                child: Align(
                  alignment: const Alignment(0, 0.3),
                  child: Text(
                    TenantService.to.appName,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF3F8DC),
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 24,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Layer 3: 可滚动内容（安全区内）
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        // 占位：绿色区域 + logo 上半圆
                        SizedBox(height: logoTop),

                        // ── Logo 圆圈（真实图片资产）
                        _buildLogo(),

                        const SizedBox(height: 14),

                        // ── 白卡内容
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            children: [
                              // 品牌名
                              Text(
                                TenantService.to.appName,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // 登录副标题
                              Text(
                                I18nKeys.loginTitle.tr,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF999999),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // ── 输入框组（账户 + 分割线 + 密码）
                              _buildInputGroup(context),

                              const SizedBox(height: 16),

                              // ── 记住密码
                              _buildRememberRow(),

                              const SizedBox(height: 30),

                              // ── 登录按钮
                              _buildLoginButton(),

                              const SizedBox(height: 22),

                              // ── 底部注册 + 客服
                              _buildBottomRow(),

                              // 底部安全距离
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Logo 圆圈：真实图片资产 + 白色描边 + 绿底 + 投影
  // ─────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF097A45),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
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

  // ─────────────────────────────────────────────────────────
  // 输入框组：共用容器 + 中间分割线（严格对应参考图）
  // ─────────────────────────────────────────────────────────
  Widget _buildInputGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 账户输入框
              SizedBox(
                height: 52,
                child: TextField(
                  controller: controller.accountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                  decoration: InputDecoration(
                    hintText: I18nKeys.accountPlaceholder.tr,
                    hintStyle: const TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                  ),
                ),
              ),

              // 分割线
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              // 密码输入框
              SizedBox(
                height: 52,
                child: Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.login(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                    decoration: InputDecoration(
                      hintText: I18nKeys.passwordPlaceholder.tr,
                      hintStyle: const TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 4,
                        top: 15,
                        bottom: 15,
                      ),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFFAAAAAA),
                          size: 20,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 错误提示
        Obx(() {
          final err = controller.accountError.value.isNotEmpty
              ? controller.accountError.value
              : controller.passwordError.value;
          if (err.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              err,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
        }),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // 记住密码（方形复选框 + 文字）
  // ─────────────────────────────────────────────────────────
  Widget _buildRememberRow() {
    return Row(
      children: [
        Obx(
          () => GestureDetector(
            onTap: controller.toggleRememberPassword,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: controller.rememberPassword.value
                    ? const Color(0xFF097A45)
                    : Colors.transparent,
                border: Border.all(
                  color: controller.rememberPassword.value
                      ? const Color(0xFF097A45)
                      : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: controller.rememberPassword.value
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
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

  // ─────────────────────────────────────────────────────────
  // 登录按钮（全宽胶囊形，绿底）
  // ─────────────────────────────────────────────────────────
  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF097A45),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
            disabledBackgroundColor: const Color(0xFFCCCCCC),
          ),
          child: controller.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${TenantService.to.appName} ${I18nKeys.login.tr}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 底部行："无账户？立即注册" 居中 + Telegram 图标右侧
  // ─────────────────────────────────────────────────────────
  Widget _buildBottomRow() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 居中文字
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              I18nKeys.noAccount.tr,
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: controller.goToRegister,
              child: Text(
                I18nKeys.goRegister.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF097A45),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // 右侧客服图标
        Positioned(
          right: 0,
          child: Obx(() {
            final iconUrl = controller.customerService.value?.icon ?? '';
            return GestureDetector(
              onTap: controller.goToService,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF2FA6D9),
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: iconUrl.isNotEmpty
                    ? Image.network(
                        iconUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
