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
    super.message = '服务器错误,请稍后重试',
    super.code,
  });
}

/// 网络失败
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = '网络连接失败,请检查网络设置',
    super.code,
  });
}

/// 缓存失败
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = '缓存读取失败',
    super.code,
  });
}

/// 验证失败
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = '数据验证失败',
    super.code,
  });
}

/// 未授权失败
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = '未授权,请先登录',
    super.code = 401,
  });
}

/// 未找到失败
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = '请求的资源不存在',
    super.code = 404,
  });
}

/// 超时失败
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = '请求超时,请稍后重试',
    super.code = 408,
  });
}

/// 未知失败
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = '未知错误',
    super.code,
  });
}
