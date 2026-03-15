import 'package:flutter/material.dart';
import 'package:official_website/presentation/widgets/common/auth_widget.dart';
import '../../models/service_models.dart';
/// 行业分类数据模型

/// 租赁页面 - 都达 B2B 租赁服务平台
///
/// 布局：顶部Header + 一级行业导航 + 二级细分导航 + 筛选工具栏 + 内容网格
/// 核心交互：点击筛选按钮时，右侧侧边栏滑入，内容区从5列变为4列
class LeasePage extends StatefulWidget {
  const LeasePage({super.key});

  @override
  State<LeasePage> createState() => _LeasePageState();
}

class _LeasePageState extends State<LeasePage>
    with SingleTickerProviderStateMixin {
  // 选中的一级行业
  IndustryCategory? _selectedIndustry;

  // 选中的二级分类
  String? _selectedSubCategory;

  // 搜索关键词
  String _searchKeyword = '';

  // 是否显示筛选侧边栏
  bool _showFilterSidebar = false;

  // 筛选侧边栏动画控制器
  late AnimationController _filterAnimationController;
  late Animation<double> _filterSlideAnimation;

  // 一级行业数据（租赁相关）
  final List<IndustryCategory> _industries = [
    const IndustryCategory(
      id: 'equipment',
      name: '设备租赁',
      icon: '🔧',
      subCategories: ['所有服务', '工程机械', '办公设备', '电脑设备', '摄影器材', '演出设备'],
    ),
    const IndustryCategory(
      id: 'vehicle',
      name: '车辆租赁',
      icon: '🚗',
      subCategories: ['所有服务', '轿车', 'SUV', '商务车', '货车', '大巴车'],
    ),
    const IndustryCategory(
      id: 'venue',
      name: '场地租赁',
      icon: '🏢',
      subCategories: ['所有服务', '会议室', '展厅', '仓库', '商铺', '厂房'],
    ),
    const IndustryCategory(
      id: 'clothing',
      name: '服装租赁',
      icon: '👔',
      subCategories: ['所有服务', '礼服', '演出服', '制服', '婚纱', '汉服'],
    ),
    const IndustryCategory(
      id: 'digital',
      name: '数码租赁',
      icon: '📱',
      subCategories: ['所有服务', '手机', '平板', '相机', '无人机', '游戏机'],
    ),
    const IndustryCategory(
      id: 'furniture',
      name: '家具租赁',
      icon: '🛋️',
      subCategories: ['所有服务', '办公家具', '家居家具', '活动家具', '户外家具', '儿童家具'],
    ),
  ];

  // 标签数据
  final List<String> _allTags = [
    '短租', '长租', '日租', '周租', '月租', '年租',
    '免押金', '包维修', '送上门', '全新', '9成新'
  ];

  // 当前选中的标签
  final Set<String> _selectedTags = {};

  // 模拟服务卡片数据（租赁相关）
  final List<ServiceCard> _serviceCards = [
    const ServiceCard(
      id: 'l001',
      title: '挖掘机日租服务',
      coverImage: '',
      tags: ['工程机械', '日租', '免押金'],
      providerName: '重型机械租赁公司',
      providerAvatar: '',
      price: 800.0,
      priceUnit: '天',
      minOrder: 1,
      category: '工程机械',
    ),
    const ServiceCard(
      id: 'l002',
      title: '办公电脑月租套餐',
      coverImage: '',
      tags: ['电脑设备', '月租', '包维修'],
      providerName: 'IT设备租赁中心',
      providerAvatar: '',
      price: 200.0,
      priceUnit: '月',
      minOrder: 3,
      category: '电脑设备',
    ),
    const ServiceCard(
      id: 'l003',
      title: '商务车婚车租赁',
      coverImage: '',
      tags: ['商务车', '日租', '送上门'],
      providerName: '婚庆车队',
      providerAvatar: '',
      price: 1200.0,
      priceUnit: '天',
      minOrder: 1,
      category: '商务车',
    ),
    const ServiceCard(
      id: 'l004',
      title: '会议室按时计费',
      coverImage: '',
      tags: ['会议室', '短租', '9成新'],
      providerName: '共享办公空间',
      providerAvatar: '',
      price: 100.0,
      priceUnit: '小时',
      minOrder: 2,
      category: '会议室',
    ),
    const ServiceCard(
      id: 'l005',
      title: '单反相机全套租赁',
      coverImage: '',
      tags: ['摄影器材', '日租', '全新'],
      providerName: '专业摄影器材',
      providerAvatar: '',
      price: 300.0,
      priceUnit: '天',
      minOrder: 1,
      category: '摄影器材',
    ),
    const ServiceCard(
      id: 'l006',
      title: '高档西装礼服租赁',
      coverImage: '',
      tags: ['礼服', '短租', '送上门'],
      providerName: '皇家礼服租赁',
      providerAvatar: '',
      price: 200.0,
      priceUnit: '天',
      minOrder: 1,
      category: '礼服',
    ),
    const ServiceCard(
      id: 'l007',
      title: '无人机航拍租赁',
      coverImage: '',
      tags: ['摄影器材', '日租', '免押金'],
      providerName: '航拍器材租赁',
      providerAvatar: '',
      price: 500.0,
      priceUnit: '天',
      minOrder: 1,
      category: '摄影器材',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 默认选中第一个行业
    if (_industries.isNotEmpty) {
      _selectedIndustry = _industries[1]; // 影音娱乐
      _selectedSubCategory = '短视频';
    }

    // 初始化筛选侧边栏动画
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filterSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    super.dispose();
  }

  /// 获取筛选后的服务卡片
  List<ServiceCard> get _filteredCards {
    var filtered = List<ServiceCard>.from(_serviceCards);

    // 按二级分类筛选
    if (_selectedSubCategory != null && _selectedSubCategory != '所有服务') {
      filtered = filtered.where((card) => card.category == _selectedSubCategory).toList();
    }

    // 按标签筛选
    if (_selectedTags.isNotEmpty) {
      filtered = filtered.where((card) {
        return card.tags.any((tag) => _selectedTags.contains(tag));
      }).toList();
    }

    // 按关键词搜索
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      filtered = filtered.where((card) {
        return card.title.toLowerCase().contains(keyword) ||
               card.tags.any((tag) => tag.toLowerCase().contains(keyword));
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // A. 顶部通栏 Header
          _buildHeader(),

          // B. 一级行业导航栏
          _buildTopIndustryBar(),

          // C. 二级细分导航条
          _buildSubCategoryBar(),

          // D. 筛选与标签工具栏
          _buildFilterToolbar(),

          // E. 主体内容展示区
          Expanded(
            child: Stack(
              children: [
                // 服务卡片网格
                _buildServiceGrid(),

                // F. 筛选侧边栏（覆盖层）
                if (_showFilterSidebar)
                  _buildFilterSidebar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A. 构建顶部通栏 Header
  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          const Text(
            '都达 Douda',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(width: 40),

          // 搜索框
          Expanded(
            child: Center(
              child: SizedBox(
                width: 600, // 固定搜索框宽度
                child: Container(
                  height: 48, // 增加高度
                  decoration: BoxDecoration(
                    color: Colors.white, // 搜索框背景设为白色
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: '搜索租赁服务...',
                            hintStyle: TextStyle(fontSize: 15, color: Color(0xFF999999)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white, // TextField内部背景为白色
                          ),
                          style: const TextStyle(fontSize: 15),
                          onChanged: (value) {
                            setState(() {
                              _searchKeyword = value;
                            });
                          },
                        ),
                      ),
                      // 搜索按钮
                      Container(
                        width: 80,
                        height: 48, // 与搜索框高度一致
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5000),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24, // 增大图标
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 40),

          // 用户功能区
          Row(
            children: [
              // 消息图标
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('打开消息中心');
                  },
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: Color(0xFF666666),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // 认证组件（与首页共用）
              const AuthWidget(),
            ],
          ),
        ],
      ),
    );
  }

  /// B. 构建一级行业导航栏
  Widget _buildTopIndustryBar() {
    return Container(
      height: 100, // 增加高度避免溢出
      padding: const EdgeInsets.symmetric(horizontal: 120), // 与二级导航保持一致
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 居中显示
        children: _industries.map((industry) {
          final isSelected = _selectedIndustry?.id == industry.id;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndustry = industry;
                  _selectedSubCategory = industry.subCategories.isNotEmpty
                      ? industry.subCategories[0]
                      : null;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12), // 使用固定的水平间距
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // 减少vertical padding
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1890FF).withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      industry.icon,
                      style: const TextStyle(
                        fontSize: 32, // 增大图标
                      ),
                    ),
                    const SizedBox(height: 4), // 减少间距
                    Text(
                      industry.name,
                      style: TextStyle(
                        fontSize: 16, // 增大文字
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6), // 减少间距
                    // 选中指示器
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      width: isSelected ? 40 : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1890FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// C. 构建二级细分导航条
  Widget _buildSubCategoryBar() {
    if (_selectedIndustry == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50, // 增加高度
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: Row(
        children: _selectedIndustry!.subCategories.map((category) {
          final isSelected = _selectedSubCategory == category;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSubCategory = category;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1890FF).withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 15, // 增大文字
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// D. 构建筛选与标签工具栏
  Widget _buildFilterToolbar() {
    final filteredCards = _filteredCards;

    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 120), // 增加左右边距
      child: Row(
        children: [
          // 左侧排序区
          Row(
            children: [
              _buildSortItem('综合'),
              const SizedBox(width: 24),
              _buildSortItem('评分'),
              const SizedBox(width: 24),
              _buildSortItem('销量'),
              const SizedBox(width: 24),
              _buildSortItem('价格'),
              const SizedBox(width: 24),
              _buildSortItem('价格区间'),
            ],
          ),

          const Spacer(),

          // 中间标签滑动区
          SizedBox(
            width: 600,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _allTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedTags.contains(tag)) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF1890FF) : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 14, // 增大文字
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // 右侧滚动指示箭头
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Color(0x00FFFFFF)],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // 右侧筛选按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showFilterSidebar = !_showFilterSidebar;
                  if (_showFilterSidebar) {
                    _filterAnimationController.forward();
                  } else {
                    _filterAnimationController.reverse();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune_outlined,
                      size: 18,
                      color: _showFilterSidebar ? const Color(0xFF1890FF) : const Color(0xFF666666),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '筛选',
                      style: TextStyle(
                        fontSize: 14,
                        color: _showFilterSidebar ? const Color(0xFF1890FF) : const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 结果数量
          Text(
            '共 ${filteredCards.length} 个服务',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建排序项
  Widget _buildSortItem(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('排序：$label');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15, // 增大文字
                color: Color(0xFF666666),
              ),
            ),
            const Icon(
              Icons.expand_more,
              size: 18, // 增大图标
              color: Color(0xFF666666),
            ),
          ],
        ),
      ),
    );
  }

  /// E. 构建服务卡片网格
  Widget _buildServiceGrid() {
    final filteredCards = _filteredCards;
    final crossAxisCount = _showFilterSidebar ? 4 : 5; // 根据侧边栏状态决定列数

    return Container(
      color: const Color(0xFFF5F7FA),
      padding: const EdgeInsets.symmetric(horizontal: 120), // 添加左右边距，与导航栏保持一致
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(
          right: _showFilterSidebar ? 300 : 0, // 为侧边栏留出空间（300px侧边栏宽度）
        ),
      child: filteredCards.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 260 / 380,
              ),
              itemCount: filteredCards.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(filteredCards[index]);
              },
            ),
      ),
    );
  }

  /// 构建服务卡片（使用案例页面的样式）
  Widget _buildServiceCard(ServiceCard card) {
    return _PurchaseServiceCard(serviceCard: card);
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            '暂无相关服务',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// F. 构建筛选侧边栏
  Widget _buildFilterSidebar() {
    return AnimatedBuilder(
      animation: _filterSlideAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // 点击空白处关闭侧边栏
            setState(() {
              _showFilterSidebar = false;
              _filterAnimationController.reverse();
            });
          },
          child: Container(
            color: Colors.black.withValues(alpha: 0.5 * _filterSlideAnimation.value),
            child: Stack(
              children: [
                // 侧边栏主体
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {}, // 阻止事件冒泡，不关闭侧边栏
                    child: Container(
                      width: 320,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 10,
                            offset: Offset(-2, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 标题栏
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '筛选条件',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showFilterSidebar = false;
                                        _filterAnimationController.reverse();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 24,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 筛选内容区（可滚动）
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 价格区间
                                  _buildFilterSection('价格区间', ['不限', '100以下', '100-500', '500-1000', '1000以上']),

                                  const SizedBox(height: 24),

                                  // 服务评分
                                  _buildFilterSection('服务评分', ['不限', '4星以上', '5星']),

                                  const SizedBox(height: 24),

                                  // 起订量
                                  _buildFilterSection('起订量', ['不限', '1件起', '10件起', '100件起']),

                                  const SizedBox(height: 24),

                                  // 服务商类型
                                  _buildFilterSection('服务商类型', ['不限', '个人', '企业', '旗舰店']),
                                ],
                              ),
                            ),
                          ),

                          // 底部按钮区
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedTags.clear();
                                        });
                                      },
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFE0E0E0)),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '重置',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF666666),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showFilterSidebar = false;
                                          _filterAnimationController.reverse();
                                        });
                                      },
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1890FF),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '应用筛选',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建筛选区块
  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            const isSelected = false;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: 实现筛选逻辑
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1890FF).withValues(alpha: 0.1) : Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 14,
                      color: isSelected ? Color(0xFF1890FF) : Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 服务卡片组件（使用案例页面的样式，带鼠标跟随效果）
