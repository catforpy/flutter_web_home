import 'package:official_website/domain/entities/course.dart';

/// 课程模拟数据源
///
/// 所有假数据集中管理，方便替换为真实 API
class CourseMockDatasource {
  /// 获取课程列表
  static List<Course> getCourses({
    int page = 1,
    int pageSize = 10,
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
    String? formatId,
    String? typeId,
  }) {
    final allCourses = _getAllCourses();

    // 应用筛选
    var filteredCourses = allCourses;

    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((c) =>
              c.title.toLowerCase().contains(searchKeyword.toLowerCase()) ||
              c.description.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }

    if (instructorId != null && instructorId.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((c) => c.instructorId == instructorId)
          .toList();
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((c) => c.categoryId == categoryId)
          .toList();
    }

    if (formatId != null && formatId.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((c) => c.formatId == formatId)
          .toList();
    }

    if (typeId != null && typeId.isNotEmpty) {
      filteredCourses = filteredCourses
          .where((c) => c.typeId == typeId)
          .toList();
    }

    // 分页
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= filteredCourses.length) {
      return [];
    }

    return filteredCourses.sublist(
      start,
      end.clamp(0, filteredCourses.length),
    );
  }

  /// 搜索课程
  static List<Course> searchCourses(String keyword) {
    return getCourses(searchKeyword: keyword);
  }

  /// 获取课程总数
  static int getCourseCount({
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
  }) {
    return getCourses(
      searchKeyword: searchKeyword,
      instructorId: instructorId,
      categoryId: categoryId,
    ).length;
  }

  /// 获取单个课程详情
  static Course? getCourseById(String id) {
    return _getAllCourses().firstWhere(
      (c) => c.id == id,
      orElse: () => throw StateError("Value not found"),
    );
  }

  /// 获取讲师列表
  static List<InstructorCategory> getInstructorCategories() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      return InstructorCategory(
        id: 'instructor_$index',
        name: '讲师${index + 1}',
        avatar: 'https://via.placeholder.com/150',
        specialties: _generateSpecialties(index),
      );
    });
  }

  /// 获取行业分类
  static List<IndustryCategoryNode> getIndustryCategories() {
    return [
      IndustryCategoryNode(
        id: '1',
        name: 'IT技术',
        level: 1,
        children: [
          IndustryCategoryNode(
            id: '1-1',
            name: '编程开发',
            level: 2,
            children: [
              IndustryCategoryNode(id: '1-1-1', name: 'Python', level: 3),
              IndustryCategoryNode(id: '1-1-2', name: 'Java', level: 3),
              IndustryCategoryNode(id: '1-1-3', name: 'JavaScript', level: 3),
            ],
          ),
          IndustryCategoryNode(
            id: '1-2',
            name: '移动开发',
            level: 2,
            children: [
              IndustryCategoryNode(id: '1-2-1', name: 'iOS', level: 3),
              IndustryCategoryNode(id: '1-2-2', name: 'Android', level: 3),
              IndustryCategoryNode(id: '1-2-3', name: 'Flutter', level: 3),
            ],
          ),
        ],
      ),
      IndustryCategoryNode(
        id: '2',
        name: '设计',
        level: 1,
        children: [
          IndustryCategoryNode(id: '2-1', name: 'UI设计', level: 2),
          IndustryCategoryNode(id: '2-2', name: 'UX设计', level: 2),
        ],
      ),
    ];
  }

  /// 获取形式分类
  static List<FormatCategory> getFormatCategories() {
    return [
      const FormatCategory(id: '1', name: '直播课'),
      const FormatCategory(id: '2', name: '录播课'),
      const FormatCategory(id: '3', name: '音频课'),
      const FormatCategory(id: '4', name: '图文课'),
    ];
  }

  /// 获取类型分类
  static List<TypeCategory> getTypeCategories() {
    return [
      const TypeCategory(id: '1', name: '单课'),
      const TypeCategory(id: '2', name: '系列课'),
      const TypeCategory(id: '3', name: '会员专享'),
    ];
  }

  // ==================== 辅助方法 ====================

  static List<String> _generateSpecialties(int index) {
    final specialties = <String>[];
    if (index % 3 == 0) specialties.add('Python');
    if (index % 3 == 1) specialties.add('Java');
    if (index % 3 == 2) specialties.add('JavaScript');
    if (index % 2 == 0) specialties.add('人工智能');
    if (index % 2 != 0) specialties.add('移动开发');
    return specialties;
  }

  // ==================== 模拟数据 ====================

  static List<Course> _getAllCourses() {
    final now = DateTime.now();

    return [
      Course(
        id: '1',
        title: 'Python 全栈开发实战',
        description: '从零开始学习 Python，掌握 Web 开发技能',
        coverUrl: 'https://via.placeholder.com/400x300',
        instructorId: 'instructor_0',
        instructorName: '讲师1',
        categoryId: '1-1',
        formatId: '2',
        typeId: '2',
        price: 29900,
        originalPrice: 49900,
        studentCount: 1234,
        rating: 4.8,
        ratingCount: 456,
        status: CourseStatus.published,
        createTime: now.subtract(const Duration(days: 30)),
        updateTime: now.subtract(const Duration(days: 5)),
      ),
      Course(
        id: '2',
        title: 'Java 企业级应用开发',
        description: '深入学习 Java 企业级开发技术',
        coverUrl: 'https://via.placeholder.com/400x300',
        instructorId: 'instructor_1',
        instructorName: '讲师2',
        categoryId: '1-1',
        formatId: '2',
        typeId: '2',
        price: 39900,
        originalPrice: 59900,
        studentCount: 2345,
        rating: 4.9,
        ratingCount: 678,
        status: CourseStatus.published,
        createTime: now.subtract(const Duration(days: 45)),
        updateTime: now.subtract(const Duration(days: 10)),
      ),
      Course(
        id: '3',
        title: 'Flutter 移动应用开发',
        description: '使用 Flutter 构建跨平台移动应用',
        coverUrl: 'https://via.placeholder.com/400x300',
        instructorId: 'instructor_2',
        instructorName: '讲师3',
        categoryId: '1-2',
        formatId: '1',
        typeId: '1',
        price: 19900,
        originalPrice: 29900,
        studentCount: 890,
        rating: 4.7,
        ratingCount: 234,
        status: CourseStatus.published,
        createTime: now.subtract(const Duration(days: 20)),
        updateTime: now.subtract(const Duration(days: 3)),
      ),
      Course(
        id: '4',
        title: '机器学习入门与实践',
        description: '系统学习机器学习核心算法',
        coverUrl: 'https://via.placeholder.com/400x300',
        instructorId: 'instructor_3',
        instructorName: '讲师4',
        categoryId: '1-1',
        formatId: '2',
        typeId: '2',
        price: 49900,
        originalPrice: 79900,
        studentCount: 1567,
        rating: 4.8,
        ratingCount: 567,
        status: CourseStatus.published,
        createTime: now.subtract(const Duration(days: 60)),
        updateTime: now.subtract(const Duration(days: 15)),
      ),
      Course(
        id: '5',
        title: 'UI/UX 设计基础',
        description: '学习用户界面和用户体验设计',
        coverUrl: 'https://via.placeholder.com/400x300',
        instructorId: 'instructor_4',
        instructorName: '讲师5',
        categoryId: '2-1',
        formatId: '2',
        typeId: '1',
        price: 24900,
        originalPrice: 39900,
        studentCount: 678,
        rating: 4.6,
        ratingCount: 189,
        status: CourseStatus.published,
        createTime: now.subtract(const Duration(days: 25)),
        updateTime: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}
