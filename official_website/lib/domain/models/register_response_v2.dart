/// 注册响应 V2
///
/// 后端注册接口响应结构（不包含token）
/// 注册成功后需要用户重新登录获取token
class RegisterResponseV2 {
  /// 业务状态码
  final int? code;

  /// 响应消息
  final String? message;

  /// 注册数据
  final RegisterDataV2? data;

  /// 时间戳
  final int? timestamp;

  /// 是否成功
  final bool? isSuccess;

  RegisterResponseV2({
    this.code,
    this.message,
    this.data,
    this.timestamp,
    this.isSuccess,
  });

  factory RegisterResponseV2.fromJson(Map<String, dynamic> json) {
    return RegisterResponseV2(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? RegisterDataV2.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as int?,
      isSuccess: json['success'] as bool? ?? json['code'] == 200,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
      'timestamp': timestamp,
      'success': isSuccess,
    };
  }
}

/// 注册数据 V2
///
/// 注册成功后返回的用户信息（不包含token）
class RegisterDataV2 {
  /// 用户ID
  final int? userId;

  /// 用户名
  final String? username;

  /// 用户类型
  final String? userType;

  /// 用户类型名称
  final String? userTypeName;

  /// 账号状态
  final String? status;

  /// 状态描述
  final String? statusDesc;

  /// 创建时间
  final String? createTime;

  /// 是否需要登录（提示用户）
  final bool? needLogin;

  /// 欢迎消息
  final String? welcomeMessage;

  RegisterDataV2({
    this.userId,
    this.username,
    this.userType,
    this.userTypeName,
    this.status,
    this.statusDesc,
    this.createTime,
    this.needLogin,
    this.welcomeMessage,
  });

  factory RegisterDataV2.fromJson(Map<String, dynamic> json) {
    return RegisterDataV2(
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      userType: json['userType'] as String?,
      userTypeName: json['userTypeName'] as String?,
      status: json['status'] as String?,
      statusDesc: json['statusDesc'] as String?,
      createTime: json['createTime'] as String?,
      needLogin: json['needLogin'] as bool?,
      welcomeMessage: json['welcomeMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'userType': userType,
      'userTypeName': userTypeName,
      'status': status,
      'statusDesc': statusDesc,
      'createTime': createTime,
      'needLogin': needLogin,
      'welcomeMessage': welcomeMessage,
    };
  }

  @override
  String toString() {
    return 'RegisterDataV2(userId: $userId, username: $username, userType: $userType)';
  }
}
