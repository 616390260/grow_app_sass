/// 应用常量
class AppConstants {
  // 应用信息
  static const String appName = 'Do Task';
  static const String appVersion = '1.0.0';
  static const String appDescription = '一个简单的任务管理应用';

  // 存储键名
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLanguage = 'language';
  static const String storageKeyFirstLaunch = 'first_launch';
  static const String storageKeyUserToken = 'user_token';
  static const String storageKeyUserInfo = 'user_info';

  // 网络配置
  static const String baseUrl = 'https://api.example.com';
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
  static const String errorNetworkUnavailable = '网络连接不可用';
  static const String errorTimeout = '请求超时';
  static const String errorServerError = '服务器错误';
  static const String errorUnknown = '未知错误';
  static const String errorInvalidInput = '输入格式不正确';
  static const String errorEmptyInput = '输入不能为空';

  // 成功消息
  static const String successSaved = '保存成功';
  static const String successDeleted = '删除成功';
  static const String successUpdated = '更新成功';
  static const String successCreated = '创建成功';

  // 确认消息
  static const String confirmDelete = '确定要删除吗？';
  static const String confirmExit = '确定要退出吗？';
  static const String confirmSave = '确定要保存吗？';

  // 按钮文本
  static const String buttonConfirm = '确认';
  static const String buttonCancel = '取消';
  static const String buttonSave = '保存';
  static const String buttonDelete = '删除';
  static const String buttonEdit = '编辑';
  static const String buttonAdd = '添加';
  static const String buttonRetry = '重试';
  static const String buttonRefresh = '刷新';
  static const String buttonSubmit = '提交';
  static const String buttonReset = '重置';

  // 状态文本
  static const String statusLoading = '加载中...';
  static const String statusEmpty = '暂无数据';
  static const String statusError = '加载失败';
  static const String statusSuccess = '加载成功';
  static const String statusCompleted = '已完成';
  static const String statusPending = '待处理';
  static const String statusInProgress = '进行中';

  // 任务优先级
  static const String priorityHigh = '高';
  static const String priorityMedium = '中';
  static const String priorityLow = '低';

  // 任务状态
  static const String taskStatusTodo = '待办';
  static const String taskStatusInProgress = '进行中';
  static const String taskStatusCompleted = '已完成';

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