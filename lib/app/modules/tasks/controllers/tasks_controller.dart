import 'package:do_task_project/app/data/services/home_api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/i18n/locale_config.dart';
import '../../../data/services/task_center_api_service.dart';
import '../../../data/models/home_info_model.dart';
class TasksController extends BaseController {
  final tasks = <RecommendTaskModel>[].obs;
  final TaskCenterApiService _taskApiService = TaskCenterApiService();
  final HomeApiService _homeApiService = HomeApiService();

  // 分页相关
  final int _limit = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initData() {
    loadTasks(isRefresh: true);
    // 语言切换后从第 1 页重拉：避免把新语言的数据追加在旧语言数据后面，
    // 让后端按 accept-language 返回的标题/描述全部切换为当前语言。
    ever<Locale>(LocaleConfig.currentLocale, (_) {
      loadTasks(isRefresh: true);
    });
  }

  /// 加载任务列表（支持分页）
  Future<void> loadTasks({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }
    if (!_hasMore && !isRefresh) {
      return;
    }
    _isLoading = true;
    await safeApiCall<TaskListResponse>(
      () => _taskApiService.getTaskList(page: _page, limit: _limit),
      (response) {
        final List<RecommendTaskModel> newTasks = response.records ?? [];
        if (isRefresh) {
          tasks.value = newTasks;
        } else {
          tasks.addAll(newTasks);
        }
        if (newTasks.length < _limit) {
          _hasMore = false;
        } else {
          _page++;
        }
        setSuccess();
      },
      errorMessage: I18nKeys.loadTasksFailed.tr,
      onError: () {
        setError(I18nKeys.loadTasksFailed.tr);
      },
      showLoading: true,
    );
    _isLoading = false;
  }
  
  /// 下拉刷新
  Future<void> onRefresh() async {
    await loadTasks(isRefresh: true);
  }
  
  /// 上拉加载更多
  Future<void> onLoadMore() async {
    if (_hasMore && !_isLoading) {
      await loadTasks();
    }
  }
  
  /// 是否还有更多数据
  bool get hasMore => _hasMore;

  // 下载APP按钮点击
  void onDownloadAppTap() async {
    try {
      // 显示加载提示

      // Web平台下调用API获取下载链接
      if (GetPlatform.isWeb) {
        final downloadUrl = await safeApiCall(
          () => _homeApiService.getApkDownloadUrl(),
          null,
        );

        if (downloadUrl != null) {
          // 假设API返回格式为 {"url": "下载链接"}
          if (downloadUrl.isNotEmpty) {
            final Uri url = Uri.parse(downloadUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              // 下载链接无法打开时的提示
              Get.snackbar(I18nKeys.downloadFailed.tr, I18nKeys.unableToOpenUrl.tr);
            }
          } else {
            // 下载链接为空时的提示
            Get.snackbar(I18nKeys.downloadFailed.tr, I18nKeys.downloadLinkEmpty.tr);
          }
        }
      } 
    } catch (e) {
      // 错误处理
      Get.snackbar(I18nKeys.downloadFailed.tr, e.toString());
    } finally {
      // 隐藏加载提示
    }
  }
}
