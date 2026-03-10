import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 工作台缓存服务
/// 负责管理工作台配置数据的本地缓存和与服务器同步
class WorkbenchCacheService {
  static const String _keyPrefix = 'workbench_';

  // 单例模式
  static final WorkbenchCacheService _instance = WorkbenchCacheService._internal();
  factory WorkbenchCacheService() => _instance;
  WorkbenchCacheService._internal();

  SharedPreferences? _prefs;

  /// 初始化缓存服务
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 确保已初始化
  Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  // ==================== 文章管理配置 ====================

  /// 获取文章管理配置
  Future<ArticleManagementConfig> getArticleManagementConfig() async {
    await _ensureInit();
    final json = _prefs!.getString('${_keyPrefix}article_management');

    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        return ArticleManagementConfig.fromJson(decoded);
      } catch (e) {
        // 如果解析失败，返回默认配置
        return ArticleManagementConfig.defaultConfig();
      }
    }

    // 返回默认配置
    return ArticleManagementConfig.defaultConfig();
  }

  /// 保存文章管理配置
  Future<void> saveArticleManagementConfig(ArticleManagementConfig config) async {
    await _ensureInit();
    final json = jsonEncode(config.toJson());
    await _prefs!.setString('${_keyPrefix}article_management', json);
  }

  // ==================== 支付配置 ====================

  /// 获取支付配置
  Future<PaymentConfig> getPaymentConfig() async {
    await _ensureInit();
    final json = _prefs!.getString('${_keyPrefix}payment_config');

    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        return PaymentConfig.fromJson(decoded);
      } catch (e) {
        return PaymentConfig.defaultConfig();
      }
    }

    return PaymentConfig.defaultConfig();
  }

  /// 保存支付配置
  Future<void> savePaymentConfig(PaymentConfig config) async {
    await _ensureInit();
    final json = jsonEncode(config.toJson());
    await _prefs!.setString('${_keyPrefix}payment_config', json);
  }

  // ==================== 音视频存储配置 ====================

  /// 获取音视频存储配置
  Future<MediaStorageConfig> getMediaStorageConfig() async {
    await _ensureInit();
    final json = _prefs!.getString('${_keyPrefix}media_storage');

    if (json != null && json.isNotEmpty) {
      try {
        final decoded = jsonDecode(json);
        return MediaStorageConfig.fromJson(decoded);
      } catch (e) {
        return MediaStorageConfig.defaultConfig();
      }
    }

    return MediaStorageConfig.defaultConfig();
  }

  /// 保存音视频存储配置
  Future<void> saveMediaStorageConfig(MediaStorageConfig config) async {
    await _ensureInit();
    final json = jsonEncode(config.toJson());
    await _prefs!.setString('${_keyPrefix}media_storage', json);
  }

  // ==================== 通用方法 ====================

  /// 清除所有工作台缓存
  Future<void> clearAll() async {
    await _ensureInit();
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (var key in keys) {
      await _prefs!.remove(key);
    }
  }

  /// 清除特定模块的缓存
  Future<void> clearModule(String module) async {
    await _ensureInit();
    await _prefs!.remove('$_keyPrefix$module');
  }
}

// ==================== 数据模型定义 ====================

/// 文章分类模型
class ArticleCategory {
  final String id;
  String name;
  int sortOrder;

