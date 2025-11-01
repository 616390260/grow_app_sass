/// API调用结果封装类 - 格式：{"code": 200, "msg": "操作成功", "data": T}
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
    String msg = '操作成功',
    int code = 200,
  }) {
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
    String msg = '网络连接失败，请检查网络设置',
  }) {
    return ApiResult._(
      code: -1,
      msg: msg,
    );
  }

  /// 服务器错误
  factory ApiResult.serverError({
    String msg = '服务器错误，请稍后重试',
    int code = 500,
  }) {
    return ApiResult._(
      code: code,
      msg: msg,
    );
  }

  /// 未知错误
  factory ApiResult.unknownError({
    String msg = '未知错误，请稍后重试',
  }) {
    return ApiResult._(
      code: -999,
      msg: msg,
    );
  }

  /// 数据为空错误
  factory ApiResult.emptyData({
    String msg = '暂无数据',
  }) {
    return ApiResult._(
      code: 404,
      msg: msg,
    );
  }

  /// 权限错误
  factory ApiResult.unauthorized({
    String msg = '权限不足，请重新登录',
  }) {
    return ApiResult._(
      code: 401,
      msg: msg,
    );
  }

  /// 参数错误
  factory ApiResult.invalidParams({
    String msg = '参数错误',
  }) {
    return ApiResult._(
      code: 400,
      msg: msg,
    );
  }

  /// 转换数据类型
  ApiResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        final mappedData = mapper(data!);
        return ApiResult.success(
          data: mappedData,
          msg: msg,
        );
      } catch (e) {
        return ApiResult.failure(
          msg: '数据转换失败: ${e.toString()}',
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
  ApiResult<R> then<R>(ApiResult<R> Function(T data) next) {
    if (isSuccess && data != null) {
      try {
        return next(data!);
      } catch (e) {
        return ApiResult.failure(
          msg: '处理失败: ${e.toString()}',
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