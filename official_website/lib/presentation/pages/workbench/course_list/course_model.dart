import '../course_qa_management/course_qa_model.dart';

/// 课程相关数据模型

/// 课程格式
enum CourseFormat {
  single('单课', 'single'),
  series('套课', 'series');

  final String label;
  final String value;

  const CourseFormat(this.label, this.value);
}

/// 课程基本信息
class Course {
  final String id; // 课程ID
  final String title; // 课程标题
  final String coverImage; // 封面图片
  final String description; // 课程简介

  // 分类信息
  final String? industryCategoryId; // 行业分类ID
  final String? industryCategoryPath; // 行业分类路径
  final String? formatCategoryId; // 形式分类ID
  final String? formatCategoryName; // 形式分类名称
  final String? typeCategoryId; // 类型分类ID
  final String? typeCategoryName; // 类型分类名称

  // 讲师信息
  final String instructorId; // 讲师ID
  final String instructorName; // 讲师姓名
  final String instructorAvatar; // 讲师头像

  // 课程状态
  final CourseStatus status; // 课程状态
  final CourseFormat format; // 课程格式

  // 统计数据
  final int totalDuration; // 总时长(分钟)
  final int lessonCount; // 课时数
  final int studentCount; // 学员数
  final int likeCount; // 点赞数
  final int reviewCount; // 评价数
  final double averageRating; // 平均评分

  // 价格信息
  final double price; // 价格
  final double originalPrice; // 原价

  // 时间信息
  final DateTime createdAt; // 创建时间
  final DateTime? publishedAt; // 发布时间

  const Course({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.description,
    this.industryCategoryId,
    this.industryCategoryPath,
    this.formatCategoryId,
    this.formatCategoryName,
    this.typeCategoryId,
    this.typeCategoryName,
    required this.instructorId,
    required this.instructorName,
    required this.instructorAvatar,
    required this.status,
    required this.format,
    required this.totalDuration,
    required this.lessonCount,
    required this.studentCount,
    required this.likeCount,
    required this.reviewCount,
    required this.averageRating,
    required this.price,
    required this.originalPrice,
    required this.createdAt,
    this.publishedAt,
  });

  /// 获取时长文本
  String get durationText {
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (hours > 0) {
      return '$hours小时${minutes > 0 ? ' $minutes分钟' : ''}';
    }
    return '$minutes分钟';
  }

  /// 是否为套课
  bool get isSeries => format == CourseFormat.series;

