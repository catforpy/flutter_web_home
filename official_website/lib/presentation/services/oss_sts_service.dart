import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:official_website/core/config/app_config.dart';

/// OSS STS 临时凭证响应模型
class STSCredentialsResponse {
  final String accessKeyId;
  final String accessKeySecret;
  final String securityToken;
  final String expiration;
  final int durationSeconds;
  final String bucketName;
  final String region;

  STSCredentialsResponse({
    required this.accessKeyId,
    required this.accessKeySecret,
    required this.securityToken,
    required this.expiration,
    required this.durationSeconds,
    required this.bucketName,
    required this.region,
  });

  factory STSCredentialsResponse.fromJson(Map<String, dynamic> json) {
    final credentials = json['credentials'];
    final ossConfig = json['ossConfig'];
    return STSCredentialsResponse(
      accessKeyId: credentials['accessKeyId'],
      accessKeySecret: credentials['accessKeySecret'],
      securityToken: credentials['securityToken'],
      expiration: credentials['expiration'],
      durationSeconds: credentials['durationSeconds'],
      bucketName: ossConfig['bucketName'],
      region: ossConfig['region'],
    );
  }

  /// 判断凭证是否已过期
  bool get isExpired {
    final expirationTime = DateTime.parse(expiration);
    return DateTime.now().isAfter(expirationTime);
  }

  /// 判断凭证是否即将过期（1小时内）
  bool get isExpiringSoon {
    final expirationTime = DateTime.parse(expiration);
    return DateTime.now().add(const Duration(hours: 1)).isAfter(expirationTime);
  }
}

/// OSS STS 服务
/// 负责获取STS临时凭证并管理OSS直传
class OSSSTSService {
  static final OSSSTSService _instance = OSSSTSService._internal();
  factory OSSSTSService() => _instance;
  OSSSTSService._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  STSCredentialsResponse? _cachedCredentials;

  /// 获取STS临时凭证
  ///
  /// [bucketName] OSS存储空间名称
  /// [objectPrefix] 对象键前缀（可选，用于限制权限范围）
  /// [durationSeconds] 有效期（秒），默认3600秒（1小时）
  ///
  /// 返回 STS 临时凭证，包含 accessKeyId、accessKeySecret、securityToken 等
  Future<STSCredentialsResponse> getSTSToken({
    required String bucketName,
    String? objectPrefix,
    int durationSeconds = 3600,
  }) async {
    try {
      // 如果缓存的凭证还有效，直接返回
      if (_cachedCredentials != null && !_cachedCredentials!.isExpiringSoon) {
        print('使用缓存的STS凭证');
        return _cachedCredentials!;
      }

      // 调用后端API获取新的STS凭证
      final response = await _dio.post(
        '/api/oss/sts/token',
        data: {
          'bucketName': bucketName,
          if (objectPrefix != null) 'objectPrefix': objectPrefix,
          'durationSeconds': durationSeconds,
          'permissionType': 'ReadWrite',
          'userId': 1, // TODO: 从用户上下文获取
          'userType': 'platform_account',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: 添加认证头
            // 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        _cachedCredentials = STSCredentialsResponse.fromJson(response.data['data']);
        print('获取STS凭证成功: bucket=${_cachedCredentials!.bucketName}');
        return _cachedCredentials!;
      } else {
        throw Exception('获取STS凭证失败: ${response.data['message']}');
      }
    } catch (e) {
      print('获取STS凭证异常: $e');
      rethrow;
    }
  }

  /// 查询已上传的图片URL列表
  ///
  /// [userId] 用户ID
  /// [bucketName] 存储空间名称（可选）
  /// [prefix] 对象键前缀（可选）
  /// [maxKeys] 最大返回数量（默认100）
  Future<List<String>> listImageUrls({
    required int userId,
    String? bucketName,
    String? prefix,
    int maxKeys = 100,
  }) async {
    try {
      final response = await _dio.get(
        '/api/oss/images',
        queryParameters: {
          'userId': userId,
          if (bucketName != null) 'bucketName': bucketName,
          if (prefix != null) 'prefix': prefix,
          'maxKeys': maxKeys,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: 添加认证头
          },
        ),
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        final data = response.data['data'];
        final List<dynamic> urls = data['imageUrls'];
        print('查询到 ${urls.length} 个图片URL');
        return urls.cast<String>();
      } else {
        throw Exception('查询图片URL失败: ${response.data['message']}');
      }
    } catch (e) {
      print('查询图片URL异常: $e');
      rethrow;
    }
  }

  /// 批量获取图片URL
  ///
  /// [bucketName] 存储空间名称
  /// [objectKeys] 对象键列表
  ///
  /// 返回 Map，key为对象键，value为URL
  Future<Map<String, String>> batchGetImageUrls({
    required String bucketName,
    required List<String> objectKeys,
  }) async {
    try {
      final response = await _dio.post(
        '/api/oss/images/batch',
        data: {
          'bucketName': bucketName,
          'objectKeys': objectKeys,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // TODO: 添加认证头
          },
        ),
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        final Map<String, dynamic> urlMap = response.data['data'];
        print('批量获取 ${urlMap.length} 个图片URL');
        return urlMap.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('批量获取图片URL失败: ${response.data['message']}');
      }
    } catch (e) {
      print('批量获取图片URL异常: $e');
      rethrow;
    }
  }

  /// 清除缓存的STS凭证
  void clearCachedCredentials() {
    _cachedCredentials = null;
    print('已清除缓存的STS凭证');
  }
}