class _PurchaseServiceCard extends StatefulWidget {
  final ServiceCard serviceCard;

  const _PurchaseServiceCard({required this.serviceCard});

  @override
  State<_PurchaseServiceCard> createState() => _PurchaseServiceCardState();
}

class _PurchaseServiceCardState extends State<_PurchaseServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (event) {
        if (_isHovered) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final localPosition = box.globalToLocal(event.position);
            if ((localPosition - _mousePosition).distance > 10) {
              setState(() {
                _mousePosition = localPosition;
              });
            }
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          debugPrint('点击服务：${widget.serviceCard.title}');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // 背景图片
                Positioned.fill(
                  child: Image.network(
                    widget.serviceCard.coverImage.isNotEmpty
                        ? widget.serviceCard.coverImage
                        : 'https://picsum.photos/260/380?random=${widget.serviceCard.id}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.withValues(alpha: 0.2),
                        child: const Center(
                          child: Icon(Icons.business_center, size: 48, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),

                // 半透明蒙层（悬停时显示）
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  color: _isHovered
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.transparent,
                ),

                // 鼠标跟随的红色光圈（悬停时显示）
                if (_isHovered)
                  Positioned(
                    left: _mousePosition.dx - 30,
                    top: _mousePosition.dy - 40,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFFD93025),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD93025).withValues(alpha: 0.6),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '咨询',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // 内容层
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(_isHovered ? 20 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左上角：服务商Logo
                        AnimatedScale(
                          scale: _isHovered ? 0.75 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.serviceCard.providerName.substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1890FF),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 底部信息
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 标签行（悬停时显示）
                            AnimatedSize(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              child: _isHovered
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: widget.serviceCard.tags.take(3).map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            // 标题 + 价格 Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.serviceCard.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.serviceCard.providerName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '¥${widget.serviceCard.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${widget.serviceCard.priceUnit}起',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
      ),
    );
  }
}
