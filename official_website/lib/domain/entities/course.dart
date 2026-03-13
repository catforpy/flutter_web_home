/// 课程实体
class Course {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String instructorId;
  final String instructorName;
  final String categoryId;
  final String formatId;
  final String typeId;
  final int price; // 价格（分）
  final int originalPrice; // 原价（分）
  final int studentCount;
  final double rating;
  final int ratingCount;
  final CourseStatus status;
  final DateTime createTime;
  final DateTime updateTime;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.instructorId,
    required this.instructorName,
    required this.categoryId,
    required this.formatId,
    required this.typeId,
    required this.price,
    required this.originalPrice,
    required this.studentCount,
    required this.rating,
    required this.ratingCount,
    required this.status,
    required this.createTime,
    required this.updateTime,
  });

  /// 获取格式化价格
  String get formattedPrice => '¥${(price / 100).toStringAsFixed(2)}';

  /// 获取格式化原价
  String get formattedOriginalPrice => '¥${(originalPrice / 100).toStringAsFixed(2)}';

  /// 是否有折扣
  bool get hasDiscount => price < originalPrice;

  /// 折扣力度
  double get discount => originalPrice > 0 ? (price / originalPrice) : 1.0;

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? coverUrl,
    String? instructorId,
    String? instructorName,
    String? categoryId,
    String? formatId,
    String? typeId,
    int? price,
    int? originalPrice,
    int? studentCount,
    double? rating,
    int? ratingCount,
    CourseStatus? status,
    DateTime? createTime,
    DateTime? updateTime,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      categoryId: categoryId ?? this.categoryId,
      formatId: formatId ?? this.formatId,
      typeId: typeId ?? this.typeId,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      studentCount: studentCount ?? this.studentCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }
}

/// 课程状态
enum CourseStatus {
  draft('草稿'),
  published('已发布'),
  offline('已下架'),
  deleted('已删除');

  final String displayName;

  const CourseStatus(this.displayName);
}

/// 讲师分类（用于筛选）
class InstructorCategory {
  final String id;
  final String name;
  final String avatar;
  final List<String> specialties;

  const InstructorCategory({
    required this.id,
    required this.name,
    required this.avatar,
    required this.specialties,
  });
}

/// 行业分类节点
class IndustryCategoryNode {
  final String id;
  final String name;
  final int level;
  final List<IndustryCategoryNode>? children;

  IndustryCategoryNode({
    required this.id,
    required this.name,
    required this.level,
    this.children,
  });
}

/// 形式分类
class FormatCategory {
  final String id;
  final String name;

  const FormatCategory({
    required this.id,
    required this.name,
  });
}

/// 类型分类
class TypeCategory {
  final String id;
  final String name;

  const TypeCategory({
    required this.id,
    required this.name,
  });
}