  /// 从JSON创建
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      coverImage: json['coverImage'] as String,
      description: json['description'] as String,
      industryCategoryId: json['industryCategoryId'] as String?,
      industryCategoryPath: json['industryCategoryPath'] as String?,
      formatCategoryId: json['formatCategoryId'] as String?,
      formatCategoryName: json['formatCategoryName'] as String?,
      typeCategoryId: json['typeCategoryId'] as String?,
      typeCategoryName: json['typeCategoryName'] as String?,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      instructorAvatar: json['instructorAvatar'] as String,
      status: CourseStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => CourseStatus.presale,
      ),
      format: CourseFormat.values.firstWhere(
        (e) => e.value == json['format'],
        orElse: () => CourseFormat.single,
      ),
      totalDuration: json['totalDuration'] as int? ?? 0,
      lessonCount: json['lessonCount'] as int? ?? 0,
      studentCount: json['studentCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      publishedAt: json['publishedTime'] != null
          ? DateTime.parse(json['publishedTime'] as String)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'description': description,
      if (industryCategoryId != null) 'industryCategoryId': industryCategoryId,
      if (industryCategoryPath != null) 'industryCategoryPath': industryCategoryPath,
      if (formatCategoryId != null) 'formatCategoryId': formatCategoryId,
      if (formatCategoryName != null) 'formatCategoryName': formatCategoryName,
      if (typeCategoryId != null) 'typeCategoryId': typeCategoryId,
      if (typeCategoryName != null) 'typeCategoryName': typeCategoryName,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
      'status': status.value,
      'format': format.value,
      'totalDuration': totalDuration,
      'lessonCount': lessonCount,
      'studentCount': studentCount,
      'likeCount': likeCount,
      'reviewCount': reviewCount,
      'averageRating': averageRating,
      'price': price,
      'originalPrice': originalPrice,
      'createdAt': createdAt.toIso8601String(),
      if (publishedAt != null) 'publishedTime': publishedAt!.toIso8601String(),
    };
  }

  /// 创建副本
  Course copyWith({
    String? id,
    String? title,
    String? coverImage,
    String? description,
    String? industryCategoryId,
    String? industryCategoryPath,
    String? formatCategoryId,
    String? formatCategoryName,
    String? typeCategoryId,
    String? typeCategoryName,
    String? instructorId,
    String? instructorName,
    String? instructorAvatar,
    CourseStatus? status,
    CourseFormat? format,
    int? totalDuration,
    int? lessonCount,
    int? studentCount,
    int? likeCount,
    int? reviewCount,
    double? averageRating,
    double? price,
    double? originalPrice,
    DateTime? createdAt,
    DateTime? publishedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      industryCategoryId: industryCategoryId ?? this.industryCategoryId,
      industryCategoryPath: industryCategoryPath ?? this.industryCategoryPath,
      formatCategoryId: formatCategoryId ?? this.formatCategoryId,
      formatCategoryName: formatCategoryName ?? this.formatCategoryName,
      typeCategoryId: typeCategoryId ?? this.typeCategoryId,
      typeCategoryName: typeCategoryName ?? this.typeCategoryName,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      status: status ?? this.status,
      format: format ?? this.format,
      totalDuration: totalDuration ?? this.totalDuration,
      lessonCount: lessonCount ?? this.lessonCount,
      studentCount: studentCount ?? this.studentCount,
      likeCount: likeCount ?? this.likeCount,
      reviewCount: reviewCount ?? this.reviewCount,
      averageRating: averageRating ?? this.averageRating,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

/// 课时信息
class Lesson {
  final String id; // 章节ID
  final String courseId; // 课程ID
  final int chapterNumber; // 章节序号
  final int lessonNumber; // 课时序号
  final String title; // 课时标题
  final String outline; // 课时大纲
  final int duration; // 时长(分钟)
  final bool isFree; // 是否免费试看
  final DateTime createdAt; // 创建时间
  final int questionCount; // 问答数量

  const Lesson({
    required this.id,
    required this.courseId,
    required this.chapterNumber,
    required this.lessonNumber,
    required this.title,
    required this.outline,
    required this.duration,
    required this.isFree,
    required this.createdAt,
    required this.questionCount,
  });

  /// 获取时长文本
  String get durationText {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (hours > 0) {
      return '$hours小时${minutes > 0 ? ' $minutes分钟' : ''}';
    }
    return '$minutes分钟';
  }

  /// 从JSON创建
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      chapterNumber: json['chapterNumber'] as int? ?? 0,
      lessonNumber: json['lessonNumber'] as int? ?? 0,
      title: json['title'] as String,
      outline: json['outline'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      isFree: json['isFree'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      questionCount: json['questionCount'] as int? ?? 0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'chapterNumber': chapterNumber,
      'lessonNumber': lessonNumber,
      'title': title,
      'outline': outline,
      'duration': duration,
      'isFree': isFree,
      'createdAt': createdAt.toIso8601String(),
      'questionCount': questionCount,
    };
  }
}

/// 课程章节
class Chapter {
  final String id; // 章节ID
  final String courseId; // 课程ID
  final int chapterNumber; // 章节序号
  final String title; // 章节标题
  final List<Lesson> lessons; // 课时列表

  const Chapter({
    required this.id,
    required this.courseId,
    required this.chapterNumber,
    required this.title,
    required this.lessons,
  });

  /// 获取章节目录总数
  int get totalLessons => lessons.length;

  /// 获取章节总时长
  int get totalDuration => lessons.fold(0, (sum, lesson) => sum + lesson.duration);

  /// 从JSON创建
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      chapterNumber: json['chapterNumber'] as int? ?? 0,
      title: json['title'] as String,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'chapterNumber': chapterNumber,
      'title': title,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}

/// 讲师简要信息
class InstructorBrief {
  final String id;
  final String name;
  final String avatar;
  final String? bio;
  final int followerCount;

  const InstructorBrief({
    required this.id,
    required this.name,
    required this.avatar,
    this.bio,
    required this.followerCount,
  });

  factory InstructorBrief.fromJson(Map<String, dynamic> json) {
    return InstructorBrief(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String?,
      followerCount: json['followerCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      if (bio != null) 'bio': bio,
      'followerCount': followerCount,
    };
  }
}
