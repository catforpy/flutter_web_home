/// 应用配置类
/// 集中管理应用的全局配置
/// 支持通过构建参数配置API地址
class AppConfig {
  /// 应用名称
  static const String appName = 'Official Website';

  /// 应用版本
  static const String appVersion = '1.0.0';

  /// 环境配置（可通过构建时指定）
  /// 使用方法：flutter build web --dart-define=ENV=staging
  static final Environment environment = _getEnvironmentFromEnv();

  /// 是否启用调试模式
  static bool get isDebug => environment != Environment.production;

  /// API基础URL
  /// 开发环境使用本地的后端API
  static String get apiBaseUrl => _getDefaultApiBaseUrl();

  /// WebSocket URL
  /// 开发环境使用本地的WebSocket服务
  static String get wsUrl => _getDefaultWsUrl();

  /// 获取默认的API URL
  static String _getDefaultApiBaseUrl() {
    switch (environment) {
      case Environment.development:
        // 开发环境默认使用本机的后端API
        return 'http://192.168.2.14:8083/api';
      case Environment.staging:
        return 'https://staging-api.example.com/api';
      case Environment.production:
        return 'https://api.example.com/api';
    }
  }

  /// 获取默认的WebSocket URL
  static String _getDefaultWsUrl() {
    switch (environment) {
      case Environment.development:
        return 'ws://192.168.2.14:8083';
      case Environment.staging:
        return 'wss://staging-api.example.com';
      case Environment.production:
        return 'wss://api.example.com';
    }
  }

  /// 默认语言
  static const String defaultLanguage = 'zh-CN';

  /// 支持的语言列表
  static const List<String> supportedLanguages = [
    'zh-CN',
    'en-US',
  ];

  /// 图片缓存配置
  static const int maxImageCacheWidth = 1200;
  static const int maxImageCacheHeight = 800;

  /// 分页配置
  static const int defaultPageSize = 20;

  /// 超时配置
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// 是否启用网络日志
  static bool get enableNetworkLog => environment != Environment.production;

  /// 是否启用性能日志
  static bool get enablePerformanceLog => isDebug;
}

/// 从环境变量获取环境配置
Environment _getEnvironmentFromEnv() {
  // 暂时固定使用开发环境
  // TODO: 后续可以通过其他方式（如配置文件）来切换环境
  return Environment.development;
}

/// 环境枚举
enum Environment {
  /// 开发环境
  development,

  /// 预发布环境
  staging,

  /// 生产环境
  production,
}

/// 环境扩展方法
extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  bool get isProduction => this == Environment.production;
  bool get isStaging => this == Environment.staging;
  bool get isDevelopment => this == Environment.development;
}

/// 配置说明文档
///
/// ## 构建时配置示例
///
/// ### 开发环境（使用默认配置）
/// ```bash
/// flutter build web --release
/// ```
///
/// ### 指定开发环境的API地址
/// ```bash
/// flutter build web --release \
///   --dart-define=ENV=development \
///   --dart-define=API_BASE_URL=http://192.168.2.14:8080/api
/// ```
///
/// ### 指定测试环境
/// ```bash
/// flutter build web --release \
///   --dart-define=ENV=staging \
///   --dart-define=API_BASE_URL=http://test-api.example.com/api
/// ```
///
/// ### 指定生产环境
/// ```bash
/// flutter build web --release \
///   --dart-define=ENV=production \
///   --dart-define=API_BASE_URL=https://api.example.com/api
/// ```
///
/// ## 运行时配置示例
///
/// ### 开发模式（带热重载）
/// ```bash
/// flutter run -d chrome \
///   --dart-define=ENV=development \
///   --dart-define=API_BASE_URL=http://192.168.2.14:8080/api
/// ```
///
/// ## 验证配置
///
/// 在浏览器控制台中查看：
/// ```javascript
/// console.log('API URL:', window.location.origin);
/// ```
///
/// 或在应用启动时打印：
/// ```dart
/// print('Environment: ${AppConfig.environment}');
/// print('API URL: ${AppConfig.apiBaseUrl}');
/// print('WS URL: ${AppConfig.wsUrl}');
/// ```
