import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';

class PromotionController extends BaseController {
  // 推广数据
  final promotionCount = 0.obs;
  final promotionEarnings = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  void loadData() async {
    try {
      // 设置加载状态
      
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟返回推广数据
      final data = {
        'promotionCount': 15,
        'promotionEarnings': 1250.0,
      };
      
      // 更新推广数据
      promotionCount.value = data['promotionCount'] as int;
      promotionEarnings.value = data['promotionEarnings'] as double;
      
      setSuccess();
    } catch (e) {
      setError('加载推广数据失败: $e');
      showErrorMessage('加载推广数据失败: $e');
    } finally {
      setLoading(false);
    }
  }
}