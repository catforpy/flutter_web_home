/// 登录请求模型
/// 对应后端 LoginRequestDTO
class LoginRequest {
  /// 登录方式
  /// account_password - 都达网账号密码登录
  /// phone_sms - 手机验证码登录
  /// email_password - 邮箱密码登录
  /// third_party - 第三方登录
  final String loginType;

  /// 用户类型
  /// normal - 普通用户（客户）
  /// merchant - 商家
  /// service_provider - 服务商
  /// platform_admin - 平台管理员
  /// backend_admin - 后台管理员
  final String userType;

  /// 用户名（都达网账号登录时使用）
  final String? username;

  /// 密码
  final String? password;

  /// 手机号
  final String? phone;

  /// 手机验证码
  final String? phoneVerifyCode;

  /// 邮箱
  final String? email;

  /// 邮箱密码
  final String? emailPassword;

  /// 第三方平台ID
  final String? thirdPartyId;

  /// 第三方平台类型（wechat、qq等）
  final String? thirdPartyType;

  /// 客户端IP
  final String? clientIp;

  LoginRequest({
    required this.loginType,
    required this.userType,
    this.username,
    this.password,
    this.phone,
    this.phoneVerifyCode,
    this.email,
    this.emailPassword,
    this.thirdPartyId,
    this.thirdPartyType,
    this.clientIp,
  });

  /// 创建账号密码登录请求
  factory LoginRequest.forAccountPassword({
    required String userType,
    required String username,
    required String password,
    String? clientIp,
  }) {
    return LoginRequest(
      loginType: 'account_password',
      userType: userType,
      username: username,
      password: password,
      clientIp: clientIp,
    );
  }

  /// 创建手机验证码登录请求
  factory LoginRequest.forPhoneSms({
    required String userType,
    required String phone,
    required String phoneVerifyCode,
    String? clientIp,
  }) {
    return LoginRequest(
      loginType: 'phone_sms',
      userType: userType,
      phone: phone,
      phoneVerifyCode: phoneVerifyCode,
      clientIp: clientIp,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'loginType': loginType,
      'userType': userType,
    };

    if (username != null) map['username'] = username;
    if (password != null) map['password'] = password;
    if (phone != null) map['phone'] = phone;
    if (phoneVerifyCode != null) map['phoneVerifyCode'] = phoneVerifyCode;
    if (email != null) map['email'] = email;
    if (emailPassword != null) map['emailPassword'] = emailPassword;
    if (thirdPartyId != null) map['thirdPartyId'] = thirdPartyId;
    if (thirdPartyType != null) map['thirdPartyType'] = thirdPartyType;
    if (clientIp != null) map['clientIp'] = clientIp;

    return map;
  }

  /// 验证请求参数
  String? validate() {
    // 验证用户类型
    if (!['normal', 'merchant', 'service_provider', 'platform_admin', 'backend_admin']
        .contains(userType)) {
      return '无效的用户类型';
    }

    // 验证登录方式
    if (!['account_password', 'phone_sms', 'email_password', 'third_party']
        .contains(loginType)) {
      return '无效的登录方式';
    }

    // 根据登录方式验证必填字段
    switch (loginType) {
      case 'account_password':
        if (username == null || username!.isEmpty) {
          return '用户名不能为空';
        }
        if (password == null || password!.isEmpty) {
          return '密码不能为空';
        }
        break;

      case 'phone_sms':
        if (phone == null || phone!.isEmpty) {
          return '手机号不能为空';
        }
        if (phoneVerifyCode == null || phoneVerifyCode!.isEmpty) {
          return '验证码不能为空';
        }
        break;

      case 'email_password':
        if (email == null || email!.isEmpty) {
          return '邮箱不能为空';
        }
        if (emailPassword == null || emailPassword!.isEmpty) {
          return '密码不能为空';
        }
        break;

      case 'third_party':
        if (thirdPartyId == null || thirdPartyId!.isEmpty) {
          return '第三方平台ID不能为空';
        }
        if (thirdPartyType == null || thirdPartyType!.isEmpty) {
          return '第三方平台类型不能为空';
        }
        break;
    }

    return null;
  }
}
