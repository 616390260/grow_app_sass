import '../../core/services/http_service.dart';
import '../../core/services/error_handler_center.dart';
import 'package:flutter/foundation.dart';
import 'package:do_task_project/app/domain/entities/online_number.dart';

/// 扫码登录二维码接口的解析结果（含可选的冷却秒数，与后端限流对齐）。
class LoginQrCodeResult {
  /// 二维码内容（可能是链接、data URI、纯 base64 或普通文本，用于渲染 QR）。
  final String content;

  /// 服务端建议的下次可请求间隔（秒）；无则由调用方用默认兜底。
  final int? cooldownSeconds;

  const LoginQrCodeResult({
    required this.content,
    this.cooldownSeconds,
  });
}

/// WhatsApp API服务类
class WhatsappApiService {
  final HttpService _httpService = HttpService.to;

  /// API端点
  static const String _getLoginCodeEndpoint = 'app/wsNumber/getLoginCode';
  static const String _getLoginQrCodeEndpoint = 'app/wsNumber/getLoginQrCode';
  static const String _getOnlineNumbersEndpoint = 'app/wsNumber/online';
  static const String _getTaskInfoEndpoint = 'app/wsNumber/getTaskInfo';
  static const String _sendMsgEndpoint = 'app/wsNumber/sendMsg';
  static const String _getAreaCodesEndpoint = 'app/wsNumber/areaCodeList';

  /// 获取登录验证码
  ///
  /// @param phoneNumber 完整号码（已拼接区号+手机号，不含 `+`）
  /// @param areaCode 国家区号（纯数字，不含 `+`），作为独立参数传给后端
  Future<String> getLoginCode(
    String phoneNumber, {
    required String areaCode,
  }) async {
    try {
      final data = await _httpService.get<String>(
        _getLoginCodeEndpoint,
        queryParameters: {
          'phone': phoneNumber,
          'areaCode': areaCode,
        },
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取扫码绑定二维码（内容 + 可选冷却秒数）
  ///
  /// 对应后端接口 `app/wsNumber/getLoginQrCode`。返回的 [LoginQrCodeResult.content]
  /// 可能为链接 / `data:image/...;base64,xxx` / 纯 base64 / 普通文本，由视图层自行渲染。
  Future<LoginQrCodeResult> getLoginQrCodeResult() async {
    try {
      final data = await _httpService.get<dynamic>(_getLoginQrCodeEndpoint);
      return _parseLoginQrResponse(data);
    } catch (e) {
      debugPrint('Error fetching login QR code: $e');
      rethrow;
    }
  }

  /// 仅返回二维码字符串；冷却信息见 [getLoginQrCodeResult]。
  Future<String> getLoginQrCode() async {
    final r = await getLoginQrCodeResult();
    return r.content;
  }

  LoginQrCodeResult _parseLoginQrResponse(dynamic data) {
    if (data == null) {
      return const LoginQrCodeResult(content: '');
    }
    if (data is String) {
      return LoginQrCodeResult(content: data.trim());
    }
    if (data is Map<String, dynamic>) {
      int? cd = ErrorHandlerCenter.parseRetryAfterSecondsFromMap(data);
      final rawData = data['data'];
      if (rawData is Map<String, dynamic>) {
        cd ??= ErrorHandlerCenter.parseRetryAfterSecondsFromMap(rawData);
      }
      final inner = data['data'] ?? data['qrCode'] ?? data['content'];
      String content = '';
      if (inner is String) {
        content = inner;
      } else if (inner != null) {
        content = inner.toString();
      }
      return LoginQrCodeResult(content: content, cooldownSeconds: cd);
    }
    return LoginQrCodeResult(content: data.toString());
  }

  /// 获取在线号码列表
  Future<List<OnlineNumber>> getOnlineNumbers() async {
    try {
      // 使用dynamic类型获取原始响应数据，避免HttpService的自动处理
      final response = await _httpService.get<dynamic>(
        _getOnlineNumbersEndpoint,
      );

      // 处理API响应
      if (response != null) {
        List<dynamic> dataList;

        // 检查响应结构
        if (response is Map<String, dynamic>) {
          // 如果是标准API格式，从data字段获取
          if (response['data'] != null && response['data'] is List) {
            dataList = response['data'] as List;
          } else {
            debugPrint('No data field found in Map response');
            return [];
          }
        } else if (response is List) {
          // 如果响应本身就是列表
          dataList = response;
        } else {
          debugPrint('Unexpected response format: ${response.runtimeType}');
          return [];
        }

        debugPrint('Data list length: ${dataList.length}');

        if (dataList.isNotEmpty) {
          debugPrint('First item sample: ${dataList[0]}');
          debugPrint('First item type: ${dataList[0].runtimeType}');
        }

        try {
          final result = dataList.map((item) {
            debugPrint('Processing item: $item');
            return OnlineNumber.fromJson(item as Map<String, dynamic>);
          }).toList();
          debugPrint('Parsed ${result.length} OnlineNumber objects');
          return result;
        } catch (e, stackTrace) {
          debugPrint('Error parsing OnlineNumber objects: $e');
          debugPrint('Stack trace: $stackTrace');
          return [];
        }
      }

      debugPrint('Response is null');
      return [];
    } catch (e, stackTrace) {
      // 发生异常时返回空列表
      debugPrint('Error fetching online numbers: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// 获取任务信息
  Future<Map<String, dynamic>> getTaskInfo() async {
    try {
      final data = await _httpService.get<Map<String, dynamic>>(
        _getTaskInfoEndpoint,
      );

      return data;
    } catch (e) {
      debugPrint('Error fetching task info: $e');
      // 发生异常时返回默认值
      return {
        'todayPoints': 0,
        'todaySendNum': 0,
        'videoUrl': '',
        'wsDownloadUrl': '',
        'yesterdayPoints': 0,
      };
    }
  }

  /// 发送WhatsApp消息
  Future<Map<String, dynamic>> sendMessage(String id) async {
    try {
      final data = await _httpService.get<Map<String, dynamic>>(
        _sendMsgEndpoint,
        queryParameters: {'id': id},
      );

      return data;
    } catch (e) {
      debugPrint('Error sending WhatsApp message: $e');
      rethrow;
    }
  }

  /// 获取国家区号列表
  Future<List<Map<String, dynamic>>> getAreaCodes() async {
    try {
      final response = await _httpService.get<dynamic>(_getAreaCodesEndpoint);

      List<dynamic> dataList;
      if (response is Map<String, dynamic>) {
        if (response['data'] is List) {
          dataList = response['data'] as List;
        } else {
          return [];
        }
      } else if (response is List) {
        dataList = response;
      } else {
        return [];
      }

      final List<Map<String, dynamic>> codes = [];
      for (final item in dataList) {
        if (item is Map<String, dynamic>) {
          codes.add({
            'short': item['short'] ?? '',
            'en': item['en'] ?? '',
            'code': item['code'] ?? '',
          });
        }
      }
      return codes;
    } catch (e) {
      return [];
    }
  }
}
