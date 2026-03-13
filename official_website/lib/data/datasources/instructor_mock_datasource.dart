import 'package:official_website/domain/entities/instructor.dart';

/// 讲师模拟数据源
///
/// 所有假数据集中管理，方便替换为真实 API
class InstructorMockDatasource {
  /// 获取讲师列表
  static List<Instructor> getInstructors({
    int page = 1,
    int pageSize = 10,
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  }) {
    // 返回分页数据
    final allInstructors = _getAllInstructors();

    // 应用筛选
    var filteredInstructors = allInstructors;

    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      filteredInstructors = filteredInstructors
          .where((i) =>
              i.name.toLowerCase().contains(searchKeyword.toLowerCase()) ||
              i.bio.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }

    if (filterSubject != null && filterSubject.isNotEmpty) {
      filteredInstructors = filteredInstructors
          .where((i) => i.subjects.any((s) => s.contains(filterSubject!)))
          .toList();
    }

    if (filterStatus != null) {
      filteredInstructors =
          filteredInstructors.where((i) => i.status == filterStatus).toList();
    }

    // 分页
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= filteredInstructors.length) {
      return [];
    }

    return filteredInstructors.sublist(
      start,
      end.clamp(0, filteredInstructors.length),
    );
  }

  /// 搜索讲师
  static List<Instructor> searchInstructors(String keyword) {
    return getInstructors(searchKeyword: keyword);
  }

  /// 获取讲师总数
  static int getInstructorCount({
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  }) {
    return getInstructors(
      searchKeyword: searchKeyword,
      filterSubject: filterSubject,
      filterStatus: filterStatus,
    ).length;
  }

  /// 获取单个讲师详情
  static Instructor? getInstructorById(String id) {
    return _getAllInstructors().firstWhere(
      (i) => i.id == id,
      orElse: () => throw StateError("Value not found"), // 会抛出异常，调用方需要处理
    );
  }

  // ==================== 模拟数据 ====================

  static List<Instructor> _getAllInstructors() {
    final now = DateTime.now();

    return [
      Instructor(
        id: '1',
        name: '张三',
        avatar: 'https://via.placeholder.com/150',
        bio: '资深Python讲师，10年开发经验，擅长Python全栈开发、人工智能应用开发。',
        subjects: ['计算机', 'Python', '人工智能'],
        registerTime: now.subtract(const Duration(days: 365)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 1234,
        followerCount: 5678,
        averageRating: 4.8,
      ),
      Instructor(
        id: '2',
        name: '李四',
        avatar: 'https://via.placeholder.com/150',
        bio: 'Java高级工程师，专注于企业级应用开发，拥有丰富的架构设计经验。',
        subjects: ['计算机', 'Java', 'Web开发'],
        registerTime: now.subtract(const Duration(days: 300)),
        status: InstructorStatus.busy,
        cooperationMode: CooperationMode.lease,
        studentCount: 2567,
        followerCount: 8234,
        averageRating: 4.9,
      ),
      Instructor(
        id: '3',
        name: '王五',
        avatar: 'https://via.placeholder.com/150',
        bio: '前端开发专家，精通React、Vue等主流框架。',
        subjects: ['计算机', '前端开发', 'React'],
        registerTime: now.subtract(const Duration(days: 200)),
        status: InstructorStatus.offline,
        cooperationMode: CooperationMode.partner,
        studentCount: 3890,
        followerCount: 12000,
        averageRating: 4.7,
      ),
      Instructor(
        id: '4',
        name: '赵六',
        avatar: 'https://via.placeholder.com/150',
        bio: '移动开发专家，专注于iOS和Android双平台开发。',
        subjects: ['移动开发', 'iOS', 'Android'],
        registerTime: now.subtract(const Duration(days: 150)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 2100,
        followerCount: 6500,
        averageRating: 4.6,
      ),
      Instructor(
        id: '5',
        name: '孙七',
        avatar: 'https://via.placeholder.com/150',
        bio: '数据科学专家，擅长机器学习和数据分析。',
        subjects: ['数据科学', '机器学习', 'Python'],
        registerTime: now.subtract(const Duration(days: 100)),
        status: InstructorStatus.busy,
        cooperationMode: CooperationMode.lease,
        studentCount: 1800,
        followerCount: 4200,
        averageRating: 4.8,
      ),
    ];
  }
}
