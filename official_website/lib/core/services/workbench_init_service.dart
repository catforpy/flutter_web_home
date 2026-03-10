import 'package:flutter/foundation.dart';
import '../cache/workbench_cache_service.dart';
import '../api/workbench_api_service.dart';

/// 工作台初始化服务
/// 负责在用户登录后或进入工作台时，从服务器加载配置并缓存到本地
class WorkbenchInitService {
  static const String _keyPrefix = 'workbench_';

  // 单例模式
  static final WorkbenchInitService _instance = WorkbenchInitService._internal();
  factory WorkbenchInitService() => _instance;
  WorkbenchInitService._internal();

  final WorkbenchCacheService _cacheService = WorkbenchCacheService();
  final WorkbenchApiService _apiService = WorkbenchApiService();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// 初始化工作台配置
  /// 优先从服务器加载最新配置，失败则使用本地缓存
  Future<bool> initializeWorkbench() async {
    try {
      debugPrint('开始初始化工作台配置...');

      // 1. 尝试从服务器批量获取所有配置
      final serverConfigs = await _apiService.fetchAllWorkbenchConfigs();

      if (serverConfigs.isNotEmpty) {
        debugPrint('从服务器加载配置成功');
        // 2. 保存到本地缓存
        await _saveServerConfigs(serverConfigs);
      } else {
        debugPrint('服务器加载失败，使用本地缓存');
        // 3. 如果服务器加载失败，检查本地缓存是否存在
        final hasLocalCache = await _checkLocalCache();
        if (!hasLocalCache) {
          debugPrint('本地缓存不存在，使用默认配置');
          // 4. 如果本地缓存也不存在，使用默认配置
          await _saveDefaultConfigs();
        }
      }

      _isInitialized = true;
      debugPrint('工作台初始化完成');
      return true;
    } catch (e) {
      debugPrint('工作台初始化失败: $e');
      // 即使失败也尝试使用默认配置
      await _saveDefaultConfigs();
      _isInitialized = true;
      return false;
    }
  }

  /// 保存服务器返回的配置到本地缓存
  Future<void> _saveServerConfigs(Map<String, dynamic> serverConfigs) async {
    try {
      // 保存文章管理配置
      if (serverConfigs['articleManagement'] != null) {
        final config = ArticleManagementConfig.fromJson(
          serverConfigs['articleManagement'] as Map<String, dynamic>,
        );
        // 标记为已同步
        final syncedConfig = config.copyWith(syncedWithServer: true);
        await _cacheService.saveArticleManagementConfig(syncedConfig);
      }

      // 保存支付配置
      if (serverConfigs['payment'] != null) {
        final config = PaymentConfig.fromJson(
          serverConfigs['payment'] as Map<String, dynamic>,
        );
        await _cacheService.savePaymentConfig(config);
      }

      // 保存音视频存储配置
      if (serverConfigs['mediaStorage'] != null) {
        final config = MediaStorageConfig.fromJson(
          serverConfigs['mediaStorage'] as Map<String, dynamic>,
        );
        await _cacheService.saveMediaStorageConfig(config);
      }
    } catch (e) {
      debugPrint('保存服务器配置失败: $e');
    }
  }

  /// 检查本地缓存是否存在
  Future<bool> _checkLocalCache() async {
    try {
      final articleConfig = await _cacheService.getArticleManagementConfig();
      return articleConfig.categories.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 保存默认配置到本地缓存
  Future<void> _saveDefaultConfigs() async {
    try {
      await _cacheService.saveArticleManagementConfig(
        ArticleManagementConfig.defaultConfig(),
      );
      await _cacheService.savePaymentConfig(
        PaymentConfig.defaultConfig(),
      );
      await _cacheService.saveMediaStorageConfig(
        MediaStorageConfig.defaultConfig(),
      );
    } catch (e) {
      debugPrint('保存默认配置失败: $e');
    }
  }

  /// 同步本地配置到服务器
  /// 在用户主动点击"提交"按钮时调用
  Future<bool> syncToServer() async {
    try {
      debugPrint('开始同步配置到服务器...');

      // 1. 从本地缓存读取所有配置
      final articleConfig = await _cacheService.getArticleManagementConfig();
      final paymentConfig = await _cacheService.getPaymentConfig();
      final mediaConfig = await _cacheService.getMediaStorageConfig();

      // 2. 批量上传到服务器
      final success = await _apiService.uploadAllWorkbenchConfigs(
        articleConfig: articleConfig,
        paymentConfig: paymentConfig,
        mediaConfig: mediaConfig,
      );

      if (success) {
        debugPrint('同步到服务器成功');

        // 3. 更新本地缓存，标记为已同步
        await _cacheService.saveArticleManagementConfig(
          articleConfig.copyWith(syncedWithServer: true),
        );

        return true;
      } else {
        debugPrint('同步到服务器失败');
        return false;
      }
    } catch (e) {
      debugPrint('同步配置失败: $e');
      return false;
    }
  }

  /// 仅同步单个模块的配置
  Future<bool> syncModuleToServer(String moduleName) async {
    try {
      debugPrint('同步模块到服务器: $moduleName');

      switch (moduleName) {
        case 'article_management':
          final config = await _cacheService.getArticleManagementConfig();
          final success = await _apiService.uploadArticleManagementConfig(config);
          return success;

        case 'payment':
          final config = await _cacheService.getPaymentConfig();
          final success = await _apiService.uploadPaymentConfig(config);
          return success;

        case 'media_storage':
          final config = await _cacheService.getMediaStorageConfig();
          final success = await _apiService.uploadMediaStorageConfig(config);
          return success;

        default:
          debugPrint('未知的模块名称: $moduleName');
          return false;
      }
    } catch (e) {
      debugPrint('同步模块失败: $e');
      return false;
    }
  }

  /// 清除所有本地数据并重新初始化
  Future<bool> clearAndReinitialize() async {
    try {
      debugPrint('清除所有缓存并重新初始化...');

      // 1. 清除本地缓存
      await _cacheService.clearAll();

      // 2. 重新初始化
      return await initializeWorkbench();
    } catch (e) {
      debugPrint('清除并重新初始化失败: $e');
      return false;
    }
  }
}
