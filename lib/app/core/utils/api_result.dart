/// API调用结果封装类
class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String message;
  final int? errorCode;
  final Exception? exception;

  const ApiResult._({
    required this.isSuccess,
    this.data,
    required this.message,
    this.errorCode,
    this.exception,
  });

  /// 成功结果
  factory ApiResult.success({
    T? data,
    String message = '操作成功',
  }) {
    return ApiResult._(
      isSuccess: true,
      data: data,
      message: message,
    );
  }

  /// 失败结果
  factory ApiResult.failure({
    required String message,
    int? errorCode,
    Exception? exception,
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
      exception: exception,
    );
  }

  /// 网络错误
  factory ApiResult.networkError({
    String message = '网络连接失败，请检查网络设置',
    Exception? exception,
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: -1,
      exception: exception,
    );
  }

  /// 服务器错误
  factory ApiResult.serverError({
    String message = '服务器错误，请稍后重试',
    int? errorCode,
    Exception? exception,
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode ?? 500,
      exception: exception,
    );
  }

  /// 未知错误
  factory ApiResult.unknownError({
    String message = '未知错误，请稍后重试',
    Exception? exception,
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: -999,
      exception: exception,
    );
  }

  /// 数据为空错误
  factory ApiResult.emptyData({
    String message = '暂无数据',
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: 404,
    );
  }

  /// 权限错误
  factory ApiResult.unauthorized({
    String message = '权限不足，请重新登录',
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: 401,
    );
  }

  /// 参数错误
  factory ApiResult.invalidParams({
    String message = '参数错误',
  }) {
    return ApiResult._(
      isSuccess: false,
      message: message,
      errorCode: 400,
    );
  }



  /// 转换数据类型
  ApiResult<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        final mappedData = mapper(data!);
        return ApiResult.success(
          data: mappedData,
          message: message,
        );
      } catch (e) {
        return ApiResult.failure(
          message: '数据转换失败: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        );
      }
    } else {
      return ApiResult.failure(
        message: message,
        errorCode: errorCode,
        exception: exception,
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
          message: '处理失败: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        );
      }
    } else {
      return ApiResult.failure(
        message: message,
        errorCode: errorCode,
        exception: exception,
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
      throw exception ?? Exception(message);
    }
  }

  /// 获取数据或默认值
  T getDataOrDefault(T defaultValue) {
    return isSuccess && data != null ? data! : defaultValue;
  }

  @override
  String toString() {
    return 'ApiResult{isSuccess: $isSuccess, message: $message, errorCode: $errorCode, hasData: ${data != null}}';
  }
}