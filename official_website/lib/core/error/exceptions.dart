/// 抽象异常类
/// 所有自定义异常的基类
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// 服务器异常
class ServerException extends AppException {
  const ServerException({
    String message = '服务器错误',
    int? code,
  }) : super(message: message, code: code);
}

/// 网络异常
class NetworkException extends AppException {
  const NetworkException({
    String message = '网络连接失败',
    int? code,
  }) : super(message: message, code: code);
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException({
    String message = '缓存操作失败',
    int? code,
  }) : super(message: message, code: code);
}

/// 序列化异常
class SerializationException extends AppException {
  const SerializationException({
    String message = '数据序列化失败',
    int? code,
  }) : super(message: message, code: code);
}

/// 未授权异常
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = '未授权访问',
    int? code = 401,
  }) : super(message: message, code: code);
}

/// 未找到异常
class NotFoundException extends AppException {
  const NotFoundException({
    String message = '资源未找到',
    int? code = 404,
  }) : super(message: message, code: code);
}

/// 超时异常
class TimeoutException extends AppException {
  const TimeoutException({
    String message = '请求超时',
    int? code = 408,
  }) : super(message: message, code: code);
}
