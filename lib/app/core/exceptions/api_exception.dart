/// API异常类 - 用于传递错误码和错误消息
class ApiException implements Exception {
  final int code;
  final String message;

  const ApiException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message)';
  }
}