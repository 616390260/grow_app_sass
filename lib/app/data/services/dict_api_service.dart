import '../../core/services/http_service.dart';
import '../models/dict_model.dart';

/// 字典数据相关 API 服务
class DictApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getDictListEndpoint = 'app/dict/data/type';

  /// 获取字典列表
  /// dictType: 字典类型，如 'app_order_type'
  Future<List<DictModel>> getDictList(String dictType) async {
    try {
      final endpoint = '$_getDictListEndpoint/$dictType';
      print('请求字典列表API: $endpoint');
      
      // 调用GET请求获取字典列表数据
      final responseData = await _httpService.get<dynamic>(
        endpoint,
      );
      
      print('获取到字典列表响应: $responseData');
      
      // 处理响应数据，转换为需要的格式
      return _parseDictList(responseData);
    } catch (e) {
      print('获取字典列表异常: $e');
      // 发生异常时返回空列表
      return [];
    }
  }
  
  /// 解析字典列表数据
  List<DictModel> _parseDictList(dynamic responseData) {
    try {
      // 检查响应是否为列表格式
      if (responseData is List) {
        print('开始解析字典列表数据: 共${responseData.length}条记录');
        
        // 将列表中的每个元素转换为DictModel
        final dictList = responseData
            .map((item) => DictModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        print('解析后字典列表数量: ${dictList.length}');
        return dictList;
      }
      // 也支持响应为Map格式，然后从某个字段获取列表
      else if (responseData is Map<String, dynamic>) {
        // 检查是否有data字段
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final dataList = responseData['data'] as List;
          print('开始解析字典列表数据(嵌套格式): 共${dataList.length}条记录');
          
          final dictList = dataList
              .map((item) => DictModel.fromJson(item as Map<String, dynamic>))
              .toList();
          
          print('解析后字典列表数量: ${dictList.length}');
          return dictList;
        }
      }
      
      // 返回空列表
      print('无法解析字典列表数据，返回空列表');
      return [];
    } catch (e) {
      print('解析字典列表数据异常: $e');
      return [];
    }
  }
  
  /// 获取默认订单类型列表（当API调用失败时使用）
  List<DictModel> _getDefaultOrderTypes() {
    return [
      DictModel(
        dictLabel: '申请中',
        dictValue: '0',
        dictType: 'app_order_type',
        remark: '申请中',
      ),
      DictModel(
        dictLabel: '已到账',
        dictValue: '1',
        dictType: 'app_order_type',
        remark: '已到账',
      ),
      DictModel(
        dictLabel: '已驳回',
        dictValue: '2',
        dictType: 'app_order_type',
        remark: '已驳回',
      ),
    ];
  }
}