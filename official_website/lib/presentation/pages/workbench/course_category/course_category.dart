/// 课程分类数据模型
class CourseCategory {
  final String id;
  final String name;
  final int level;
  final String? parentId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CourseCategory> children;

  CourseCategory({
    required this.id,
    required this.name,
    required this.level,
    this.parentId,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    List<CourseCategory>? children,
  }) : children = children ?? [];

  /// 从JSON创建
  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      parentId: json['parentId'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => CourseCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'parentId': parentId,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  /// 创建副本
  CourseCategory copyWith({
    String? id,
    String? name,
    int? level,
    String? parentId,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CourseCategory>? children,
  }) {
    return CourseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      children: children ?? this.children,
    );
  }
}
