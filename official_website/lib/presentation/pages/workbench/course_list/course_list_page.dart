import 'package:flutter/material.dart';
import 'course_model.dart';
import '../course_qa_management/course_qa_model.dart';

/// 讲师分类（用于下拉选择）
class InstructorCategory {
  final String id;
  final String name;
  final String avatar;
  final List<String> specialties; // 擅长的领域（对应行业分类ID）

  InstructorCategory({
    required this.id,
    required this.name,
    required this.avatar,
    required this.specialties,
  });
}

/// 行业分类节点（树形结构）
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

  FormatCategory({
    required this.id,
    required this.name,
  });
}

/// 类型分类
class TypeCategory {
  final String id;
  final String name;

  TypeCategory({
    required this.id,
    required this.name,
  });
}

/// 课程列表管理页面
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  // 搜索关键词
  String _searchKeyword = '';

  // 筛选条件
  String? _selectedInstructorId;
  String? _selectedIndustryCategoryId;
  String? _selectedFormatCategoryId;
  String? _selectedTypeCategoryId;

  // 级联选择状态
  String? _selectedIndustry1;
  String? _selectedIndustry2;
  String? _selectedIndustry3;
  String? _selectedIndustry4;

  // 模拟数据
  List<InstructorCategory> _instructorCategories = [];
  List<IndustryCategoryNode> _industryCategories = [];
  List<FormatCategory> _formatCategories = [];
  List<TypeCategory> _typeCategories = [];
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // 模拟100个讲师，每个讲师有不同的专业领域
    _instructorCategories = List.generate(100, (index) {
      final id = index + 1;

      // 根据ID分配专业领域
      List<String> specialties = [];

      // 1-30: 计算机领域
      if (id <= 30) {
        specialties.add('ind_1'); // 计算机一级

        // 1-10: Python方向
        if (id <= 10) {
          specialties.add('ind_1_1'); // Python二级
          specialties.add('ind_1_1_1'); // Django三级
          if (id <= 3) {
            specialties.add('ind_1_1_1_1'); // RESTful API四级
          }
        }
        // 11-20: Java方向
        else if (id <= 20) {
          specialties.add('ind_1_2'); // Java二级
          specialties.add('ind_1_2_1'); // Spring Boot三级
        }
        // 21-30: 前端方向
        else {
          specialties.add('ind_1_3'); // 前端二级
          if (id <= 25) {
            specialties.add('ind_1_3_1'); // React三级
          } else {
            specialties.add('ind_1_3_2'); // Vue三级
          }
        }
      }
      // 31-50: 设计领域
      else if (id <= 50) {
        specialties.add('ind_2'); // 设计一级
        if (id <= 40) {
          specialties.add('ind_2_1'); // UI设计二级
        } else {
          specialties.add('ind_2_2'); // 平面设计二级
        }
      }
      // 51-100: 其他领域（通用）
      else {
        specialties.add('ind_1'); // 也懂计算机
        specialties.add('ind_2'); // 也懂设计
      }

      return InstructorCategory(
        id: 'ins_$id',
        name: '讲师$id',
        avatar: 'https://via.placeholder.com/40',
        specialties: specialties,
      );
    });

    // 行业分类（4层结构）
    _industryCategories = [
      IndustryCategoryNode(
        id: 'ind_1',
        name: '计算机',
        level: 1,
        children: [
          IndustryCategoryNode(
            id: 'ind_1_1',
            name: 'Python',
            level: 2,
            children: [
              IndustryCategoryNode(
                id: 'ind_1_1_1',
                name: 'Django',
                level: 3,
                children: [
                  IndustryCategoryNode(
                    id: 'ind_1_1_1_1',
                    name: 'RESTful API',
                    level: 4,
                  ),
                ],
              ),
            ],
          ),
          IndustryCategoryNode(
            id: 'ind_1_2',
            name: 'Java',
            level: 2,
            children: [
              IndustryCategoryNode(
                id: 'ind_1_2_1',
                name: 'Spring Boot',
                level: 3,
              ),
            ],
          ),
          IndustryCategoryNode(
            id: 'ind_1_3',
            name: '前端',
            level: 2,
            children: [
              IndustryCategoryNode(
                id: 'ind_1_3_1',
                name: 'React',
                level: 3,
              ),
              IndustryCategoryNode(
                id: 'ind_1_3_2',
                name: 'Vue',
                level: 3,
              ),
            ],
          ),
        ],
      ),
    ];

    _formatCategories = [
      FormatCategory(id: 'format_single', name: '单课'),
      FormatCategory(id: 'format_series', name: '套课'),
    ];

    _typeCategories = [
      TypeCategory(id: 'type_video', name: '视频课'),
      TypeCategory(id: 'type_live', name: '直播课'),
    ];

    // 课程数据
    _courses = [
      Course(
        id: 'course_001',
        title: 'Python全栈开发实战',
        coverImage: 'https://via.placeholder.com/300x200',
        description: '从零基础到全栈开发',
        industryCategoryId: 'ind_1_1_1_1',
        industryCategoryPath: '计算机 > Python > Django > RESTful API',
        formatCategoryId: 'format_single',
        formatCategoryName: '单课',
        typeCategoryId: 'type_video',
        typeCategoryName: '视频课',
        instructorId: 'ins_1',
        instructorName: '讲师1',
        instructorAvatar: 'https://via.placeholder.com/40',
        status: CourseStatus.completed,
        format: CourseFormat.single,
        totalDuration: 1440,
        lessonCount: 30,
        studentCount: 1256,
        likeCount: 3420,
        reviewCount: 89,
        averageRating: 4.8,
        price: 199.0,
        originalPrice: 299.0,
        createdAt: DateTime.now(),
      ),
      Course(
        id: 'course_002',
        title: 'React18高级进阶',
        coverImage: 'https://via.placeholder.com/300x200',
        description: '深入理解React18',
        industryCategoryId: 'ind_1_3_1',
        industryCategoryPath: '计算机 > 前端 > React',
        formatCategoryId: 'format_series',
        formatCategoryName: '套课',
        typeCategoryId: 'type_video',
        typeCategoryName: '视频课',
        instructorId: 'ins_2',
        instructorName: '讲师2',
        instructorAvatar: 'https://via.placeholder.com/40',
        status: CourseStatus.inProduction,
        format: CourseFormat.series,
        totalDuration: 2100,
        lessonCount: 45,
        studentCount: 890,
        likeCount: 2156,
        reviewCount: 56,
        averageRating: 4.6,
        price: 299.0,
        originalPrice: 399.0,
        createdAt: DateTime.now(),
      ),
    ];
  }

  List<Course> get _filteredCourses {
    var courses = _courses;

    if (_selectedInstructorId != null) {
      courses = courses.where((c) => c.instructorId == _selectedInstructorId).toList();
    }
    if (_selectedIndustryCategoryId != null) {
      courses = courses.where((c) => c.industryCategoryId == _selectedIndustryCategoryId).toList();
    }
    if (_selectedFormatCategoryId != null) {
      courses = courses.where((c) => c.formatCategoryId == _selectedFormatCategoryId).toList();
    }
    if (_selectedTypeCategoryId != null) {
      courses = courses.where((c) => c.typeCategoryId == _selectedTypeCategoryId).toList();
    }
    if (_searchKeyword.isNotEmpty) {
      courses = courses.where((c) =>
          c.title.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
          c.instructorName.toLowerCase().contains(_searchKeyword.toLowerCase())
      ).toList();
    }

    return courses;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _filteredCourses;

    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: _buildCourseList(filteredCourses),
        ),
      ],
    );
  }

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
      child: const Row(
        children: [
          Text(
            '课程列表',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：行业分类（4级级联）
          const Text(
            '行业分类',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedIndustry1,
                  decoration: const InputDecoration(
                    labelText: '一级分类',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('请选择'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('全部分类')),
                    ..._industryCategories.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry1 = value;
                      _selectedIndustry2 = null;
                      _selectedIndustry3 = null;
                      _selectedIndustry4 = null;
                      _selectedIndustryCategoryId = value;
                      _selectedInstructorId = null; // 重置讲师选择
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedIndustry2,
                  decoration: const InputDecoration(
                    labelText: '二级分类',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('请选择'),
                  items: _buildLevel2Items(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry2 = value;
                      _selectedIndustry3 = null;
                      _selectedIndustry4 = null;
                      _selectedIndustryCategoryId = value;
                      _selectedInstructorId = null; // 重置讲师选择
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedIndustry3,
                  decoration: const InputDecoration(
                    labelText: '三级分类',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('请选择'),
                  items: _buildLevel3Items(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry3 = value;
                      _selectedIndustry4 = null;
                      _selectedIndustryCategoryId = value;
                      _selectedInstructorId = null; // 重置讲师选择
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedIndustry4,
                  decoration: const InputDecoration(
                    labelText: '四级分类',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('请选择'),
                  items: _buildLevel4Items(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry4 = value;
                      _selectedIndustryCategoryId = value;
                      _selectedInstructorId = null; // 重置讲师选择
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 第二行：讲师（根据选中的行业显示）
          const Text(
            '讲师',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String?>(
                  value: _selectedInstructorId,
                  decoration: const InputDecoration(
                    labelText: '选择讲师',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: Text(_getInstructorDropdownHint()),
                  items: _buildInstructorItems(),
                  onChanged: (value) {
                    setState(() {
                      _selectedInstructorId = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _getInstructorHintText(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 第三行：课程形式、课程类型
          Row(
            children: [
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedFormatCategoryId,
                  decoration: const InputDecoration(
                    labelText: '课程形式',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('全部形式'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('全部形式')),
                    ..._formatCategories.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFormatCategoryId = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String?>(
                  value: _selectedTypeCategoryId,
                  decoration: const InputDecoration(
                    labelText: '课程类型',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('全部类型'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('全部类型')),
                    ..._typeCategories.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeCategoryId = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedInstructorId = null;
                    _selectedFormatCategoryId = null;
                    _selectedTypeCategoryId = null;
                    _selectedIndustry1 = null;
                    _selectedIndustry2 = null;
                    _selectedIndustry3 = null;
                    _selectedIndustry4 = null;
                    _selectedIndustryCategoryId = null;
                    _searchKeyword = '';
                  });
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('重置筛选'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 第四行：搜索框
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: '搜索',
                    hintText: '课程名称、讲师名称、关键字',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    suffixIcon: _searchKeyword.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchKeyword = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              if (_searchKeyword.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    '搜索结果: ${_filteredCourses.length} 门课程',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取讲师下拉框提示文字
  String _getInstructorDropdownHint() {
    if (_selectedIndustryCategoryId == null) {
      return '请先选择行业';
    }
    return '全部讲师';
  }

  /// 获取讲师提示文字
  String _getInstructorHintText() {
    if (_selectedIndustryCategoryId == null) {
      return '💡 提示：先选择行业分类，系统会显示该领域的专业讲师';
    }

    final filteredInstructors = _getFilteredInstructors();
    final count = filteredInstructors.length;

    // 根据选择的层级显示不同的提示
    if (_selectedIndustry4 != null) {
      return '🎯 该细分领域共有 $count 位专家讲师';
    } else if (_selectedIndustry3 != null) {
      return '📚 该专业方向共有 $count 位讲师';
    } else if (_selectedIndustry2 != null) {
      return '👨‍🏫 该二级分类共有 $count 位讲师';
    } else {
      return '💼 该一级分类共有 $count 位相关讲师';
    }
  }

  /// 根据选中的行业获取筛选后的讲师列表
  List<InstructorCategory> _getFilteredInstructors() {
    // 如果没有选择行业，返回所有讲师
    if (_selectedIndustryCategoryId == null) {
      return _instructorCategories;
    }

    // 获取当前选中的最精确的分类ID
    // 优先级：四级 > 三级 > 二级 > 一级
    String? targetCategoryId;
    if (_selectedIndustry4 != null) {
      targetCategoryId = _selectedIndustry4;
    } else if (_selectedIndustry3 != null) {
      targetCategoryId = _selectedIndustry3;
    } else if (_selectedIndustry2 != null) {
      targetCategoryId = _selectedIndustry2;
    } else if (_selectedIndustry1 != null) {
      targetCategoryId = _selectedIndustry1;
    }

    if (targetCategoryId == null) {
      return _instructorCategories;
    }

    // 根据目标分类ID过滤讲师
    // 讲师的specialties包含这个分类ID就匹配
    final filtered = _instructorCategories.where((instructor) {
      return instructor.specialties.contains(targetCategoryId);
    }).toList();

    return filtered;
  }

  /// 构建讲师下拉菜单项
  List<DropdownMenuItem<String?>> _buildInstructorItems() {
    if (_selectedIndustryCategoryId == null) {
      return [
        const DropdownMenuItem(
          value: null,
          child: Text('请先选择行业分类'),
        ),
      ];
    }

    final filteredInstructors = _getFilteredInstructors();
    final count = filteredInstructors.length;

    // 如果没有匹配的讲师
    if (count == 0) {
      return [
        const DropdownMenuItem(
          value: null,
          child: Text('该领域暂无讲师'),
        ),
      ];
    }

    return [
      DropdownMenuItem(
        value: null,
        child: Row(
          children: [
            const Text('全部讲师'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count人',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      ...filteredInstructors.take(50).map((instructor) {
        return DropdownMenuItem(
          value: instructor.id,
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(instructor.avatar),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      instructor.name,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (instructor.specialties.length > 1)
                      Text(
                        '擅长 ${instructor.specialties.length} 个领域',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      if (count > 50)
        DropdownMenuItem(
          value: 'more',
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '...还有 ${count - 50} 位讲师，请使用搜索功能',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
    ];
  }

  List<DropdownMenuItem<String?>> _buildLevel2Items() {
    if (_selectedIndustry1 == null) {
      return [const DropdownMenuItem(value: null, child: Text('请先选择一级'))];
    }
    final level1 = _industryCategories.firstWhere((c) => c.id == _selectedIndustry1);
    if (level1.children == null || level1.children!.isEmpty) {
      return [const DropdownMenuItem(value: null, child: Text('无二级分类'))];
    }
    return [
      const DropdownMenuItem(value: null, child: Text('全部二级')),
      ...level1.children!.map((child) {
        return DropdownMenuItem(value: child.id, child: Text(child.name));
      }),
    ];
  }

  List<DropdownMenuItem<String?>> _buildLevel3Items() {
    if (_selectedIndustry2 == null) {
      return [const DropdownMenuItem(value: null, child: Text('请先选择二级'))];
    }
    final level1 = _industryCategories.firstWhere((c) => c.id == _selectedIndustry1);
    final level2 = level1.children!.firstWhere((c) => c.id == _selectedIndustry2);
    if (level2.children == null || level2.children!.isEmpty) {
      return [const DropdownMenuItem(value: null, child: Text('无三级分类'))];
    }
    return [
      const DropdownMenuItem(value: null, child: Text('全部三级')),
      ...level2.children!.map((child) {
        return DropdownMenuItem(value: child.id, child: Text(child.name));
      }),
    ];
  }

  List<DropdownMenuItem<String?>> _buildLevel4Items() {
    if (_selectedIndustry3 == null) {
      return [const DropdownMenuItem(value: null, child: Text('请先选择三级'))];
    }
    final level1 = _industryCategories.firstWhere((c) => c.id == _selectedIndustry1);
    final level2 = level1.children!.firstWhere((c) => c.id == _selectedIndustry2);
    final level3 = level2.children!.firstWhere((c) => c.id == _selectedIndustry3);
    if (level3.children == null || level3.children!.isEmpty) {
      return [const DropdownMenuItem(value: null, child: Text('无四级分类'))];
    }
    return [
      const DropdownMenuItem(value: null, child: Text('全部四级')),
      ...level3.children!.map((child) {
        return DropdownMenuItem(value: child.id, child: Text(child.name));
      }),
    ];
  }

  Widget _buildCourseList(List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无符合条件的课程', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 12,
            horizontalMargin: 12,
            headingRowHeight: 50,
            dataRowMinHeight: 70,
            dataRowMaxHeight: 90,
            border: TableBorder.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
            columns: const [
              DataColumn(
                label: Center(child: Text('课程名称')),
                tooltip: '点击查看详情',
              ),
              DataColumn(
                label: Center(child: Text('行业分类')),
              ),
              DataColumn(
                label: Center(child: Text('形式')),
              ),
              DataColumn(
                label: Center(child: Text('类型')),
              ),
              DataColumn(
                label: Center(child: Text('讲师')),
              ),
              DataColumn(
                label: Center(child: Text('状态')),
              ),
              DataColumn(
                label: Center(child: Text('时长')),
              ),
              DataColumn(
                label: Center(child: Text('课时')),
              ),
              DataColumn(
                label: Center(child: Text('学员')),
              ),
              DataColumn(
                label: Center(child: Text('评分')),
              ),
              DataColumn(
                label: Center(child: Text('操作')),
              ),
            ],
            rows: courses.map((course) {
              return DataRow(
                color: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.blue[50];
                  }
                  return Colors.white;
                }),
                cells: [
                  // 课程名称
                  DataCell(
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              course.coverImage,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 24),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (course.isSeries)
                                  Text(
                                    '套课 · ${course.lessonCount}节',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 行业分类
                  DataCell(
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        course.industryCategoryPath ?? '-',
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // 课程形式
                  DataCell(
                    Center(
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: course.format == CourseFormat.series
                              ? Colors.purple[50]
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: course.format == CourseFormat.series
                                ? Colors.purple[200]!
                                : Colors.blue[200]!,
                          ),
                        ),
                        child: Text(
                          course.formatCategoryName ?? '-',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: course.format == CourseFormat.series
                                ? Colors.purple[700]
                                : Colors.blue[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // 课程类型
                  DataCell(
                    Center(
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          course.typeCategoryName ?? '-',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // 讲师
                  DataCell(
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(course.instructorAvatar),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              course.instructorName,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 课程状态
                  DataCell(
                    Center(
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(course.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.status.label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // 总时长
                  DataCell(
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        course.durationText,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // 课时数
                  DataCell(
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        course.isSeries ? '${course.lessonCount}' : '-',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // 学员数
                  DataCell(
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${course.studentCount}',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // 评分
                  DataCell(
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            course.averageRating > 0
                                ? '${course.averageRating}'
                                : '-',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 操作
                  DataCell(
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _showCourseDetail(course);
                            },
                            icon: const Icon(Icons.visibility, size: 18),
                            tooltip: '查看详情',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              _showCourseEdit(course);
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            tooltip: '编辑课程',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              _showDeleteConfirm(course);
                            },
                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                            tooltip: '删除课程',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
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

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return Colors.green;
      case CourseStatus.inProduction:
        return Colors.orange;
      case CourseStatus.presale:
        return Colors.grey;
    }
  }

  /// 显示课程详情
  void _showCourseDetail(Course course) {
    showDialog(
      context: context,
      builder: (context) => CourseDetailDialog(course: course),
    );
  }

  /// 显示课程编辑
  void _showCourseEdit(Course course) {
    // 先弹出授权确认对话框
    _showAuthorizationDialog(
      title: '编辑课程需要讲师授权',
      content: '您即将编辑课程"${course.title}"。\n\n系统将向该课程的讲师（${course.instructorName}）发送站内信请求授权。\n\n讲师授权后，您才可以进行编辑操作。',
      course: course,
      operation: 'edit',
    );
  }

  /// 显示删除确认
  void _showDeleteConfirm(Course course) {
    // 先弹出授权确认对话框
    _showAuthorizationDialog(
      title: '删除课程需要讲师授权',
      content: '您即将删除课程"${course.title}"。\n\n⚠️ 此操作不可恢复！\n\n系统将向该课程的讲师（${course.instructorName}）发送站内信请求授权。\n\n讲师授权后，课程将被永久删除。',
      course: course,
      operation: 'delete',
    );
  }

  /// 显示授权对话框
  void _showAuthorizationDialog({
    required String title,
    required String content,
    required Course course,
    required String operation,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      operation == 'edit'
                          ? '发送授权请求后，讲师会在"站内信"中收到通知。授权后即可编辑课程信息、章节内容等。'
                          : '发送授权请求后，讲师会在"站内信"中收到通知。授权后课程将被永久删除，请谨慎操作！',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
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
              Navigator.of(context).pop();
              _sendAuthorizationRequest(course, operation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('发送授权请求'),
          ),
        ],
      ),
    );
  }

  /// 发送授权请求
  void _sendAuthorizationRequest(Course course, String operation) {
    // TODO: 调用API发送站内信

    // 模拟发送成功
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已向讲师"${course.instructorName}"发送授权请求'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '查看站内信',
          textColor: Colors.white,
          onPressed: () {
            _showMessageBox();
          },
        ),
      ),
    );

    // 显示站内信预览对话框
    Future.delayed(const Duration(milliseconds: 500), () {
      _showMessagePreview(course, operation);
    });
  }

  /// 显示站内信预览
  void _showMessagePreview(Course course, String operation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.mail, color: Colors.blue),
            const SizedBox(width: 8),
            const Expanded(child: Text('站内信已发送')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('收件人：', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(course.instructorName),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '待授权',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('标题：', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    operation == 'edit' ? '【授权请求】编辑课程：${course.title}' : '【授权请求】删除课程：${course.title}',
                  ),
                  const SizedBox(height: 12),
                  const Text('内容：', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    operation == 'edit'
                        ? '您好！\n\n管理员请求编辑您的课程"${course.title}"。\n\n请点击下方按钮进行授权：\n• 同意授权 - 管理员将可以编辑课程信息\n• 拒绝授权 - 取消本次操作\n\n此请求将在7天后自动过期。'
                        : '您好！\n\n管理员请求删除您的课程"${course.title}"。\n\n⚠️ 注意：删除后课程将永久消失，无法恢复！\n\n请点击下方按钮进行授权：\n• 同意授权 - 课程将被删除\n• 拒绝授权 - 取消本次操作\n\n此请求将在7天后自动过期。',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showMessageBox();
            },
            child: const Text('查看站内信'),
          ),
        ],
      ),
    );
  }

  /// 显示站内信列表对话框
  void _showMessageBox() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            child: Container(
              width: 800,
              height: 600,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 28),
                      const SizedBox(width: 12),
                      const Text(
                        '站内信',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // 站内信列表
                  Expanded(
                    child: ListView(
                      children: [
                        _buildMessageItem(
                          title: '【授权请求】编辑课程：Python全栈开发实战',
                          sender: '系统管理员',
                          time: '2分钟前',
                          status: 'pending',
                          onTap: () {
                            Navigator.of(context).pop();
                            _showAuthorizationDetail('edit');
                          },
                        ),
                        const Divider(),
                        _buildMessageItem(
                          title: '【授权请求】删除课程：React18高级进阶',
                          sender: '系统管理员',
                          time: '10分钟前',
                          status: 'approved',
                          onTap: () {
                            Navigator.of(context).pop();
                            _showAuthorizationDetail('delete');
                          },
                        ),
                        const Divider(),
                        _buildMessageItem(
                          title: '您的课程"Flutter移动开发实战"已通过审核',
                          sender: '审核团队',
                          time: '1小时前',
                          status: 'read',
                          onTap: () {
                            // 显示普通消息详情
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建站内信列表项
  Widget _buildMessageItem({
    required String title,
    required String sender,
    required String time,
    required String status,
    required VoidCallback onTap,
  }) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = '待处理';
        statusIcon = Icons.pending;
        break;
      case 'approved':
        statusColor = Colors.green;
        statusText = '已同意';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = '已拒绝';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = '已读';
        statusIcon = Icons.mail_outline;
    }

    return ListTile(
      leading: Icon(
        statusIcon,
        color: statusColor,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('$sender · $time'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: statusColor),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            fontSize: 12,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  /// 显示授权详情对话框
  void _showAuthorizationDetail(String operation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.orange),
            const SizedBox(width: 8),
            const Expanded(child: Text('授权请求详情')),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('请求信息：', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('请求类型', operation == 'edit' ? '编辑课程' : '删除课程'),
                    _buildInfoRow('课程名称', 'Python全栈开发实战'),
                    _buildInfoRow('请求人', '系统管理员'),
                    _buildInfoRow('请求时间', '2025-03-09 14:30'),
                    _buildInfoRow('过期时间', '2025-03-16 14:30'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('授权说明：', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: operation == 'delete' ? Colors.red[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  operation == 'edit'
                      ? '授权后，管理员将可以编辑该课程的以下内容：\n• 课程标题、简介、封面\n• 章节和课时信息\n• 图文和视频内容\n• 课程状态和价格'
                      : '⚠️ 警告：授权后，该课程将被永久删除！\n\n删除内容包括：\n• 课程基本信息\n• 所有章节和课时\n• 学员学习记录\n• 课程问答数据\n\n此操作不可恢复！',
                  style: TextStyle(
                    fontSize: 13,
                    color: operation == 'delete' ? Colors.red[700] : Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已拒绝授权请求'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('拒绝授权'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleAuthorizationApproved(operation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('同意授权'),
          ),
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label：',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理授权通过
  void _handleAuthorizationApproved(String operation) {
    // TODO: 调用API更新授权状态

    if (operation == 'edit') {
      // 授权通过，打开编辑对话框
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Expanded(child: Text('授权成功')),
            ],
          ),
          content: const Text('授权已通过，现在可以编辑课程了。'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 打开编辑对话框
                _openEditDialogAfterAuth();
              },
              child: const Text('开始编辑'),
            ),
          ],
        ),
      );
    } else {
      // 删除授权通过
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Expanded(child: Text('授权成功')),
            ],
          ),
          content: const Text('授权已通过，课程将被删除。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('课程已删除'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('确认删除'),
            ),
          ],
        ),
      );
    }
  }

  /// 授权通过后打开编辑对话框
  void _openEditDialogAfterAuth() {
    // 这里应该使用具体的course对象
    // 为了演示，使用模拟数据
    final mockCourse = _courses.first;
    showDialog(
      context: context,
      builder: (context) => CourseEditDialog(course: mockCourse),
    );
  }
}

/// 课程详情对话框
class CourseDetailDialog extends StatefulWidget {
  final Course course;

  const CourseDetailDialog({super.key, required this.course});

  @override
  State<CourseDetailDialog> createState() => _CourseDetailDialogState();
}

class _CourseDetailDialogState extends State<CourseDetailDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              children: [
                const Text(
                  '课程详情',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 课程基本信息
            _buildCourseBasicInfo(),
            const SizedBox(height: 24),

            // Tab栏
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: '课程简介'),
                Tab(text: '课程目录'),
                Tab(text: '课程问答'),
              ],
            ),
            const SizedBox(height: 16),

            // Tab内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDescriptionTab(),
                  _buildCurriculumTab(),
                  _buildQATab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建课程基本信息
  Widget _buildCourseBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 课程封面
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(widget.course.coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 24),

          // 课程信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 课程标题
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // 分类和状态
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(widget.course.formatCategoryName ?? '-'),
                      backgroundColor: Colors.blue[50],
                    ),
                    Chip(
                      label: Text(widget.course.typeCategoryName ?? '-'),
                      backgroundColor: Colors.green[50],
                    ),
                    Chip(
                      label: Text(widget.course.status.label),
                      backgroundColor: widget.course.status == CourseStatus.completed
                          ? Colors.green[50]
                          : widget.course.status == CourseStatus.inProduction
                              ? Colors.orange[50]
                              : Colors.grey[50],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 讲师信息
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          NetworkImage(widget.course.instructorAvatar),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '讲师: ${widget.course.instructorName}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 统计数据
                Row(
                  children: [
                    _buildStatItem('时长', widget.course.durationText),
                    const SizedBox(width: 24),
                    if (widget.course.isSeries)
                      _buildStatItem('课时', '${widget.course.lessonCount}节'),
                    if (widget.course.isSeries) const SizedBox(width: 24),
                    _buildStatItem('学员', '${widget.course.studentCount}'),
                    const SizedBox(width: 24),
                    _buildStatItem('点赞', '${widget.course.likeCount}'),
                    const SizedBox(width: 24),
                    _buildStatItem('评价', '${widget.course.reviewCount}'),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          widget.course.averageRating > 0
                              ? '${widget.course.averageRating}'
                              : '-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// 构建简介Tab
  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '课程简介',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.course.description,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            '讲师简介',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(widget.course.instructorAvatar),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.instructorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '资深讲师，拥有多年行业经验，擅长将复杂的概念简单化，帮助学员快速掌握知识点。',
                        style: TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建目录Tab
  Widget _buildCurriculumTab() {
    // 模拟章节数据
    final chapters = [
      Chapter(
        id: 'ch_001',
        courseId: widget.course.id,
        chapterNumber: 1,
        title: '第一章：课程介绍与环境搭建',
        lessons: [
          Lesson(
            id: 'l_001',
            courseId: widget.course.id,
            chapterNumber: 1,
            lessonNumber: 1,
            title: '1.1 课程介绍',
            outline: '本节课介绍课程的主要内容和学习目标，帮助学员了解课程整体结构。',
            duration: 15,
            isFree: true,
            createdAt: DateTime.now(),
            questionCount: 5,
          ),
          Lesson(
            id: 'l_002',
            courseId: widget.course.id,
            chapterNumber: 1,
            lessonNumber: 2,
            title: '1.2 开发环境搭建',
            outline: '详细讲解如何搭建开发环境，包括软件安装、配置等步骤。',
            duration: 45,
            isFree: true,
            createdAt: DateTime.now(),
            questionCount: 12,
          ),
        ],
      ),
      Chapter(
        id: 'ch_002',
        courseId: widget.course.id,
        chapterNumber: 2,
        title: '第二章：基础知识讲解',
        lessons: [
          Lesson(
            id: 'l_003',
            courseId: widget.course.id,
            chapterNumber: 2,
            lessonNumber: 1,
            title: '2.1 基础概念',
            outline: '讲解课程的核心概念和基础知识，为后续学习打下坚实基础。',
            duration: 52,
            isFree: false,
            createdAt: DateTime.now(),
            questionCount: 8,
          ),
          Lesson(
            id: 'l_004',
            courseId: widget.course.id,
            chapterNumber: 2,
            lessonNumber: 2,
            title: '2.2 核心语法',
            outline: '深入讲解核心语法和使用技巧，通过实例加深理解。',
            duration: 68,
            isFree: false,
            createdAt: DateTime.now(),
            questionCount: 15,
          ),
        ],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              chapter.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${chapter.totalLessons}节课时 · ${_formatDuration(chapter.totalDuration)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            children: chapter.lessons.map((lesson) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (lesson.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              '免费',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '大纲: ${lesson.outline}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 12, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                lesson.durationText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.chat_bubble,
                                  size: 12, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${lesson.questionCount}条问答',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  _showLessonQuestions(lesson);
                                },
                                child: const Text('查看问答'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// 构建问答Tab
  Widget _buildQATab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            '课程问答功能',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '该课程的课后问答将在这里显示',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示课时问答
  void _showLessonQuestions(Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${lesson.title} - 问答列表'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('共 ${lesson.questionCount} 条问答'),
            const SizedBox(height: 16),
            const Text('问答列表待实现...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '$hours小时${mins > 0 ? ' $mins分钟' : ''}';
    }
    return '$mins分钟';
  }
}

/// 课程编辑对话框
class CourseEditDialog extends StatefulWidget {
  final Course course;

  const CourseEditDialog({super.key, required this.course});

  @override
  State<CourseEditDialog> createState() => _CourseEditDialogState();
}

class _CourseEditDialogState extends State<CourseEditDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _coverImageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _titleController = TextEditingController(text: widget.course.title);
    _descriptionController = TextEditingController(text: widget.course.description);
    _coverImageController = TextEditingController(text: widget.course.coverImage);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 900,
        height: 650,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              children: [
                const Text(
                  '编辑课程',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab栏
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                const Tab(text: '基本信息'),
                Tab(text: widget.course.format == CourseFormat.series ? '课程章节' : '课时管理'),
              ],
            ),
            const SizedBox(height: 16),

            // Tab内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildLessonsTab(),
                ],
              ),
            ),

            // 底部按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 保存课程信息
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('保存成功')),
                    );
                  },
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 基本信息Tab
  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 课程封面
          const Text(
            '课程封面',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(_coverImageController.text),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // 加载失败显示占位图
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('支持 JPG、PNG 格式，建议尺寸 16:9'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _coverImageController,
                      decoration: const InputDecoration(
                        labelText: '封面图片URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: 上传图片
                      },
                      icon: const Icon(Icons.upload, size: 16),
                      label: const Text('上传图片'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 课程标题
          const Text(
            '课程标题',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '请输入课程标题',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // 课程简介
          const Text(
            '课程简介',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '请输入课程简介',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // 课程状态和形式
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '课程状态',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<CourseStatus>(
                      value: widget.course.status,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: CourseStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: 更新状态
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '课程形式',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<CourseFormat>(
                      value: widget.course.format,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: CourseFormat.values.map((format) {
                        return DropdownMenuItem(
                          value: format,
                          child: Text(format.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // TODO: 更新形式
                      },
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

  /// 课时管理Tab
  Widget _buildLessonsTab() {
    return Column(
      children: [
        // 操作按钮
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _showAddChapterDialog();
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('添加章节'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  _showUploadVideoDialog();
                },
                icon: const Icon(Icons.video_library, size: 16),
                label: const Text('上传视频'),
              ),
            ],
          ),
        ),

        // 章节列表
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildChapterCard('第一章：课程介绍', 2, true),
              const SizedBox(height: 16),
              _buildChapterCard('第二章：基础知识', 3, false),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建章节卡片
  Widget _buildChapterCard(String title, int lessonCount, bool isExpanded) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('$lessonCount 节课'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    // TODO: 编辑章节
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () {
                    // TODO: 删除章节
                  },
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLessonTile('第1节: 课程介绍', '15分钟', true),
                  const Divider(),
                  _buildLessonTile('第2节: 环境搭建', '45分钟', false),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建课时列表项
  Widget _buildLessonTile(String title, String duration, bool isFree) {
    return ListTile(
      leading: const Icon(Icons.play_circle_outline),
      title: Text(title),
      subtitle: Text(duration),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFree)
            Chip(
              label: const Text('免费', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.green[50],
            ),
          IconButton(
            icon: const Icon(Icons.edit, size: 16),
            onPressed: () {
              _showLessonEditDialog(title);
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload, size: 16),
            onPressed: () {
              // TODO: 上传视频
            },
          ),
        ],
      ),
    );
  }

  /// 显示添加章节对话框
  void _showAddChapterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加章节'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: '章节标题',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('章节添加成功')),
              );
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  /// 显示上传视频对话框
  void _showUploadVideoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('上传视频'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('支持 MP4、AVI 等格式'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: 选择文件
              },
              icon: const Icon(Icons.folder_open, size: 16),
              label: const Text('选择文件'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 显示课时编辑对话框
  void _showLessonEditDialog(String lessonTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑课时'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: '课时标题',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: lessonTitle),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: '课时大纲',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: '视频URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('是否免费试看：'),
                  Switch(value: true, onChanged: (value) {}),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('课时保存成功')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}


/// 课程列表内容组件（嵌入在merchant_dashboard中使用）
class CourseListContent extends StatelessWidget {
  const CourseListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseListPage();
  }
}
