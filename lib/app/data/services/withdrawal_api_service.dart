import 'package:do_task_project/app/core/models/base_list_entity.dart';
import 'package:do_task_project/app/domain/entities/withdrawal_record.dart';
import 'package:do_task_project/app/domain/entities/withdrawal_setting.dart';
import 'package:flutter/material.dart';
import '../../core/services/http_service.dart';

/// 提现相关 API 服务
class WithdrawalApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getWithdrawalRecordsEndpoint = 'app/withdrawRecord/getPage';
  static const String _withdrawalEndpoint = 'app/goldenFlowInfo/withdrawal';
  static const String _getWithdrawalSettingEndpoint = 'app/goldenFlowInfo/getWithdrawalSetting';
  
  /// 提交提现请求
  /// [params] 包含：account, bankId, goldenFlowId, loginPassword, name, points
  Future<Map<String, dynamic>> submitWithdrawal(Map<String, dynamic> params) async {
    try {
      debugPrint('请求提现API: $_withdrawalEndpoint, 参数: $params');
      
      final responseData = await _httpService.postData<Map<String, dynamic>>(
        _withdrawalEndpoint,
        data: params,
      );
      
      debugPrint('获取到提现响应: $responseData');
      return responseData;
    } catch (e) {
      debugPrint('提现请求异常: $e');
      rethrow;
    }
  }

  /// 获取提现记录列表（分页）
  Future<BaseListEntity<WithdrawalRecord>> getWithdrawalRecords({
    int page = 1,
    int limit = 20,
    String? status,
    String? timeRange,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'current': page,
        'size': limit,
      };

      // 添加筛选参数
      if (status != null && status.isNotEmpty) {
        queryParameters['type'] = status;
      }
      
      if (timeRange != null && timeRange.isNotEmpty) {
        queryParameters['timeType'] = timeRange;
      }

      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getWithdrawalRecordsEndpoint,
        queryParameters: queryParameters,
      );
      
      
      // 安全地转换数据模型
      return BaseListEntity<WithdrawalRecord>.fromJsonSafe(
        responseData,
        (json) => WithdrawalRecord.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print('获取提现记录异常: $e');
      // 发生异常时返回一个空的BaseListEntity实例
      return BaseListEntity<WithdrawalRecord>(
        records: <WithdrawalRecord>[],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }
  }

  /// 获取提现配置
  Future<WithdrawalSetting> getWithdrawalSetting() async {
    try {
      debugPrint('请求提现配置API: $_getWithdrawalSettingEndpoint');
      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getWithdrawalSettingEndpoint,
      );
      
      debugPrint('获取到提现配置响应: $responseData');
      
      // 安全地获取data字段并转换为WithdrawalSetting
      // final data = responseData['data'] as Map<String, dynamic>?;
      return WithdrawalSetting.fromJson(responseData);
    } catch (e) {
      debugPrint('获取提现配置异常: $e');
      // 发生异常时返回一个空的WithdrawalSetting实例
      return const WithdrawalSetting();
    }
  }
}
