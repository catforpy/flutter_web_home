/// 讲师数据模型
library;

/// 讲师登录状态
enum InstructorStatus {
  online('在线', 'online'),
  busy('忙碌', 'busy'),
  offline('离线', 'offline');

  final String label;
  final String value;

  const InstructorStatus(this.label, this.value);
}

/// 合作模式
enum CooperationMode {
  partner('合作模式', 'partner'),
  lease('租赁模式', 'lease');

  final String label;
  final String value;

  const CooperationMode(this.label, this.value);
}

/// 课程统计
class CourseStatistics {
  final int singleCourses; // 单课数量
  final int seriesCourses; // 套课数量
  final int videoCourses; // 视频数量
  final int liveReplays; // 直播回放数量

  const CourseStatistics({
    this.singleCourses = 0,
    this.seriesCourses = 0,
    this.videoCourses = 0,
    this.liveReplays = 0,
  });

  int get total => singleCourses + seriesCourses + videoCourses + liveReplays;

  CourseStatistics copyWith({
    int? singleCourses,
    int? seriesCourses,
    int? videoCourses,
    int? liveReplays,
  }) {
    return CourseStatistics(
      singleCourses: singleCourses ?? this.singleCourses,
      seriesCourses: seriesCourses ?? this.seriesCourses,
      videoCourses: videoCourses ?? this.videoCourses,
      liveReplays: liveReplays ?? this.liveReplays,
    );
  }
}

/// 收入统计
class RevenueStatistics {
  final double weeklyRevenue; // 最近一周收入
  final double monthlyRevenue; // 最近一月收入
  final double quarterlyRevenue; // 最近一季度收入
  final double totalRevenue; // 总收入

  const RevenueStatistics({
    this.weeklyRevenue = 0,
    this.monthlyRevenue = 0,
    this.quarterlyRevenue = 0,
    this.totalRevenue = 0,
  });

  RevenueStatistics copyWith({
    double? weeklyRevenue,
    double? monthlyRevenue,
    double? quarterlyRevenue,
    double? totalRevenue,
  }) {
    return RevenueStatistics(
      weeklyRevenue: weeklyRevenue ?? this.weeklyRevenue,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      quarterlyRevenue: quarterlyRevenue ?? this.quarterlyRevenue,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }
}

/// 学员评价
class StudentReview {
  final String id;
  final String studentName;
  final String content;
  final double rating;
  final DateTime createTime;

  const StudentReview({
    required this.id,
    required this.studentName,
    required this.content,
    required this.rating,
    required this.createTime,
  });

  StudentReview copyWith({
    String? id,
    String? studentName,
    String? content,
    double? rating,
    DateTime? createTime,
  }) {
    return StudentReview(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      createTime: createTime ?? this.createTime,
    );
  }
}

/// 资质证书
class QualificationCertificate {
  final String id;
  final String name; // 证书名称
  final String imageUrl; // 证书图片URL
  final String issuingOrganization; // 颁发机构
  final DateTime issueDate; // 颁发日期
  final DateTime? expiryDate; // 过期日期（永久有效则为null）
  final String certificateNumber; // 证书编号

  const QualificationCertificate({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.issuingOrganization,
    required this.issueDate,
    this.expiryDate,
    required this.certificateNumber,
  });

  QualificationCertificate copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? certificateNumber,
  }) {
    return QualificationCertificate(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      certificateNumber: certificateNumber ?? this.certificateNumber,
    );
  }

  /// 是否已过期
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// 是否即将过期（30天内）
  bool get isExpiringSoon {
    if (expiryDate == null || isExpired) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }
}

/// 讲师信息
class Instructor {
  final String id;
  final String name; // 姓名
  final String avatar; // 头像URL
  final String bio; // 简介
  final List<String> subjects; // 学科标签
  final DateTime registerTime; // 注册时间
  final InstructorStatus status; // 登录状态
  final CooperationMode cooperationMode; // 合作模式

  // 统计数据
  final int studentCount; // 学生数量
  final int followerCount; // 关注度
  final double questionAnswerRate; // 问答率 (0-1)
  final double courseLikeRate; // 课程点赞率 (0-1)
  final double courseShareRate; // 课程转发率 (0-1)
  final double averageRating; // 平均评分 (1-5)

