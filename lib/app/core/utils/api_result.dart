import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:get/get.dart';

/// API调用结果封装类 - 格式：{"code": 200, "msg": "", "data": T}
class ApiResult<T> {
  final int code;
  final String msg;
  final T? data;

  bool get isSuccess => code == 200;

  const ApiResult._({
    required this.code,
    required this.msg,
    this.data,
  });

  /// 成功结果
  factory ApiResult.success({
    T? data,
    String msg = '',
    int code = 200,
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.operationSuccess.tr;
    }
    return ApiResult._(
      code: code,
      msg: msg,
      data: data,
    );
  }

  /// 失败结果
  factory ApiResult.failure({
    required String msg,
    int code = 400,
  }) {
    return ApiResult._(
      code: code,
      msg: msg,
    );
  }

  /// 网络错误
  factory ApiResult.networkError({
    String msg = '',
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.errorNetwork.tr;
    }
    return ApiResult._(
      code: -1,
      msg: msg,
    );
  }

  /// 服务器错误
  factory ApiResult.serverError({
    String msg = '',
    int code = 500,
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.errorServerError.tr;
    }
    return ApiResult._(
      code: code,
      msg: msg,
    );
  }

  /// 未知错误
  factory ApiResult.unknownError({
    String msg = '',
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.errorUnknown.tr;
    }
    return ApiResult._(
      code: -999,
      msg: msg,
    );
  }

  /// 数据为空错误
  factory ApiResult.emptyData({
    String msg = '',
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.noData.tr;
    }
    return ApiResult._(
      code: 404,
      msg: msg,
    );
  }

  /// 权限错误
  factory ApiResult.unauthorized({
    String msg = '',
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.insufficientPermissionsPleaseLoginAgain.tr;
    }
    return ApiResult._(
      code: 401,
      msg: msg,
    );
  }

  /// 参数错误
  factory ApiResult.invalidParams({
    String msg = '',
  }) {
    if (msg.isEmpty) {
      msg = I18nKeys.errorInvalidParams.tr;
    }
    return ApiResult._(
      code: 400,
      msg: msg,
    );
  }

  /// 转换数据类型
  ApiResult<R> map<R>(R Function(T? data) mapper) {
    if (isSuccess) {
      try {
        final mappedData = mapper(data);
        return ApiResult.success(
          data: mappedData,
          msg: msg,
        );
      } catch (e) {
        return ApiResult.failure(
          msg: '${I18nKeys.errorUnknown.tr}: ${e.toString()}',
        );
      }
    } else {
      return ApiResult.failure(
        msg: msg,
        code: code,
      );
    }
  }

  /// 链式调用处理
  ApiResult<R> then<R>(ApiResult<R> Function(T? data) next) {
    if (isSuccess) {
      try {
        return next(data);
      } catch (e) {
        return ApiResult.failure(
          msg: '${I18nKeys.processingFailed.tr}: ${e.toString()}',
        );
      }
    } else {
      return ApiResult.failure(
        msg: msg,
        code: code,
      );
    }
  }

  /// 获取数据或默认值
  T? getDataOrNull() => isSuccess ? data : null;

  /// 获取数据或抛出异常
  T getDataOrThrow() {
    if (isSuccess && data != null) {
      return data!;
    } else {
      throw Exception(msg);
    }
  }

  /// 获取数据或默认值
  T getDataOrDefault(T defaultValue) {
    return isSuccess && data != null ? data! : defaultValue;
  }

  @override
  String toString() {
    return 'ApiResult{code: $code, msg: $msg, hasData: ${data != null}}';
  }
}