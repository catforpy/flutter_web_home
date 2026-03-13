import 'package:equatable/equatable.dart';

/// 会员类型实体
///
/// 用于表示付费会员类型，如日卡、月卡、年卡等
class MemberTypeEntity extends Equatable {
  /// 唯一标识
  final String id;

  /// 标题（如：日卡、月卡、年卡、季卡等）
  final String title;

  /// 价格（元）
  final double price;

  /// 类型（日卡、月卡、年卡等）
  final MemberType type;

  /// 时长（与type对应，如type为月卡时，duration为1表示1个月）
  final int duration;

  /// 描述
  final String? description;

  /// 会员权益列表
  final List<String> benefits;

  /// 是否启用
  final bool isEnabled;

  /// 排序序号
  final int sortOrder;

  /// 封面图URL
  final String? coverImage;

  /// 创建时间
  final DateTime createTime;

  /// 更新时间
  final DateTime? updateTime;

  /// 购买人数
  final int purchaseCount;

  /// 总收入（元）
  final double totalRevenue;

  const MemberTypeEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    required this.duration,
    this.description,
    this.benefits = const [],
    this.isEnabled = true,
    this.sortOrder = 0,
    this.coverImage,
    required this.createTime,
    this.updateTime,
    this.purchaseCount = 0,
    this.totalRevenue = 0.0,
  });

  /// 获取时长文本描述
  String get durationText {
    switch (type) {
      case MemberType.daily:
        return '$duration天';
      case MemberType.weekly:
        return '$duration周';
      case MemberType.monthly:
        return '$duration个月';
      case MemberType.yearly:
        return '$duration年';
      case MemberType.permanent:
        return '永久';
    }
  }

  /// 获取价格文本
  String get priceText => '¥${price.toStringAsFixed(2)}';

  /// 计算折扣价（如果原价高于现价）
  double get discountRate {
    // 这里可以根据原价和现价计算折扣
    return 1.0;
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'type': type.name,
        'duration': duration,
        'description': description,
        'benefits': benefits,
        'isEnabled': isEnabled,
        'sortOrder': sortOrder,
        'coverImage': coverImage,
        'createTime': createTime.toIso8601String(),
        'updateTime': updateTime?.toIso8601String(),
        'purchaseCount': purchaseCount,
        'totalRevenue': totalRevenue,
      };

  /// 从JSON创建
  factory MemberTypeEntity.fromJson(Map<String, dynamic> json) {
    return MemberTypeEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      type: MemberType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MemberType.monthly,
      ),
      duration: json['duration'] as int,
      description: json['description'] as String?,
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isEnabled: json['isEnabled'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      coverImage: json['coverImage'] as String?,
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : null,
      purchaseCount: json['purchaseCount'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// 复制并修改部分属性
  MemberTypeEntity copyWith({
    String? id,
    String? title,
    double? price,
    MemberType? type,
    int? duration,
    String? description,
    List<String>? benefits,
    bool? isEnabled,
    int? sortOrder,
    String? coverImage,
    DateTime? createTime,
    DateTime? updateTime,
    int? purchaseCount,
    double? totalRevenue,
  }) {
    return MemberTypeEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      benefits: benefits ?? this.benefits,
      isEnabled: isEnabled ?? this.isEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
      coverImage: coverImage ?? this.coverImage,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        type,
        duration,
        description,
        benefits,
        isEnabled,
        sortOrder,
        coverImage,
        createTime,
        updateTime,
        purchaseCount,
        totalRevenue,
      ];
}

/// 会员类型枚举
enum MemberType {
  /// 日卡
  daily('日卡', '天'),

  /// 周卡
  weekly('周卡', '周'),

  /// 月卡
  monthly('月卡', '个月'),

  /// 年卡
  yearly('年卡', '年'),

  /// 永久
  permanent('永久', '');

  const MemberType(this.displayName, this.durationUnit);

  /// 显示名称
  final String displayName;

  /// 时长单位
  final String durationUnit;
}
