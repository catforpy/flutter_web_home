import 'package:equatable/equatable.dart';

/// 抽象失败类
/// 所有失败类型的基类
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// 服务器失败
class ServerFailure extends Failure {
  const ServerFailure({
    String message = '服务器错误,请稍后重试',
    int? code,
  }) : super(message: message, code: code);
}

/// 网络失败
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = '网络连接失败,请检查网络设置',
    int? code,
  }) : super(message: message, code: code);
}

/// 缓存失败
class CacheFailure extends Failure {
  const CacheFailure({
    String message = '缓存读取失败',
    int? code,
  }) : super(message: message, code: code);
}

/// 验证失败
class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = '数据验证失败',
    int? code,
  }) : super(message: message, code: code);
}

/// 未授权失败
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = '未授权,请先登录',
    int? code = 401,
  }) : super(message: message, code: code);
}

/// 未找到失败
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = '请求的资源不存在',
    int? code = 404,
  }) : super(message: message, code: code);
}

/// 超时失败
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = '请求超时,请稍后重试',
    int? code = 408,
  }) : super(message: message, code: code);
}

/// 未知失败
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = '未知错误',
    int? code,
  }) : super(message: message, code: code);
}
