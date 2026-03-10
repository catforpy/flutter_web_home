import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 行业分类数据模型
class IndustryCategory {
  final String id;
  final String name;
  final String icon;
  final List<String> subCategories;

  const IndustryCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}

/// 服务卡片数据模型
class ServiceCard {
  final String id;
  final String title;
  final String coverImage;
  final List<String> tags;
  final String providerName;
  final String providerAvatar;
  final double price;
  final String priceUnit;
  final int minOrder;
  final String category;

  const ServiceCard({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.tags,
    required this.providerName,
    required this.providerAvatar,
    required this.price,
    required this.priceUnit,
    required this.minOrder,
    required this.category,
  });
}

/// 购买页面 - 都达 B2B 行业服务聚合平台
///
/// 布局：顶部Header + 一级行业导航 + 二级细分导航 + 筛选工具栏 + 内容网格
/// 核心交互：点击筛选按钮时，右侧侧边栏滑入，内容区从5列变为4列
class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage>
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

  // 一级行业数据
  final List<IndustryCategory> _industries = [
    IndustryCategory(
      id: 'logistics',
      name: '物流交通',
      icon: '🚚',
      subCategories: ['所有服务', '快递配送', '货运物流', '冷链物流', '同城配送', '仓储管理'],
    ),
    IndustryCategory(
      id: 'media',
      name: '影音娱乐',
      icon: '🎬',
      subCategories: ['所有服务', '短视频', '直播', '游戏开发', '影视制作', '音乐制作'],
    ),
    IndustryCategory(
      id: 'medical',
      name: '医疗健康',
      icon: '🏥',
      subCategories: ['所有服务', '智慧医院', '健康管理', '心理咨询', '医疗器械', '体检服务'],
    ),
    IndustryCategory(
      id: 'construction',
      name: '建筑工程',
      icon: '🏗️',
      subCategories: ['所有服务', '室内设计', '装修施工', '工程监理', '建材供应', '工程造价'],
    ),
    IndustryCategory(
      id: 'business',
      name: '商务服务',
      icon: '💼',
      subCategories: ['所有服务', '工商注册', '财务代理', '法律咨询', '知识产权', '人力资源'],
    ),
    IndustryCategory(
      id: 'education',
      name: '教育培训',
      icon: '📚',
      subCategories: ['所有服务', 'K12教育', '职业教育', '语言培训', 'IT培训', '艺术培训'],
    ),
    IndustryCategory(
      id: 'beauty',
      name: '美容美发',
      icon: '💇',
      subCategories: ['所有服务', '美发沙龙', '美容SPA', '美甲美睫', '化妆造型', '皮肤管理'],
    ),
  ];

  // 标签数据
  final List<String> _allTags = [
    '美妆', '颜值', '户外', '越野', '剧情', '科普', '美食', '科技',
    '经济', '搞笑', '生活', '运动', '时尚', '母婴', '汽车'
  ];

  // 当前选中的标签
  final Set<String> _selectedTags = {};

  // 模拟服务卡片数据
  final List<ServiceCard> _serviceCards = [
    ServiceCard(
      id: 's001',
      title: '高端美妆短视频全案策划',
      coverImage: '',
      tags: ['美妆', '剧情', '颜值'],
      providerName: '网红策划有限公司',
      providerAvatar: '',
      price: 5000.0,
      priceUnit: '次',
      minOrder: 1,
      category: '短视频',
    ),
    ServiceCard(
      id: 's002',
      title: '企业宣传片拍摄制作',
      coverImage: '',
      tags: ['剧情', '科技', '商务'],
      providerName: '视界传媒工作室',
      providerAvatar: '',
      price: 8000.0,
      priceUnit: '条',
      minOrder: 1,
      category: '影视制作',
    ),
    ServiceCard(
      id: 's003',
      title: '抖音账号代运营服务',
      coverImage: '',
      tags: ['短视频', '科技', '经济'],
      providerName: '流量跳动科技',
      providerAvatar: '',
      price: 3000.0,
      priceUnit: '月',
      minOrder: 3,
      category: '短视频',
    ),
    ServiceCard(
      id: 's004',
      title: '直播带货策划执行',
      coverImage: '',
      tags: ['直播', '美食', '销售'],
      providerName: '直播优选传媒',
      providerAvatar: '',
      price: 6000.0,
      priceUnit: '场',
      minOrder: 1,
      category: '直播',
    ),
    ServiceCard(
      id: 's005',
      title: '科普短视频内容创作',
      coverImage: '',
      tags: ['科普', '教育', '短视频'],
      providerName: '知识传播工场',
      providerAvatar: '',
      price: 2000.0,
      priceUnit: '条',
      minOrder: 10,
      category: '短视频',
    ),
    ServiceCard(
      id: 's006',
      title: '户外探险短视频拍摄',
      coverImage: '',
      tags: ['户外', '越野', '剧情'],
      providerName: '极限视觉工作室',
      providerAvatar: '',
      price: 4500.0,
      priceUnit: '组',
      minOrder: 1,
      category: '短视频',
    ),
    ServiceCard(
      id: 's007',
      title: '搞笑短视频剧本创作',
      coverImage: '',
      tags: ['搞笑', '剧情', '短视频'],
      providerName: '快乐剧本工场',
      providerAvatar: '',
      price: 1500.0,
      priceUnit: '个',
      minOrder: 5,
      category: '短视频',
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
    // 延迟执行动画，确保布局完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showFilterSidebar) {
        _filterAnimationController.forward();
      }
    });

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
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '搜索行业服务...',
                        hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      style: const TextStyle(fontSize: 14),
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
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5000),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
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

              // 个人中心头像
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('打开个人中心');
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF1890FF),
                    child: const Icon(
                      Icons.person,
                      size: 18,
                      color: Colors.white,
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

  /// B. 构建一级行业导航栏
  Widget _buildTopIndustryBar() {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      industry.icon,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      industry.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
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
      height: 40,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                margin: const EdgeInsets.only(right: 24),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
          Container(
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
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                fontSize: 13,
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
                        colors: [Colors.transparent, Color(0x00FFFFFF],
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
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const Icon(
              Icons.expand_more,
              size: 16,
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.only(
        left: 24,
        right: _showFilterSidebar ? 324 : 24, // 为侧边栏留出空间
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
    );
  }

  /// 构建服务卡片
  Widget _buildServiceCard(ServiceCard card) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击服务：${card.title}');
        },
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面图
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: card.coverImage.isNotEmpty
                    ? Image.network(
                        card.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 48, color: Color(0xFFCCCCCC)),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.business_center, size: 48, color: Color(0xFFCCCCCC)),
                      ),
              ),

              // 内容区域
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // 标签行
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: card.tags.take(3).map((tag) {
                        return Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 8),

                    // 服务商信息
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFF1890FF),
                          child: Text(
                            card.providerName.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            card.providerName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5000).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: const Color(0xFFFF5000).withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            '企',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFFFF5000),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // 底部栏
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 价格/起订量
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¥${card.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF5000),
                              ),
                            ),
                            Text(
                              '${card.priceUnit} · ${card.minOrder}起订',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),

                        // 立即咨询按钮
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('立即咨询：${card.title}');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF1890FF)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '立即咨询',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1890FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: const Color(0xFFCCCCCC),
          ),
          const SizedBox(height: 16),
          const Text(
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
        return Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              // 点击遮罩关闭侧边栏
              setState(() {
                _showFilterSidebar = false;
                _filterAnimationController.reverse();
              });
            },
            child: Container(
              width: 300 + (320 * _filterSlideAnimation.value),
              color: Colors.black.withValues(alpha: 0.5 * _filterSlideAnimation.value),
              child: Stack(
                children: [
                  // 侧边栏内容
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 300,
                      color: Colors.white,
                      child: Column(
                        children: [
                          // 侧边栏标题
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '筛选条件',
                                  style: TextStyle(
                                    fontSize: 16,
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
                                      size: 20,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 筛选项内容
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                _buildFilterSection('所在地', ['全国', '北京', '上海', '深圳', '杭州']),
                                _buildFilterSection('服务等级', ['全部', '金牌服务商', '银牌服务商', '认证服务商']),
                                _buildFilterSection('认证类型', ['全部', '企业认证', '个人认证', '实名认证']),
                                _buildFilterSection('价格区间', ['全部', '1000以下', '1000-5000', '5000-10000', '10000以上']),
                              ],
                            ),
                          ),

                          // 底部操作按钮
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        // 重置筛选
                                        setState(() {
                                          _selectedTags.clear();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFE0E0E0)),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          '重置',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        // 应用筛选
                                        setState(() {
                                          _showFilterSidebar = false;
                                          _filterAnimationController.reverse();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1890FF),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          '确定',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建筛选区域
  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: 应用筛选
                  debugPrint('筛选：$option');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
