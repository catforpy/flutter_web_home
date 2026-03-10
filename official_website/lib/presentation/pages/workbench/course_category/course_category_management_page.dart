import 'package:flutter/material.dart';
import 'course_category.dart';

/// 课程分类完整管理页面
/// 包含3个分类维度：行业分类、课程形式、课程类型
class CourseCategoryManagementPage extends StatefulWidget {
  const CourseCategoryManagementPage({super.key});

  @override
  State<CourseCategoryManagementPage> createState() => _CourseCategoryManagementPageState();
}

class _CourseCategoryManagementPageState extends State<CourseCategoryManagementPage>
    with TickerProviderStateMixin<CourseCategoryManagementPage> {
  // 当前选中的分类类型Tab
  int _selectedTypeIndex = 0;

  late TabController _tabController;

  // 3个分类类型的数据
  final Map<int, List<CourseCategory>> _categoryData = {
    0: [], // 行业分类
    1: [], // 课程形式
    2: [], // 课程类型
  };

  // 每个分类类型的选中状态（支持最多4级）
  final Map<int, List<CourseCategory?>> _selectedCategories = {
    0: [null, null, null, null], // 行业分类的4级选中
    1: [null, null, null, null], // 课程形式的4级选中
    2: [null, null, null, null], // 课程类型的4级选中
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      initialIndex: _selectedTypeIndex,
      vsync: this,
    );
    _loadAllCategoryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 加载所有分类的默认数据
  void _loadAllCategoryData() {
    final now = DateTime.now();

    // 0: 行业分类
    _categoryData[0] = [
      CourseCategory(
        id: 'd1',
        name: '物流交通',
        level: 1,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
      CourseCategory(
        id: 'd2',
        name: '科技培训',
        level: 1,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 'd2-1',
            name: '计算机',
            level: 2,
            parentId: 'd2',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
            children: [
              CourseCategory(
                id: 'd2-1-1',
                name: 'Python',
                level: 3,
                parentId: 'd2-1',
                sortOrder: 1,
                createdAt: now,
                updatedAt: now,
                children: [
                  CourseCategory(
                    id: 'd2-1-1-1',
                    name: '基础',
                    level: 4,
                    parentId: 'd2-1-1',
                    sortOrder: 1,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  CourseCategory(
                    id: 'd2-1-1-2',
                    name: '进阶',
                    level: 4,
                    parentId: 'd2-1-1',
                    sortOrder: 2,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ],
              ),
              CourseCategory(
                id: 'd2-1-2',
                name: 'Java',
                level: 3,
                parentId: 'd2-1',
                sortOrder: 2,
                createdAt: now,
                updatedAt: now,
              ),
              CourseCategory(
                id: 'd2-1-3',
                name: 'Web开发',
                level: 3,
                parentId: 'd2-1',
                sortOrder: 3,
                createdAt: now,
                updatedAt: now,
              ),
            ],
          ),
          CourseCategory(
            id: 'd2-2',
            name: '心理健康',
            level: 2,
            parentId: 'd2',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
            children: [],
          ),
          CourseCategory(
            id: 'd2-3',
            name: '美食',
            level: 2,
            parentId: 'd2',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
            children: [],
          ),
        ],
      ),
      CourseCategory(
        id: 'd3',
        name: '餐饮生活',
        level: 1,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
      CourseCategory(
        id: 'd4',
        name: '生活娱乐',
        level: 1,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
      CourseCategory(
        id: 'd5',
        name: '电商平台',
        level: 1,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
    ];

    // 1: 课程形式分类
    _categoryData[1] = [
      CourseCategory(
        id: 'f1',
        name: '图文',
        level: 1,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 'f1-1',
            name: '纯文字',
            level: 2,
            parentId: 'f1',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f1-2',
            name: '图文混排',
            level: 2,
            parentId: 'f1',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f1-3',
            name: '漫画',
            level: 2,
            parentId: 'f1',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      CourseCategory(
        id: 'f2',
        name: '音频',
        level: 1,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 'f2-1',
            name: '讲座',
            level: 2,
            parentId: 'f2',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f2-2',
            name: '有声书',
            level: 2,
            parentId: 'f2',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f2-3',
            name: '播客',
            level: 2,
            parentId: 'f2',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      CourseCategory(
        id: 'f3',
        name: '视频',
        level: 1,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 'f3-1',
            name: '录播视频',
            level: 2,
            parentId: 'f3',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f3-2',
            name: '直播回放',
            level: 2,
            parentId: 'f3',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f3-3',
            name: '动画演示',
            level: 2,
            parentId: 'f3',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      CourseCategory(
        id: 'f4',
        name: '直播',
        level: 1,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 'f4-1',
            name: '视频直播',
            level: 2,
            parentId: 'f4',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f4-2',
            name: '音频直播',
            level: 2,
            parentId: 'f4',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 'f4-3',
            name: '图文直播',
            level: 2,
            parentId: 'f4',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    ];

    // 2: 课程类型分类
    _categoryData[2] = [
      CourseCategory(
        id: 't1',
        name: '单课',
        level: 1,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 't1-1',
            name: '付费单课',
            level: 2,
            parentId: 't1',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 't1-2',
            name: '免费单课',
            level: 2,
            parentId: 't1',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 't1-3',
            name: 'VIP专享',
            level: 2,
            parentId: 't1',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      CourseCategory(
        id: 't2',
        name: '套课',
        level: 1,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        children: [
          CourseCategory(
            id: 't2-1',
            name: '系列课',
            level: 2,
            parentId: 't2',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 't2-2',
            name: '专题课',
            level: 2,
            parentId: 't2',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 't2-3',
            name: '训练营',
            level: 2,
            parentId: 't2',
            sortOrder: 3,
            createdAt: now,
            updatedAt: now,
          ),
          CourseCategory(
            id: 't2-4',
            name: '年度会员',
            level: 2,
            parentId: 't2',
            sortOrder: 4,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    ];
  }

  /// 获取当前选中的分类类型Tab的根分类列表
  List<CourseCategory> get _currentRootCategories {
    return _categoryData[_selectedTypeIndex] ?? [];
  }

  /// 获取当前Tab的当前选中的分类
  CourseCategory? get _currentSelection {
    final selected = _selectedCategories[_selectedTypeIndex]!;
    return selected[3] ?? selected[2] ?? selected[1] ?? selected[0];
  }

  /// 获取当前Tab的最大层级
  int get _maxLevel {
    switch (_selectedTypeIndex) {
      case 0: // 行业分类
        return 4;
      case 1: // 课程形式
        return 2;
      case 2: // 课程类型
        return 2;
      default:
        return 4;
    }
  }

  /// 选中指定层级的分类
  void _selectCategory(int level, CourseCategory category) {
    setState(() {
      final selected = _selectedCategories[_selectedTypeIndex]!;
      selected[level] = category;
      // 清空后面层级的选中
      for (var i = level + 1; i < 4; i++) {
        selected[i] = null;
      }
    });
  }

  /// 获取指定层级的子分类列表
  List<CourseCategory> _getChildren(int level) {
    final selected = _selectedCategories[_selectedTypeIndex]!;
    switch (level) {
      case 0:
        return _currentRootCategories;
      case 1:
        return selected[0]?.children ?? [];
      case 2:
        return selected[1]?.children ?? [];
      case 3:
        return selected[2]?.children ?? [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 分类类型Tab选择器
        _buildCategoryTypeTabs(),

        // 内容区域
        Expanded(
          child: _buildContentArea(),
        ),
      ],
    );
  }

  /// 构建分类类型Tab选择器
  Widget _buildCategoryTypeTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 1200, // 限制最大宽度，和下面的标签容器一致
        child: TabBar(
          onTap: (index) {
            setState(() {
              _selectedTypeIndex = index;
            });
          },
          controller: TabController(
            length: 3,
            initialIndex: _selectedTypeIndex,
            vsync: this,
          ),
          labelColor: const Color(0xFF666666),
          unselectedLabelColor: const Color(0xFF999999),
          indicatorColor: const Color(0xFF1A9B8E),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: '行业分类'),
            Tab(text: '课程形式'),
            Tab(text: '课程类型'),
          ],
        ),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContentArea() {
    // 显示对应分类类型的内容
    return Column(
      children: [
        // 根据最大层级显示1-4行标签容器
        for (int level = 1; level <= _maxLevel; level++)
          _buildCategoryLevel(level),

        // 当前选中分类的操作区域
        if (_currentSelection != null) _buildCurrentSelectionActions(),
      ],
    );
  }

  /// 构建当前选中分类的操作区域
  Widget _buildCurrentSelectionActions() {
    final category = _currentSelection!;
    final canAddSub = category.level < _maxLevel;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '当前选中的分类',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),

          // 分类名称和层级
          Row(
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2329),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_getLevelLabel(category.level)}级',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A9B8E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 操作按钮
          Wrap(
            spacing: 12,
            children: [
              // 编辑按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _editCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '编辑名称',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 删除按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _deleteCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4F),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '删除分类',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 添加子分类按钮
              if (canAddSub)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _showAddDialog(category.level + 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1890FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            '添加子分类',
                            style: TextStyle(fontSize: 14, color: Colors.white),
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
    );
  }

  /// 构建分类层级标签容器
  Widget _buildCategoryLevel(int level) {
    final categories = _getChildren(level - 1);
    final hasCategories = categories.isNotEmpty;

    if (!hasCategories) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 层级标签
          Text(
            '${_getLevelLabel(level)}级',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),

          // 标签容器 - 限制最大宽度，不要满屏
          SizedBox(
            width: 1200, // 限制最大宽度
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == categories.length) {
                    // 添加按钮
                    return _buildAddButton(level);
                  }
                  final category = categories[index];
                  final isSelected = _isCategorySelected(category, level);
                  return _buildCategoryTab(category, isSelected, level);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取层级标签文本
  String _getLevelLabel(int level) {
    switch (_selectedTypeIndex) {
      case 0: // 行业分类
        return '第$level';
      case 1: // 课程形式
        return level == 1 ? '形式' : '子类型';
      case 2: // 课程类型
        return level == 1 ? '类型' : '子类型';
      default:
        return '第$level';
    }
  }

  /// 判断分类是否被选中
  bool _isCategorySelected(CourseCategory category, int level) {
    final selected = _selectedCategories[_selectedTypeIndex]!;
    return selected[level - 1]?.id == category.id;
  }

  /// 构建分类标签
  Widget _buildCategoryTab(CourseCategory category, bool isSelected, int level) {
    return GestureDetector(
      onTap: () => _selectCategory(level - 1, category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFD9D9D9),
          ),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF1F2329),
          ),
        ),
      ),
    );
  }

  /// 构建添加按钮
  Widget _buildAddButton(int level) {
    return GestureDetector(
      onTap: () => _showAddDialog(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18, color: Color(0xFF1A9B8E)),
            SizedBox(width: 4),
            Text(
              '添加',
              style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E)),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示添加分类对话框
  void _showAddDialog(int level) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _AddCategoryDialog(
        level: level,
        categoryType: _selectedTypeIndex,
        existingNames: _getChildren(level - 1).map((e) => e.name).toList(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      final now = DateTime.now();
      final newCategory = CourseCategory(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        name: result,
        level: level,
        parentId: level > 1 ? _currentSelection?.id : null,
        sortOrder: _getChildren(level - 1).length,
        createdAt: now,
        updatedAt: now,
      );

      setState(() {
        if (level == 1) {
          _currentRootCategories.add(newCategory);
        } else {
          _currentSelection!.children.add(newCategory);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类添加成功')),
        );
      }
    }
  }

  /// 删除分类
  void _deleteCategory(CourseCategory category) {
    // 检查是否有子分类
    if (category.children.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('无法删除'),
          content: Text('该分类下有${category.children.length}个子分类，请先删除子分类后再操作。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
      return;
    }

    // 显示删除确认对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${category.name}"分类吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _removeCategory(category);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分类删除成功')),
              );
            },
            child: const Text('确定删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 从树中移除分类
  void _removeCategory(CourseCategory category) {
    final selected = _selectedCategories[_selectedTypeIndex]!;

    if (category.level == 1) {
      // 一级分类，直接从根列表移除
      _currentRootCategories.removeWhere((c) => c.id == category.id);
    } else {
      // 子分类，从父分类的children中移除
      final parent = selected[category.level - 2];
      if (parent != null) {
        parent.children.removeWhere((c) => c.id == category.id);
      }
    }

    // 清除选中状态
    for (var i = 0; i < 4; i++) {
      if (selected[i]?.id == category.id) {
        selected[i] = null;
      }
    }
  }

  /// 编辑分类
  void _editCategory(CourseCategory category) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _EditCategoryDialog(
        category: category,
        existingNames: _getSiblingNames(category),
      ),
    );

    if (result != null && result.isNotEmpty && result != category.name) {
      setState(() {
        _updateCategoryName(category, result);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类名称更新成功')),
        );
      }
    }
  }

  /// 获取同级分类的名称列表（用于验证重复）
  List<String> _getSiblingNames(CourseCategory category) {
    if (category.level == 1) {
      return _currentRootCategories.map((c) => c.name).toList();
    } else {
      final selected = _selectedCategories[_selectedTypeIndex]!;
      final parent = selected[category.level - 2];
      return parent?.children.map((c) => c.name).toList() ?? [];
    }
  }

  /// 递归更新分类名称
  void _updateCategoryName(CourseCategory target, String newName) {
    bool updated = false;

    if (target.level == 1) {
      // 更新根列表中的分类
      final index = _currentRootCategories.indexWhere((c) => c.id == target.id);
      if (index != -1) {
        _currentRootCategories[index] = target.copyWith(name: newName);
        updated = true;
      }
    } else {
      // 递归查找并更新子分类
      for (var root in _currentRootCategories) {
        updated = _updateNameInTree(root, target.id, newName);
        if (updated) break;
      }
    }
  }

  /// 在树中递归查找并更新名称
  bool _updateNameInTree(CourseCategory parent, String targetId, String newName) {
    // 检查直接子节点
    final index = parent.children.indexWhere((c) => c.id == targetId);
    if (index != -1) {
      parent.children[index] = parent.children[index].copyWith(name: newName);
      return true;
    }

    // 递归检查子节点的子节点
    for (var child in parent.children) {
      if (_updateNameInTree(child, targetId, newName)) {
        return true;
      }
    }

    return false;
  }
}

/// 添加分类对话框
class _AddCategoryDialog extends StatefulWidget {
  final int level;
  final int categoryType;
  final List<String> existingNames;

  const _AddCategoryDialog({
    required this.level,
    required this.categoryType,
    required this.existingNames,
  });

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String get _levelLabel {
    switch (widget.categoryType) {
      case 0: // 行业分类
        return '第${widget.level}级行业';
      case 1: // 课程形式
        return widget.level == 1 ? '课程形式' : '子类型';
      case 2: // 课程类型
        return widget.level == 1 ? '课程类型' : '子类型';
      default:
        return '分类';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加$_levelLabel'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '分类名称',
            hintText: '请输入分类名称',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入分类名称';
            }
            if (widget.existingNames.contains(value.trim())) {
              return '该分类名称已存在';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

/// 编辑分类对话框
class _EditCategoryDialog extends StatefulWidget {
  final CourseCategory category;
  final List<String> existingNames;

  const _EditCategoryDialog({
    required this.category,
    required this.existingNames,
  });

  @override
  State<_EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<_EditCategoryDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑分类'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '分类名称',
            hintText: '请输入分类名称',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入分类名称';
            }
            // 排除自己原名后检查重复
            final otherNames = widget.existingNames.where((name) => name != widget.category.name).toList();
            if (otherNames.contains(value.trim())) {
              return '该分类名称已存在';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

/// 课程分类管理内容组件（嵌入在merchant_dashboard中使用）
class CourseCategoryManagementContent extends StatelessWidget {
  const CourseCategoryManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseCategoryManagementPage();
  }
}