  // 课程统计
  final CourseStatistics courseStats; // 课程统计详情
  final RevenueStatistics revenueStats; // 收入统计

  // 预约与完结
  final int reservedCourseCount; // 预购课程数量
  final int completedCourseCount; // 已完结课程数量

  // 最近登录时间
  final DateTime? lastLoginTime;

  // 学员评价
  final List<StudentReview> reviews;

  // 资质证书
  final List<QualificationCertificate> qualifications;

  const Instructor({
    required this.id,
    required this.name,
    required this.avatar,
    this.bio = '',
    this.subjects = const [],
    required this.registerTime,
    required this.status,
    required this.cooperationMode,
    this.studentCount = 0,
    this.followerCount = 0,
    this.questionAnswerRate = 0,
    this.courseLikeRate = 0,
    this.courseShareRate = 0,
    this.averageRating = 0,
    this.courseStats = const CourseStatistics(),
    this.revenueStats = const RevenueStatistics(),
    this.reservedCourseCount = 0,
    this.completedCourseCount = 0,
    this.lastLoginTime,
    this.reviews = const [],
    this.qualifications = const [],
  });

  /// 从JSON创建
  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String? ?? '',
      subjects: (json['subjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      registerTime: DateTime.parse(json['registerTime'] as String),
      status: InstructorStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => InstructorStatus.offline,
      ),
      cooperationMode: CooperationMode.values.firstWhere(
        (e) => e.value == json['cooperationMode'],
        orElse: () => CooperationMode.partner,
      ),
      studentCount: json['studentCount'] as int? ?? 0,
      followerCount: json['followerCount'] as int? ?? 0,
      questionAnswerRate: (json['questionAnswerRate'] as num?)?.toDouble() ?? 0,
      courseLikeRate: (json['courseLikeRate'] as num?)?.toDouble() ?? 0,
      courseShareRate: (json['courseShareRate'] as num?)?.toDouble() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      courseStats: json['courseStats'] != null
          ? CourseStatistics(
              singleCourses: json['courseStats']['singleCourses'] as int? ?? 0,
              seriesCourses: json['courseStats']['seriesCourses'] as int? ?? 0,
              videoCourses: json['courseStats']['videoCourses'] as int? ?? 0,
              liveReplays: json['courseStats']['liveReplays'] as int? ?? 0,
            )
          : const CourseStatistics(),
      revenueStats: json['revenueStats'] != null
          ? RevenueStatistics(
              weeklyRevenue: (json['revenueStats']['weeklyRevenue'] as num?)?.toDouble() ?? 0,
              monthlyRevenue: (json['revenueStats']['monthlyRevenue'] as num?)?.toDouble() ?? 0,
              quarterlyRevenue: (json['revenueStats']['quarterlyRevenue'] as num?)?.toDouble() ?? 0,
              totalRevenue: (json['revenueStats']['totalRevenue'] as num?)?.toDouble() ?? 0,
            )
          : const RevenueStatistics(),
      reservedCourseCount: json['reservedCourseCount'] as int? ?? 0,
      completedCourseCount: json['completedCourseCount'] as int? ?? 0,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => StudentReview(
                    id: e['id'] as String,
                    studentName: e['studentName'] as String,
                    content: e['content'] as String,
                    rating: (e['rating'] as num).toDouble(),
                    createTime: DateTime.parse(e['createTime'] as String),
                  ))
              .toList() ??
          [],
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => QualificationCertificate(
                    id: e['id'] as String,
                    name: e['name'] as String,
                    imageUrl: e['imageUrl'] as String,
                    issuingOrganization: e['issuingOrganization'] as String,
                    issueDate: DateTime.parse(e['issueDate'] as String),
                    expiryDate: e['expiryDate'] != null ? DateTime.parse(e['expiryDate'] as String) : null,
                    certificateNumber: e['certificateNumber'] as String,
                  ))
              .toList() ??
          [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'subjects': subjects,
      'registerTime': registerTime.toIso8601String(),
      'status': status.value,
      'cooperationMode': cooperationMode.value,
      'studentCount': studentCount,
      'followerCount': followerCount,
      'questionAnswerRate': questionAnswerRate,
      'courseLikeRate': courseLikeRate,
      'courseShareRate': courseShareRate,
      'averageRating': averageRating,
      'courseStats': courseStats.toJson(),
      'revenueStats': revenueStats.toJson(),
      'reservedCourseCount': reservedCourseCount,
      'completedCourseCount': completedCourseCount,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'qualifications': qualifications.map((e) => {
        'id': e.id,
        'name': e.name,
        'imageUrl': e.imageUrl,
        'issuingOrganization': e.issuingOrganization,
        'issueDate': e.issueDate.toIso8601String(),
        'expiryDate': e.expiryDate?.toIso8601String(),
        'certificateNumber': e.certificateNumber,
      }).toList(),
    };
  }

  /// 创建副本
  Instructor copyWith({
    String? id,
    String? name,
    String? avatar,
    String? bio,
    List<String>? subjects,
    DateTime? registerTime,
    InstructorStatus? status,
    CooperationMode? cooperationMode,
    int? studentCount,
    int? followerCount,
    double? questionAnswerRate,
    double? courseLikeRate,
    double? courseShareRate,
    double? averageRating,
    CourseStatistics? courseStats,
    RevenueStatistics? revenueStats,
    int? reservedCourseCount,
    int? completedCourseCount,
    DateTime? lastLoginTime,
    List<StudentReview>? reviews,
    List<QualificationCertificate>? qualifications,
  }) {
    return Instructor(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      subjects: subjects ?? this.subjects,
      registerTime: registerTime ?? this.registerTime,
      status: status ?? this.status,
      cooperationMode: cooperationMode ?? this.cooperationMode,
      studentCount: studentCount ?? this.studentCount,
      followerCount: followerCount ?? this.followerCount,
      questionAnswerRate: questionAnswerRate ?? this.questionAnswerRate,
      courseLikeRate: courseLikeRate ?? this.courseLikeRate,
      courseShareRate: courseShareRate ?? this.courseShareRate,
      averageRating: averageRating ?? this.averageRating,
      courseStats: courseStats ?? this.courseStats,
      revenueStats: revenueStats ?? this.revenueStats,
      reservedCourseCount: reservedCourseCount ?? this.reservedCourseCount,
      completedCourseCount: completedCourseCount ?? this.completedCourseCount,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      reviews: reviews ?? this.reviews,
      qualifications: qualifications ?? this.qualifications,
    );
  }
}

