/// 后端用户类型枚举
/// 对应后端 UserTypeEnum
///
/// 后端路径：com.duda.user.enums.UserTypeEnum
enum BackendUserType {
  /// 都达网账户（普通用户）
  /// code: platform_account
  platformAccount('platform_account', '都达网账户'),

  /// 服务商
  /// code: service_provider
  serviceProvider('service_provider', '服务商'),

  /// 平台管理员
  /// code: platform_admin
  platformAdmin('platform_admin', '平台管理员'),

  /// 后台管理员
  /// code: backend_admin
  backendAdmin('backend_admin', '后台管理员');

  /// 代码值
  final String code;

  /// 描述
  final String desc;

  const BackendUserType(this.code, this.desc);

  /// 从code获取枚举
  static BackendUserType? fromCode(String code) {
    for (final type in BackendUserType.values) {
      if (type.code == code) {
        return type;
      }
    }
    return null;
  }

  /// 转换为前端使用的用户类型
  String toFrontendType() {
    switch (this) {
      case BackendUserType.platformAccount:
        return 'normal';
      case BackendUserType.serviceProvider:
        return 'merchant';
      case BackendUserType.platformAdmin:
        return 'platform_admin';
      case BackendUserType.backendAdmin:
        return 'backend_admin';
    }
  }
}

/// 后端登录方式枚举
enum BackendLoginType {
  /// 账号密码登录
  password,

  /// 手机验证码登录
  sms,

  /// 邮箱密码登录
  email,

  /// 第三方登录
  thirdParty;
}

/// 后端API配置常量
class BackendApiConfig {
  /// ==================== V2接口基础路径 ====================

  /// V2接口基础路径（不包含 /api，因为 AppConfig.apiBaseUrl 已包含）
  static const String v2BasePath = '/auth/v2';

  /// ==================== 都达网账户接口 ====================

  /// 都达网账户 - 账号密码注册
  static const String platformAccountRegisterPassword =
      '/auth/v2/platform-account/register/password';

  /// 都达网账户 - 账号密码登录
  static const String platformAccountLoginPassword =
      '/auth/v2/platform-account/login/password';

  /// 都达网账户 - 手机验证码登录
  static const String platformAccountLoginSms =
      '/auth/v2/platform-account/login/sms';

  /// ==================== 服务商接口 ====================

  /// 服务商 - 账号密码注册
  static const String serviceProviderRegisterPassword =
      '/auth/v2/service-provider/register/password';

  /// 服务商 - 账号密码登录
  static const String serviceProviderLoginPassword =
      '/auth/v2/service-provider/login/password';

  /// 服务商 - 手机验证码登录
  static const String serviceProviderLoginSms =
      '/auth/v2/service-provider/login/sms';

  /// ==================== 平台管理员接口 ====================

  /// 平台管理员 - 账号密码注册
  static const String platformAdminRegisterPassword =
      '/auth/v2/platform-admin/register/password';

  /// 平台管理员 - 账号密码登录
  static const String platformAdminLoginPassword =
      '/auth/v2/platform-admin/login/password';

  /// ==================== 后台管理员接口 ====================

  /// 后台管理员 - 账号密码注册
  static const String backendAdminRegisterPassword =
      '/auth/v2/backend-admin/register/password';

  /// 后台管理员 - 账号密码登录
  static const String backendAdminLoginPassword =
      '/auth/v2/backend-admin/login/password';

  /// ==================== 通用接口（不区分身份） ====================

  /// 用户登出
  static const String logout = '/auth/v2/logout';

  /// 刷新Token
  static const String refresh = '/auth/v2/refresh';

  /// 验证Token
  static const String validate = '/auth/v2/validate';

  /// 获取当前用户信息
  static const String userInfo = '/auth/v2/user/info';

  /// 发送短信验证码
  static const String sendSms = '/auth/v2/sms/send';
}
