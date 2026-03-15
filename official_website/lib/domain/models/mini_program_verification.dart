
/// 小程序认证信息模型
/// 用于收集商户认证小程序所需的所有信息
class MiniProgramVerification {
  // ========== 基本信息 ==========
  /// 小程序APPID
  final String appId;

  /// 正式小程序名称（认证后不可修改）
  final String officialMiniProgramName;

  // ========== 认证材料 ==========
  /// 营业执照照片URL（企业类必填）
  final String? businessLicenseUrl;

  /// 对公账户信息
  final BankAccountInfo? bankAccountInfo;

  /// 运营文档URL
  final String? operationDocUrl;

  /// 其他认证材料
  final List<VerificationMaterial> otherMaterials;

  // ========== 支付信息 ==========
  /// 支付方式
  final PaymentMethod paymentMethod;

  /// 认证订单号（创建后返回）
  final String? orderId;

  /// 认证费用（300元）
  final double verificationFee = 300.0;

  // ========== 认证状态 ==========
  /// 认证状态
  final VerificationStatus status;

  /// 认证到期时间
  final DateTime? expiryDate;

  /// 错误信息
  final String? errorMessage;

  // ========== 时间戳 ==========
  /// 提交时间
  final DateTime submittedAt;

  /// 支付时间
  final DateTime? paidAt;

  /// 审核通过时间
  final DateTime? approvedAt;

  /// 完成时间
  final DateTime? completedAt;

  const MiniProgramVerification({
    required this.appId,
    required this.officialMiniProgramName,
    this.businessLicenseUrl,
    this.bankAccountInfo,
    this.operationDocUrl,
    this.otherMaterials = const [],
    required this.paymentMethod,
    this.orderId,
    required this.status,
    this.expiryDate,
    this.errorMessage,
    required this.submittedAt,
    this.paidAt,
    this.approvedAt,
    this.completedAt,
  });

  /// 复制并修改
  MiniProgramVerification copyWith({
    String? appId,
    String? officialMiniProgramName,
    String? businessLicenseUrl,
    BankAccountInfo? bankAccountInfo,
    String? operationDocUrl,
    List<VerificationMaterial>? otherMaterials,
    PaymentMethod? paymentMethod,
    String? orderId,
    VerificationStatus? status,
    DateTime? expiryDate,
    String? errorMessage,
    DateTime? submittedAt,
    DateTime? paidAt,
    DateTime? approvedAt,
    DateTime? completedAt,
  }) {
    return MiniProgramVerification(
      appId: appId ?? this.appId,
      officialMiniProgramName: officialMiniProgramName ?? this.officialMiniProgramName,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      bankAccountInfo: bankAccountInfo ?? this.bankAccountInfo,
      operationDocUrl: operationDocUrl ?? this.operationDocUrl,
      otherMaterials: otherMaterials ?? this.otherMaterials,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      errorMessage: errorMessage ?? this.errorMessage,
      submittedAt: submittedAt ?? this.submittedAt,
      paidAt: paidAt ?? this.paidAt,
      approvedAt: approvedAt ?? this.approvedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'name': officialMiniProgramName,
      'businessLicense': businessLicenseUrl,
      'bankAccount': bankAccountInfo?.toJson(),
      'operationDoc': operationDocUrl,
      'otherMaterials': otherMaterials.map((m) => m.toJson()).toList(),
      'paymentMethod': paymentMethod.value,
    };
  }

  /// 创建初始状态
  factory MiniProgramVerification.initial({
    required String appId,
    required String initialMiniProgramName,
  }) {
    return MiniProgramVerification(
      appId: appId,
      officialMiniProgramName: initialMiniProgramName,
      otherMaterials: [],
      paymentMethod: PaymentMethod.merchant,
      status: VerificationStatus.draft,
      submittedAt: DateTime.now(),
    );
  }
}

/// 认证状态枚举
enum VerificationStatus {
  /// 草稿
  draft,

  /// 材料已上传
  materialsUploaded,

  /// 已提交审核
  submitted,

  /// 等待法人授权
  waitingAuthorization,

  /// 等待支付
  waitingPayment,

  /// 审核中
  reviewing,

  /// 审核通过
  approved,

  /// 审核驳回
  rejected,

  /// 已完成
  completed,

  /// 认证失败
  failed,
}

/// 支付方式枚举
enum PaymentMethod {
  /// 商家交纳（商户自己支付300元）
  merchant(1, '商家交纳'),

  /// 服务商代交（从预购额度扣除）
  provider(2, '服务商代交');

  final int value;
  final String label;

  const PaymentMethod(this.value, this.label);

  static PaymentMethod fromValue(int value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => PaymentMethod.merchant,
    );
  }
}

/// 银行账户信息
class BankAccountInfo {
  /// 银行名称
  final String bankName;

  /// 开户行名称
  final String branchName;

  /// 账户名称
  final String accountName;

  /// 账户号码
  final String accountNumber;

  /// 开户许可证图片URL
  final String? licenseUrl;

  const BankAccountInfo({
    required this.bankName,
    required this.branchName,
    required this.accountName,
    required this.accountNumber,
    this.licenseUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'branchName': branchName,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'licenseUrl': licenseUrl,
    };
  }

  factory BankAccountInfo.fromJson(Map<String, dynamic> json) {
    return BankAccountInfo(
      bankName: json['bankName'] as String,
      branchName: json['branchName'] as String,
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      licenseUrl: json['licenseUrl'] as String?,
    );
  }
}

/// 认证材料
class VerificationMaterial {
  /// 材料类型
  final MaterialType type;

  /// 材料名称
  final String name;

  /// 材料URL
  final String url;

  /// 上传时间
  final DateTime uploadedAt;

  const VerificationMaterial({
    required this.type,
    required this.name,
    required this.url,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'name': name,
      'url': url,
    };
  }
}

/// 材料类型枚举
enum MaterialType {
  /// 营业执照
  businessLicense(1, '营业执照'),

  /// 开户许可证
  bankLicense(2, '开户许可证'),

  /// 运营文档
  operationDoc(3, '运营文档'),

  /// 其他
  other(99, '其他');

  final int value;
  final String label;

  const MaterialType(this.value, this.label);

  static MaterialType fromValue(int value) {
    return MaterialType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MaterialType.other,
    );
  }
}
