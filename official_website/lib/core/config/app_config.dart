import 'package:flutter/material.dart';

/// 应用配置类
/// 集中管理应用的全局配置
class AppConfig {
  /// 应用名称
  static const String appName = 'Official Website';

  /// 应用版本
  static const String appVersion = '1.0.0';

  /// 环境配置
  static const Environment environment = Environment.development;

  /// 是否启用调试模式
  static bool get isDebug => environment != Environment.production;

  /// API基础URL
  static String get apiBaseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:3000/api';
      case Environment.staging:
        return 'https://staging-api.example.com/api';
      case Environment.production:
        return 'https://api.example.com/api';
    }
  }

  /// WebSocket URL
  static String get wsUrl {
    switch (environment) {
      case Environment.development:
        return 'ws://localhost:3000';
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
