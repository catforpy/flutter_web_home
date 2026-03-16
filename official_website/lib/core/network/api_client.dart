import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/config/app_config.dart';
import 'package:official_website/core/services/token_manager.dart';
import 'package:official_website/core/services/auth_v2_service.dart';

/// API 客户端
///
/// 负责所有 HTTP 请求的发送和响应处理
/// 包含：
/// - 自动添加认证 Token
/// - 统一错误处理
/// - 请求/响应日志
/// - Token 刷新机制（带锁，防止并发刷新）
/// - 对接真实的后端API
class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  late final TokenManager _tokenManager;
  late final AuthServiceV2 _authServiceV2;

  /// Token刷新锁，防止并发刷新
  bool _isRefreshing = false;

  /// 等待重试的请求队列
  final List<_RetryRequest> _retryRequests = [];

  // 单例模式
  static ApiClient? _instance;
  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }
  ApiClient._internal() {
    _tokenManager = TokenManager();
    _authServiceV2 = AuthServiceV2();
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  /// 创建 Dio 基础配置
  static BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: AppConfig.apiBaseUrl, // 使用 AppConfig（支持可配置）
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// 设置拦截器
  void _setupInterceptors() {
    // 请求拦截器 - 添加 Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 从TokenManager获取 Token
        final token = await _tokenManager.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (AppConfig.enableNetworkLog) {
          _logger.d('🚀 Request: ${options.method} ${options.uri}');
          _logger.d('📝 Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('📦 Body: ${options.data}');
          }
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        if (AppConfig.enableNetworkLog) {
          _logger.d('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
          _logger.d('📄 Data: ${response.data}');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (AppConfig.enableNetworkLog) {
          _logger.e('❌ Error: ${error.requestOptions.uri}');
          _logger.e('📛 Status: ${error.response?.statusCode}');
          _logger.e('💥 Message: ${error.message}');
          _logger.e('📄 Response: ${error.response?.data}');
        }

        // 处理 401 未授权错误 - 尝试刷新 Token（带锁机制）
        if (error.response?.statusCode == 401) {
          if (_isRefreshing) {
            // 如果正在刷新Token，将请求加入队列
            _logger.d('⏳ Token刷新中，请求加入队列...');
            _retryRequests.add(_RetryRequest(error.requestOptions, handler));
            return;
          }

          // 开始刷新Token
          _isRefreshing = true;
          final refreshed = await _refreshTokenAndRetry();
          _isRefreshing = false;

          if (refreshed) {
            // Token刷新成功，重试原请求
            try {
              final response = await _retry(error.requestOptions);
              // 重试所有排队的请求
              for (final retryRequest in _retryRequests) {
                try {
                  final queuedResponse = await _retry(retryRequest.requestOptions);
                  retryRequest.handler.resolve(queuedResponse);
                } catch (e) {
                  _logger.e('❌ 队列请求重试失败: $e');
                  retryRequest.handler.next(error);
                }
              }
              _retryRequests.clear();
              return handler.resolve(response);
            } catch (e) {
              _logger.e('❌ 请求重试失败: $e');
              _retryRequests.clear();
            }
          } else {
            // Token刷新失败，拒绝所有排队的请求
            for (final retryRequest in _retryRequests) {
              retryRequest.handler.next(error);
            }
            _retryRequests.clear();
          }
        }

        handler.next(error);
      },
    ));

    // 日志拦截器
    if (AppConfig.enableNetworkLog) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// 刷新Token并重试
  Future<bool> _refreshTokenAndRetry() async {
    try {
      _logger.i('🔄 Token过期，尝试刷新（V2接口）...');
      final result = await _authServiceV2.refreshToken();

      return result.fold(
        (failure) {
          _logger.e('❌ Token刷新失败: ${failure.message}');
          // Token刷新失败，清除本地Token并跳转到登录页
          _handleRefreshFailure();
          return false;
        },
        (loginData) {
          _logger.i('✅ Token刷新成功');
          return true;
        },
      );
    } catch (e) {
      _logger.e('❌ Token刷新异常: $e');
      // Token刷新异常，清除本地Token并跳转到登录页
      _handleRefreshFailure();
      return false;
    }
  }

  /// 处理Token刷新失败
  /// 清除本地Token
  void _handleRefreshFailure() {
    _logger.w('⚠️  Token刷新失败，清除本地Token');
    // 清除本地Token
    _tokenManager.clearTokens();
    // 注意：实际的页面跳转需要在UI层处理，可以监听AuthState的变化
  }

  /// 重试请求
  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ==================== 公共 API 方法 ====================

  /// GET 请求
  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// POST 请求
  Future<Either<Failure, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// PUT 请求
  Future<Either<Failure, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// DELETE 请求
  Future<Either<Failure, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// 文件上传
  Future<Either<Failure, T>> upload<T>(
    String path,
    String filePath, {
    String? fileKey,
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey ?? 'file': await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post(
        path,
        data: formData,
      );

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }
      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ==================== 错误处理 ====================

  /// 处理 Dio 错误
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: '网络连接超时，请检查网络设置');

      case DioExceptionType.connectionError:
        return const ServerFailure(message: '网络连接失败，请检查网络设置');

      case DioExceptionType.badResponse:
        return _handleHttpResponse(error.response!);

      case DioExceptionType.cancel:
        return const ServerFailure(message: '请求已取消');

      case DioExceptionType.unknown:
      default:
        return ServerFailure(message: error.message ?? '未知错误');
    }
  }

  /// 处理 HTTP 响应错误
  Failure _handleHttpResponse(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    // 尝试从响应中获取错误信息
    String message = '请求失败';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
                 data['msg'] as String? ??
                 data['error'] as String? ??
                 message;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message: message);
      case 401:
        return const ServerFailure(message: '未授权，请重新登录');
      case 403:
        return const ServerFailure(message: '无权访问');
      case 404:
        return NotFoundFailure(message: message);
      case 500:
        return const ServerFailure(message: '服务器错误，请稍后重试');
      default:
        return ServerFailure(message: message);
    }
  }

  // ==================== 公共方法 ====================

  /// 获取 Dio 实例（用于特殊场景）
  Dio get dio => _dio;
}

/// 重试请求封装类
class _RetryRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RetryRequest(this.requestOptions, this.handler);
}
