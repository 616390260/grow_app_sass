import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/data/services/user_points_api_service.dart';
import 'package:do_task_project/app/modules/income_details/models/income_details_model.dart';

/// 收益明细控制器
class IncomeDetailsController extends BaseController {
  // API服务
  final UserPointsApiService _apiService = UserPointsApiService();
  
  // 筛选选项
  final selectedType = I18nKeys.allTypes.tr.obs;
  final selectedTimeRange = I18nKeys.allTime.tr.obs;
  
  // 收益列表数据 - 修改为RxList
  final RxList<IncomeItem> incomeList = <IncomeItem>[].obs;
  
  // 分页信息
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    // 初始化数据加载
    loadIncomeData();
  }

  // 加载收益数据
  void loadIncomeData() async {
    setLoading(true);
    _currentPage = 1;
    
    try {
      final response = await _apiService.getUserPointsList(page: _currentPage);
      final convertedList = response.records.map((record) => IncomeItem(
        type: record.type,
        amount: record.points,
        time: record.createTime,
      )).toList();
      
      incomeList.assignAll(convertedList);
      _hasMoreData = response.records.isNotEmpty && response.current < response.pages;
      
      setSuccess();
    } catch (e) {
      setError(e.toString());
      showErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // 加载更多数据
  void loadMoreData() async {
    if (!_hasMoreData || isLoading) return;
    
    setLoading(true);
    _currentPage++;
    
    try {
      final response = await _apiService.getUserPointsList(page: _currentPage);
      final convertedList = response.records.map((record) => IncomeItem(
        type: record.type,
        amount: record.points,
        time: record.createTime,
      )).toList();
      
      incomeList.addAll(convertedList);
      _hasMoreData = response.records.isNotEmpty && response.current < response.pages;
      
      setSuccess();
    } catch (e) {
      _currentPage--; // 回退页码
      setError(e.toString());
      showErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // 切换类型筛选
  void onTypeFilterChanged(String value) {
    selectedType.value = value;
    // 这里可以添加根据类型筛选的逻辑
    // 重新加载数据
    loadIncomeData();
  }

  // 切换时间筛选
  void onTimeFilterChanged(String value) {
    selectedTimeRange.value = value;
    // 这里可以添加根据时间筛选的逻辑
    // 重新加载数据
    loadIncomeData();
  }

  // 返回上一页
  void onBackPress() {
    Navigator.pop(Get.context!);
  }
}

/// 收益项目模型
class IncomeItem {
  final String type;
  final num amount;
  final String time;

  IncomeItem({
    required this.type,
    required this.amount,
    required this.time,
  });
}