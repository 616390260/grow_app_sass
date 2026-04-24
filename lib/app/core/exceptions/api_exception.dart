/// API异常类 - 用于传递错误码和错误消息
class ApiException implements Exception {
  final int code;
  final String message;

  /// 服务端建议的再次请求间隔（秒），如限流、`Retry-After` 等；无则 null。
  final int? retryAfterSeconds;

  const ApiException({
    required this.code,
    required this.message,
    this.retryAfterSeconds,
  });

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message, retryAfterSeconds: $retryAfterSeconds)';
  }
}
