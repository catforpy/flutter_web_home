/// 注册请求模型
/// 对应后端 RegisterRequestDTO
class RegisterRequest {
  /// 用户类型
  /// normal - 普通用户（客户）
  /// merchant - 商家
  /// service_provider - 服务商
  /// platform_admin - 平台管理员
  /// backend_admin - 后台管理员
  final String userType;

  /// 注册方式
  /// account - 都达网账号（用户名密码）
  /// phone_sms - 手机验证码
  /// email - 邮箱
  final String registerType;

  /// 用户名（都达网账号注册时必填）
  final String? username;

  /// 密码
  final String? password;

  /// 确认密码
  final String? confirmPassword;

  /// 真实姓名
  final String? realName;

  /// 手机号
  final String? phone;

  /// 手机验证码
  final String? phoneVerifyCode;

  /// 邮箱
  final String? email;

  /// 邮箱验证码
  final String? emailVerifyCode;

  /// 第三方平台ID（微信、QQ等）
  final String? thirdPartyId;

  /// 第三方平台类型
  final String? thirdPartyType;

  /// 客户端IP
  final String? clientIp;

  RegisterRequest({
    required this.userType,
    required this.registerType,
    this.username,
    this.password,
    this.confirmPassword,
    this.realName,
    this.phone,
    this.phoneVerifyCode,
    this.email,
    this.emailVerifyCode,
    this.thirdPartyId,
    this.thirdPartyType,
    this.clientIp,
  });

  /// 创建账号密码注册请求
  factory RegisterRequest.forAccountPassword({
    required String userType,
    required String username,
    required String password,
    required String confirmPassword,
    String? realName,
    String? phone,
    String? clientIp,
  }) {
    return RegisterRequest(
      userType: userType,
      registerType: 'account',
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      realName: realName,
      phone: phone,
      clientIp: clientIp,
    );
  }

  /// 创建手机验证码注册请求
  factory RegisterRequest.forPhoneSms({
    required String userType,
    required String phone,
    required String phoneVerifyCode,
    String? realName,
    String? clientIp,
  }) {
    return RegisterRequest(
      userType: userType,
      registerType: 'phone_sms',
      phone: phone,
      phoneVerifyCode: phoneVerifyCode,
      realName: realName,
      clientIp: clientIp,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userType': userType,
      'registerType': registerType,
    };

    if (username != null) map['username'] = username;
    if (password != null) map['password'] = password;
    if (confirmPassword != null) map['confirmPassword'] = confirmPassword;
    if (realName != null) map['realName'] = realName;
    if (phone != null) map['phone'] = phone;
    if (phoneVerifyCode != null) map['phoneVerifyCode'] = phoneVerifyCode;
    if (email != null) map['email'] = email;
    if (emailVerifyCode != null) map['emailVerifyCode'] = emailVerifyCode;
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

    // 验证注册方式
    if (!['account', 'phone_sms', 'email'].contains(registerType)) {
      return '无效的注册方式';
    }

    // 根据注册方式验证必填字段
    switch (registerType) {
      case 'account':
        if (username == null || username!.isEmpty) {
          return '用户名不能为空';
        }
        if (password == null || password!.isEmpty) {
          return '密码不能为空';
        }
        if (confirmPassword == null || confirmPassword!.isEmpty) {
          return '确认密码不能为空';
        }
        if (password != confirmPassword) {
          return '两次输入的密码不一致';
        }
        if (password!.length < 6) {
          return '密码长度不能少于6位';
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

      case 'email':
        if (email == null || email!.isEmpty) {
          return '邮箱不能为空';
        }
        if (emailVerifyCode == null || emailVerifyCode!.isEmpty) {
          return '验证码不能为空';
        }
        break;
    }

    return null;
  }
}