  ArticleCategory({
    required this.id,
    required this.name,
    this.sortOrder = 0,
  });

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrder': sortOrder,
    };
  }

  ArticleCategory copyWith({
    String? id,
    String? name,
    int? sortOrder,
  }) {
    return ArticleCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 文章管理配置
class ArticleManagementConfig {
  // 分类列表
  List<ArticleCategory> categories;

  // 是否启用打赏
  bool rewardEnabled;

  // 文章列表展示样式
  // 可选值: '上图下文', '一左一右', '左图右文', '左文右图', '高级版 (信息流)'
  String listStyle;

  // 最后更新时间
  DateTime? lastUpdateTime;

  // 是否已同步到服务器
  bool syncedWithServer;

  ArticleManagementConfig({
    required this.categories,
    this.rewardEnabled = true,
    this.listStyle = '上图下文',
    this.lastUpdateTime,
    this.syncedWithServer = false,
  });

  /// 默认配置
  factory ArticleManagementConfig.defaultConfig() {
    return ArticleManagementConfig(
      categories: [
        ArticleCategory(id: '1', name: '部门简介', sortOrder: 0),
        ArticleCategory(id: '2', name: '培训师资', sortOrder: 1),
        ArticleCategory(id: '3', name: '抖音视频', sortOrder: 2),
        ArticleCategory(id: '4', name: '最新资讯', sortOrder: 3),
        ArticleCategory(id: '5', name: '老师介绍', sortOrder: 4),
      ],
      rewardEnabled: true,
      listStyle: '上图下文',
      syncedWithServer: false,
    );
  }

  factory ArticleManagementConfig.fromJson(Map<String, dynamic> json) {
    final categoriesList = json['categories'] as List?;
    return ArticleManagementConfig(
      categories: categoriesList?.map((item) => ArticleCategory.fromJson(item)).toList() ?? [],
      rewardEnabled: json['rewardEnabled'] as bool? ?? true,
      listStyle: json['listStyle'] as String? ?? '上图下文',
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'] as String)
          : null,
      syncedWithServer: json['syncedWithServer'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((cat) => cat.toJson()).toList(),
      'rewardEnabled': rewardEnabled,
      'listStyle': listStyle,
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
      'syncedWithServer': syncedWithServer,
    };
  }

  ArticleManagementConfig copyWith({
    List<ArticleCategory>? categories,
    bool? rewardEnabled,
    String? listStyle,
    DateTime? lastUpdateTime,
    bool? syncedWithServer,
  }) {
    return ArticleManagementConfig(
      categories: categories ?? this.categories,
      rewardEnabled: rewardEnabled ?? this.rewardEnabled,
      listStyle: listStyle ?? this.listStyle,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      syncedWithServer: syncedWithServer ?? this.syncedWithServer,
    );
  }
}

/// 支付配置（示例）
class PaymentConfig {
  // 微信支付商户号
  String? merchantId;

  // 特约商户进件配置
  Map<String, dynamic>? merchantApplication;

  // 最后更新时间
  DateTime? lastUpdateTime;

  PaymentConfig({
    this.merchantId,
    this.merchantApplication,
    this.lastUpdateTime,
  });

  factory PaymentConfig.defaultConfig() {
    return PaymentConfig();
  }

  factory PaymentConfig.fromJson(Map<String, dynamic> json) {
    return PaymentConfig(
      merchantId: json['merchantId'] as String?,
      merchantApplication: json['merchantApplication'] as Map<String, dynamic>?,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantApplication': merchantApplication,
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
    };
  }
}

/// 音视频存储配置
class MediaStorageConfig {
  // 云服务提供商: 'qiniu', 'tencent'
  String provider;

  // 七牛云配置
  QiniuConfig? qiniuConfig;

  // 腾讯云配置
  Map<String, dynamic>? tencentConfig;

  // 最后更新时间
  DateTime? lastUpdateTime;

  MediaStorageConfig({
    this.provider = 'qiniu',
    this.qiniuConfig,
    this.tencentConfig,
    this.lastUpdateTime,
  });

  factory MediaStorageConfig.defaultConfig() {
    return MediaStorageConfig(
      provider: 'qiniu',
      qiniuConfig: QiniuConfig.defaultConfig(),
    );
  }

  factory MediaStorageConfig.fromJson(Map<String, dynamic> json) {
    return MediaStorageConfig(
      provider: json['provider'] as String? ?? 'qiniu',
      qiniuConfig: json['qiniuConfig'] != null
          ? QiniuConfig.fromJson(json['qiniuConfig'] as Map<String, dynamic>)
          : null,
      tencentConfig: json['tencentConfig'] as Map<String, dynamic>?,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'qiniuConfig': qiniuConfig?.toJson(),
      'tencentConfig': tencentConfig,
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
    };
  }
}

/// 七牛云配置
class QiniuConfig {
  String accessKey;
  String secretKey;
  String bucketName;
  String region;
  String domain;
  bool updateDomain;
  String? cdnDomain;

  QiniuConfig({
    required this.accessKey,
    required this.secretKey,
    required this.bucketName,
    required this.region,
    required this.domain,
    this.updateDomain = false,
    this.cdnDomain,
  });

  factory QiniuConfig.defaultConfig() {
    return QiniuConfig(
      accessKey: '',
      secretKey: '',
      bucketName: '',
      region: '华东',
      domain: '',
      updateDomain: false,
    );
  }

  factory QiniuConfig.fromJson(Map<String, dynamic> json) {
    return QiniuConfig(
      accessKey: json['accessKey'] as String? ?? '',
      secretKey: json['secretKey'] as String? ?? '',
      bucketName: json['bucketName'] as String? ?? '',
      region: json['region'] as String? ?? '华东',
      domain: json['domain'] as String? ?? '',
      updateDomain: json['updateDomain'] as bool? ?? false,
      cdnDomain: json['cdnDomain'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessKey': accessKey,
      'secretKey': secretKey,
      'bucketName': bucketName,
      'region': region,
      'domain': domain,
      'updateDomain': updateDomain,
      'cdnDomain': cdnDomain,
    };
  }
}
