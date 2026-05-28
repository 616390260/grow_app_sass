import '../../core/services/http_service.dart';
import '../models/sign_in_record_model.dart';

/// 签到相关 API 服务
class SignInApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getSignInInfoEndpoint = 'app/checkInRecord/getInfo';
  static const String _checkInEndpoint = 'app/checkInRecord/checkIn';
  static const String _isCheckInEndpoint = 'app/checkInRecord/isCheckIn';

  /// 获取签到信息
  Future<SignInRecordModel> getSignInInfo() async {
    try {
      // 发送GET请求
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getSignInInfoEndpoint,
      );

      // 处理响应数据，转换为模型对象
      // 注意：根据实际API响应格式，可能需要从data字段中获取数据
      final data = responseData['data'] is Map<String, dynamic>
          ? responseData['data']
          : responseData;

      return SignInRecordModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      // 处理异常，可以根据需要进行日志记录或错误处理
      print('获取签到信息失败: $e');
      rethrow;
    }
  }

  /// 执行签到
  Future<int> checkIn() async {
    try {
      // 发送GET请求到签到接口
      final responseData = await _httpService.get<int>(
        _checkInEndpoint,
        // 签到接口通常不需要额外参数
      );

      // 返回响应数据，可能包含签到结果、奖励信息等
      return responseData;
    } catch (e) {
      // 处理异常，进行日志记录并重新抛出，让上层组件能够捕获并处理
      print('签到失败: $e');
      rethrow;
    }
  }
  
  /// 检查今日是否已签到
  Future<bool> isCheckIn() async {
    try {
      // 发送GET请求到检查签到状态接口，直接获取bool值
      final result = await _httpService.get<bool>(
        _isCheckInEndpoint,
      );
      
      print('isCheckIn接口返回结果: $result');
      return result;
    } catch (e) {
      // 处理异常，进行日志记录并返回默认值
      print('检查签到状态失败: $e');
      // 发生错误时，返回false表示未签到
      return false;
    }
  }
}