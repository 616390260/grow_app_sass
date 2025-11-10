import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/data/services/income_details_api_service.dart';
import 'package:do_task_project/app/data/services/dict_api_service.dart';
import 'package:do_task_project/app/data/models/dict_model.dart';
import 'package:do_task_project/app/modules/income_details/models/income_details_model.dart';

/// 收益明细控制器
class IncomeDetailsController extends BaseController {
  // API服务
  final IncomeDetailsApiService _apiService = IncomeDetailsApiService();
  final DictApiService _dictApiService = DictApiService();
  
  // 筛选选项
  final selectedType = I18nKeys.allTypes.tr.obs;
  final selectedTimeRange = I18nKeys.allTime.tr.obs;
  final selectedTypeValue = ''.obs; // 存储选中的类型值
  
  // 奖励类型列表
  final rewardTypes = <DictModel>[].obs;
  
  // 时间类型列表
  final timeTypes = <DictModel>[].obs;
  
  // 类型选项 - 动态获取
  final typeOptions = RxList<String>([I18nKeys.allTypes.tr]);
  
  // 时间范围选项
  final timeRangeOptions = RxList<String>([I18nKeys.allTime.tr]);
  
  // 类型名称到值的映射
  final Map<String, String> _typeNameToValue = {};
  
  // 时间范围名称到值的映射
  final Map<String, String> _timeRangeNameToValue = {};
  
  // 加载状态
  bool _isLoadingTypes = false;
  bool _isLoadingTimeTypes = false;
  
  // 收益列表数据 - 修改为RxList
  final RxList<IncomeItem> incomeList = <IncomeItem>[].obs;
  
  // 分页信息
  int _currentPage = 1;
  bool _hasMoreData = true;
  
  // 加载更多状态
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 先获取奖励类型和时间类型，再加载收益数据
    Future.wait([loadRewardTypes(), loadTimeTypes()]).then((_) => loadIncomeData());
  }
  
  // 加载奖励类型
  Future<void> loadRewardTypes() async {
    if (_isLoadingTypes) return;
    
    try {
      _isLoadingTypes = true;
      
      // 使用safeApiCall进行API调用
      await safeApiCall(
        () async {
          // 从API获取奖励类型列表
          final List<DictModel> dictList = await _dictApiService.getDictList('points_reward_type');
          return dictList;
        },
        (List<DictModel> dictList) {
          // 处理获取到的奖励类型
          if (dictList.isNotEmpty) {
            rewardTypes.assignAll(dictList);
            // 更新类型选项列表
            typeOptions.clear();
            typeOptions.add(I18nKeys.allTypes.tr);
            // 将每个类型的名称添加到选项列表
            for (var dict in dictList) {
              if (dict.dictLabel != null && dict.dictLabel!.isNotEmpty) {
                typeOptions.add(dict.dictLabel!);
                // 存储类型名称到类型值的映射，用于筛选
                _typeNameToValue[dict.dictLabel!] = dict.dictValue ?? '';
              }
            }
            print('获取到奖励类型数量: ${dictList.length}');
          }
        },
        onError: () {
          print(I18nKeys.getRewardTypesFailed.tr);
        },
        showLoading: false,
        errorMessage: I18nKeys.getRewardTypesFailed.tr
      );
    } catch (e) {
      print('加载奖励类型异常: $e');
    } finally {
      _isLoadingTypes = false;
    }
  }
  
  // 加载时间类型
  Future<void> loadTimeTypes() async {
    if (_isLoadingTimeTypes) return;
    
    try {
      _isLoadingTimeTypes = true;
      
      // 使用safeApiCall进行API调用
      await safeApiCall(
        () async {
          // 从API获取时间类型列表
          final List<DictModel> dictList = await _dictApiService.getDictList('time_type');
          return dictList;
        },
        (List<DictModel> dictList) {
          // 处理获取到的时间类型
          if (dictList.isNotEmpty) {
            timeTypes.assignAll(dictList);
            // 更新时间范围选项列表
            timeRangeOptions.clear();
            timeRangeOptions.add(I18nKeys.allTime.tr);
            // 将每个时间类型的名称添加到选项列表
            for (var dict in dictList) {
              if (dict.dictLabel != null && dict.dictLabel!.isNotEmpty) {
                timeRangeOptions.add(dict.dictLabel!);
                // 存储时间范围名称到值的映射，用于筛选
                _timeRangeNameToValue[dict.dictLabel!] = dict.dictValue ?? '';
              }
            }
            print('获取到时间类型数量: ${dictList.length}');
          }
        },
        onError: () {
          print(I18nKeys.getTimeTypesFailed2.tr);
        },
        showLoading: false,
        errorMessage: I18nKeys.getTimeTypesFailed2.tr
      );
    } catch (e) {
      print('加载时间类型异常: $e');
    } finally {
      _isLoadingTimeTypes = false;
    }
  }

  // 加载收益数据
  void loadIncomeData() async {
    setLoading(true);
    _currentPage = 1;
    
    try {
      // 构建查询参数
      String? typeParam;
      String? timeRangeParam;
      
      // 如果选择了特定类型并且不是全部类型
      if (selectedTypeValue.value.isNotEmpty && selectedTypeValue.value != 'all') {
        typeParam = selectedTypeValue.value;
      }
      
      // 处理时间范围参数
      if (selectedTimeRange.value.isNotEmpty && selectedTimeRange.value != I18nKeys.allTime.tr) {
        timeRangeParam = _timeRangeNameToValue[selectedTimeRange.value] ?? selectedTimeRange.value;
      }

      print('加载收益数据参数 - 类型: $typeParam, 时间范围: $timeRangeParam');
      
      final response = await _apiService.getIncomeDetailsList(
        page: _currentPage,
        type: typeParam,
        timeRange: timeRangeParam
      );
      final convertedList = response.records.map((record) => IncomeItem(
        type: record.typeName ?? record.type,
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
    if (!_hasMoreData || isLoading || isLoadingMore.value) return;
    
    isLoadingMore.value = true;
    _currentPage++;
    
    try {
      // 构建查询参数
      String? typeParam;
      String? timeRangeParam;
      
      // 如果选择了特定类型并且不是全部类型
      if (selectedTypeValue.value.isNotEmpty && selectedTypeValue.value != 'all') {
        typeParam = selectedTypeValue.value;
      }
      
      // 处理时间范围参数
      if (selectedTimeRange.value.isNotEmpty && selectedTimeRange.value != I18nKeys.allTime.tr) {
        timeRangeParam = _timeRangeNameToValue[selectedTimeRange.value] ?? selectedTimeRange.value;
      }
      
      final response = await _apiService.getIncomeDetailsList(
        page: _currentPage,
        type: typeParam,
        timeRange: timeRangeParam
      );
      final convertedList = response.records.map((record) => IncomeItem(
        type: record.typeName ?? record.type,
        amount: record.points,
        time: record.createTime,
      )).toList();
      
      incomeList.addAll(convertedList);
      _hasMoreData = response.records.isNotEmpty && response.current < response.pages;
      
    } catch (e) {
      _currentPage--; // 回退页码
      showErrorMessage(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  // 切换类型筛选
  void onTypeFilterChanged(String value) {
    selectedType.value = value;
    // 更新选中的类型值
    if (value == I18nKeys.allTypes.tr) {
      selectedTypeValue.value = '';
    } else {
      selectedTypeValue.value = _typeNameToValue[value] ?? '';
    }
    // 重新加载数据
    loadIncomeData();
  }

  // 切换时间筛选
  void onTimeFilterChanged(String value) {
    selectedTimeRange.value = value;
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