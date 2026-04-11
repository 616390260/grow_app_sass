import '../../core/services/http_service.dart';
import '../../core/models/base_list_entity.dart';
import '../models/country_model.dart';

/// 国家列表相关 API 服务
class CountryApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getCountryListEndpoint = 'app/goldenFlowInfo/getPage';

  /// 获取国家列表
  Future<BaseListEntity<CountryModel>> getCountryList() async {
    try {
      print('请求国家列表API: $_getCountryListEndpoint');
      
      // 调用GET请求获取国家列表数据
      final responseData = await _httpService.get<dynamic>(
        _getCountryListEndpoint,
      );
      
      print('获取到国家列表响应: $responseData');
      
      // 处理响应数据，转换为需要的格式
      return _parseCountryList(responseData);
    } catch (e) {
      print('获取国家列表异常: $e');
      // 发生异常时返回空的分页实体
      return BaseListEntity<CountryModel>(
        records: [],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }
  }
  
  /// 解析国家列表数据
  BaseListEntity<CountryModel> _parseCountryList(dynamic responseData) {
    try {
      // 使用BaseListEntity安全解析数据
      if (responseData is Map<String, dynamic>) {
        // 检查是否是直接包含records等字段的响应格式
        if (responseData.containsKey('records')) {
          print('开始解析国家列表数据(直接格式): $responseData');
          
          // 直接使用响应数据进行解析
          final result = BaseListEntity<CountryModel>.fromJsonSafe(
            responseData,
            (json) => CountryModel.fromJson(json as Map<String, dynamic>),
            defaultRecords: [],
          );
          
          print('解析后国家列表数量: ${result.records.length}');
          return result;
        } 
        // 也支持嵌套在data字段中的格式
        else if (responseData.containsKey('data') && 
                 responseData['data'] is Map<String, dynamic>) {
          
          final data = responseData['data'];
          print('开始解析国家列表数据(嵌套格式): $data');
          
          // 使用fromJsonSafe方法进行安全解析
          final result = BaseListEntity<CountryModel>.fromJsonSafe(
            data,
            (json) => CountryModel.fromJson(json as Map<String, dynamic>),
            defaultRecords: [],
          );
          
          print('解析后国家列表数量: ${result.records.length}');
          return result;
        }
      }
      
      // 返回空的分页实体
      return BaseListEntity<CountryModel>(
        records: [],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
      } catch (e) {
      print('解析国家列表数据异常: $e');
      return BaseListEntity<CountryModel>(
        records: [],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }
  }
  
  /// 获取默认国家列表（当API调用失败时使用）
  List<Map<String, String>> _getDefaultCountries() {
    return [
      {'key': 'nigeria', 'label': 'Nigeria'},
      {'key': 'trx', 'label': 'TRX'},
      {'key': 'india', 'label': 'India'},
      {'key': 'philippines', 'label': 'Philippines'},
      {'key': 'indonesia', 'label': 'Indonesia'},
      {'key': 'bangladesh', 'label': 'Bangladesh'},
      {'key': 'pakistan', 'label': 'Pakistan'},
      {'key': 'southAfrica', 'label': 'South Africa'},
    ];
  }
}