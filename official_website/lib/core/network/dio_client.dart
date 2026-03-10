import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';

/// Dio客户端封装
/// 统一网络请求处理
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// 设置拦截器
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('Request: ${options.method} ${options.uri}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('Error: ${error.message}');
          _logger.e('Response: ${error.response}');

          final exception = _handleDioError(error);
          return handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ));
        },
      ),
    );
  }

  /// 处理Dio错误
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: '请求超时: ${error.message}',
          code: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: '网络连接失败: ${error.message}',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: '请求已取消',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: '网络错误: ${error.message}',
        );

      default:
        return NetworkException(
          message: '未知错误: ${error.message}',
        );
    }
  }

  /// 处理响应错误
  AppException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['message'] ?? '请求失败';

    switch (statusCode) {
      case 400:
        return NetworkException(message: message, code: statusCode);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return NetworkException(
          message: '无权限访问',
          code: statusCode,
        );
      case 404:
        return NotFoundException(message: message);
      case 500:
        return ServerException(message: '服务器错误', code: statusCode);
      default:
        return ServerException(
          message: message,
          code: statusCode,
        );
    }
  }

  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException {
      rethrow;
    }
  }

  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }

  /// 设置Token
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除Token
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}
