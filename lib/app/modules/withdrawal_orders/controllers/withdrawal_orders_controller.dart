import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/services/withdrawal_api_service.dart';
import '../../../data/services/dict_api_service.dart';
import '../../../core/models/base_list_entity.dart';
import '../../../data/models/dict_model.dart';
import '../../../../domain/entities/withdrawal_record.dart';
import '../../../core/i18n/i18n_keys.dart';

class WithdrawalOrdersController extends BaseController {
  // API服务
  final WithdrawalApiService _apiService = WithdrawalApiService();
  final DictApiService _dictApiService = DictApiService();
  
  // 订单列表
  final orders = <WithdrawalRecord>[].obs;
  
  // 订单类型列表
  final orderTypes = <DictModel>[].obs;
  
  // 时间类型列表
  final timeTypes = <DictModel>[].obs;
  
  // 分页信息
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  bool _isLoadingTypes = false;
  bool _isLoadingTimeTypes = false;
  
  // Getter for isLoading
  @override
  bool get isLoading => _isLoading;
  
  // Getter for hasMoreData
  bool get hasMoreData => _hasMoreData;
  
  // 筛选条件
  final selectedType = I18nKeys.allTypes.tr.obs;
  final selectedTypeValue = ''.obs; // 存储选中的类型值
  final selectedTimeRange = I18nKeys.allTime.tr.obs;

  // 类型选项 - 动态获取
  final typeOptions = RxList<String>([I18nKeys.allTypes.tr]);

  // 时间范围选项
  final timeRangeOptions = RxList<String>([I18nKeys.allTime.tr]);
  
  // 类型名称到值的映射
  final Map<String, String> _typeNameToValue = {};
  
  // 时间范围名称到值的映射
  final Map<String, String> _timeRangeNameToValue = {};

  @override
  void onInit() {
    super.onInit();
    // 先获取订单类型和时间类型，再加载订单数据
    Future.wait([loadOrderTypes(), loadTimeTypes()]).then((_) => loadOrders());
  }
  
  // 加载订单类型
  Future<void> loadOrderTypes() async {
    if (_isLoadingTypes) return;
    
    try {
      _isLoadingTypes = true;
      
      // 使用safeApiCall进行API调用
          await safeApiCall(
            () async {
              // 从API获取订单类型列表
              final List<DictModel> dictList = await _dictApiService.getDictList('app_order_type');
              return dictList;
            },
            (List<DictModel> dictList) {
              // 处理获取到的订单类型
              if (dictList.isNotEmpty) {
                orderTypes.assignAll(dictList);
                // 更新类型选项列表，添加"全部类型"
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
                // 获取到订单类型数量: ${dictList.length}
              } else {
                // 如果API调用失败，使用默认类型
              }
            },
            onError: () {
              // 获取订单类型失败，使用默认类型
            },
            showLoading: false,
            errorMessage: I18nKeys.getOrderTypesFailed.tr
          );
    } catch (e) {
      // 加载订单类型异常: $e
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
            // 获取到时间类型数量: ${dictList.length}
          } else {
            // 如果API调用失败，使用默认时间类型
          }
        },
        onError: () {
          // 获取时间类型失败，使用默认时间类型
        },
        showLoading: false,
        errorMessage: I18nKeys.getTimeTypesFailed.tr
      );
    } catch (e) {
      // 加载时间类型异常: $e
    } finally {
      _isLoadingTimeTypes = false;
    }
  }
  

  // 加载订单数据
  Future<void> loadOrders() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      setLoading(true);
      
      // 构建查询参数
      String? statusParam;
      String? timeRangeParam;
      
      // 如果选择了特定类型并且不是全部类型
      if (selectedTypeValue.value.isNotEmpty && selectedTypeValue.value != 'all') {
        statusParam = selectedTypeValue.value;
      }
      
      // 处理时间范围参数
      if (selectedTimeRange.value.isNotEmpty && selectedTimeRange.value != I18nKeys.allTime.tr) {
        timeRangeParam = _timeRangeNameToValue[selectedTimeRange.value] ?? selectedTimeRange.value;
      }

      // 加载订单参数 - 状态: $statusParam, 时间范围: $timeRangeParam

      // 使用safeApiCall进行API调用
          await safeApiCall(
            () async {
              final BaseListEntity<WithdrawalRecord> response = 
                  await _apiService.getWithdrawalRecords(
                    page: _currentPage,
                    status: statusParam,
                    timeRange: timeRangeParam,
                  );
              return response;
            },
            (BaseListEntity<WithdrawalRecord> response) {
              // 清空现有数据（仅在第一页时清空）
              if (_currentPage == 1) {
                orders.clear();
              }
              
              // 添加获取到的订单数据
              if (response.records.isNotEmpty) {
                orders.addAll(response.records);
              }
              
              // 更新分页信息
              _hasMoreData = response.records.length >= 20;
              
              // 加载完成，总订单数: ${orders.length}, 是否有更多: $_hasMoreData
              
              if (orders.isEmpty) {
                setEmpty();
              } else {
                setSuccess();
              }
            },
            onError: () {
              setError(I18nKeys.loadOrdersFailed.tr);
              // 出错时仍然清空列表并设置为空状态
              if (_currentPage == 1) {
                orders.clear();
              }
              setEmpty();
            },
            errorMessage: I18nKeys.loadOrdersFailed.tr
          );
    } catch (e) {
      // 加载订单异常: $e
      setError(I18nKeys.loadOrdersFailed.tr);
      if (_currentPage == 1) {
        orders.clear();
      }
      setEmpty();
    } finally {
      _isLoading = false;
      setLoading(false);
    }
  }

  // 刷新数据
  @override
  void refreshData() {
    _currentPage = 1;
    loadOrders();
  }

  // 加载更多数据
  Future<void> loadMore() async {
    if (!_hasMoreData || _isLoading) return;
    
    _currentPage++;
    await loadOrders();
  }

  // 选择类型筛选
  void selectType(String type) {
    selectedType.value = type;
    if (type == I18nKeys.allTypes.tr) {
      selectedTypeValue.value = '';
    } else {
      selectedTypeValue.value = _typeNameToValue[type] ?? '';
    }
    // 选中的订单类型: $type, 值: ${selectedTypeValue.value}
    
    // 根据选择的类型重新加载数据
    _currentPage = 1;
    loadOrders();
  }

  // 选择时间范围筛选
  void selectTimeRange(String timeRange) {
    selectedTimeRange.value = timeRange;
    // 选中的时间范围: $timeRange, 值: ${_timeRangeNameToValue[timeRange] ?? timeRange}
    // 根据选择的时间范围重新加载数据
    _currentPage = 1;
    loadOrders();
  }

  // 返回上一页
  void goBack() {
    Get.back();
  }
}