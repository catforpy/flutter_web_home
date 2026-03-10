import 'package:flutter/material.dart';

/// 商品分类节点（树形结构）
class ProductCategory {
  final String id;
  final String name;
  final int level; // 1-4级
  final String? parentId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductCategory> children;

  ProductCategory({
    required this.id,
    required this.name,
    required this.level,
    this.parentId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    List<ProductCategory>? children,
  }) : children = children ?? [];

  /// 复制并更新部分字段
  ProductCategory copyWith({
    String? id,
    String? name,
    int? level,
    String? parentId,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProductCategory>? children,
  }) {
    return ProductCategory(
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

/// 用户自定义商品分类
class UserProductCategory {
  final String id;
  final String name;
  final String? description;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> productIds; // 该分类包含的商品ID列表

  UserProductCategory({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    List<String>? productIds,
  }) : productIds = productIds ?? [];

  /// 复制并更新部分字段
  UserProductCategory copyWith({
    String? id,
    String? name,
    String? description,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? productIds,
  }) {
    return UserProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productIds: productIds ?? this.productIds,
    );
  }
}

/// 商品分类管理页面
/// 包含两个Tab：
/// 1. 基础分类（4级树形结构）
/// 2. 客户自定义分类（用户可自定义）
class ProductCategoryManagementPage extends StatefulWidget {
  const ProductCategoryManagementPage({super.key});

  @override
  State<ProductCategoryManagementPage> createState() => _ProductCategoryManagementPageState();
}

class _ProductCategoryManagementPageState extends State<ProductCategoryManagementPage>
    with TickerProviderStateMixin<ProductCategoryManagementPage> {
  // 当前选中的Tab（0: 基础分类, 1: 客户自定义分类）
  int _selectedTab = 0;

  late TabController _tabController;

  // 基础分类数据（4级树形结构）
  List<ProductCategory> _baseCategories = [];

  // 基础分类的选中状态（支持4级）
  final List<ProductCategory?> _selectedBaseCategories = [null, null, null, null];

  // 客户自定义分类数据
  List<UserProductCategory> _userCategories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: _selectedTab,
      vsync: this,
    );
    _loadBaseCategories();
    _loadUserCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 加载基础分类数据
  void _loadBaseCategories() {
    final now = DateTime.now();

    _baseCategories = [
      ProductCategory(
        id: 'b1',
        name: '服装鞋帽',
        level: 1,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        children: [
          ProductCategory(
            id: 'b1-1',
            name: '男装',
            level: 2,
            parentId: 'b1',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
            children: [
              ProductCategory(
                id: 'b1-1-1',
                name: '上衣',
                level: 3,
                parentId: 'b1-1',
                sortOrder: 1,
                createdAt: now,
                updatedAt: now,
                children: [
                  ProductCategory(
                    id: 'b1-1-1-1',
                    name: 'T恤',
                    level: 4,
                    parentId: 'b1-1-1',
                    sortOrder: 1,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  ProductCategory(
                    id: 'b1-1-1-2',
                    name: '衬衫',
                    level: 4,
                    parentId: 'b1-1-1',
                    sortOrder: 2,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  ProductCategory(
                    id: 'b1-1-1-3',
                    name: '夹克',
                    level: 4,
                    parentId: 'b1-1-1',
                    sortOrder: 3,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ],
              ),
              ProductCategory(
                id: 'b1-1-2',
                name: '裤装',
                level: 3,
                parentId: 'b1-1',
                sortOrder: 2,
                createdAt: now,
                updatedAt: now,
                children: [
                  ProductCategory(
                    id: 'b1-1-2-1',
                    name: '牛仔裤',
                    level: 4,
                    parentId: 'b1-1-2',
                    sortOrder: 1,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  ProductCategory(
                    id: 'b1-1-2-2',
                    name: '休闲裤',
                    level: 4,
                    parentId: 'b1-1-2',
                    sortOrder: 2,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ],
              ),
            ],
          ),
          ProductCategory(
            id: 'b1-2',
            name: '女装',
            level: 2,
            parentId: 'b1',
            sortOrder: 2,
            createdAt: now,
            updatedAt: now,
            children: [
              ProductCategory(
                id: 'b1-2-1',
                name: '连衣裙',
                level: 3,
                parentId: 'b1-2',
                sortOrder: 1,
                createdAt: now,
                updatedAt: now,
                children: [
                  ProductCategory(
                    id: 'b1-2-1-1',
                    name: '长裙',
                    level: 4,
                    parentId: 'b1-2-1',
                    sortOrder: 1,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  ProductCategory(
                    id: 'b1-2-1-2',
                    name: '短裙',
                    level: 4,
                    parentId: 'b1-2-1',
                    sortOrder: 2,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ProductCategory(
        id: 'b2',
        name: '数码电器',
        level: 1,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        children: [
          ProductCategory(
            id: 'b2-1',
            name: '手机',
            level: 2,
            parentId: 'b2',
            sortOrder: 1,
            createdAt: now,
            updatedAt: now,
            children: [
              ProductCategory(
                id: 'b2-1-1',
                name: '智能手机',
                level: 3,
                parentId: 'b2-1',
                sortOrder: 1,
                createdAt: now,
                updatedAt: now,
                children: [
                  ProductCategory(
                    id: 'b2-1-1-1',
                    name: '苹果',
                    level: 4,
                    parentId: 'b2-1-1',
                    sortOrder: 1,
                    createdAt: now,
                    updatedAt: now,
                  ),
                  ProductCategory(
                    id: 'b2-1-1-2',
                    name: '华为',
                    level: 4,
                    parentId: 'b2-1-1',
                    sortOrder: 2,
                    createdAt: now,
                    updatedAt: now,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ProductCategory(
        id: 'b3',
        name: '美妆护肤',
        level: 1,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
      ProductCategory(
        id: 'b4',
        name: '家居用品',
        level: 1,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
      ProductCategory(
        id: 'b5',
        name: '食品饮料',
        level: 1,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
        children: [],
      ),
    ];
  }

  /// 加载客户自定义分类数据
  void _loadUserCategories() {
    final now = DateTime.now();

    _userCategories = [
      UserProductCategory(
        id: 'u1',
        name: '热销商品',
        description: '销量最高的商品',
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
        productIds: ['p001', 'p002', 'p003'],
      ),
      UserProductCategory(
        id: 'u2',
        name: '新品推荐',
        description: '最新上架的商品',
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
        productIds: ['p004', 'p005'],
      ),
      UserProductCategory(
        id: 'u3',
        name: '促销活动',
        description: '正在促销的商品',
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
        productIds: ['p006', 'p007', 'p008', 'p009'],
      ),
      UserProductCategory(
        id: 'u4',
        name: '季节特惠',
        description: '季节性特价商品',
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
        productIds: ['p010', 'p011'],
      ),
    ];
  }

  /// 获取当前选中的基础分类
  ProductCategory? get _currentBaseSelection {
    return _selectedBaseCategories[3] ??
           _selectedBaseCategories[2] ??
           _selectedBaseCategories[1] ??
           _selectedBaseCategories[0];
  }

  /// 选中指定层级的分类
  void _selectBaseCategory(int level, ProductCategory category) {
    setState(() {
      _selectedBaseCategories[level] = category;
      // 清空后面层级的选中
      for (var i = level + 1; i < 4; i++) {
        _selectedBaseCategories[i] = null;
      }
    });
  }

  /// 获取指定层级的子分类列表
  List<ProductCategory> _getBaseChildren(int level) {
    switch (level) {
      case 0:
        return _baseCategories;
      case 1:
        return _selectedBaseCategories[0]?.children ?? [];
      case 2:
        return _selectedBaseCategories[1]?.children ?? [];
      case 3:
        return _selectedBaseCategories[2]?.children ?? [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab选择器
        _buildTabBar(),

        // 内容区域
        Expanded(
          child: _buildContentArea(),
        ),
      ],
    );
  }

  /// 构建Tab选择器
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        controller: _tabController,
        labelColor: const Color(0xFF666666),
        unselectedLabelColor: const Color(0xFF999999),
        indicatorColor: const Color(0xFF1A9B8E),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: '基础分类'),
          Tab(text: '客户自定义分类'),
        ],
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContentArea() {
    if (_selectedTab == 0) {
      return _buildBaseCategoryContent();
    } else {
      return _buildUserCategoryContent();
    }
  }

  /// 构建基础分类内容
  Widget _buildBaseCategoryContent() {
    return Column(
      children: [
        // 根据最大层级显示1-4行标签容器
        for (int level = 1; level <= 4; level++)
          _buildBaseCategoryLevel(level),

        // 当前选中分类的操作区域
        if (_currentBaseSelection != null) _buildCurrentBaseSelectionActions(),
      ],
    );
  }

  /// 构建基础分类层级标签容器
  Widget _buildBaseCategoryLevel(int level) {
    final categories = _getBaseChildren(level - 1);

    if (categories.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 层级标签
          Text(
            '第$level级',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),

          // 标签容器
          SizedBox(
            width: 1200,
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
                  final isSelected = _isBaseCategorySelected(category, level);
                  return _buildBaseCategoryTab(category, isSelected, level);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 判断基础分类是否被选中
  bool _isBaseCategorySelected(ProductCategory category, int level) {
    return _selectedBaseCategories[level - 1]?.id == category.id;
  }

  /// 构建基础分类标签
  Widget _buildBaseCategoryTab(ProductCategory category, bool isSelected, int level) {
    return GestureDetector(
      onTap: () => _selectBaseCategory(level - 1, category),
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
      onTap: () => _showAddBaseDialog(level),
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

  /// 构建当前选中基础分类的操作区域
  Widget _buildCurrentBaseSelectionActions() {
    final category = _currentBaseSelection!;
    final canAddSub = category.level < 4;

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
                  '${category.level}级',
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
              _buildActionButton(Icons.edit, '编辑名称', const Color(0xFF1A9B8E), () {
                _editBaseCategory(category);
              }),

              // 删除按钮
              _buildActionButton(Icons.delete, '删除分类', const Color(0xFFFF4D4F), () {
                _deleteBaseCategory(category);
              }),

              // 添加子分类按钮
              if (canAddSub)
                _buildActionButton(Icons.add_circle_outline, '添加子分类', const Color(0xFF1890FF), () {
                  _showAddBaseDialog(category.level + 1);
                }),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建客户自定义分类内容
  Widget _buildUserCategoryContent() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部操作栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '客户自定义分类',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _showAddUserDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 18, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '添加分类',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 分类列表
          Expanded(
            child: _buildUserCategoryList(),
          ),
        ],
      ),
    );
  }

  /// 构建客户自定义分类列表
  Widget _buildUserCategoryList() {
    if (_userCategories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 80,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
              '暂无自定义分类',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 3,
      ),
      itemCount: _userCategories.length,
      itemBuilder: (context, index) {
        return _buildUserCategoryCard(_userCategories[index]);
      },
    );
  }

  /// 构建客户自定义分类卡片
  Widget _buildUserCategoryCard(UserProductCategory category) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类名称和商品数量
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${category.productIds.length}个商品',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A9B8E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 描述
          if (category.description != null && category.description!.isNotEmpty)
            Text(
              category.description!,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const Spacer(),

          // 操作按钮
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _editUserCategory(category),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _deleteUserCategory(category),
                  child: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Color(0xFFFF4D4F),
                  ),
                ),
              ),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('管理商品：${category.name}');
                  },
                  child: const Text(
                    '管理商品',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A9B8E),
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

  /// 构建操作按钮
  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示添加基础分类对话框
  void _showAddBaseDialog(int level) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _AddBaseCategoryDialog(
        level: level,
        existingNames: _getBaseChildren(level - 1).map((e) => e.name).toList(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      final now = DateTime.now();
      final newCategory = ProductCategory(
        id: 'base_${DateTime.now().millisecondsSinceEpoch}',
        name: result,
        level: level,
        parentId: level > 1 ? _currentBaseSelection?.id : null,
        sortOrder: _getBaseChildren(level - 1).length,
        createdAt: now,
        updatedAt: now,
      );

      setState(() {
        if (level == 1) {
          _baseCategories.add(newCategory);
        } else {
          _currentBaseSelection!.children.add(newCategory);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类添加成功')),
        );
      }
    }
  }

  /// 删除基础分类
  void _deleteBaseCategory(ProductCategory category) {
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
                _removeBaseCategory(category);
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

  /// 从树中移除基础分类
  void _removeBaseCategory(ProductCategory category) {
    if (category.level == 1) {
      _baseCategories.removeWhere((c) => c.id == category.id);
    } else {
      final parent = _selectedBaseCategories[category.level - 2];
      if (parent != null) {
        parent.children.removeWhere((c) => c.id == category.id);
      }
    }

    // 清除选中状态
    for (var i = 0; i < 4; i++) {
      if (_selectedBaseCategories[i]?.id == category.id) {
        _selectedBaseCategories[i] = null;
      }
    }
  }

  /// 编辑基础分类
  void _editBaseCategory(ProductCategory category) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _EditBaseCategoryDialog(
        category: category,
        existingNames: _getBaseSiblingNames(category),
      ),
    );

    if (result != null && result.isNotEmpty && result != category.name) {
      setState(() {
        _updateBaseCategoryName(category, result);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类名称更新成功')),
        );
      }
    }
  }

  /// 获取同级基础分类的名称列表
  List<String> _getBaseSiblingNames(ProductCategory category) {
    if (category.level == 1) {
      return _baseCategories.map((c) => c.name).toList();
    } else {
      final parent = _selectedBaseCategories[category.level - 2];
      return parent?.children.map((c) => c.name).toList() ?? [];
    }
  }

  /// 递归更新基础分类名称
  void _updateBaseCategoryName(ProductCategory target, String newName) {
    if (target.level == 1) {
      final index = _baseCategories.indexWhere((c) => c.id == target.id);
      if (index != -1) {
        _baseCategories[index] = target.copyWith(name: newName);
      }
    } else {
      for (var root in _baseCategories) {
        if (_updateNameInBaseTree(root, target.id, newName)) break;
      }
    }
  }

  /// 在树中递归查找并更新名称
  bool _updateNameInBaseTree(ProductCategory parent, String targetId, String newName) {
    final index = parent.children.indexWhere((c) => c.id == targetId);
    if (index != -1) {
      parent.children[index] = parent.children[index].copyWith(name: newName);
      return true;
    }

    for (var child in parent.children) {
      if (_updateNameInBaseTree(child, targetId, newName)) {
        return true;
      }
    }

    return false;
  }

  /// 显示添加客户自定义分类对话框
  void _showAddUserDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _AddUserCategoryDialog(),
    );
    if (result != null) {
      final now = DateTime.now();
      final newCategory = UserProductCategory(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: result['name'] as String,
        description: result['description'] as String?,
        sortOrder: _userCategories.length,
        createdAt: now,
        updatedAt: now,
        productIds: [],
      );

      setState(() {
        _userCategories.add(newCategory);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('自定义分类添加成功')),
        );
      }
    }
  }

  /// 编辑客户自定义分类
  void _editUserCategory(UserProductCategory category) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _EditUserCategoryDialog(category: category),
    );

    if (result != null) {
      setState(() {
        final index = _userCategories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _userCategories[index] = category.copyWith(
            name: result['name'] as String? ?? category.name,
            description: result['description'] as String?,
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分类更新成功')),
        );
      }
    }
  }

  /// 删除客户自定义分类
  void _deleteUserCategory(UserProductCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除"${category.name}"分类吗？'),
            if (category.productIds.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '注意：该分类下还有${category.productIds.length}个商品',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFFF9800),
                ),
              ),
            ],
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
                _userCategories.removeWhere((c) => c.id == category.id);
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
}

/// 添加基础分类对话框
class _AddBaseCategoryDialog extends StatefulWidget {
  final int level;
  final List<String> existingNames;

  const _AddBaseCategoryDialog({
    required this.level,
    required this.existingNames,
  });

  @override
  State<_AddBaseCategoryDialog> createState() => _AddBaseCategoryDialogState();
}

class _AddBaseCategoryDialogState extends State<_AddBaseCategoryDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加第${widget.level}级分类'),
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

/// 编辑基础分类对话框
class _EditBaseCategoryDialog extends StatefulWidget {
  final ProductCategory category;
  final List<String> existingNames;

  const _EditBaseCategoryDialog({
    required this.category,
    required this.existingNames,
  });

  @override
  State<_EditBaseCategoryDialog> createState() => _EditBaseCategoryDialogState();
}

class _EditBaseCategoryDialogState extends State<_EditBaseCategoryDialog> {
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

/// 添加客户自定义分类对话框
class _AddUserCategoryDialog extends StatefulWidget {
  const _AddUserCategoryDialog();

  @override
  State<_AddUserCategoryDialog> createState() => _AddUserCategoryDialogState();
}

class _AddUserCategoryDialogState extends State<_AddUserCategoryDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加自定义分类'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
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
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: '分类描述（可选）',
                hintText: '请输入分类描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
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
              Navigator.of(context).pop({
                'name': _nameController.text.trim(),
                'description': _descController.text.trim().isEmpty
                    ? null
                    : _descController.text.trim(),
              });
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

/// 编辑客户自定义分类对话框
class _EditUserCategoryDialog extends StatefulWidget {
  final UserProductCategory category;

  const _EditUserCategoryDialog({required this.category});

  @override
  State<_EditUserCategoryDialog> createState() => _EditUserCategoryDialogState();
}

class _EditUserCategoryDialogState extends State<_EditUserCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descController = TextEditingController(text: widget.category.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑自定义分类'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
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
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: '分类描述（可选）',
                hintText: '请输入分类描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
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
              Navigator.of(context).pop({
                'name': _nameController.text.trim(),
                'description': _descController.text.trim().isEmpty
                    ? null
                    : _descController.text.trim(),
              });
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}

/// 商品分类管理内容组件（嵌入在merchant_dashboard中使用）
class ProductCategoryManagementContent extends StatelessWidget {
  const ProductCategoryManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductCategoryManagementPage();
  }
}
