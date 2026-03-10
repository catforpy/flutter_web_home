/// 课程问答数据模型

/// 问答类型
enum QAType {
  preCourse('课前问答', 'pre_course'),
  postCourse('课后问答', 'post_course');

  final String label;
  final String value;

  const QAType(this.label, this.value);
}

/// 课程状态
enum CourseStatus {
  presale('预售', 'presale'),
  inProduction('制作中', 'in_production'),
  completed('完结', 'completed');

  final String label;
  final String value;

  const CourseStatus(this.label, this.value);
}

/// 回答人类型
enum AnswererType {
  customerService('客服', 'customer_service'),
  instructor('讲师', 'instructor');

  final String label;
  final String value;

  const AnswererType(this.label, this.value);
}

/// 课程问答统计
class CourseQAStats {
  final String courseId; // 课程ID
  final String courseName; // 课程名称
  final String instructorId; // 讲师ID
  final String instructorName; // 讲师姓名
  final String instructorAvatar; // 讲师头像

  // 分类信息
  final String? industryCategory; // 行业分类路径
  final String? formatCategory; // 课程形式分类路径
  final String? typeCategory; // 课程类型分类

  final CourseStatus courseStatus; // 课程状态
  final int followerCount; // 关注人数
  final int studentCount; // 学生人数
  final int totalQuestions; // 问题总数
  final int resolvedCount; // 已解决数量
  final double averageRating; // 课程评分

  const CourseQAStats({
    required this.courseId,
    required this.courseName,
    required this.instructorId,
    required this.instructorName,
    required this.instructorAvatar,
    this.industryCategory,
    this.formatCategory,
    this.typeCategory,
    required this.courseStatus,
    required this.followerCount,
    required this.studentCount,
    required this.totalQuestions,
    required this.resolvedCount,
    required this.averageRating,
  });

  /// 计算待解决数量
  int get pendingCount => totalQuestions - resolvedCount;

  /// 获取问答率
  double get qaRate => totalQuestions > 0 ? resolvedCount / totalQuestions : 0;

  /// 从JSON创建
  factory CourseQAStats.fromJson(Map<String, dynamic> json) {
    return CourseQAStats(
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      instructorAvatar: json['instructorAvatar'] as String,
      industryCategory: json['industryCategory'] as String?,
      formatCategory: json['formatCategory'] as String?,
      typeCategory: json['typeCategory'] as String?,
      courseStatus: CourseStatus.values.firstWhere(
        (e) => e.value == json['courseStatus'],
        orElse: () => CourseStatus.presale,
      ),
      followerCount: json['followerCount'] as int? ?? 0,
      studentCount: json['studentCount'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      resolvedCount: json['resolvedCount'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
      if (industryCategory != null) 'industryCategory': industryCategory,
      if (formatCategory != null) 'formatCategory': formatCategory,
      if (typeCategory != null) 'typeCategory': typeCategory,
      'courseStatus': courseStatus.value,
      'followerCount': followerCount,
      'studentCount': studentCount,
      'totalQuestions': totalQuestions,
      'resolvedCount': resolvedCount,
      'pendingCount': pendingCount,
      'averageRating': averageRating,
    };
  }
}

/// 问题
class Question {
  final String id; // 问题ID
  final String courseId; // 课程ID
  final String courseName; // 课程名称（冗余字段）
  final QAType qaType; // 问答类型
  final String userId; // 提问用户ID
  final String userName; // 提问用户名
  final String userAvatar; // 提问用户头像
  final String title; // 问题标题
  final String content; // 问题内容
  final DateTime askTime; // 提问时间
  final bool isResolved; // 是否已解决
  final AnswererType? answererType; // 回答人类型
  final String? answererId; // 回答人ID
  final String? answererName; // 回答人姓名
  final DateTime? answerTime; // 回答时间
  final String? answerContent; // 回答内容
  final int likes; // 点赞数

  const Question({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.qaType,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.content,
    required this.askTime,
    this.isResolved = false,
    this.answererType,
    this.answererId,
    this.answererName,
    this.answerTime,
    this.answerContent,
    this.likes = 0,
  });

  /// 从JSON创建
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      qaType: QAType.values.firstWhere(
        (e) => e.value == json['qaType'],
        orElse: () => QAType.preCourse,
      ),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      askTime: DateTime.parse(json['askTime'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
      answererType: json['answererType'] != null
          ? AnswererType.values.firstWhere(
              (e) => e.value == json['answererType'],
              orElse: () => AnswererType.customerService,
            )
          : null,
      answererId: json['answererId'] as String?,
      answererName: json['answererName'] as String?,
      answerTime: json['answerTime'] != null
          ? DateTime.parse(json['answerTime'] as String)
          : null,
      answerContent: json['answerContent'] as String?,
      likes: json['likes'] as int? ?? 0,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseName': courseName,
      'qaType': qaType.value,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'title': title,
      'content': content,
      'askTime': askTime.toIso8601String(),
      'isResolved': isResolved,
      if (answererType != null) 'answererType': answererType!.value,
      if (answererId != null) 'answererId': answererId,
      if (answererName != null) 'answererName': answererName,
      if (answerTime != null) 'answerTime': answerTime!.toIso8601String(),
      if (answerContent != null) 'answerContent': answerContent,
      'likes': likes,
    };
  }

  /// 创建副本
  Question copyWith({
    String? id,
    String? courseId,
    String? courseName,
    QAType? qaType,
    String? userId,
    String? userName,
    String? userAvatar,
    String? title,
    String? content,
    DateTime? askTime,
    bool? isResolved,
    AnswererType? answererType,
    String? answererId,
    String? answererName,
    DateTime? answerTime,
    String? answerContent,
    int? likes,
  }) {
    return Question(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      qaType: qaType ?? this.qaType,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      title: title ?? this.title,
      content: content ?? this.content,
      askTime: askTime ?? this.askTime,
      isResolved: isResolved ?? this.isResolved,
      answererType: answererType ?? this.answererType,
      answererId: answererId ?? this.answererId,
      answererName: answererName ?? this.answererName,
      answerTime: answerTime ?? this.answerTime,
      answerContent: answerContent ?? this.answerContent,
      likes: likes ?? this.likes,
    );
  }
}
