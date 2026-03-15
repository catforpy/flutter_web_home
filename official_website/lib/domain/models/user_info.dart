import 'login_response_v2.dart';

/// 用户信息模型
/// 对应后端 UserDTO 和 LoginResponseDTO
class UserInfo {
  /// 用户ID
  final int userId;

  /// 用户名
  final String username;

  /// 真实姓名
  final String? realName;

  /// 用户类型
  /// normal - 普通用户（客户）
  /// merchant - 商家
  /// service_provider - 服务商
  /// platform_admin - 平台管理员
  /// backend_admin - 后台管理员
  final String userType;

  /// 头像URL
  final String? avatar;

  /// 手机号
  final String? phone;

  /// 邮箱
  final String? email;

  /// 账号状态
  /// active - 正常
  /// frozen - 冻结
  /// deleted - 已删除
  final String? status;

  /// 最后登录时间
  final DateTime? lastLoginTime;

  /// 创建时间
  final DateTime? createTime;

  /// 更新时间
  final DateTime? updateTime;

  UserInfo({
    required this.userId,
    required this.username,
    this.realName,
    required this.userType,
    this.avatar,
    this.phone,
    this.email,
    this.status,
    this.lastLoginTime,
    this.createTime,
    this.updateTime,
  });

  /// 从LoginResponse创建（兼容V1和V2）
  factory UserInfo.fromLoginResponse(dynamic loginResponse) {
    // V2: 如果传入的是LoginDataV2对象
    if (loginResponse is LoginDataV2) {
      return UserInfo(
        userId: loginResponse.userId ?? 0,
        username: loginResponse.username ?? '',
        realName: loginResponse.realName,
        userType: loginResponse.userType ?? 'normal',
        avatar: loginResponse.avatar,
        phone: loginResponse.phone,
        email: loginResponse.email,
        status: loginResponse.status,
        lastLoginTime: loginResponse.loginTime,
      );
    }

    // V2: 如果传入的是Map
    if (loginResponse is Map<String, dynamic>) {
      return UserInfo.fromJson(loginResponse);
    }

    // 兜底返回空对象
    return UserInfo(
      userId: 0,
      username: '',
      userType: 'normal',
    );
  }

  /// 从JSON创建
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] as int? ?? json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      realName: json['realName'] as String?,
      userType: json['userType'] as String? ?? 'normal',
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'])
          : null,
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'])
          : null,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'realName': realName,
      'userType': userType,
      'avatar': avatar,
      'phone': phone,
      'email': email,
      'status': status,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'createTime': createTime?.toIso8601String(),
      'updateTime': updateTime?.toIso8601String(),
    };
  }

  /// 获取显示名称（优先使用真实姓名，否则用户名）
  String get displayName {
    return realName?.isNotEmpty == true ? realName! : username;
  }

  /// 是否为普通用户
  bool get isNormalUser => userType == 'normal';

  /// 是否为商家
  bool get isMerchant => userType == 'merchant';

  /// 是否为服务商
  bool get isServiceProvider => userType == 'service_provider';

  /// 是否为平台管理员
  bool get isPlatformAdmin => userType == 'platform_admin';

  /// 是否为后台管理员
  bool get isBackendAdmin => userType == 'backend_admin';

  /// 获取用户类型中文名称
  String get getUserTypeName {
    switch (userType) {
      case 'normal':
        return '普通用户';
      case 'merchant':
        return '商家';
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

  /// 是否处于正常状态
  bool get isActive => status == 'active' || status == null;

  /// 是否被冻结
  bool get isFrozen => status == 'frozen';

  /// 是否已删除
  bool get isDeleted => status == 'deleted';
}
