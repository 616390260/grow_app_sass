import '../models/configuration_model.dart';
import '../../core/services/http_service.dart';

/// 系统配置 API
class ConfigurationApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getByIdEndpoint = 'app/configuration/getById';

  /// 按 id 查询单条配置（如 id=24 为网站使用时区）
  Future<ConfigurationItem> getById(int id) async {
    final data = await _httpService.get<Map<String, dynamic>>(
      _getByIdEndpoint,
      queryParameters: {'id': id},
    );
    return ConfigurationItem.fromJson(data);
  }
}
