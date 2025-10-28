/// 图片资源常量管理
/// 统一管理所有图片资源路径，避免硬编码
class ImageAssets {
  // 私有构造函数，防止实例化
  ImageAssets._();

  // 基础路径
  static const String _basePath = 'assets/images';

  // 默认图片路径
  static const String _defaultPath = '$_basePath/default';

  // 登录相关图片
  static const String loginBg = '$_basePath/login_bg.png';
  static const String loginPswCheck = '$_basePath/login_psw_check.png';
  static const String loginPswLook = '$_basePath/login_psw_look.png';
  static const String homeDownload = '$_basePath/home_download.png';
  static const String homeWheel = '$_basePath/home_wheel.png';
  static const String homeSign = '$_basePath/home_sign.png';
  static const String homeBanner = '$_basePath/home_banner.webp';
  static const String homeTask = '$_basePath/home_task.png';

  // 多语言横幅图片
  static const String welcomeBannerZhCn = '$_basePath/zh_CN/welcome_banner.svg';
  static const String welcomeBannerEnUs = '$_basePath/en_US/welcome_banner.svg';
  static const String welcomeBannerPtBr = '$_basePath/pt_BR/welcome_banner.svg';

  /// 根据当前语言获取欢迎横幅
  /// [locale] 语言代码，如 'zh_CN', 'en_US' 等
  static String getWelcomeBanner(String locale) {
    switch (locale) {
      case 'zh_CN':
        return welcomeBannerZhCn;
      case 'en_US':
        return welcomeBannerEnUs;
      case 'pt_BR':
        return welcomeBannerPtBr;
      default:
        return welcomeBannerEnUs; // 默认使用英文
    }
  }

  /// 获取指定语言目录下的图片
  /// [locale] 语言代码
  /// [imageName] 图片名称（包含扩展名）
  static String getLocalizedImage(String locale, String imageName) {
    return '$_basePath/$locale/$imageName';
  }

  /// 获取默认目录下的图片
  /// [imageName] 图片名称（包含扩展名）
  static String getDefaultImage(String imageName) {
    return '$_defaultPath/$imageName';
  }
}
