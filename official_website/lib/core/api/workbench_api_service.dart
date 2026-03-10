import 'package:dio/dio.dart';
import '../cache/workbench_cache_service.dart';

/// 工作台 API 服务
/// 负责与服务器进行数据交互
class WorkbenchApiService {
  static const String _baseUrl = 'https://your-api-domain.com/api'; // 替换为实际的 API 地址

  late final Dio _dio;

  // 单例模式
  static final WorkbenchApiService _instance = WorkbenchApiService._internal();
  factory WorkbenchApiService() => _instance;
  WorkbenchApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // ==================== 通用方法 ====================

  /// 设置认证 Token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除认证 Token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // ==================== 文章管理 API ====================

  /// 从服务器获取文章管理配置
  Future<ArticleManagementConfig?> fetchArticleManagementConfig() async {
    try {
      final response = await _dio.get('/workbench/article-management/config');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ArticleManagementConfig.fromJson(data);
      }
    } catch (e) {
      print('获取文章管理配置失败: $e');
    }
    return null;
  }

  /// 上传文章管理配置到服务器
  Future<bool> uploadArticleManagementConfig(ArticleManagementConfig config) async {
    try {
      final response = await _dio.post(
        '/workbench/article-management/config',
        data: config.toJson(),
      );

      if (response.statusCode == 200) {
        // 上传成功，更新同步状态
        final updatedConfig = config.copyWith(
          syncedWithServer: true,
          lastUpdateTime: DateTime.now(),
        );

        // 保存到缓存
        await WorkbenchCacheService().saveArticleManagementConfig(updatedConfig);

        return true;
      }
    } catch (e) {
      print('上传文章管理配置失败: $e');
    }
    return false;
  }

  // ==================== 支付配置 API ====================

  /// 从服务器获取支付配置
  Future<PaymentConfig?> fetchPaymentConfig() async {
    try {
      final response = await _dio.get('/workbench/payment/config');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentConfig.fromJson(data);
      }
    } catch (e) {
      print('获取支付配置失败: $e');
    }
    return null;
  }

  /// 上传支付配置到服务器
  Future<bool> uploadPaymentConfig(PaymentConfig config) async {
    try {
      final response = await _dio.post(
        '/workbench/payment/config',
        data: config.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('上传支付配置失败: $e');
    }
    return false;
  }

  // ==================== 音视频存储 API ====================

  /// 从服务器获取音视频存储配置
  Future<MediaStorageConfig?> fetchMediaStorageConfig() async {
    try {
      final response = await _dio.get('/workbench/media-storage/config');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return MediaStorageConfig.fromJson(data);
      }
    } catch (e) {
      print('获取音视频存储配置失败: $e');
    }
    return null;
  }

  /// 上传音视频存储配置到服务器
  Future<bool> uploadMediaStorageConfig(MediaStorageConfig config) async {
    try {
      final response = await _dio.post(
        '/workbench/media-storage/config',
        data: config.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('上传音视频存储配置失败: $e');
    }
    return false;
  }

  // ==================== 批量同步 ====================

  /// 从服务器批量获取所有工作台配置
  Future<Map<String, dynamic>> fetchAllWorkbenchConfigs() async {
    try {
      final response = await _dio.get('/workbench/configs/all');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print('批量获取工作台配置失败: $e');
    }
    return {};
  }

  /// 批量上传所有工作台配置到服务器
  Future<bool> uploadAllWorkbenchConfigs({
    ArticleManagementConfig? articleConfig,
    PaymentConfig? paymentConfig,
    MediaStorageConfig? mediaConfig,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (articleConfig != null) {
        data['articleManagement'] = articleConfig.toJson();
      }
      if (paymentConfig != null) {
        data['payment'] = paymentConfig.toJson();
      }
      if (mediaConfig != null) {
        data['mediaStorage'] = mediaConfig.toJson();
      }

      final response = await _dio.post(
        '/workbench/configs/all',
        data: data,
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('批量上传工作台配置失败: $e');
    }
    return false;
  }
}
