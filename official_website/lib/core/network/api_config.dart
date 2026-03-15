/// API 配置类
/// 集中管理所有 API 相关的配置信息
class ApiConfig {
  // ==================== 后端API路径常量 ====================
  // 对接后端 DudaNexus 项目
  // 基础路径由 AppConfig.apiBaseUrl 提供

  /// ==================== 认证相关 (AuthController) ====================
  /// 注意：这些路径不包含 /api 前缀，因为 AppConfig.apiBaseUrl 已经包含了

  /// 用户注册
  /// POST /api/auth/register
  static const String authRegister = '/auth/register';

  /// 用户登录
  /// POST /api/auth/login
  static const String authLogin = '/auth/login';

  /// 用户登出
  /// POST /api/auth/logout
  static const String authLogout = '/auth/logout';

  /// 刷新Token
  /// POST /api/auth/refresh
  static const String authRefresh = '/auth/refresh';

  /// 验证Token
  /// GET /api/auth/validate
  static const String authValidate = '/auth/validate';

  /// 获取当前用户信息
  /// GET /api/auth/user/info
  static const String authUserInfo = '/auth/user/info';

  /// 发送短信验证码
  /// POST /api/auth/sms/send
  static const String authSendSms = '/auth/sms/send';

  /// ==================== 认证V2 (AuthV2Controller) ====================

  /// 都达网账户 - 账号密码注册
  /// POST /api/auth/v2/platform-account/register/password
  static const String v2PlatformAccountRegisterPassword = '/auth/v2/platform-account/register/password';

  /// 都达网账户 - 账号密码登录
  /// POST /api/auth/v2/platform-account/login/password
  static const String v2PlatformAccountLoginPassword = '/auth/v2/platform-account/login/password';

  /// 都达网账户 - 手机验证码登录
  /// POST /api/auth/v2/platform-account/login/sms
  static const String v2PlatformAccountLoginSms = '/auth/v2/platform-account/login/sms';

  /// 服务商 - 账号密码注册
  /// POST /api/auth/v2/service-provider/register/password
  static const String v2ServiceProviderRegisterPassword = '/auth/v2/service-provider/register/password';

  /// 服务商 - 账号密码登录
  /// POST /api/auth/v2/service-provider/login/password
  static const String v2ServiceProviderLoginPassword = '/auth/v2/service-provider/login/password';

  /// 服务商 - 手机验证码登录
  /// POST /api/auth/v2/service-provider/login/sms
  static const String v2ServiceProviderLoginSms = '/auth/v2/service-provider/login/sms';

  /// 平台管理员 - 账号密码注册
  /// POST /api/auth/v2/platform-admin/register/password
  static const String v2PlatformAdminRegisterPassword = '/auth/v2/platform-admin/register/password';

  /// 平台管理员 - 账号密码登录
  /// POST /api/auth/v2/platform-admin/login/password
  static const String v2PlatformAdminLoginPassword = '/auth/v2/platform-admin/login/password';

  /// 后台管理员 - 账号密码注册
  /// POST /api/auth/v2/backend-admin/register/password
  static const String v2BackendAdminRegisterPassword = '/auth/v2/backend-admin/register/password';

  /// 后台管理员 - 账号密码登录
  /// POST /api/auth/v2/backend-admin/login/password
  static const String v2BackendAdminLoginPassword = '/auth/v2/backend-admin/login/password';

  /// ==================== 用户相关 (UserController) ====================

  /// 根据ID查询用户
  /// GET /user/{userId}
  static const String userById = '/user/';

  /// 根据用户名查询用户
  /// GET /user/username/{username}
  static const String userByUsername = '/user/username/';

  /// 更新用户信息
  /// PUT /user/update
  static const String userUpdate = '/user/update';

  /// 删除用户
  /// DELETE /user/{userId}
  static const String userDelete = '/user/';

  /// 分页查询用户
  /// GET /user/page
  static const String userPage = '/user/page';

  /// ==================== 其他API（未对接后端，保留假数据） ====================

  /// 用户个人信息（假数据）
  static const String userProfile = '/user/profile';

  /// 更新个人信息（假数据）
  static const String userUpdateProfile = '/user/profile/update';

  /// 文章列表（假数据）
  static const String articleList = '/articles';

  /// 文章详情（假数据）
  static const String articleDetail = '/articles';

  /// 文章分类（假数据）
  static const String articleCategories = '/articles/categories';

  /// 账户设置（假数据）
  static const String accountSettings = '/account/settings';

  /// 修改密码（假数据）
  static const String changePassword = '/account/change-password';

  /// 上传头像（假数据）
  static const String uploadAvatar = '/account/upload-avatar';

  /// 绑定手机（假数据）
  static const String bindPhone = '/account/bind-phone';

  /// 绑定邮箱（假数据）
  static const String bindEmail = '/account/bind-email';

  /// 删除账户（假数据）
  static const String deleteAccount = '/account/delete';

  /// 工作台相关（假数据）
  static const String workbenchArticleConfig = '/workbench/article-management/config';
  static const String workbenchPaymentConfig = '/workbench/payment/config';
  static const String workbenchMediaConfig = '/workbench/media-storage/config';
}
