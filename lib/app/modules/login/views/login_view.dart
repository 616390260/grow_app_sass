import 'package:do_task_project/app/core/config/environment_config.dart';
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
                child: Stack(
                  children: [
                    // 底部白色区域的金币堆叠效果
                    _buildLeftCoinPile(),
                    _buildRightCoinPile(),

                    SingleChildScrollView(
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

                            const SizedBox(height: 40),

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
                  ],
                ),
              ),
            ),
            
            // 跨界漂浮金币（一半在绿色背景，一半在白色卡片）
            _build3DCoin(size: 80, top: 220, right: 20, angle: -0.5, tiltX: 0.6, tiltY: 0.4, opacity: 1.0, coinType: 0),
            _build3DCoin(size: 45, top: 240, left: 30, angle: 0.6, tiltX: 0.9, tiltY: -0.3, opacity: 0.95, isDark: true, coinType: 2),
            _build3DCoin(size: 35, top: 210, right: 80, angle: 0.2, tiltX: 1.1, tiltY: 0.1, opacity: 0.8, coinType: 3),
          ],
        ),
      ),
    );
  }

  /// 底部左侧金币堆叠
  Widget _buildLeftCoinPile() {
    return Positioned(
      bottom: -30,
      left: -40,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 底层散落
            _build3DCoin(size: 90, bottom: 10, left: 20, tiltX: 1.0, angle: 0.2, isDark: true, coinType: 1),
            _build3DCoin(size: 85, bottom: 30, left: 80, tiltX: 1.2, angle: -0.4, coinType: 2),
            // 中层堆叠
            _build3DCoin(size: 95, bottom: 40, left: 30, tiltX: 1.1, angle: 0.5, coinType: 0),
            _build3DCoin(size: 90, bottom: 65, left: 45, tiltX: 0.9, angle: 0.1, isDark: true, coinType: 1),
            // 顶层倾斜靠着
            _build3DCoin(size: 100, bottom: 50, left: 90, tiltX: 0.4, tiltY: 0.6, angle: -0.2, coinType: 0),
            _build3DCoin(size: 80, bottom: 90, left: 60, tiltX: 0.8, angle: 0.3, coinType: 2),
          ],
        ),
      ),
    );
  }

  /// 底部右侧金币堆叠
  Widget _buildRightCoinPile() {
    return Positioned(
      bottom: -20,
      right: -20,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _build3DCoin(size: 70, bottom: 10, right: 20, tiltX: 1.1, angle: -0.3, isDark: true, coinType: 1),
            _build3DCoin(size: 75, bottom: 35, right: 30, tiltX: 0.9, angle: 0.2, coinType: 0),
            _build3DCoin(size: 65, bottom: 20, right: 70, tiltX: 0.6, tiltY: -0.5, angle: 0.4, coinType: 2),
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
          // 漂浮的 3D 金币装饰 (顶部背景) - 减少元素
          _build3DCoin(size: 60, top: 40, right: 10, angle: 0.4, tiltX: 0.5, tiltY: 0.3, opacity: 0.9, coinType: 0),
          _build3DCoin(size: 35, top: 110, left: 30, angle: -0.3, tiltX: 0.8, tiltY: -0.2, opacity: 0.7, isDark: true, coinType: 1),
          // Logo + 平台名 + 登录标题
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
        ],
      ),
    );
  }

  /// 漂浮的 3D 金币装饰元素（使用 Flutter 绘制，模拟图2的厚重金属感）
  Widget _build3DCoin({
    required double size,
    double? top,
    double? left,
    double? right,
    double? bottom,
    double angle = 0,
    double tiltX = 0,
    double tiltY = 0,
    double opacity = 1.0,
    bool isDark = false, // 是否是暗色金币（增加层次感）
    int coinType = 0, // 0: 星星, 1: 同心圆, 2: 钻石, 3: 闪光空白
  }) {
    // 根据图2调整金币颜色：更偏向真实的黄铜/黄金色，对比度更强
    final baseColor = isDark ? const Color(0xFFB45309) : const Color(0xFFF59E0B);
    final lightColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFFFD700);
    final darkColor = isDark ? const Color(0xFF78350F) : const Color(0xFFB45309);
    final borderColor = isDark ? const Color(0xFFD97706) : const Color(0xFFFEF08A);

    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Opacity(
        opacity: opacity,
        child: Transform(
          // 使用 3D 旋转来模拟硬币的透视感
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 透视效果
            ..rotateX(tiltX) // X轴旋转产生倾斜
            ..rotateY(tiltY) // Y轴旋转产生翻转
            ..rotateZ(angle), // Z轴平面旋转
          alignment: Alignment.center,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // 模拟金属光泽的复杂渐变
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.3),
                radius: 0.8,
                colors: [
                  lightColor, // 高光点
                  baseColor, // 基础色
                  darkColor, // 阴影色
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                // 模拟硬币厚度的多重阴影
                BoxShadow(
                  color: darkColor.withValues(alpha: 0.9),
                  offset: Offset(size * 0.04, size * 0.08),
                  blurRadius: 0, // 硬边缘模拟厚度
                ),
                BoxShadow(
                  color: const Color(0xFF78350F).withValues(alpha: 0.5),
                  offset: Offset(size * 0.08, size * 0.15),
                  blurRadius: size * 0.15, // 真实的投影
                ),
                // 内部高光（模拟立体感边缘）
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.4),
                  blurRadius: size * 0.08,
                  offset: Offset(-size * 0.03, -size * 0.03),
                ),
              ],
              border: Border.all(
                color: borderColor,
                width: size * 0.04, // 边框宽度随尺寸自适应
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 内圈装饰线
                Container(
                  width: size * 0.8,
                  height: size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: darkColor.withValues(alpha: 0.3),
                      width: size * 0.02,
                    ),
                  ),
                ),
                // 根据 coinType 渲染不同的内部图案
                if (coinType == 0)
                  Icon(
                    Icons.star_rounded,
                    size: size * 0.55,
                    color: darkColor.withValues(alpha: 0.8),
                  )
                else if (coinType == 1)
                  Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: darkColor.withValues(alpha: 0.5),
                        width: size * 0.04,
                      ),
                    ),
                  )
                else if (coinType == 2)
                  Icon(
                    Icons.diamond_rounded,
                    size: size * 0.5,
                    color: darkColor.withValues(alpha: 0.7),
                  )
                else if (coinType == 3)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
      I18nKeys.loginTitle.tr,
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
                    ? AppTheme.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: controller.rememberPassword.value
                      ? AppTheme.primaryColor
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: controller.isLoading
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF059669)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            boxShadow: controller.isLoading
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF059669).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: controller.isLoading ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // 背景透明，使用Container的渐变
              shadowColor: Colors.transparent, // 阴影透明，使用Container的阴影
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
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
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
