import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cloud_storage_config.dart';

/// 云存储配置管理器
class CloudStorageManager {
  static final CloudStorageManager _instance = CloudStorageManager._internal();
  factory CloudStorageManager() => _instance;
  CloudStorageManager._internal();

  static const String _storageConfigKey = 'cloud_storage_configs';

  /// 获取所有配置
  Future<List<CloudStorageConfig>> getConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getString(_storageConfigKey);

    if (configsJson == null || configsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(configsJson);
      return decoded.map((json) => CloudStorageConfig.fromJson(json)).toList();
    } catch (e) {
      print('加载云存储配置失败: $e');
      return [];
    }
  }

  /// 保存配置
  Future<void> saveConfig(CloudStorageConfig config) async {
    final configs = await getConfigs();

    // 查找是否已存在相同ID的配置
    final index = configs.indexWhere((c) => c.id == config.id);
    if (index != -1) {
      configs[index] = config;
    } else {
      configs.add(config);
    }

    await _saveConfigs(configs);
  }

  /// 删除配置
  Future<void> deleteConfig(String configId) async {
    final configs = await getConfigs();
    configs.removeWhere((c) => c.id == configId);
    await _saveConfigs(configs);
  }

  /// 保存所有配置
  Future<void> _saveConfigs(List<CloudStorageConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = jsonEncode(configs.map((c) => c.toJson()).toList());
    await prefs.setString(_storageConfigKey, configsJson);
  }

  /// 检查是否有任何配置
  Future<bool> hasAnyConfig() async {
    final configs = await getConfigs();
    return configs.isNotEmpty;
  }

  /// 根据ID获取配置
  Future<CloudStorageConfig?> getConfig(String id) async {
    final configs = await getConfigs();
    try {
      return configs.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 模拟获取buckets列表（实际应该调用云服务商API）
  Future<List<BucketInfo>> getBuckets(CloudStorageConfig config) async {
    // TODO: 实际应该调用阿里云OSS/ListBuckets API
    // 这里返回模拟数据
    return [
      BucketInfo(name: 'duda-public', region: 'oss-cn-hangzhou'),
      BucketInfo(name: 'duda-private', region: 'oss-cn-beijing'),
      BucketInfo(name: 'duda-media', region: 'oss-cn-shanghai'),
    ];
  }

  /// 模拟获取文件夹列表（实际应该调用云服务商API）
  Future<List<FolderInfo>> getFolders(CloudStorageConfig config, String bucketName) async {
    // TODO: 实际应该调用云服务商API获取文件夹列表
    // 这里返回模拟数据
    return [
      FolderInfo(name: 'avatars', path: '/avatars'),
      FolderInfo(name: 'products', path: '/products'),
      FolderInfo(name: 'documents', path: '/documents'),
      FolderInfo(name: 'images', path: '/images'),
    ];
  }

  /// 上传文件到云存储
  Future<String> uploadFile({
    required CloudStorageConfig config,
    required String bucketName,
    required String folderPath,
    required String fileName,
    required String fileData, // base64数据
  }) async {
    // TODO: 根据不同的provider调用不同的上传API
    // 这里返回模拟的URL
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileNameWithTimestamp = '${timestamp}_$fileName';

    // 构建文件路径
    final fullPath = folderPath.endsWith('/')
        ? '$folderPath$fileNameWithTimestamp'
        : '$folderPath/$fileNameWithTimestamp';

    // 模拟返回URL（实际应该调用云存储API上传）
    String url = '';
    switch (config.provider) {
      case CloudProvider.aliyun:
        url = 'https://${config.bucketName}.oss-cn-hangzhou.aliyuncs.com$fullPath';
        break;
      case CloudProvider.tencent:
        url = 'https://${config.bucketName}.cos.ap-beijing.myqcloud.com$fullPath';
        break;
      case CloudProvider.qiniu:
        url = 'https://${config.bucketName}.cdn.qiniu.com$fullPath';
        break;
    }

    return url;
  }
}
