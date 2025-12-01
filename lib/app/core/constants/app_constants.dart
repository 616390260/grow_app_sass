/// 应用常量
class AppConstants {
  // 应用信息
  static const String appName = 'Taskgo8';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'I18nKeys.appDescription'; // 使用国际化键

  // 存储键名
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLanguage = 'language';
  static const String storageKeyFirstLaunch = 'first_launch';
  static const String storageKeyUserToken = 'user_token';
  static const String storageKeyUserInfo = 'user_info';
  static const String storageKeyAppVersion = 'app_version';

  // 网络配置
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 15000;

  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 动画时长
  static const int animationDuration = 300;
  static const int longAnimationDuration = 500;
  static const int shortAnimationDuration = 150;

  // 尺寸常量
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double smallRadius = 4.0;

  // 字体大小
  static const double fontSizeSmall = 12.0;
  static const double fontSizeNormal = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;

  // 图标大小
  static const double iconSizeSmall = 16.0;
  static const double iconSizeNormal = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // 按钮高度
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightNormal = 48.0;
  static const double buttonHeightLarge = 56.0;

  // 输入框高度
  static const double inputHeightNormal = 48.0;
  static const double inputHeightLarge = 56.0;

  // 列表项高度
  static const double listItemHeightSmall = 48.0;
  static const double listItemHeightNormal = 56.0;
  static const double listItemHeightLarge = 72.0;

  // 阴影
  static const double shadowElevationLow = 2.0;
  static const double shadowElevationMedium = 4.0;
  static const double shadowElevationHigh = 8.0;

  // 透明度
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.87;

  // 正则表达式
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // 日期格式
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String fullDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  // 错误消息
  static const String errorNetworkUnavailable = 'I18nKeys.errorNetworkUnavailable';
  static const String errorTimeout = 'I18nKeys.errorTimeout';
  static const String errorServerError = 'I18nKeys.errorServerError';
  static const String errorUnknown = 'I18nKeys.errorUnknown';
  static const String errorInvalidInput = 'I18nKeys.errorInvalidInput';
  static const String errorEmptyInput = 'I18nKeys.errorEmptyInput';

  // 成功消息
  static const String successSaved = 'I18nKeys.successSaved';
  static const String successDeleted = 'I18nKeys.successDeleted';
  static const String successUpdated = 'I18nKeys.successUpdated';
  static const String successCreated = 'I18nKeys.successCreated';

  // 确认消息
  static const String confirmDelete = 'I18nKeys.confirmDelete';
  static const String confirmExit = 'I18nKeys.confirmExit';
  static const String confirmSave = 'I18nKeys.confirmSave';

  // 按钮文本
  static const String buttonConfirm = 'I18nKeys.buttonConfirm';
  static const String cancel = 'I18nKeys.cancel';
  static const String buttonSave = 'I18nKeys.buttonSave';
  static const String buttonDelete = 'I18nKeys.buttonDelete';
  static const String buttonEdit = 'I18nKeys.buttonEdit';
  static const String buttonAdd = 'I18nKeys.buttonAdd';
  static const String buttonRetry = 'I18nKeys.buttonRetry';
  static const String buttonRefresh = 'I18nKeys.buttonRefresh';
  static const String buttonSubmit = 'I18nKeys.buttonSubmit';
  static const String buttonReset = 'I18nKeys.buttonReset';

  // 状态文本
  static const String statusLoading = 'I18nKeys.statusLoading';
  static const String statusEmpty = 'I18nKeys.statusEmpty';
  static const String statusError = 'I18nKeys.statusError';
  static const String statusSuccess = 'I18nKeys.statusSuccess';
  static const String statusCompleted = 'I18nKeys.statusCompleted';
  static const String statusPending = 'I18nKeys.statusPending';
  static const String statusInProgress = 'I18nKeys.statusInProgress';

  // 任务优先级
  static const String priorityHigh = 'I18nKeys.priorityHigh';
  static const String priorityMedium = 'I18nKeys.priorityMedium';
  static const String priorityLow = 'I18nKeys.priorityLow';

  // 任务状态
  static const String taskStatusTodo = 'I18nKeys.taskStatusTodo';
  static const String taskStatusInProgress = 'I18nKeys.taskStatusInProgress';
  static const String taskStatusCompleted = 'I18nKeys.taskStatusCompleted';

  // 主题模式
  static const String themeModeSystem = 'system';
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';

  // 语言代码
  static const String languageZh = 'zh';
  static const String languageEn = 'en';

  // 文件类型
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  static const List<String> documentExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'];
  static const List<String> videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'];
  static const List<String> audioExtensions = ['mp3', 'wav', 'aac', 'flac', 'ogg'];

  // 文件大小限制（字节）
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxDocumentSize = 50 * 1024 * 1024; // 50MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB

  // 缓存配置
  static const int cacheMaxAge = 7 * 24 * 60 * 60; // 7天（秒）
  static const int cacheMaxSize = 100 * 1024 * 1024; // 100MB

  // 调试配置
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableCrashlytics = false;
}
