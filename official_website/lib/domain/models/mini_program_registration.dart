/// 小程序注册信息模型
/// 用于收集商户注册小程序所需的所有信息
class MiniProgramRegistration {
  // ========== 企业主体信息 ==========
  /// 企业名称（需与工商部门登记一致）
  final String enterpriseName;

  /// 统一社会信用代码（18位）
  final String enterpriseCode;

  /// 企业主体类型：1-企业, 2-政府, 3-媒体, 4-其他组织, 5-个人
  final int enterpriseType;

  /// 法人姓名（需与微信支付银行卡一致）
  final String legalPersonName;

  /// 法人微信号（在"微信-我"中获取，不是手机号）
  final String legalPersonWechat;

  /// 第三方客服电话（建议填写）
  final String? servicePhone;

  // ========== 小程序基本信息 ==========
  /// 小程序名称（临时名称，2-30个字，认证时可修改）
  final String miniProgramName;

  /// 小程序简介（4-120个字）
  final String miniProgramIntro;

  /// 功能介绍（4-120个字，一句话描述核心功能）
  final String miniProgramSignature;

  /// 服务类目列表（1-5个）
  final List<ServiceCategory> categories;

  /// 小程序头像URL（可选，后续可修改）
  final String? miniProgramLogo;

  // ========== 注册状态 ==========
  /// 注册状态
  final RegistrationStatus status;

  /// 小程序APPID（注册成功后返回）
  final String? appId;

  /// 原始ID（注册成功后返回）
  final String? originalId;

  /// 错误信息（如果注册失败）
  final String? errorMessage;

  // ========== 时间戳 ==========
  /// 创建时间
  final DateTime createdAt;

  /// 法人授权时间
  final DateTime? authorizedAt;

  /// 完成时间
  final DateTime? completedAt;

  const MiniProgramRegistration({
    required this.enterpriseName,
    required this.enterpriseCode,
    required this.enterpriseType,
    required this.legalPersonName,
    required this.legalPersonWechat,
    this.servicePhone,
    required this.miniProgramName,
    required this.miniProgramIntro,
    required this.miniProgramSignature,
    required this.categories,
    this.miniProgramLogo,
    required this.status,
    this.appId,
    this.originalId,
    this.errorMessage,
    required this.createdAt,
    this.authorizedAt,
    this.completedAt,
  });

  /// 复制并修改部分字段
  MiniProgramRegistration copyWith({
    String? enterpriseName,
    String? enterpriseCode,
    int? enterpriseType,
    String? legalPersonName,
    String? legalPersonWechat,
    String? servicePhone,
    String? miniProgramName,
    String? miniProgramIntro,
    String? miniProgramSignature,
    List<ServiceCategory>? categories,
    String? miniProgramLogo,
    RegistrationStatus? status,
    String? appId,
    String? originalId,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? authorizedAt,
    DateTime? completedAt,
  }) {
    return MiniProgramRegistration(
      enterpriseName: enterpriseName ?? this.enterpriseName,
      enterpriseCode: enterpriseCode ?? this.enterpriseCode,
      enterpriseType: enterpriseType ?? this.enterpriseType,
      legalPersonName: legalPersonName ?? this.legalPersonName,
      legalPersonWechat: legalPersonWechat ?? this.legalPersonWechat,
      servicePhone: servicePhone ?? this.servicePhone,
      miniProgramName: miniProgramName ?? this.miniProgramName,
      miniProgramIntro: miniProgramIntro ?? this.miniProgramIntro,
      miniProgramSignature: miniProgramSignature ?? this.miniProgramSignature,
      categories: categories ?? this.categories,
      miniProgramLogo: miniProgramLogo ?? this.miniProgramLogo,
      status: status ?? this.status,
      appId: appId ?? this.appId,
      originalId: originalId ?? this.originalId,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      authorizedAt: authorizedAt ?? this.authorizedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// 转换为JSON（用于API调用）
  Map<String, dynamic> toJson() {
    return {
      'enterpriseName': enterpriseName,
      'enterpriseCode': enterpriseCode,
      'enterpriseType': enterpriseType,
      'legalPersonaName': legalPersonName,
      'legalPersonaWechat': legalPersonWechat,
      'componentPhone': servicePhone,
      'name': miniProgramName,
      'intro': miniProgramIntro,
      'signature': miniProgramSignature,
      'categories': categories.map((c) => c.toJson()).toList(),
      'logo': miniProgramLogo,
    };
  }

  /// 创建初始状态
  factory MiniProgramRegistration.initial() {
    return MiniProgramRegistration(
      enterpriseName: '',
      enterpriseCode: '',
      enterpriseType: 1, // 默认为企业
      legalPersonName: '',
      legalPersonWechat: '',
      miniProgramName: '',
      miniProgramIntro: '',
      miniProgramSignature: '',
      categories: [],
      status: RegistrationStatus.draft,
      createdAt: DateTime.now(),
    );
  }
}

/// 注册状态枚举
enum RegistrationStatus {
  /// 草稿（信息填写中）
  draft,

  /// 信息已填写完成，等待提交
  infoCompleted,

  /// 已提交（等待法人扫码）
  submitted,

  /// 法人已授权（等待获取APPID）
  authorized,

  /// 已完成（已获取APPID）
  completed,

  /// 失败
  failed,
}

/// 企业主体类型枚举
enum EnterpriseType {
  /// 企业
  enterprise(1, '企业'),

  /// 政府
  government(2, '政府'),

  /// 媒体
  media(3, '媒体'),

  /// 其他组织
  other(4, '其他组织'),

  /// 个人
  individual(5, '个人');

  final int value;
  final String label;

  const EnterpriseType(this.value, this.label);

  static EnterpriseType fromValue(int value) {
    return EnterpriseType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => EnterpriseType.enterprise,
    );
  }
}

/// 服务类目模型
class ServiceCategory {
  /// 一级类目ID
  final int firstId;

  /// 一级类目名称
  final String firstName;

  /// 二级类目ID
  final int secondId;

  /// 二级类目名称
  final String secondName;

  /// 是否已审核通过
  final bool isApproved;

  const ServiceCategory({
    required this.firstId,
    required this.firstName,
    required this.secondId,
    required this.secondName,
    this.isApproved = false,
  });

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'first': firstId,
      'second': secondId,
    };
  }

  /// 从JSON创建
  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      firstId: json['first'] as int,
      firstName: json['firstName'] as String? ?? '',
      secondId: json['second'] as int,
      secondName: json['secondName'] as String? ?? '',
      isApproved: json['isApproved'] as bool? ?? false,
    );
  }

  /// 复制并修改
  ServiceCategory copyWith({
    int? firstId,
    String? firstName,
    int? secondId,
    String? secondName,
    bool? isApproved,
  }) {
    return ServiceCategory(
      firstId: firstId ?? this.firstId,
      firstName: firstName ?? this.firstName,
      secondId: secondId ?? this.secondId,
      secondName: secondName ?? this.secondName,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceCategory &&
        other.firstId == firstId &&
        other.secondId == secondId;
  }

  @override
  int get hashCode => firstId.hashCode ^ secondId.hashCode;
}

/// 名称检测结果
class NameCheckResult {
  /// 名称是否可用
  final bool isAvailable;

  /// 提示信息
  final String message;

  /// 是否包含非法词
  final bool hasIllegalWords;

  /// 是否已被占用
  final bool isTaken;

  const NameCheckResult({
    required this.isAvailable,
    required this.message,
    this.hasIllegalWords = false,
    this.isTaken = false,
  });
}
