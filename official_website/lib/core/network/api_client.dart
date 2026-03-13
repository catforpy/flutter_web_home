import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_config.dart';
import 'package:official_website/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 客户端
///
/// 负责所有 HTTP 请求的发送和响应处理
/// 包含：
/// - 自动添加认证 Token
/// - 统一错误处理
/// - 请求/响应日志
/// - Token 刷新机制
class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  // 单例模式
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  /// 创建 Dio 基础配置
  static BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: AppConfig.apiBaseUrl, // 使用 AppConfig
      connectTimeout: Duration(seconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
      sendTimeout: Duration(seconds: AppConfig.receiveTimeout),
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
        // 从本地存储获取 Token
        final token = await _getToken();
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

        // 处理 401 未授权错误 - 尝试刷新 Token
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // 重试原请求
            return handler.resolve(await _retry(error.requestOptions));
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

  /// 从本地获取 Token
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      _logger.e('Failed to get token: $e');
      return null;
    }
  }

  /// 保存 Token 到本地
  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      _logger.e('Failed to save token: $e');
    }
  }

  /// 清除 Token
  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      _logger.e('Failed to clear token: $e');
    }
  }

  /// 刷新 Token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiConfig.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['accessToken'] as String?;
        if (newToken != null) {
          await _saveToken(newToken);
          return true;
        }
      }
    } catch (e) {
      _logger.e('Failed to refresh token: $e');
    }
    return false;
  }

  /// 获取刷新 Token
  Future<String?> _getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refresh_token');
    } catch (e) {
      return null;
    }
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

  /// 设置认证 Token（外部调用）
  Future<void> setAuthToken(String token) async {
    await _saveToken(token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除认证 Token（外部调用）
  Future<void> clearAuthToken() async {
    await _clearToken();
    _dio.options.headers.remove('Authorization');
  }

  /// 获取 Dio 实例（用于特殊场景）
  Dio get dio => _dio;
}
