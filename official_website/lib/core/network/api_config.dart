/// API 配置类
/// 集中管理所有 API 相关的配置信息
class ApiConfig {
  /// API 基础地址
  ///
  /// 开发环境使用 localhost
  /// 生产环境需要修改为实际的 API 服务器地址
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api', // 修改为你的实际API地址
  );

  /// 连接超时时间（秒）
  static const int connectTimeout = 30;

  /// 接收超时时间（秒）
  static const int receiveTimeout = 30;

  /// 是否启用请求日志
  static const bool enableLog = true;

  /// 是否启用HTTPS证书验证（生产环境建议开启）
  static const bool validateCertificate = false;

  // ==================== API 路径常量 ====================

  /// 认证相关
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefresh = '/auth/refresh';

  /// 用户相关
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/profile/update';

  /// 文章相关
  static const String articleList = '/articles';
  static const String articleDetail = '/articles';
  static const String articleCategories = '/articles/categories';

  /// 账户设置相关
  static const String accountSettings = '/account/settings';
  static const String changePassword = '/account/change-password';
  static const String uploadAvatar = '/account/upload-avatar';
  static const String bindPhone = '/account/bind-phone';
  static const String bindEmail = '/account/bind-email';
  static const String deleteAccount = '/account/delete';

  /// 工作台相关
  static const String workbenchArticleConfig = '/workbench/article-management/config';
  static const String workbenchPaymentConfig = '/workbench/payment/config';
  static const String workbenchMediaConfig = '/workbench/media-storage/config';
}
