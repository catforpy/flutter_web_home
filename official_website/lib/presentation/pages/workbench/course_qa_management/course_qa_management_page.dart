import 'package:flutter/material.dart';
import 'course_qa_model.dart';

/// 课程问答管理页面
class CourseQAManagementPage extends StatefulWidget {
  const CourseQAManagementPage({super.key});

  @override
  State<CourseQAManagementPage> createState() => _CourseQAManagementPageState();
}

class _CourseQAManagementPageState extends State<CourseQAManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 搜索条件
  String _selectedIndustryCategory = '全部';
  String _selectedFormatCategory = '全部';
  String _selectedTypeCategory = '全部';
  String _searchCourseName = '';
  String _searchInstructorName = '';

  // 模拟数据
  List<CourseQAStats> _preCourseData = [];
  List<CourseQAStats> _postCourseData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 加载模拟数据
  void _loadMockData() {
    _preCourseData = [
      const CourseQAStats(
        courseId: 'course_001',
        courseName: 'Python全栈开发实战',
        instructorId: 'ins_001',
        instructorName: '张三',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > Python',
        formatCategory: '单课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.completed,
        followerCount: 1250,
        studentCount: 856,
        totalQuestions: 24,
        resolvedCount: 20,
        averageRating: 4.8,
      ),
      const CourseQAStats(
        courseId: 'course_002',
        courseName: 'React18高级进阶',
        instructorId: 'ins_002',
        instructorName: '李四',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 前端 > React',
        formatCategory: '单课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.inProduction,
        followerCount: 890,
        studentCount: 432,
        totalQuestions: 15,
        resolvedCount: 12,
        averageRating: 4.6,
      ),
      const CourseQAStats(
        courseId: 'course_003',
        courseName: 'Flutter移动开发实战',
        instructorId: 'ins_003',
        instructorName: '王五',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 移动开发 > Flutter',
        formatCategory: '套课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.completed,
        followerCount: 2100,
        studentCount: 1567,
        totalQuestions: 38,
        resolvedCount: 35,
        averageRating: 4.9,
      ),
      const CourseQAStats(
        courseId: 'course_004',
        courseName: 'Java Spring Boot微服务',
        instructorId: 'ins_001',
        instructorName: '张三',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 后端 > Java',
        formatCategory: '套课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.presale,
        followerCount: 567,
        studentCount: 0,
        totalQuestions: 8,
        resolvedCount: 6,
        averageRating: 0.0,
      ),
      const CourseQAStats(
        courseId: 'course_005',
        courseName: 'Vue3企业级项目实战',
        instructorId: 'ins_002',
        instructorName: '李四',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 前端 > Vue',
        formatCategory: '单课',
        typeCategory: '直播课',
        courseStatus: CourseStatus.inProduction,
        followerCount: 1234,
        studentCount: 789,
        totalQuestions: 19,
        resolvedCount: 16,
        averageRating: 4.7,
      ),
    ];

    _postCourseData = [
      const CourseQAStats(
        courseId: 'course_001',
        courseName: 'Python全栈开发实战',
        instructorId: 'ins_001',
        instructorName: '张三',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > Python',
        formatCategory: '单课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.completed,
        followerCount: 1250,
        studentCount: 856,
        totalQuestions: 156,
        resolvedCount: 142,
        averageRating: 4.8,
      ),
      const CourseQAStats(
        courseId: 'course_002',
        courseName: 'React18高级进阶',
        instructorId: 'ins_002',
        instructorName: '李四',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 前端 > React',
        formatCategory: '单课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.inProduction,
        followerCount: 890,
        studentCount: 432,
        totalQuestions: 89,
        resolvedCount: 76,
        averageRating: 4.6,
      ),
      const CourseQAStats(
        courseId: 'course_003',
        courseName: 'Flutter移动开发实战',
        instructorId: 'ins_003',
        instructorName: '王五',
        instructorAvatar: 'https://via.placeholder.com/40',
        industryCategory: '计算机 > 移动开发 > Flutter',
        formatCategory: '套课',
        typeCategory: '视频课',
        courseStatus: CourseStatus.completed,
        followerCount: 2100,
        studentCount: 1567,
        totalQuestions: 234,
        resolvedCount: 218,
        averageRating: 4.9,
      ),
    ];
  }

  /// 获取当前显示的数据
  List<CourseQAStats> get _currentData {
    final isPreCourse = _tabController.index == 0;
    var data = isPreCourse ? _preCourseData : _postCourseData;

    // 应用筛选条件
    if (_selectedIndustryCategory != '全部') {
      data = data
          .where((course) =>
              course.industryCategory?.contains(_selectedIndustryCategory) ??
              false)
          .toList();
    }

    if (_selectedFormatCategory != '全部') {
      data = data
          .where(
              (course) => course.formatCategory == _selectedFormatCategory)
          .toList();
    }

    if (_selectedTypeCategory != '全部') {
      data = data
          .where((course) => course.typeCategory == _selectedTypeCategory)
          .toList();
    }

    if (_searchCourseName.isNotEmpty) {
      data = data
          .where((course) => course.courseName
              .toLowerCase()
              .contains(_searchCourseName.toLowerCase()))
          .toList();
    }

    if (_searchInstructorName.isNotEmpty) {
      data = data
          .where((course) => course.instructorName
              .toLowerCase()
              .contains(_searchInstructorName.toLowerCase()))
          .toList();
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCourseList(QAType.preCourse),
              _buildCourseList(QAType.postCourse),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            '课程问答管理',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: '课前问答'),
                Tab(text: '课后问答'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选区域
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          // 行业分类
          DropdownButton<String>(
            value: _selectedIndustryCategory,
            items: const [
              DropdownMenuItem(value: '全部', child: Text('行业分类: 全部')),
              DropdownMenuItem(value: '计算机', child: Text('计算机')),
              DropdownMenuItem(value: 'Python', child: Text('Python')),
              DropdownMenuItem(value: '前端', child: Text('前端')),
              DropdownMenuItem(value: '移动开发', child: Text('移动开发')),
              DropdownMenuItem(value: '后端', child: Text('后端')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedIndustryCategory = value ?? '全部';
              });
            },
          ),
          // 课程形式
          DropdownButton<String>(
            value: _selectedFormatCategory,
            items: const [
              DropdownMenuItem(value: '全部', child: Text('课程形式: 全部')),
              DropdownMenuItem(value: '单课', child: Text('单课')),
              DropdownMenuItem(value: '套课', child: Text('套课')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFormatCategory = value ?? '全部';
              });
            },
          ),
          // 课程类型
          DropdownButton<String>(
            value: _selectedTypeCategory,
            items: const [
              DropdownMenuItem(value: '全部', child: Text('课程类型: 全部')),
              DropdownMenuItem(value: '视频课', child: Text('视频课')),
              DropdownMenuItem(value: '直播课', child: Text('直播课')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedTypeCategory = value ?? '全部';
              });
            },
          ),
          // 课程名称搜索
          SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                labelText: '课程名称',
                hintText: '请输入课程名称',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchCourseName = value;
                });
              },
            ),
          ),
          // 讲师名称搜索
          SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                labelText: '讲师名称',
                hintText: '请输入讲师名称',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchInstructorName = value;
                });
              },
            ),
          ),
          // 搜索按钮
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('搜索'),
          ),
          // 重置按钮
          OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedIndustryCategory = '全部';
                _selectedFormatCategory = '全部';
                _selectedTypeCategory = '全部';
                _searchCourseName = '';
                _searchInstructorName = '';
              });
            },
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }

  /// 构建课程列表
  Widget _buildCourseList(QAType qaType) {
    final data = _currentData;

    if (data.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('课程名称')),
              DataColumn(label: Text('行业分类')),
              DataColumn(label: Text('课程形式')),
              DataColumn(label: Text('课程类型')),
              DataColumn(label: Text('讲师')),
              DataColumn(label: Text('课程状态')),
              DataColumn(label: Text('关注人数')),
              DataColumn(label: Text('学生人数')),
              DataColumn(label: Text('问题数')),
              DataColumn(label: Text('已解决')),
              DataColumn(label: Text('待解决')),
              DataColumn(label: Text('评分')),
              DataColumn(label: Text('操作')),
            ],
            rows: data.map((course) {
              return DataRow(
                cells: [
                  DataCell(Text(course.courseName)),
                  DataCell(Text(course.industryCategory ?? '-')),
                  DataCell(Text(course.formatCategory ?? '-')),
                  DataCell(Text(course.typeCategory ?? '-')),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(course.instructorAvatar),
                        ),
                        const SizedBox(width: 8),
                        Text(course.instructorName),
                      ],
                    ),
                  ),
                  DataCell(Text(course.courseStatus.label)),
                  DataCell(Text('${course.followerCount}')),
                  DataCell(Text('${course.studentCount}')),
                  DataCell(Text('${course.totalQuestions}')),
                  DataCell(Text('${course.resolvedCount}')),
                  DataCell(Text('${course.pendingCount}')),
                  DataCell(
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.orange),
                        Text(course.averageRating > 0
                            ? '${course.averageRating}'
                            : '-'),
                      ],
                    ),
                  ),
                  DataCell(
                    TextButton(
                      onPressed: () {
                        _showQuestionDetail(course, qaType);
                      },
                      child: const Text('查看详情'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// 显示问题详情对话框
  void _showQuestionDetail(CourseQAStats course, QAType qaType) {
    showDialog(
      context: context,
      builder: (context) => CourseQADetailDialog(
        course: course,
        qaType: qaType,
      ),
    );
  }
}

/// 课程问答详情对话框
class CourseQADetailDialog extends StatefulWidget {
  final CourseQAStats course;
  final QAType qaType;

  const CourseQADetailDialog({
    super.key,
    required this.course,
    required this.qaType,
  });

  @override
  State<CourseQADetailDialog> createState() => _CourseQADetailDialogState();
}

class _CourseQADetailDialogState extends State<CourseQADetailDialog> {
  bool _showResolvedOnly = false;

  // 模拟问题数据
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = [
      Question(
        id: 'q_001',
        courseId: widget.course.courseId,
        courseName: widget.course.courseName,
        qaType: widget.qaType,
        userId: 'u_001',
        userName: '小明',
        userAvatar: 'https://via.placeholder.com/40',
        title: '这个课程适合零基础吗？',
        content: '我完全没有编程基础,想学这个课程,不知道从哪里开始比较好？',
        askTime: DateTime.now().subtract(const Duration(days: 2)),
        isResolved: true,
        answererType: widget.qaType == QAType.preCourse
            ? AnswererType.customerService
            : AnswererType.instructor,
        answererId: widget.qaType == QAType.preCourse
            ? 'cs_001'
            : widget.course.instructorId,
        answererName: widget.qaType == QAType.preCourse
            ? '客服小助手'
            : widget.course.instructorName,
        answerTime: DateTime.now().subtract(const Duration(days: 2)),
        answerContent: widget.qaType == QAType.preCourse
            ? '您好！这个课程是从基础开始讲的，适合零基础学员。我们会从Python安装、环境配置开始，逐步深入到实际项目开发。'
            : '课程中有专门针对零基础学员的讲解，建议从第一章开始学习，遇到问题可以在课后问答中提问。',
        likes: 23,
      ),
      Question(
        id: 'q_002',
        courseId: widget.course.courseId,
        courseName: widget.course.courseName,
        qaType: widget.qaType,
        userId: 'u_002',
        userName: '小红',
        userAvatar: 'https://via.placeholder.com/40',
        title: '课程更新频率是怎样的？',
        content: '想了解一下课程的更新计划，大概多久更新一次？',
        askTime: DateTime.now().subtract(const Duration(days: 1)),
        isResolved: true,
        answererType: AnswererType.instructor,
        answererId: widget.course.instructorId,
        answererName: widget.course.instructorName,
        answerTime: DateTime.now().subtract(const Duration(days: 1)),
        answerContent: '课程每周更新2-3节，预计总共50节课左右，目前已经更新了30节。',
        likes: 15,
      ),
      Question(
        id: 'q_003',
        courseId: widget.course.courseId,
        courseName: widget.course.courseName,
        qaType: widget.qaType,
        userId: 'u_003',
        userName: '小刚',
        userAvatar: 'https://via.placeholder.com/40',
        title: '购买后可以永久观看吗？',
        content: '想确认一下课程的有效期，购买后是不是可以一直观看？',
        askTime: DateTime.now().subtract(const Duration(hours: 12)),
        isResolved: false,
        likes: 8,
      ),
      Question(
        id: 'q_004',
        courseId: widget.course.courseId,
        courseName: widget.course.courseName,
        qaType: widget.qaType,
        userId: 'u_004',
        userName: '小李',
        userAvatar: 'https://via.placeholder.com/40',
        title: '课程有提供源码吗？',
        content: '学习过程中是否可以获取课程的源代码？',
        askTime: DateTime.now().subtract(const Duration(hours: 6)),
        isResolved: false,
        likes: 12,
      ),
    ];
  }

  List<Question> get _filteredQuestions {
    if (_showResolvedOnly) {
      return _questions.where((q) => q.isResolved).toList();
    }
    return _questions;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.courseName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(widget.qaType.label),
                            backgroundColor: widget.qaType == QAType.preCourse
                                ? Colors.blue[50]
                                : Colors.green[50],
                          ),
                          const SizedBox(width: 8),
                          Text('讲师: ${widget.course.instructorName}'),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 32),

            // 统计信息
            Row(
              children: [
                _buildStatCard('总问题数', '${_questions.length}', Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard(
                    '已解决', '${_questions.where((q) => q.isResolved).length}', Colors.green),
                const SizedBox(width: 16),
                _buildStatCard(
                    '待解决', '${_questions.where((q) => !q.isResolved).length}', Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // 筛选按钮
            Row(
              children: [
                FilterChip(
                  label: const Text('只看已解决'),
                  selected: _showResolvedOnly,
                  onSelected: (selected) {
                    setState(() {
                      _showResolvedOnly = selected;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 问题列表
            Expanded(
              child: _filteredQuestions.isEmpty
                  ? const Center(
                      child: Text('暂无问题'),
                    )
                  : ListView.builder(
                      itemCount: _filteredQuestions.length,
                      itemBuilder: (context, index) {
                        final question = _filteredQuestions[index];
                        return _buildQuestionCard(question);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 问题头部
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(question.userAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDateTime(question.askTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (question.isResolved)
                  const Chip(
                    label: Text('已解决', style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  )
                else
                  const Chip(
                    label: Text('待解决', style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.orange,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 问题标题和内容
            Text(
              question.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            // 点赞数
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${question.likes}'),
                const SizedBox(width: 24),
                const Icon(Icons.comment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text('1'),
              ],
            ),

            // 回答内容
            if (question.isResolved && question.answerContent != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: question.answererType == AnswererType.instructor
                        ? Colors.blue[100]
                        : Colors.green[100],
                    child: Text(
                      question.answererType == AnswererType.instructor ? '讲' : '客',
                      style: TextStyle(
                        fontSize: 12,
                        color: question.answererType == AnswererType.instructor
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              question.answererName ?? '未知',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                question.answererType?.label ?? '',
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        if (question.answerTime != null)
                          Text(
                            _formatDateTime(question.answerTime!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  question.answerContent!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],

            // 未解决时的回答按钮
            if (!question.isResolved) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showAnswerDialog(question);
                    },
                    child: const Text('回答问题'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  void _showAnswerDialog(Question question) {
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('回答问题'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '问题: ${question.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(question.content),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '回答内容',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 调用API提交回答
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('回答提交成功')),
              );
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}

/// 课程问答管理内容组件（嵌入在merchant_dashboard中使用）
class CourseQAManagementContent extends StatelessWidget {
  const CourseQAManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseQAManagementPage();
  }
}
