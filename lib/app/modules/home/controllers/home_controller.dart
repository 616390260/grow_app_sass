import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/managers/api_call_manager.dart';
import '../../../core/utils/api_result.dart';
import '../../../routes/app_pages.dart';

class HomeController extends BaseController {
  // 统计数据
  final accountBalance = 0.obs;
  final dailyEarnings = 0.obs;
  final promotionEarnings = 0.obs;
  
  // 底部导航当前索引
  final currentTabIndex = 0.obs;

  // API调用管理器
  final _apiCallManager = ApiCallManager();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // 加载数据
  void loadData() async {
    // 设置加载状态
    setLoading(true);
    
    final result = await _apiCallManager.call<Map<String, dynamic>>(
      apiCall: () async {
        // 模拟网络请求
        await Future.delayed(const Duration(seconds: 1));
        
        // 模拟返回数据
        return ApiResult.success(data: {
          'accountBalance': 0,
          'dailyEarnings': 0,
          'promotionEarnings': 0,
        });
      },
      showLoading: false, // 不显示全局加载，使用页面状态管理
      showErrorMessage: true,
    );
    
    if (result.isSuccess && result.data != null) {
      // 更新统计数据
      accountBalance.value = result.data!['accountBalance'] ?? 0;
      dailyEarnings.value = result.data!['dailyEarnings'] ?? 0;
      promotionEarnings.value = result.data!['promotionEarnings'] ?? 0;
      setSuccess();
    } else {
      setError(result.message);
    }
  }

  // 刷新数据
  void refreshData() {
    loadData();
  }

  // 底部导航切换
  void onTabChanged(int index) {
    currentTabIndex.value = index;
  }

  // 幸运转盘点击
  void onLuckyWheelTap() {
    Get.toNamed(Routes.LUCKY_WHEEL);
  }

  // 签到日历点击
  void onSignInCalendarTap() {
    Get.toNamed(Routes.SIGN_IN_CALENDAR);
  }

  // 任务卡片点击
  void onTaskCardTap(String taskId) {
    Get.snackbar('任务', '开始任务: $taskId');
  }
}