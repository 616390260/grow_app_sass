
/// 图片资源常量管理
/// 统一管理所有图片资源路径，避免硬编码
class ImageAssets {
  // 私有构造函数，防止实例化
  ImageAssets._();

  // 基础路径
  static const String _basePath = 'assets/images';

  // 默认图片路径
  static const String _defaultPath = '$_basePath/default';

  static const String logo = '$_basePath/logo.png';
  static const String home = '$_basePath/home.svg';
  static const String promotion = '$_basePath/promotion.svg';
  static const String tasks = '$_basePath/task.svg';
  static const String service = '$_basePath/service.svg';
  static const String account = '$_basePath/account.svg';

  // 登录相关图片
  static const String loginBg = '$_basePath/login_bg.png';
  static const String error = '$_basePath/error.png';
  static const String msgEmpty = '$_basePath/msg_empty.png';
  static const String loginPswCheck = '$_basePath/login_psw_check.png';
  static const String loginPswLook = '$_basePath/login_psw_look.png';
  static const String homeDownload = '$_basePath/home_download.png';
  static const String homeWheel = '$_basePath/home_wheel.png';
  static const String homeSign = '$_basePath/home_sign.png';
  static const String homePhone = '$_basePath/home_phone.png';
  static const String homeInvite = '$_basePath/home_invite.png';
  static const String homeBanner = '$_basePath/home_banner.webp';
  static const String homeTask = '$_basePath/home_task.png';
  static const String mineBg = '$_basePath/mine_bg.webp';
  static const String mineMsg = '$_basePath/mine_msg.svg';
  static const String mineService = '$_basePath/mine_service.svg';
  static const String mineSwitch = '$_basePath/mine_switch.svg';
  static const String mineAccount = '$_basePath/mine_account.svg';
  static const String rightGray = '$_basePath/right_gray.svg';
  static const String mineIncome = '$_basePath/mine_income.svg';
  static const String mineWithdraw = '$_basePath/mine_withdraw.svg';
  static const String minePsw = '$_basePath/mine_psw.svg';
  static const String mineLanguage = '$_basePath/mine_language.svg';
  static const String vipCrown = '$_basePath/vip_crown.png';
  static const String signBg = '$_basePath/sign_bg.png';
  static const String inviteWhatsapp = '$_basePath/invite_whats.png';
  static const String inviteFacebook = '$_basePath/invite_fb.png';
  static const String inviteTelegram = '$_basePath/invite_tele.png';
  static const String inviteBoxAble = '$_basePath/invite_box_able.png';
  static const String inviteBoxUnAble = '$_basePath/invite_box_disable.png';
  static const String rewardBg = '$_basePath/reward_bg.png';
  static const String wheelBg = '$_basePath/wheel_bg.png';
  static const String wheelPoint = '$_basePath/wheel_point.png';
  static const String inviteBg = '$_basePath/invite_bg.webp';
  static const String serviceBg = '$_basePath/service_bg.png';
  static const String serviceGuide = '$_basePath/service_guide.png';
  static const String onlinePhone = '$_basePath/online_phone.png';
  static const String iconEmpty = '$_basePath/icon_empty.png';
  static const String iconClose = '$_basePath/icon_close.png';

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
