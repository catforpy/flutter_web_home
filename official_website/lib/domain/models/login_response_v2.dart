/// 登录响应模型（V2）
/// 对应后端 LoginResponseDTO
///
/// 后端实际返回的数据结构
class LoginResponseV2 {
  /// 状态码
  final int? code;

  /// 消息
  final String? message;

  /// 数据
  final LoginDataV2? data;

  /// 时间戳
  final int? timestamp;

  /// 是否成功
  final bool? success;

  LoginResponseV2({
    this.code,
    this.message,
    this.data,
    this.timestamp,
    this.success,
  });

  /// 从JSON创建
  factory LoginResponseV2.fromJson(Map<String, dynamic> json) {
    return LoginResponseV2(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? LoginDataV2.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as int?,
      success: json['success'] as bool?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
      'timestamp': timestamp,
      'success': success,
    };
  }

  /// 检查是否成功
  bool get isSuccess => code == 200 && success == true;
}

/// 登录数据模型（V2）
class LoginDataV2 {
  /// 访问令牌
  final String? accessToken;

  /// 刷新令牌
  final String? refreshToken;

  /// 令牌类型
  final String? tokenType;

  /// 过期时间（秒）
  final int? expiresIn;

  /// 用户ID
  final int? userId;

  /// 用户名
  final String? username;

  /// 用户类型
  /// service_provider, platform_account, platform_admin, backend_admin
  final String? userType;

  /// 用户类型名称
  final String? userTypeName;

  /// 真实姓名
  final String? realName;

  /// 头像URL
  final String? avatar;

  /// 手机号
  final String? phone;

  /// 邮箱
  final String? email;

  /// 是否首次登录
  final bool? isFirstLogin;

  /// 是否需要完善信息
  final bool? needCompleteInfo;

  /// 账号状态
  /// active, frozen, deleted等
  final String? status;

  /// 状态描述
  final String? statusDesc;

  /// 公司ID
  final String? companyId;

  /// 部门
  final String? department;

  /// 职位
  final String? position;

  /// 登录时间
  final DateTime? loginTime;

  LoginDataV2({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.userId,
    this.username,
    this.userType,
    this.userTypeName,
    this.realName,
    this.avatar,
    this.phone,
    this.email,
    this.isFirstLogin,
    this.needCompleteInfo,
    this.status,
    this.statusDesc,
    this.companyId,
    this.department,
    this.position,
    this.loginTime,
  });

  /// 从JSON创建
  factory LoginDataV2.fromJson(Map<String, dynamic> json) {
    return LoginDataV2(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String?,
      expiresIn: json['expiresIn'] as int?,
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      userType: json['userType'] as String?,
      userTypeName: json['userTypeName'] as String?,
      realName: json['realName'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isFirstLogin: json['isFirstLogin'] as bool?,
      needCompleteInfo: json['needCompleteInfo'] as bool?,
      status: json['status'] as String?,
      statusDesc: json['statusDesc'] as String?,
      companyId: json['companyId']?.toString(),
      department: json['department'] as String?,
      position: json['position'] as String?,
      loginTime: json['loginTime'] != null
          ? DateTime.parse(json['loginTime'])
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'userId': userId,
      'username': username,
      'userType': userType,
      'userTypeName': userTypeName,
      'realName': realName,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'isFirstLogin': isFirstLogin,
      'needCompleteInfo': needCompleteInfo,
      'status': status,
      'statusDesc': statusDesc,
      'companyId': companyId,
      'department': department,
      'position': position,
      'loginTime': loginTime?.toIso8601String(),
    };
  }

  /// 检查Token是否即将过期（5分钟内）
  bool get isTokenAboutToExpire {
    if (expiresIn == null) return false;
    final expireTime = DateTime.now().add(Duration(seconds: expiresIn!));
    final warningTime = DateTime.now().add(const Duration(minutes: 5));
    return expireTime.isBefore(warningTime);
  }

  /// 检查Token是否已过期
  bool get isTokenExpired {
    if (expiresIn == null) return true;
    final expireTime = DateTime.now().add(Duration(seconds: expiresIn!));
    return expireTime.isBefore(DateTime.now());
  }

  /// 获取Token过期的Unix时间戳
  int? get expireTimestamp {
    if (expiresIn == null) return null;
    return DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn!;
  }

  /// 是否为都达网账户
  bool get isPlatformAccount => userType == 'platform_account';

  /// 是否为服务商
  bool get isServiceProvider => userType == 'service_provider';

  /// 是否为平台管理员
  bool get isPlatformAdmin => userType == 'platform_admin';

  /// 是否为后台管理员
  bool get isBackendAdmin => userType == 'backend_admin';

  /// 获取用户类型中文名称
  String get getUserTypeDesc {
    switch (userType) {
      case 'platform_account':
        return '都达网账户';
      case 'service_provider':
        return '服务商';
      case 'platform_admin':
        return '平台管理员';
      case 'backend_admin':
        return '后台管理员';
      default:
        return '未知用户';
    }
  }

  /// 转换为UserInfo模型
  /// 返回Map供外部使用
  Map<String, dynamic> toUserInfoMap() {
    return {
      'userId': userId ?? 0,
      'username': username ?? '',
      'realName': realName,
      'userType': userType ?? 'normal',
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'status': status,
      'lastLoginTime': loginTime?.toIso8601String(),
    };
  }
}
