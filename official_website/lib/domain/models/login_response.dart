/// 登录响应模型
/// 对应后端 LoginResponseDTO
class LoginResponse {
  /// 用户ID
  final long userId;

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

  /// 访问令牌
  final String accessToken;

  /// 刷新令牌
  final String refreshToken;

  /// 令牌类型（通常是 "Bearer"）
  final String tokenType;

  /// 过期时间（秒）
  final int expiresIn;

  /// 最后登录时间
  final DateTime? lastLoginTime;

  LoginResponse({
    required this.userId,
    required this.username,
    this.realName,
    required this.userType,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.lastLoginTime,
  });

  /// 从JSON创建
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as int,
      username: json['username'] as String,
      realName: json['realName'] as String?,
      userType: json['userType'] as String? ?? json['userType'] as String? ?? 'normal',
      accessToken: json['accessToken'] as String? ?? json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: json['expiresIn'] as int? ?? 7200,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'])
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
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
    };
  }

  /// 获取过期的Unix时间戳
  int get ExpireTimestamp {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn;
  }

  /// 检查是否即将过期（在5分钟内）
  bool get isAboutToExpire {
    final expireTime = DateTime.now().add(Duration(seconds: expiresIn));
    final warningTime = DateTime.now().add(const Duration(minutes: 5));
    return expireTime.isBefore(warningTime);
  }

  /// 检查是否已过期
  bool get isExpired {
    final expireTime = DateTime.now().add(Duration(seconds: expiresIn));
    return expireTime.isBefore(DateTime.now());
  }
}

// 修复Dart中没有long类型的问题
typedef long = int;
