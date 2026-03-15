import 'package:flutter/material.dart';
import 'instructor.dart';

/// 讲师管理总览页面
class InstructorManagementPage extends StatefulWidget {
  const InstructorManagementPage({super.key});

  @override
  State<InstructorManagementPage> createState() => _InstructorManagementPageState();
}

class _InstructorManagementPageState extends State<InstructorManagementPage> {
  // 搜索关键词
  String _searchKeyword = '';

  // 筛选条件
  String? _filterSubject;
  InstructorStatus? _filterStatus;
  CooperationMode? _filterMode;

  // 排序方式
  String _sortBy = 'registerTime';
  bool _sortAscending = false;

  // 分页
  int _currentPage = 1;
  final int _pageSize = 10;

  // 讲师列表
  List<Instructor> _instructors = [];

  // 待审核申请列表
  List<Map<String, dynamic>> _pendingApplications = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultData();
  }

  /// 加载默认数据
  void _loadDefaultData() {
    final now = DateTime.now();

    _instructors = [
      // 计算机类
      Instructor(
        id: '1',
        name: '张三',
        avatar: 'https://via.placeholder.com/150',
        bio: '资深Python讲师，10年开发经验，擅长Python全栈开发、人工智能应用开发。曾服务过多家知名企业，累计培训学员超过1200人。',
        subjects: ['计算机', 'Python', '人工智能'],
        registerTime: now.subtract(const Duration(days: 365)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 1234,
        followerCount: 5678,
        questionAnswerRate: 0.92,
        courseLikeRate: 0.87,
        courseShareRate: 0.65,
        averageRating: 4.8,
        courseStats: const CourseStatistics(
          singleCourses: 12,
          seriesCourses: 8,
          videoCourses: 5,
          liveReplays: 3,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 2100,
          monthlyRevenue: 8900,
          quarterlyRevenue: 26700,
          totalRevenue: 156000,
        ),
        reservedCourseCount: 5,
        completedCourseCount: 23,
        lastLoginTime: now.subtract(const Duration(minutes: 10)),
        qualifications: [
          QualificationCertificate(
            id: 'cert_1_1',
            name: 'Python高级开发工程师认证',
            imageUrl: 'https://via.placeholder.com/300x200',
            issuingOrganization: '中国软件行业协会',
            issueDate: now.subtract(const Duration(days: 1825)),
            expiryDate: now.add(const Duration(days: 365)),
            certificateNumber: 'PY2020100123',
          ),
          QualificationCertificate(
            id: 'cert_1_2',
            name: '人工智能算法专家认证',
            imageUrl: 'https://via.placeholder.com/300x200',
            issuingOrganization: '国际人工智能联盟',
            issueDate: now.subtract(const Duration(days: 730)),
            expiryDate: null, // 永久有效
            certificateNumber: 'AI2022001456',
          ),
        ],
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
        questionAnswerRate: 0.88,
        courseLikeRate: 0.91,
        courseShareRate: 0.72,
        averageRating: 4.9,
        courseStats: const CourseStatistics(
          singleCourses: 15,
          seriesCourses: 20,
          videoCourses: 7,
          liveReplays: 3,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 3800,
          monthlyRevenue: 15000,
          quarterlyRevenue: 45000,
          totalRevenue: 280000,
        ),
        reservedCourseCount: 8,
        completedCourseCount: 37,
        lastLoginTime: now.subtract(const Duration(minutes: 30)),
        qualifications: [
          QualificationCertificate(
            id: 'cert_2_1',
            name: 'Oracle认证大师',
            imageUrl: 'https://via.placeholder.com/300x200',
            issuingOrganization: 'Oracle公司',
            issueDate: now.subtract(const Duration(days: 1460)),
            expiryDate: now.subtract(const Duration(days: 30)), // 已过期
            certificateNumber: 'OCM2019888',
          ),
        ],
      ),
      Instructor(
        id: '3',
        name: '王五',
        avatar: 'https://via.placeholder.com/150',
        bio: '前端开发专家，精通React、Vue等主流框架，擅长大型SPA应用开发。',
        subjects: ['计算机', '前端开发', 'React'],
        registerTime: now.subtract(const Duration(days: 200)),
        status: InstructorStatus.offline,
        cooperationMode: CooperationMode.partner,
        studentCount: 3890,
        followerCount: 12000,
        questionAnswerRate: 0.85,
        courseLikeRate: 0.89,
        courseShareRate: 0.68,
        averageRating: 4.7,
        courseStats: const CourseStatistics(
          singleCourses: 8,
          seriesCourses: 15,
          videoCourses: 10,
          liveReplays: 2,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 4500,
          monthlyRevenue: 18000,
          quarterlyRevenue: 54000,
          totalRevenue: 320000,
        ),
        reservedCourseCount: 3,
        completedCourseCount: 35,
        lastLoginTime: now.subtract(const Duration(hours: 2)),
      ),

      // 心理学类
      Instructor(
        id: '4',
        name: '赵六',
        avatar: 'https://via.placeholder.com/150',
        bio: '国家二级心理咨询师，专注心理健康领域，擅长情绪管理与压力疏导。',
        subjects: ['心理学', '心理健康'],
        registerTime: now.subtract(const Duration(days: 400)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 890,
        followerCount: 3456,
        questionAnswerRate: 0.95,
        courseLikeRate: 0.93,
        courseShareRate: 0.58,
        averageRating: 4.8,
        courseStats: const CourseStatistics(
          singleCourses: 6,
          seriesCourses: 4,
          videoCourses: 2,
          liveReplays: 1,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 1200,
          monthlyRevenue: 5600,
          quarterlyRevenue: 16800,
          totalRevenue: 89000,
        ),
        reservedCourseCount: 2,
        completedCourseCount: 11,
        lastLoginTime: now.subtract(const Duration(minutes: 5)),
      ),
      Instructor(
        id: '5',
        name: '钱七',
        avatar: 'https://via.placeholder.com/150',
        bio: '心理学博士，专注于恋爱心理学和人际关系心理学的研究与教学。',
        subjects: ['心理学', '恋爱心理学'],
        registerTime: now.subtract(const Duration(days: 150)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 1567,
        followerCount: 6789,
        questionAnswerRate: 0.90,
        courseLikeRate: 0.88,
        courseShareRate: 0.62,
        averageRating: 4.6,
        courseStats: const CourseStatistics(
          singleCourses: 8,
          seriesCourses: 6,
          videoCourses: 3,
          liveReplays: 2,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 2800,
          monthlyRevenue: 11200,
          quarterlyRevenue: 33600,
          totalRevenue: 156000,
        ),
        reservedCourseCount: 4,
        completedCourseCount: 19,
        lastLoginTime: now.subtract(const Duration(minutes: 20)),
      ),

      // 美食类
      Instructor(
        id: '6',
        name: '孙八',
        avatar: 'https://via.placeholder.com/150',
        bio: '国家一级厨师，精通川菜、湘菜等八大菜系，拥有20年烹饪经验。',
        subjects: ['美食', '中餐', '川菜'],
        registerTime: now.subtract(const Duration(days: 500)),
        status: InstructorStatus.busy,
        cooperationMode: CooperationMode.lease,
        studentCount: 2345,
        followerCount: 9876,
        questionAnswerRate: 0.87,
        courseLikeRate: 0.92,
        courseShareRate: 0.70,
        averageRating: 4.7,
        courseStats: const CourseStatistics(
          singleCourses: 10,
          seriesCourses: 12,
          videoCourses: 6,
          liveReplays: 2,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 3200,
          monthlyRevenue: 12800,
          quarterlyRevenue: 38400,
          totalRevenue: 210000,
        ),
        reservedCourseCount: 6,
        completedCourseCount: 28,
        lastLoginTime: now.subtract(const Duration(minutes: 15)),
      ),
      Instructor(
        id: '7',
        name: '周九',
        avatar: 'https://via.placeholder.com/150',
        bio: '西餐资深厨师，毕业于法国蓝带厨艺学院，擅长法式西餐和烘焙。',
        subjects: ['美食', '西餐', '烘焙'],
        registerTime: now.subtract(const Duration(days: 250)),
        status: InstructorStatus.offline,
        cooperationMode: CooperationMode.partner,
        studentCount: 1876,
        followerCount: 7654,
        questionAnswerRate: 0.82,
        courseLikeRate: 0.86,
        courseShareRate: 0.64,
        averageRating: 4.8,
        courseStats: const CourseStatistics(
          singleCourses: 7,
          seriesCourses: 9,
          videoCourses: 4,
          liveReplays: 1,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 1900,
          monthlyRevenue: 7600,
          quarterlyRevenue: 22800,
          totalRevenue: 134000,
        ),
        reservedCourseCount: 3,
        completedCourseCount: 20,
        lastLoginTime: now.subtract(const Duration(hours: 5)),
      ),

      // 设计类
      Instructor(
        id: '8',
        name: '吴十',
        avatar: 'https://via.placeholder.com/150',
        bio: 'UI/UX设计专家，曾获多项国际设计大奖，擅长用户体验设计和交互设计。',
        subjects: ['设计', 'UI设计'],
        registerTime: now.subtract(const Duration(days: 180)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 3456,
        followerCount: 15678,
        questionAnswerRate: 0.93,
        courseLikeRate: 0.95,
        courseShareRate: 0.75,
        averageRating: 4.9,
        courseStats: const CourseStatistics(
          singleCourses: 9,
          seriesCourses: 11,
          videoCourses: 5,
          liveReplays: 2,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 4200,
          monthlyRevenue: 16800,
          quarterlyRevenue: 50400,
          totalRevenue: 298000,
        ),
        reservedCourseCount: 5,
        completedCourseCount: 27,
        lastLoginTime: now.subtract(const Duration(minutes: 3)),
      ),
      Instructor(
        id: '9',
        name: '郑十一',
        avatar: 'https://via.placeholder.com/150',
        bio: '平面设计师，精通Photoshop、Illustrator等设计软件，擅长品牌视觉设计。',
        subjects: ['设计', '平面设计'],
        registerTime: now.subtract(const Duration(days: 120)),
        status: InstructorStatus.online,
        cooperationMode: CooperationMode.partner,
        studentCount: 2789,
        followerCount: 11234,
        questionAnswerRate: 0.89,
        courseLikeRate: 0.91,
        courseShareRate: 0.69,
        averageRating: 4.7,
        courseStats: const CourseStatistics(
          singleCourses: 11,
          seriesCourses: 8,
          videoCourses: 4,
          liveReplays: 1,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 3600,
          monthlyRevenue: 14400,
          quarterlyRevenue: 43200,
          totalRevenue: 256000,
        ),
        reservedCourseCount: 4,
        completedCourseCount: 24,
        lastLoginTime: now.subtract(const Duration(minutes: 25)),
      ),

      // 营销类
      Instructor(
        id: '10',
        name: '陈十二',
        avatar: 'https://via.placeholder.com/150',
        bio: '数字营销专家，精通SEO、SEM、社交媒体营销等，帮助企业提升品牌影响力。',
        subjects: ['营销', '数字营销'],
        registerTime: now.subtract(const Duration(days: 220)),
        status: InstructorStatus.busy,
        cooperationMode: CooperationMode.lease,
        studentCount: 4321,
        followerCount: 18765,
        questionAnswerRate: 0.86,
        courseLikeRate: 0.88,
        courseShareRate: 0.71,
        averageRating: 4.8,
        courseStats: const CourseStatistics(
          singleCourses: 13,
          seriesCourses: 14,
          videoCourses: 6,
          liveReplays: 2,
        ),
        revenueStats: const RevenueStatistics(
          weeklyRevenue: 4800,
          monthlyRevenue: 19200,
          quarterlyRevenue: 57600,
          totalRevenue: 340000,
        ),
        reservedCourseCount: 7,
        completedCourseCount: 32,
        lastLoginTime: now.subtract(const Duration(minutes: 45)),
      ),
    ];

    // 待审核申请数据
    _pendingApplications = [
      {
        'id': 'app_1',
        'name': '小明',
        'avatar': 'https://via.placeholder.com/150',
        'bio': '热爱编程的全栈开发者，擅长Vue.js和Node.js开发，拥有5年一线开发经验，曾参与多个大型Web项目。希望通过分享实战经验，帮助更多开发者快速成长。',
        'subjects': ['计算机', 'Web开发'],
        'applyTime': now.subtract(const Duration(hours: 3)),
        'cooperationMode': CooperationMode.partner,
        'phone': '13800138000',
        'email': 'xiaoming@example.com',
        'qualifications': [
          {
            'id': 'cert_1_1',
            'name': '全栈工程师认证',
            'imageUrl': 'https://via.placeholder.com/300x200',
            'issuingOrganization': '中国信息技术认证中心',
            'issueDate': now.subtract(const Duration(days: 730)),
            'expiryDate': now.add(const Duration(days: 365)),
            'certificateNumber': 'IT2020123456',
          },
          {
            'id': 'cert_1_2',
            'name': '前端开发高级证书',
            'imageUrl': 'https://via.placeholder.com/300x200',
            'issuingOrganization': '工信部',
            'issueDate': now.subtract(const Duration(days: 365)),
            'expiryDate': null, // 永久有效
            'certificateNumber': 'FE2021987654',
          },
        ],
      },
      {
        'id': 'app_2',
        'name': '小红',
        'avatar': 'https://via.placeholder.com/150',
        'bio': '专业瑜伽教练，10年教学经验，擅长哈他瑜伽和流瑜伽。曾在多家知名瑜伽会所任职，累计教学超过5000小时。持有国际瑜伽联盟认证资格。',
        'subjects': ['运动', '瑜伽'],
        'applyTime': now.subtract(const Duration(days: 1)),
        'cooperationMode': CooperationMode.lease,
        'phone': '13900139000',
        'email': 'xiaohong@example.com',
        'qualifications': [
          {
            'id': 'cert_2_1',
            'name': '瑜伽联盟高级教练认证',
            'imageUrl': 'https://via.placeholder.com/300x200',
            'issuingOrganization': '国际瑜伽联盟',
            'issueDate': now.subtract(const Duration(days: 1825)),
            'expiryDate': now.add(const Duration(days: 365)),
            'certificateNumber': 'YA2019111122',
          },
        ],
      },
    ];
  }

  /// 获取筛选后的讲师列表
  List<Instructor> get _filteredInstructors {
    var result = _instructors.toList();

    // 搜索过滤
    if (_searchKeyword.isNotEmpty) {
      result = result.where((instructor) {
        return instructor.name.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
            instructor.subjects.any((s) => s.toLowerCase().contains(_searchKeyword.toLowerCase()));
      }).toList();
    }

    // 学科过滤
    if (_filterSubject != null) {
      result = result.where((instructor) => instructor.subjects.contains(_filterSubject!)).toList();
    }

    // 状态过滤
    if (_filterStatus != null) {
      result = result.where((instructor) => instructor.status == _filterStatus).toList();
    }

    // 模式过滤
    if (_filterMode != null) {
      result = result.where((instructor) => instructor.cooperationMode == _filterMode).toList();
    }

    // 排序
    result = _sortInstructors(result);

    return result;
  }

  /// 排序讲师列表
  List<Instructor> _sortInstructors(List<Instructor> instructors) {
    switch (_sortBy) {
      case 'registerTime':
        instructors.sort((a, b) => _sortAscending
            ? a.registerTime.compareTo(b.registerTime)
            : b.registerTime.compareTo(a.registerTime));
        break;
      case 'studentCount':
        instructors.sort((a, b) => _sortAscending
            ? a.studentCount.compareTo(b.studentCount)
            : b.studentCount.compareTo(a.studentCount));
        break;
      case 'followerCount':
        instructors.sort((a, b) => _sortAscending
            ? a.followerCount.compareTo(b.followerCount)
            : b.followerCount.compareTo(a.followerCount));
        break;
      case 'revenue':
        instructors.sort((a, b) => _sortAscending
            ? a.revenueStats.monthlyRevenue.compareTo(b.revenueStats.monthlyRevenue)
            : b.revenueStats.monthlyRevenue.compareTo(a.revenueStats.monthlyRevenue));
        break;
      case 'rating':
        instructors.sort((a, b) => _sortAscending
            ? a.averageRating.compareTo(b.averageRating)
            : b.averageRating.compareTo(a.averageRating));
        break;
    }
    return instructors;
  }

  /// 获取当前页的讲师列表
  List<Instructor> get _currentPageInstructors {
    final filtered = _filteredInstructors;
    final start = (_currentPage - 1) * _pageSize;
    final end = start + _pageSize;

    if (start >= filtered.length) return [];
    if (end > filtered.length) return filtered.sublist(start);
    return filtered.sublist(start, end);
  }

  /// 获取总页数
  int get _totalPages {
    return (_filteredInstructors.length / _pageSize).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索筛选区
        _buildSearchArea(),

        const SizedBox(height: 24),

        // 讲师列表表格
        Expanded(
          child: _buildInstructorTable(),
        ),
      ],
    );
  }

  /// 构建搜索筛选区
  Widget _buildSearchArea() {
    return Container(
      width: 1200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '讲师管理',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
              Row(
                children: [
                  // 审核申请按钮
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showPendingApplications(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.pending_actions, size: 16, color: Colors.white),
                            const SizedBox(width: 6),
                            const Text(
                              '审核申请',
                              style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_pendingApplications.length}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFFFF7A00), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 新增讲师按钮
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _addInstructor(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              '新增讲师',
                              style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          const SizedBox(height: 20),

          // 搜索框
          Row(
            children: [
              const Icon(Icons.search, size: 20, color: Color(0xFF999999)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '搜索讲师姓名或学科关键词',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                      _currentPage = 1;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 筛选条件
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // 学科筛选
              _buildFilterDropdown(
                label: '🏷️ 学科',
                value: _filterSubject ?? '全部',
                items: ['全部', '计算机', '心理学', '美食', '设计', '营销'],
                onChanged: (value) {
                  setState(() {
                    _filterSubject = value == '全部' ? null : value;
                    _currentPage = 1;
                  });
                },
              ),

              // 状态筛选
              _buildFilterDropdown(
                label: '📱 状态',
                value: _filterStatus?.label ?? '全部',
                items: ['全部', '在线', '忙碌', '离线'],
                onChanged: (value) {
                  setState(() {
                    _filterStatus = value == '全部' ? null : InstructorStatus.values.firstWhere(
                      (e) => e.label == value,
                      orElse: () => InstructorStatus.offline,
                    );
                    _currentPage = 1;
                  });
                },
              ),

              // 模式筛选
              _buildFilterDropdown(
                label: '🤝 模式',
                value: _filterMode?.label ?? '全部',
                items: ['全部', '合作模式', '租赁模式'],
                onChanged: (value) {
                  setState(() {
                    _filterMode = value == '全部' ? null : CooperationMode.values.firstWhere(
                      (e) => e.label == value,
                      orElse: () => CooperationMode.partner,
                    );
                    _currentPage = 1;
                  });
                },
              ),

              // 排序
              _buildFilterDropdown(
                label: '📊 排序',
                value: _getSortLabel(),
                items: ['注册时间', '学生数', '关注数', '收入', '评分'],
                onChanged: (value) {
                  setState(() {
                    // 如果点击的是当前排序字段，则切换升降序
                    if (_sortBy == _getSortValue(value)) {
                      _sortAscending = !_sortAscending;
                    } else {
                      _sortBy = _getSortValue(value);
                      _sortAscending = false; // 新字段默认降序
                    }
                    _currentPage = 1;
                  });
                },
                showArrow: true, // 显示箭头
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建筛选下拉框
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    bool showArrow = false,
  }) {
    // 如果是排序下拉框且需要显示箭头
    final displayLabel = showArrow ? _getSortLabelWithArrow() : label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(displayLabel, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              style: const TextStyle(color: Color(0xFF1F2329)),
            ),
          ),
        ),
      ],
    );
  }

  /// 获取排序标签
  String _getSortLabel() {
    switch (_sortBy) {
      case 'registerTime':
        return '注册时间';
      case 'studentCount':
        return '学生数';
      case 'followerCount':
        return '关注数';
      case 'revenue':
        return '收入';
      case 'rating':
        return '评分';
      default:
        return '注册时间';
    }
  }

  /// 获取排序标签（带箭头）
  String _getSortLabelWithArrow() {
    final label = _getSortLabel();
    return '$label${_sortAscending ? '↑' : '↓'}';
  }

  /// 获取排序值
  String _getSortValue(String label) {
    if (label.contains('注册时间')) return 'registerTime';
    if (label.contains('学生数')) return 'studentCount';
    if (label.contains('关注数')) return 'followerCount';
    if (label.contains('收入')) return 'revenue';
    if (label.contains('评分')) return 'rating';
    return 'registerTime';
  }

  /// 构建讲师列表表格
  Widget _buildInstructorTable() {
    final instructors = _currentPageInstructors;

    if (instructors.isEmpty) {
      return const Center(
        child: Text(
          '暂无讲师数据',
          style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
        ),
      );
    }

    return Container(
      width: 1200,
      constraints: const BoxConstraints(maxHeight: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: instructors.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE5E5E5)),
              itemBuilder: (context, index) {
                return _buildInstructorRow(instructors[index]);
              },
            ),
          ),

          // 分页
          _buildPagination(),
        ],
      ),
    );
  }

  /// 构建表头
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 50, child: Text('头像', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 85, child: Text('姓名', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 160, child: Text('学科', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('状态', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('模式', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('学生数', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('关注数', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('课程数', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 95, child: Text('本月收入', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 80, child: Text('评分', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          SizedBox(width: 125, child: Text('操作', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
        ],
      ),
    );
  }

  /// 构建讲师行
  Widget _buildInstructorRow(Instructor instructor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // 第1行：基本信息
            Row(
              children: [
                // 头像
                SizedBox(
                  width: 50,
                  child: _buildAvatar(instructor.avatar, instructor.name),
                ),

                // 姓名
                SizedBox(
                  width: 85,
                  child: Text(
                    instructor.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 学科标签
                SizedBox(
                  width: 160,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _buildSubjectTags(instructor.subjects),
                  ),
                ),

                // 状态
                SizedBox(
                  width: 80,
                  child: _buildStatusIndicator(instructor.status),
                ),

                // 模式
                SizedBox(
                  width: 80,
                  child: _buildModeIndicator(instructor.cooperationMode),
                ),

                // 学生数
                SizedBox(
                  width: 80,
                  child: Text(
                    _formatNumber(instructor.studentCount),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 关注数
                SizedBox(
                  width: 80,
                  child: Text(
                    _formatNumber(instructor.followerCount),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 课程数
                SizedBox(
                  width: 80,
                  child: Text(
                    '${instructor.courseStats.total}门',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                  ),
                ),

                // 收入
                SizedBox(
                  width: 95,
                  child: Text(
                    '¥${_formatRevenue(instructor.revenueStats.monthlyRevenue)}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329), fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // 评分
                SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Color(0xFFFFB400)),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          instructor.averageRating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                        ),
                      ),
                    ],
                  ),
                ),

                // 操作
                SizedBox(
                  width: 125,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton('详情', onPressed: () => _showDetailDialog(instructor)),
                      const SizedBox(width: 1),
                      _buildActionButton('编辑', onPressed: () => _editInstructor(instructor)),
                      const SizedBox(width: 1),
                      _buildActionButton('删除', isDestructive: true, onPressed: () => _deleteInstructor(instructor)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // 第2行：课程详情
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Text(
                    '课程详情: 单课${instructor.courseStats.singleCourses} 套课${instructor.courseStats.seriesCourses} 视频${instructor.courseStats.videoCourses} 直播${instructor.courseStats.liveReplays}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建学科标签
  List<Widget> _buildSubjectTags(List<String> subjects) {
    const maxShow = 2;
    final showSubjects = subjects.take(maxShow).toList();
    final remaining = subjects.length - maxShow;

    return [
      ...showSubjects.map((subject) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF1A9B8E), width: 0.5),
        ),
        child: Text(
          subject,
          style: const TextStyle(fontSize: 12, color: Color(0xFF1A9B8E)),
        ),
      )),
      if (remaining > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF999999).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF999999), width: 0.5),
          ),
          child: Text(
            '+$remaining',
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
        ),
    ];
  }

  /// 构建头像（带错误处理）
  Widget _buildAvatar(String avatarUrl, String name) {
    return Center(
      child: CircleAvatar(
        radius: 20,
        child: ClipOval(
          child: avatarUrl.isEmpty
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              : Image.network(
                  avatarUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cacheWidth: 200,
                  cacheHeight: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.withValues(alpha: 0.3),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// 构建状态指示器
  Widget _buildStatusIndicator(InstructorStatus status) {
    Color color;
    String label;

    switch (status) {
      case InstructorStatus.online:
        color = const Color(0xFF52C41A);
        label = '在线';
        break;
      case InstructorStatus.busy:
        color = const Color(0xFFFF4D4F);
        label = '忙碌';
        break;
      case InstructorStatus.offline:
        color = const Color(0xFFD9D9D9);
        label = '离线';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  /// 构建模式指示器
  Widget _buildModeIndicator(CooperationMode mode) {
    final color = mode == CooperationMode.partner ? const Color(0xFF1890FF) : const Color(0xFFFF7A00);
    final label = mode.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(String label, {bool isDestructive = false, required VoidCallback onPressed}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isDestructive ? const Color(0xFFFF4D4F) : const Color(0xFF1A9B8E),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// 构建分页
  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '共 ${_filteredInstructors.length} 位讲师',
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Row(
            children: [
              // 上一页
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),

              // 页码
              ...List.generate(_totalPages, (index) => index + 1).take(5).map((page) {
                final isActive = page == _currentPage;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF1A9B8E) : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isActive ? const Color(0xFF1A9B8E) : const Color(0xFFD9D9D9),
                        ),
                      ),
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 14,
                          color: isActive ? Colors.white : const Color(0xFF1F2329),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              if (_totalPages > 5)
                const Text(
                  '...',
                  style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                ),

              // 下一页
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < _totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 显示详情弹窗
  void _showDetailDialog(Instructor instructor) {
    showDialog(
      context: context,
      builder: (context) => _InstructorDetailDialog(instructor: instructor),
    );
  }

  /// 编辑讲师
  void _editInstructor(Instructor instructor) {
    // TODO: 实现编辑功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('编辑讲师: ${instructor.name}')),
    );
  }

  /// 删除讲师
  void _deleteInstructor(Instructor instructor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 确认删除'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除讲师"${instructor.name}"吗？'),
            const SizedBox(height: 16),
            const Text('⚠️ 注意：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• 该讲师名下有 ${instructor.courseStats.total} 门课程'),
            Text('• 该讲师有 ${_formatNumber(instructor.studentCount)} 名学员'),
            const Text('• 删除后相关数据将保留，但讲师信息将被清空'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _instructors.removeWhere((i) => i.id == instructor.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('讲师"${instructor.name}"已删除')),
              );
            },
            child: const Text('确认删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 新增讲师
  void _addInstructor() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '新增讲师',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 表单内容
              Expanded(
                child: _AddInstructorForm(
                  onSubmit: (name, avatar, bio, subjects, cooperationMode) {
                    setState(() {
                      _instructors.insert(0, Instructor(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        avatar: avatar,
                        bio: bio,
                        subjects: subjects,
                        registerTime: DateTime.now(),
                        status: InstructorStatus.offline,
                        cooperationMode: cooperationMode,
                      ));
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ 已成功添加讲师：$name'),
                        backgroundColor: const Color(0xFF52C41A),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示申请详情
  void _showApplicationDetail(Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 900,
          constraints: const BoxConstraints(maxHeight: 800),
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '申请详情 - ${application['name']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 详情内容
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 基本信息
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.network(
                                application['avatar'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                cacheWidth: 200,
                                cacheHeight: 200,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      application['name'],
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF7A00).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFFF7A00), width: 0.5),
                                      ),
                                      child: Text(
                                        (application['cooperationMode'] as CooperationMode).label,
                                        style: const TextStyle(fontSize: 13, color: Color(0xFFFF7A00)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 16,
                                  children: [
                                    Text(
                                      '📱 ${application['phone']}',
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                    ),
                                    Text(
                                      '✉️ ${application['email']}',
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 个人简介
                      const Text(
                        '📝 个人简介',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          application['bio'],
                          style: const TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 学科标签
                      const Text(
                        '🏷️ 学科标签',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (application['subjects'] as List<String>).map((subject) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF1A9B8E), width: 0.5),
                          ),
                          child: Text(
                            subject,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF1A9B8E)),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 24),

                      // 资质证书
                      const Text(
                        '📜 资质证书',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      const SizedBox(height: 12),
                      if (application['qualifications'] != null && (application['qualifications'] as List).isNotEmpty)
                        Column(
                          children: (application['qualifications'] as List<Map<String, dynamic>>).map((cert) {
                            final issueDate = cert['issueDate'] as DateTime;
                            final expiryDate = cert['expiryDate'] as DateTime?;
                            final isExpired = expiryDate != null && DateTime.now().isAfter(expiryDate);
                            final isExpiringSoon = expiryDate != null && !isExpired && expiryDate.difference(DateTime.now()).inDays <= 30;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE5E5E5)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 证书图片
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      cert['imageUrl'],
                                      width: 150,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 150,
                                          height: 100,
                                          color: const Color(0xFFE5E5E5),
                                          child: const Icon(Icons.broken_image, size: 40, color: Color(0xFF999999)),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 证书信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cert['name'],
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '颁发机构：${cert['issuingOrganization']}',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '证书编号：${cert['certificateNumber']}',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '颁发日期：${issueDate.year}年${issueDate.month}月${issueDate.day}日',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                                        ),
                                        if (expiryDate != null) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '有效期至：${expiryDate.year}年${expiryDate.month}月${expiryDate.day}日',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isExpired ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
                                                ),
                                              ),
                                              if (isExpiringSoon) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFF7A00).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: const Color(0xFFFF7A00)),
                                                  ),
                                                  child: const Text(
                                                    '即将过期',
                                                    style: TextStyle(fontSize: 11, color: Color(0xFFFF7A00)),
                                                  ),
                                                ),
                                              ],
                                              if (isExpired) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: const Color(0xFFFF4D4F)),
                                                  ),
                                                  child: const Text(
                                                    '已过期',
                                                    style: TextStyle(fontSize: 11, color: Color(0xFFFF4D4F)),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const Text(
                          '暂无资质证书',
                          style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                        ),
                      const SizedBox(height: 24),

                      // 操作按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('关闭'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _approveApplication(application);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A9B8E),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('通过申请'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示待审核申请
  void _showPendingApplications() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '讲师申请审核',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 申请列表
              Expanded(
                child: _pendingApplications.isEmpty
                    ? const Center(
                        child: Text(
                          '暂无待审核申请',
                          style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _pendingApplications.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final application = _pendingApplications[index];
                          return _buildApplicationItem(application);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建申请项
  Widget _buildApplicationItem(Map<String, dynamic> application) {
    final applyTime = application['applyTime'] as DateTime;
    final timeDiff = DateTime.now().difference(applyTime);

    String timeText;
    if (timeDiff.inHours < 1) {
      timeText = '${timeDiff.inMinutes}分钟前';
    } else if (timeDiff.inDays < 1) {
      timeText = '${timeDiff.inHours}小时前';
    } else {
      timeText = '${timeDiff.inDays}天前';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(application['avatar']),
          ),
          const SizedBox(width: 16),

          // 申请信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      application['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A00).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFF7A00), width: 0.5),
                      ),
                      child: Text(
                        (application['cooperationMode'] as CooperationMode).label,
                        style: const TextStyle(fontSize: 12, color: Color(0xFFFF7A00)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  application['bio'],
                  style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Text(
                      '📱 ${application['phone']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    Text(
                      '✉️ ${application['email']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    Text(
                      '📅 申请时间: $timeText',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: (application['subjects'] as List<String>).map((subject) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF1A9B8E), width: 0.5),
                    ),
                    child: Text(
                      subject,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF1A9B8E)),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 操作按钮
          Column(
            children: [
              // 查看详情按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _showApplicationDetail(application),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '查看详情',
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 通过按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _approveApplication(application),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '通过',
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 拒绝按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _rejectApplication(application),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4F),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '拒绝',
                      style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 通过申请
  void _approveApplication(Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ 确认通过'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要通过"${application['name']}"的讲师申请吗？'),
            const SizedBox(height: 16),
            Text(
              '通过后，该用户将成为正式讲师，${application['cooperationMode'].label}。',
              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭确认对话框
              Navigator.of(context).pop(); // 关闭审核列表对话框

              // 创建新讲师
              final newInstructor = Instructor(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: application['name'],
                avatar: application['avatar'],
                bio: application['bio'],
                subjects: List<String>.from(application['subjects']),
                registerTime: DateTime.now(),
                status: InstructorStatus.offline,
                cooperationMode: application['cooperationMode'],
              );

              setState(() {
                _instructors.insert(0, newInstructor);
                _pendingApplications.removeWhere((app) => app['id'] == application['id']);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ 已通过"${application['name']}"的讲师申请'),
                  backgroundColor: const Color(0xFF52C41A),
                ),
              );
            },
            child: const Text('确认通过', style: TextStyle(color: Color(0xFF1A9B8E))),
          ),
        ],
      ),
    );
  }

  /// 拒绝申请
  void _rejectApplication(Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('❌ 确认拒绝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要拒绝"${application['name']}"的讲师申请吗？'),
            const SizedBox(height: 16),
            const Text(
              '拒绝后，该用户可以重新提交申请。',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭确认对话框
              Navigator.of(context).pop(); // 关闭审核列表对话框

              setState(() {
                _pendingApplications.removeWhere((app) => app['id'] == application['id']);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ 已拒绝"${application['name']}"的讲师申请'),
                  backgroundColor: const Color(0xFFFF4D4F),
                ),
              );
            },
            child: const Text('确认拒绝', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 格式化数字
  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// 格式化收入
  String _formatRevenue(double revenue) {
    if (revenue >= 10000) {
      return '${(revenue / 1000).toStringAsFixed(1)}k';
    }
    return revenue.toStringAsFixed(0);
  }
}

/// 讲师详情弹窗
class _InstructorDetailDialog extends StatelessWidget {
  final Instructor instructor;

  const _InstructorDetailDialog({required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '讲师详情 - ${instructor.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2329),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 内容区（滚动）
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 基本信息
                    _buildBasicInfo(),
                    const SizedBox(height: 24),

                    // 数据概览
                    _buildDataOverview(),
                    const SizedBox(height: 24),

                    // 课程统计
                    _buildCourseStats(),
                    const SizedBox(height: 24),

                    // 资质证书
                    _buildQualifications(context),
                    const SizedBox(height: 24),

                    // 互动数据
                    _buildInteractionStats(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建基本信息区
  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '基本信息',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(instructor.avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructor.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: instructor.subjects.map((s) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s, style: const TextStyle(fontSize: 12, color: Color(0xFF1A9B8E))),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 60,
                child: Text(
                  '合作模式:',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ),
              Text(
                instructor.cooperationMode.label,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
              ),
              const SizedBox(width: 24),
              const SizedBox(
                width: 60,
                child: Text(
                  '登录状态:',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ),
              _buildStatusIndicator(instructor.status),
              const SizedBox(width: 24),
              const SizedBox(
                width: 60,
                child: Text(
                  '注册时间:',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ),
              Text(
                '${instructor.registerTime.year}-${instructor.registerTime.month.toString().padLeft(2, '0')}-${instructor.registerTime.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            instructor.bio.isEmpty ? '暂无简介' : instructor.bio,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  /// 构建状态指示器
  Widget _buildStatusIndicator(InstructorStatus status) {
    Color color;
    String label;

    switch (status) {
      case InstructorStatus.online:
        color = const Color(0xFF52C41A);
        label = '在线';
        break;
      case InstructorStatus.busy:
        color = const Color(0xFFFF4D4F);
        label = '忙碌';
        break;
      case InstructorStatus.offline:
        color = const Color(0xFFD9D9D9);
        label = '离线';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  /// 构建数据概览区
  Widget _buildDataOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '数据概览',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDataCard('👨‍🎓 学员数据', '总数', '${instructor.studentCount}', '新增', '+123')),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('❤️ 关注数据', '总数', '${instructor.followerCount}', '新增', '+456')),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('📚 课程数据', '总数', '${instructor.courseStats.total}', '本月', '+3')),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('💰 收入数据', '本月', '¥${instructor.revenueStats.monthlyRevenue.toStringAsFixed(0)}', '季度', '¥${instructor.revenueStats.quarterlyRevenue.toStringAsFixed(0)}')),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建数据卡片
  Widget _buildDataCard(String title, String label1, String value1, String label2, String value2) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label1, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
              Text(value1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label2, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
              Text(value2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A9B8E))),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建资质证书
  Widget _buildQualifications(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📜 资质证书',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
              ),
              // 添加证书按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 实现添加证书功能
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('添加证书功能开发中...')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text('添加证书', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (instructor.qualifications.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, size: 48, color: Color(0xFFD9D9D9)),
                    SizedBox(height: 12),
                    Text(
                      '暂无资质证书',
                      style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '点击"添加证书"为讲师添加资质证明',
                      style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: instructor.qualifications.map((cert) {
                final isExpired = cert.isExpired;
                final isExpiringSoon = cert.isExpiringSoon;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isExpired
                          ? const Color(0xFFFF4D4F)
                          : isExpiringSoon
                              ? const Color(0xFFFF7A00)
                              : const Color(0xFFE5E5E5),
                      width: isExpired || isExpiringSoon ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 证书图片
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cert.imageUrl,
                          width: 180,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 180,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.broken_image, size: 40, color: Color(0xFFD9D9D9)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),

                      // 证书信息
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题行：证书名称 + 操作按钮
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cert.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2329),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 查看大图按钮
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: 实现查看大图功能
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1890FF).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.visibility, size: 12, color: Color(0xFF1890FF)),
                                              SizedBox(width: 4),
                                              Text('查看', style: TextStyle(fontSize: 11, color: Color(0xFF1890FF))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // 编辑按钮
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO: 实现编辑证书功能
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('编辑证书功能开发中...')),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.edit, size: 12, color: Color(0xFF1A9B8E)),
                                              SizedBox(width: 4),
                                              Text('编辑', style: TextStyle(fontSize: 11, color: Color(0xFF1A9B8E))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // 删除按钮
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          _showDeleteCertificateDialog(context, cert);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.delete, size: 12, color: Color(0xFFFF4D4F)),
                                              SizedBox(width: 4),
                                              Text('删除', style: TextStyle(fontSize: 11, color: Color(0xFFFF4D4F))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // 证书详情
                            _buildCertDetailRow('颁发机构', cert.issuingOrganization),
                            const SizedBox(height: 6),
                            _buildCertDetailRow('证书编号', cert.certificateNumber),
                            const SizedBox(height: 6),
                            _buildCertDetailRow(
                              '颁发日期',
                              '${cert.issueDate.year}年${cert.issueDate.month}月${cert.issueDate.day}日',
                            ),

                            // 有效期
                            if (cert.expiryDate != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 70,
                                    child: Text(
                                      '有效期至',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                                    ),
                                  ),
                                  Text(
                                    '${cert.expiryDate!.year}年${cert.expiryDate!.month}月${cert.expiryDate!.day}日',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isExpired ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
                                    ),
                                  ),
                                  if (isExpiringSoon && !isExpired) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF7A00).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFFF7A00)),
                                      ),
                                      child: const Text(
                                        '即将过期',
                                        style: TextStyle(fontSize: 10, color: Color(0xFFFF7A00)),
                                      ),
                                    ),
                                  ],
                                  if (isExpired) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFFF4D4F)),
                                      ),
                                      child: const Text(
                                        '已过期',
                                        style: TextStyle(fontSize: 10, color: Color(0xFFFF4D4F)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ] else
                              const SizedBox(height: 6),
                            _buildCertDetailRow('有效期', '永久有效'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// 构建证书详情行
  Widget _buildCertDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
        ),
      ],
    );
  }

  /// 显示删除证书确认对话框
  void _showDeleteCertificateDialog(BuildContext context, QualificationCertificate cert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 确认删除'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除证书"${cert.name}"吗？'),
            const SizedBox(height: 12),
            Text(
              '证书编号：${cert.certificateNumber}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 实际删除证书
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已删除证书：${cert.name}')),
              );
            },
            child: const Text('确认删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 构建课程统计
  Widget _buildCourseStats() {
    final stats = instructor.courseStats;
    final total = stats.total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📚 课程总数: ${stats.total}门',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          _buildProgressBar('单课', stats.singleCourses, total, const Color(0xFF1890FF)),
          const SizedBox(height: 12),
          _buildProgressBar('套课', stats.seriesCourses, total, const Color(0xFF52C41A)),
          const SizedBox(height: 12),
          _buildProgressBar('视频', stats.videoCourses, total, const Color(0xFF722ED1)),
          const SizedBox(height: 12),
          _buildProgressBar('直播', stats.liveReplays, total, const Color(0xFFFA541C)),
        ],
      ),
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label: $value门', style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            Text('$percentage%', style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建互动数据
  Widget _buildInteractionStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '互动数据分析',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildProgressBar('📊 问答率', (instructor.questionAnswerRate * 100).toInt(), 100, const Color(0xFF1890FF))),
              const SizedBox(width: 16),
              Expanded(child: _buildProgressBar('👍 点赞率', (instructor.courseLikeRate * 100).toInt(), 100, const Color(0xFFFFB400))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildProgressBar('🔄 转发率', (instructor.courseShareRate * 100).toInt(), 100, const Color(0xFF722ED1))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⭐ 平均评分', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Color(0xFFFFB400)),
                        const SizedBox(width: 4),
                        Text(
                          '${instructor.averageRating.toStringAsFixed(1)}/5.0',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${instructor.reviews.length}条评价)',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 新增讲师表单
class _AddInstructorForm extends StatefulWidget {
  final Function(String name, String avatar, String bio, List<String> subjects, CooperationMode mode) onSubmit;

  const _AddInstructorForm({required this.onSubmit});

  @override
  State<_AddInstructorForm> createState() => _AddInstructorFormState();
}

class _AddInstructorFormState extends State<_AddInstructorForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController(text: 'https://via.placeholder.com/150');
  final _bioController = TextEditingController();

  final List<String> _selectedSubjects = [];
  CooperationMode _cooperationMode = CooperationMode.partner;

  final List<String> _availableSubjects = [
    '计算机', '心理学', '美食', '设计', '营销',
    '运动', '音乐', '艺术', '语言', '金融',
    '医疗', '法律', '教育', '其他'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请至少选择一个学科')),
        );
        return;
      }
      widget.onSubmit(
        _nameController.text,
        _avatarController.text,
        _bioController.text,
        _selectedSubjects,
        _cooperationMode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 姓名
            const Text(
              '姓名 *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '请输入讲师姓名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入讲师姓名';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 头像URL
            const Text(
              '头像URL *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _avatarController,
              decoration: const InputDecoration(
                hintText: '请输入头像图片URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入头像URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 合作模式
            const Text(
              '合作模式 *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
            ),
            const SizedBox(height: 8),
            Row(
              children: CooperationMode.values.map((mode) {
                final isSelected = _cooperationMode == mode;
                return Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _cooperationMode = mode;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: mode == CooperationMode.partner ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          mode.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : const Color(0xFF1F2329),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 学科标签
            const Text(
              '学科标签 *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
            ),
            const SizedBox(height: 8),
            const Text(
              '请至少选择一个学科',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSubjects.map((subject) {
                final isSelected = _selectedSubjects.contains(subject);
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSubjects.remove(subject);
                        } else {
                          _selectedSubjects.add(subject);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFD9D9D9),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? Colors.white : const Color(0xFF1F2329),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // 个人简介
            const Text(
              '个人简介 *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bioController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '请输入讲师的个人简介、教学经验等...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入个人简介';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A9B8E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 讲师管理内容组件（嵌入在merchant_dashboard中使用）
class InstructorManagementContent extends StatelessWidget {
  const InstructorManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const InstructorManagementPage();
  }
}
