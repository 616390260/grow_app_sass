import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/base/base_view.dart';
import '../../../core/constants/image_assets.dart';
import 'package:do_task_project/app/core/services/tenant_service.dart';
import '../../../core/i18n/i18n_keys.dart';

/**
 * 登录页 —— 完美复刻 UI 参考图
 */
class TaskgoReplicateLoginView extends BaseView<LoginController> {
  const TaskgoReplicateLoginView({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildContent(BuildContext context) {
    final themeColor = TenantService.to.brandColor ?? const Color(0xFF097A45);
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
      backgroundColor: themeColor,
      // 设置为 false，确保背景和组件在键盘弹出时不会被压缩滑动
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          // 白色卡片起点的基础高度
          final cardTop = h * 0.44;
          // 曲线的高度差
          const curveHeight = 110.0;
          // Logo 圆圈直径 88
          const logoSize = 88.0;
          // Logo 中心点设在卡片基础高度，确保一半在绿区一半在白区
          final logoCenterY = cardTop;

          return Stack(
            children: [
              // ── Layer 0: 全屏背景图（绿色底 + coins/diamonds）
              // 使用负的 top 将图片向上偏移，吃掉原图中多余的绿边
              Positioned(
                top: -80, 
                left: -20,
                right: -20,
                bottom: h * 0.4, // 让它覆盖整个上半屏
                child: Image.asset(
                  'assets/images/login_bg_diamonds.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/login_coins_bg.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) =>
                        ColoredBox(color: themeColor),
                  ),
                ),
              ),

              // ── Layer 1: 白色卡片背景（自定义波浪曲线剪裁）
              Positioned(
                top: cardTop - curveHeight * 0.5, // 卡片裁剪器起始高度稍微上移，以露出左边的大圆角
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipPath(
                  clipper: _LoginCardClipper(curveHeight: curveHeight),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),

              // ── Layer 2: 品牌名背景文字及外围发光圆环
              Positioned(
                top: h * 0.05, // 稍微上移以容纳整个发光圆环
                left: 0,
                right: 0,
                height: h * 0.35, // 给圆环提供足够的绘制空间
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ── 外围发光同心圆环层 ──
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CustomPaint(
                          painter: _GlowingRingsPainter(),
                        ),
                      ),
                      
                      // ── 品牌名文字层 ──
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // 发光层（底部的柔和光晕）
                          Text(
                            TenantService.to.appName,
                            style: TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.transparent, // 文字本身透明，只显示阴影
                              shadows: [
                                Shadow(
                                  color: const Color(0xFFD4E89B).withOpacity(0.6),
                                  blurRadius: 30,
                                  offset: Offset.zero,
                                ),
                                Shadow(
                                  color: const Color(0xFFFFF8D6).withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: Offset.zero,
                                ),
                              ],
                            ),
                          ),
                          // 渐变文字层（使用 ShaderMask 应用金黄色渐变）
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFFFBD6), // 顶部浅奶白金
                                Color(0xFFE4B35A), // 底部深暗金
                              ],
                              stops: [0.1, 0.9], // 调整渐变分布让底部金色更浓
                            ).createShader(bounds),
                            child: Text(
                              TenantService.to.appName,
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // 必须为白色以便 ShaderMask 染色
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Layer 3: Logo 圆圈（绝对定位，悬挂在卡片平坦处的边界线上）
              Positioned(
                top: logoCenterY - logoSize / 2,
                left: constraints.maxWidth / 2 - logoSize / 2,
                child: _buildLogo(themeColor: themeColor),
              ),

              // ── Layer 4: 表单内容（绝对定位，不可滑动）
              Positioned(
                top: logoCenterY + logoSize / 2 + 14,
                left: 28,
                right: 28,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        I18nKeys.login.tr,
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
                      _buildRememberRow(themeColor: themeColor),

                      const SizedBox(height: 30),

                      // ── 登录按钮
                      _buildLoginButton(themeColor: themeColor),

                      // 使用 Spacer 将底部行推到底部，彻底去除外层的 SingleChildScrollView
                      const Spacer(),

                      // ── 底部注册 + 客服
                      _buildBottomRow(themeColor: themeColor),

                      // 底部安全距离
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /**
   * Logo 圆圈：真实图片资产 + 白色描边 + 绿底 + 投影
   */
  Widget _buildLogo({required Color themeColor}) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeColor,
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

  /**
   * 输入框组：共用容器 + 中间分割线
   */
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
                    hintText: I18nKeys.accountPlaceholder.tr, // 严格符合UI图文字
                    hintStyle: const TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
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
                      hintText: I18nKeys.passwordPlaceholder.tr, // 严格符合UI图文字
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

  /**
   * 记住密码（方形复选框 + 文字）
   */
  Widget _buildRememberRow({required Color themeColor}) {
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
                    ? themeColor
                    : Colors.transparent,
                border: Border.all(
                  color: controller.rememberPassword.value
                      ? themeColor
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
          I18nKeys.rememberPassword.tr, // 严格符合UI图文字
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  /**
   * 登录按钮（全宽胶囊形，绿底）
   */
  Widget _buildLoginButton({required Color themeColor}) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.isLoading ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
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

  /**
   * 底部行："无账户？立即注册" 居中 + 纸飞机图标紧随其后
   */
  Widget _buildBottomRow({required Color themeColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          I18nKeys.noAccount.tr, // 严格符合UI图文字
          style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: controller.goToRegister,
          child: Text(
            I18nKeys.goRegister.tr,
            style: TextStyle(
              fontSize: 14,
              color: themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8), // 注册和图标之间的间距
        
        // 纸飞机图标（直接使用 assets 里的 invite_tele.png）
        Obx(() {
          final iconUrl = controller.customerService.value?.icon ?? '';
          return GestureDetector(
            onTap: controller.goToService,
            child: ClipOval(
              child: iconUrl.isNotEmpty
                  ? Image.network(
                      iconUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        ImageAssets.inviteTelegram,
                        width: 32,
                        height: 32,
                      ),
                    )
                  : Image.asset(
                      ImageAssets.inviteTelegram,
                      width: 32,
                      height: 32,
                    ),
            ),
          );
        }),
      ],
    );
  }
}

/**
 * 自定义曲线裁剪器
 * UI图的曲线：
 * - 左侧：平滑的圆角凸起
 * - 中间：向下凹陷承接 Logo 
 * - 右侧：平缓连接
 */
class _LoginCardClipper extends CustomClipper<Path> {
  final double curveHeight;

  _LoginCardClipper({required this.curveHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // 起点：左上角圆角的外沿。向下留出一定的高度，以便左侧能“凸起”圆滑的肩膀
    path.moveTo(0, curveHeight * 0.4);
    
    // 左侧凸起的圆肩：从 y=0.4 拱起到最高点 y=0 附近
    path.quadraticBezierTo(
      size.width * 0.08, 0, // 控制点：向左上顶起
      size.width * 0.25, curveHeight * 0.2, // 拱起后的回落点
    );

    // 中间凹陷承托 Logo 区域：下沉至曲线最低点附近（y=curveHeight*0.8）
    path.quadraticBezierTo(
      size.width * 0.5, curveHeight * 0.9, // 最低点
      size.width * 0.75, curveHeight * 0.3, // 凹陷后回升
    );

    // 右侧平滑过渡
    path.quadraticBezierTo(
      size.width * 0.9, 0, 
      size.width, curveHeight * 0.4, // 右侧收尾
    );

    // 右边界向下
    path.lineTo(size.width, size.height);
    // 底部向左
    path.lineTo(0, size.height);
    // 左边界向上回到起点
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant _LoginCardClipper oldClipper) {
    return oldClipper.curveHeight != curveHeight;
  }
}

/**
 * 自定义画笔：绘制品牌名背后的发光同心圆环和星光点缀
 */
class _GlowingRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 最外层的大圆光晕（很淡的绿色/黄色光晕铺底）
    final bgGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4E89B).withOpacity(0.15),
          const Color(0xFFD4E89B).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    canvas.drawCircle(center, size.width / 2, bgGlowPaint);

    // 圆环基础画笔
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFFFF8D6).withOpacity(0.3)
      ..strokeWidth = 1.0;

    // 带有发光效果的圆环画笔
    final glowRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFFFF8D6).withOpacity(0.6)
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    // 绘制内层小圆环
    final innerRadius = size.width * 0.3;
    canvas.drawCircle(center, innerRadius, glowRingPaint);
    canvas.drawCircle(center, innerRadius, ringPaint);

    // 绘制外层大圆环
    final outerRadius = size.width * 0.48;
    canvas.drawCircle(center, outerRadius, glowRingPaint);
    canvas.drawCircle(center, outerRadius, ringPaint);

    // 星光画笔（绘制圆环上的亮点）
    final starPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    // 在内层圆环上绘制几个亮点
    // 通过简单的极坐标偏移确定位置
    canvas.drawCircle(center + Offset(-innerRadius * 0.8, -innerRadius * 0.6), 2.5, starPaint);
    canvas.drawCircle(center + Offset(innerRadius * 0.9, innerRadius * 0.4), 3.0, starPaint);

    // 在外层圆环上绘制几个亮点
    canvas.drawCircle(center + Offset(-outerRadius * 0.4, outerRadius * 0.9), 3.5, starPaint);
    canvas.drawCircle(center + Offset(outerRadius * 0.8, -outerRadius * 0.6), 2.0, starPaint);
    canvas.drawCircle(center + Offset(-outerRadius * 0.95, -outerRadius * 0.2), 2.5, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