/// CourseStatistics扩展方法
extension CourseStatisticsJson on CourseStatistics {
  Map<String, dynamic> toJson() {
    return {
      'singleCourses': singleCourses,
      'seriesCourses': seriesCourses,
      'videoCourses': videoCourses,
      'liveReplays': liveReplays,
    };
  }

  static CourseStatistics fromJson(Map<String, dynamic> json) {
    return CourseStatistics(
      singleCourses: json['singleCourses'] as int? ?? 0,
      seriesCourses: json['seriesCourses'] as int? ?? 0,
      videoCourses: json['videoCourses'] as int? ?? 0,
      liveReplays: json['liveReplays'] as int? ?? 0,
    );
  }
}

/// RevenueStatistics扩展方法
extension RevenueStatisticsJson on RevenueStatistics {
  Map<String, dynamic> toJson() {
    return {
      'weeklyRevenue': weeklyRevenue,
      'monthlyRevenue': monthlyRevenue,
      'quarterlyRevenue': quarterlyRevenue,
      'totalRevenue': totalRevenue,
    };
  }

  static RevenueStatistics fromJson(Map<String, dynamic> json) {
    return RevenueStatistics(
      weeklyRevenue: (json['weeklyRevenue'] as num?)?.toDouble() ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0,
      quarterlyRevenue: (json['quarterlyRevenue'] as num?)?.toDouble() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// StudentReview扩展方法
extension StudentReviewJson on StudentReview {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'content': content,
      'rating': rating,
      'createTime': createTime.toIso8601String(),
    };
  }

  static StudentReview fromJson(Map<String, dynamic> json) {
    return StudentReview(
      id: json['id'] as String,
      studentName: json['studentName'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      createTime: DateTime.parse(json['createTime'] as String),
    );
  }
}
