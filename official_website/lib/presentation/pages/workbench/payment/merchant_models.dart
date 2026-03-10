/// 商户进件相关数据模型

/// 商户主体类型
enum MerchantSubjectType {
  individual('个体户', '🧑🌾'),
  enterprise('企业', '🏢'),
  other('其他', '📋');

  final String label;
  final String icon;

  const MerchantSubjectType(this.label, this.icon);
}

/// 商户进件状态
enum MerchantStatus {
  submitting('提交审核', '🟡', 0xFFFFA940),
  reviewing('审核中', '🟡', 0xFFFFA940),
  pendingVerification('待账户验证', '🔵', 0xFF1890FF),
  pendingContract('待签约', '🟠', 0xFFFF7A45),
  completed('已完成', '🟢', 0xFF52C41A),
  rejected('已驳回', '🔴', 0xFFFF4D4F);

  final String label;
  final String icon;
  final int color;

  const MerchantStatus(this.label, this.icon, this.color);
}

/// 进件进度节点
enum ProgressStep {
  submitted('资料提交成功'),
  reviewPassed('微信审核通过'),
  pendingVerification('待账户验证'),
  pendingContract('待签约'),
  completed('入驻完成');

  final String label;

  const ProgressStep(this.label);
}

/// 商户信息模型
class MerchantInfo {
  final String id;
  final String shortName; // 商户简称
  final String fullName; // 商户全称
  final MerchantSubjectType subjectType;
  final String servicePhone; // 客服电话
  final List<String> businessScenes; // 经营场景
  final String? businessLicenseUrl; // 营业执照
  final String? legalPersonIdCardUrl; // 法人身份证
  final String? bankAccount; // 银行账号
  final String? bankName; // 开户银行
  final String? accountName; // 开户名称

  // 超级管理员信息
  final String adminName;
  final String adminPhone;
  final String adminEmail;
  final String? adminIdCard;

  // 进件状态
  final MerchantStatus status;
  final DateTime? submitTime;
  final DateTime? reviewTime;
  final DateTime? completeTime;

  // 进度
  final ProgressStep currentStep;
  final List<ProgressStep> completedSteps;

  // 二维码授权URL（用于验证和签约）
  String? authUrl;
  String? authQrCode;

  MerchantInfo({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.subjectType,
    required this.servicePhone,
    required this.businessScenes,
    this.businessLicenseUrl,
    this.legalPersonIdCardUrl,
    this.bankAccount,
    this.bankName,
    this.accountName,
    required this.adminName,
    required this.adminPhone,
    required this.adminEmail,
    this.adminIdCard,
    required this.status,
    this.submitTime,
    this.reviewTime,
    this.completeTime,
    required this.currentStep,
    required this.completedSteps,
    this.authUrl,
    this.authQrCode,
  });

  /// 复制并修改部分字段
  MerchantInfo copyWith({
    String? id,
    String? shortName,
    String? fullName,
    MerchantSubjectType? subjectType,
    String? servicePhone,
    List<String>? businessScenes,
    String? businessLicenseUrl,
    String? legalPersonIdCardUrl,
    String? bankAccount,
    String? bankName,
    String? accountName,
    String? adminName,
    String? adminPhone,
    String? adminEmail,
    String? adminIdCard,
    MerchantStatus? status,
    DateTime? submitTime,
    DateTime? reviewTime,
    DateTime? completeTime,
    ProgressStep? currentStep,
    List<ProgressStep>? completedSteps,
    String? authUrl,
    String? authQrCode,
  }) {
    return MerchantInfo(
      id: id ?? this.id,
      shortName: shortName ?? this.shortName,
      fullName: fullName ?? this.fullName,
      subjectType: subjectType ?? this.subjectType,
      servicePhone: servicePhone ?? this.servicePhone,
      businessScenes: businessScenes ?? this.businessScenes,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      legalPersonIdCardUrl: legalPersonIdCardUrl ?? this.legalPersonIdCardUrl,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      adminName: adminName ?? this.adminName,
      adminPhone: adminPhone ?? this.adminPhone,
      adminEmail: adminEmail ?? this.adminEmail,
      adminIdCard: adminIdCard ?? this.adminIdCard,
      status: status ?? this.status,
      submitTime: submitTime ?? this.submitTime,
      reviewTime: reviewTime ?? this.reviewTime,
      completeTime: completeTime ?? this.completeTime,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      authUrl: authUrl ?? this.authUrl,
      authQrCode: authQrCode ?? this.authQrCode,
    );
  }
}

/// 进件统计数据
class MerchantStatistics {
  final int totalInProgress; // 进件总数
  final int pendingVerification; // 待验证
  final int pendingContract; // 待签约
  final int completedToday; // 今日完成

  MerchantStatistics({
    required this.totalInProgress,
    required this.pendingVerification,
    required this.pendingContract,
    required this.completedToday,
  });
}

/// 经营场景
enum BusinessScene {
  miniProgram('小程序'),
  officialAccount('公众号'),
  offlineStore('线下门店'),
  h5('H5页面'),
  app('APP');

  final String label;

  const BusinessScene(this.label);
}
