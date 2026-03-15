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
    super.message = '服务器错误',
    super.code,
  });
}

/// 网络异常
class NetworkException extends AppException {
  const NetworkException({
    super.message = '网络连接失败',
    super.code,
  });
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException({
    super.message = '缓存操作失败',
    super.code,
  });
}

/// 序列化异常
class SerializationException extends AppException {
  const SerializationException({
    super.message = '数据序列化失败',
    super.code,
  });
}

/// 未授权异常
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = '未授权访问',
    super.code = 401,
  });
}

/// 未找到异常
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = '资源未找到',
    super.code = 404,
  });
}

/// 超时异常
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = '请求超时',
    super.code = 408,
  });
}
