import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/managers/api_call_manager.dart';
import '../../../core/utils/api_result.dart';

class PromotionController extends BaseController {
  // 推广数据
  final promotionCount = 0.obs;
  final promotionEarnings = 0.0.obs;

  // API调用管理器
  final _apiCallManager = ApiCallManager();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    // 设置加载状态
    setLoading(true);
    
    final result = await _apiCallManager.call<Map<String, dynamic>>(
      apiCall: () async {
        // 模拟网络请求
        await Future.delayed(const Duration(seconds: 1));
        
        // 模拟返回推广数据
        return ApiResult.success(data: {
          'promotionCount': 15,
          'promotionEarnings': 1250.0,
        });
      },
      showLoading: false, // 不显示全局加载，使用页面状态管理
      showErrorMessage: true,
    );
    
    if (result.isSuccess && result.data != null) {
      // 更新推广数据
      promotionCount.value = result.data!['promotionCount'] ?? 0;
      promotionEarnings.value = result.data!['promotionEarnings'] ?? 0.0;
      setSuccess();
    } else {
      setError(result.message);
    }
  }
}