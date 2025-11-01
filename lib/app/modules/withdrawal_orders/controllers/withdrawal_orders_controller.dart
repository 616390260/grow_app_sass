import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';

// 提现订单数据模型
class WithdrawalOrder {
  final double amount;
  final String status;
  final String time;

  WithdrawalOrder({
    required this.amount,
    required this.status,
    required this.time,
  });
}

class WithdrawalOrdersController extends BaseController {
  // 订单列表
  final orders = <WithdrawalOrder>[].obs;
  
  // 筛选条件
  final selectedType = '全部类型'.obs;
  final selectedTimeRange = '全部时间'.obs;
  
  // 类型选项
  final typeOptions = ['全部类型', '成功', '处理中', '失败'];
  
  // 时间范围选项
  final timeRangeOptions = ['全部时间', '今天', '本周', '本月'];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // 加载订单数据
  Future<void> loadOrders() async {
    try {
      setLoading(true);
      
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));
      
      // 这里应该是实际的API调用，现在返回空列表以匹配UI图中的"暂无数据"
      orders.clear();
      
      // 如果有数据时，可以取消下面的注释并添加实际数据
      orders.addAll([
        WithdrawalOrder(amount: 100.0, status: '成功', time: '2024-01-20 14:30'),
        WithdrawalOrder(amount: 50.0, status: '处理中', time: '2024-01-19 10:15'),
        WithdrawalOrder(amount: 200.0, status: '成功', time: '2024-01-18 09:45'),
      ]);
      
      if (orders.isEmpty) {
        setEmpty();
      } else {
        setSuccess();
      }
    } catch (e) {
      setError('加载订单失败');
      showErrorMessage('加载订单失败');
    }
  }

  // 刷新数据
  void refreshData() {
    loadOrders();
  }

  // 选择类型筛选
  void selectType(String type) {
    selectedType.value = type;
    // 这里可以根据选择的类型重新加载或筛选数据
    loadOrders();
  }

  // 选择时间范围筛选
  void selectTimeRange(String timeRange) {
    selectedTimeRange.value = timeRange;
    // 这里可以根据选择的时间范围重新加载或筛选数据
    loadOrders();
  }

  // 返回上一页
  void goBack() {
    Get.back();
  }
}