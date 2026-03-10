import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
import 'reward_records_content.dart';
import 'article_list_content.dart';
import 'article_edit_page.dart';
import 'payment_management_page.dart';
import 'carousel_management_content.dart';
import '../../../../core/cache/workbench_cache_service.dart';

/// 文章管理页面
/// 包含分类管理、文章列表预览和样式配置
class ArticleManagementPage extends StatefulWidget {
  /// 是否显示完整的导航（一级导航栏+顶部标题栏）
  /// 当嵌入到 MerchantDashboard 中时，应设置为 false
  final bool showFullNavigation;

  const ArticleManagementPage({
    super.key,
    this.showFullNavigation = true,
  });

  @override
  State<ArticleManagementPage> createState() => _ArticleManagementPageState();
}

class _ArticleManagementPageState extends State<ArticleManagementPage> {
  // 展开的子菜单
  final Set<String> _expandedMenus = {'模块管理'};

  // 当前选中的子标签（文章管理模块的二级标签）
  String _selectedSubTab = '分类管理';

  // 二级标签导航历史栈
  final List<String> _tabNavigationHistory = [];

  // 是否启用打赏
  bool _isRewardEnabled = true;

  // 当前激活的功能标签（幻灯图管理/分类链接）
  String _activeTab = '分类链接';

  // 文章展示样式
  String _listStyle = '上图下文';

  // 分类列表（使用缓存数据模型）
  List<ArticleCategory> _categories = [];

  // 当前选中的分类索引
  int _selectedCategoryIndex = 0;

  // 配置是否已加载
  bool _isConfigLoaded = false;

  // 缓存服务
  final WorkbenchCacheService _cacheService = WorkbenchCacheService();

  // 编辑状态：当前正在编辑的文章ID（null表示新增，非null表示编辑）
  String? _editingArticleId;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  /// 从缓存加载配置
  Future<void> _loadConfig() async {
    try {
      final config = await _cacheService.getArticleManagementConfig();
      setState(() {
        _categories = config.categories;
        _isRewardEnabled = config.rewardEnabled;
        _listStyle = config.listStyle;
        _isConfigLoaded = true;
      });
      debugPrint('加载文章管理配置成功，分类数量: ${_categories.length}');
    } catch (e) {
      debugPrint('加载配置失败: $e');
      // 使用默认配置
      setState(() {
        _categories = ArticleManagementConfig.defaultConfig().categories;
        _isConfigLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根据 showFullNavigation 参数决定布局
    if (widget.showFullNavigation) {
      // 完整页面布局（包含一级导航栏和顶部标题栏）
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6F7),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧一级导航栏（200px）
              _buildSidebar(),

              // 二级标签栏（垂直，120px）
              _buildSecondLevelSidebar(),

              // 主内容区
              Expanded(
                child: Column(
                  children: [
                    // 顶部标题栏
                    _buildTopHeader(),

                    // 主内容区
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildMainContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 嵌入式布局（不包含一级导航栏和顶部标题栏，用于嵌入到 MerchantDashboard）
      // 如果正在编辑文章，直接返回 ArticleEditPage
      if (_editingArticleId != null || _selectedSubTab == '新增文章') {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 二级标签栏（垂直，120px）
            _buildSecondLevelSidebar(),
            // 编辑页面
            Expanded(
              child: ArticleEditPage(
                articleId: _editingArticleId,
                showFullNavigation: false,
                onBack: () {
                  setState(() {
                    _editingArticleId = null;
                    _selectedSubTab = '文章列表';
                  });
                },
                onBackToPrevious: () {
                  // 从导航栈返回上一级标签
                  if (_tabNavigationHistory.isNotEmpty) {
                    setState(() {
                      final previousTab = _tabNavigationHistory.removeLast();
                      _selectedSubTab = previousTab;
                    });
                  } else {
                    // 导航栈为空，返回到文章列表
                    setState(() {
                      _editingArticleId = null;
                      _selectedSubTab = '文章列表';
                    });
                  }
                },
              ),
            ),
          ],
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 二级标签栏（垂直，120px）
          _buildSecondLevelSidebar(),

          // 主内容区
          Expanded(
            child: _buildMainContentWrapper(),
          ),
        ],
      );
    }
  }

  /// 构建左侧导航栏
  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
          // 菜单项列表
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.store, '管理中心', isActive: false, hasSubmenu: false),
                _buildMenuItem(Icons.phone_android, '小程序管理', isActive: false, hasSubmenu: true,
                  submenu: ['开发设置', '审核管理', '菜单导航', '订阅消息', '跳转小程序', '开发者模式']),
                _buildMenuItem(Icons.settings, '配置管理', isActive: false, hasSubmenu: true,
                  submenu: ['支付配置', '分享海报设置', '客服设置', '短信设置', '音视频存储', '广告位配置']),
                _buildMenuItem(Icons.extension, '模块管理', isActive: true, hasSubmenu: true,
                  submenu: ['文章管理', '留言管理', '启动图管理', '活动页配置', '经典语录管理']),
                _buildMenuItem(Icons.image, '页面管理', isActive: false, hasSubmenu: true,
                  submenu: ['主页管理', '个人中心管理']),
                _buildMenuItem(Icons.menu_book, '课程管理', isActive: false, hasSubmenu: true,
                  submenu: ['课程分类', '课程列表', '作者列表', '评论管理']),
                _buildMenuItem(Icons.shopping_cart, '订单管理', isActive: false, hasSubmenu: true,
                  submenu: ['课程订单']),
                _buildMenuItem(Icons.storefront, '商城管理', isActive: false, hasSubmenu: true,
                  submenu: ['商品分类', '商品列表', '运费模板', '商品评价', '商城订单', '维权订单', '订单设置', '留言模版']),
                _buildMenuItem(Icons.people, '用户管理', isActive: false, hasSubmenu: true,
                  submenu: ['用户列表', '用户分类', '用户等级', '签到记录', '搜索历史管理']),
                _buildMenuItem(Icons.card_membership, '会员卡管理', isActive: false, hasSubmenu: true,
                  submenu: ['会员卡', '储值卡', '会员对话码']),
                _buildMenuItem(Icons.campaign, '营销工具', isActive: false, hasSubmenu: true,
                  submenu: ['优惠券', '拼团', '秒杀']),
                _buildMenuItem(Icons.bar_chart, '商户概览', isActive: false, hasSubmenu: false),
                _buildMenuItem(Icons.edit_note, '操作日志', isActive: false, hasSubmenu: false),
                _buildMenuItem(Icons.notifications, '推送消息配置', isActive: false, hasSubmenu: false),
                _buildMenuItem(Icons.lock, '权限设置', isActive: false, hasSubmenu: false),
              ],
            ),
          ),

          // 底部分隔线
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),

          // 底部品牌标识
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFF1A9B8E)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '唐极课得',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFCCCCCC),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(IconData icon, String label, {bool isActive = false, bool hasSubmenu = false, List<String>? submenu}) {
    final isExpanded = _expandedMenus.contains(label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 父级菜单项
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (hasSubmenu) {
                  if (_expandedMenus.contains(label)) {
                    _expandedMenus.remove(label);
                  } else {
                    _expandedMenus.add(label);
                  }
                } else {
                  if (label == '管理中心') {
                    Navigator.pop(context);
                  }
                }
              });
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: (isExpanded || isActive) ? const Color(0xFF2D343A) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: (isExpanded || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: (isExpanded || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  if (hasSubmenu)
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.keyboard_arrow_down,
                      size: 18,
                      color: (isExpanded || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 子菜单列表
        if (hasSubmenu && submenu != null && isExpanded)
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: submenu.map((subItem) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('点击子菜单：$subItem');
                      if (subItem == '文章管理') {
                        // 当前页面，无需操作
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"$subItem" 功能即将推出')),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        subItem,
                        style: TextStyle(
                          fontSize: 15,
                          color: subItem == '文章管理' ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                          fontWeight: subItem == '文章管理' ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// 构建顶部标题栏
  Widget _buildTopHeader() {
    return Container(
      height: 60,
      color: const Color(0xFF1A9B8E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo + 系统名称
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A9B8E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '唐极课得 管理系统 | 文章管理',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // 右侧功能按钮组
          Row(
            children: [
              _buildHeaderButton('预览'),
              const SizedBox(width: 16),
              _buildHeaderButton('提交'),
              const SizedBox(width: 16),
              _buildHeaderButton('消息通知', hasBadge: true, badgeCount: 3),
              const SizedBox(width: 16),
              _buildHeaderButton('店铺设置'),
              const SizedBox(width: 16),
              _buildHeaderButton('管理中心'),
              const SizedBox(width: 16),
              _buildHeaderButton('退出'),
              const SizedBox(width: 16),
              _buildHeaderButton('更多操作', isMoreButton: true),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildHeaderButton(String text, {bool hasBadge = false, int badgeCount = 0, bool isMoreButton = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击按钮：$text');
          if (text == '管理中心') {
            context.go(AppRouter.merchantDashboard);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('"$text" 功能即将推出')),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (text.isNotEmpty)
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              if (hasBadge) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D4F),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              if (isMoreButton)
                const Icon(
                  Icons.more_horiz,
                  size: 16,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建主内容区
  Widget _buildMainContent() {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 面包屑导航
          _buildBreadcrumb(),

          const SizedBox(height: 24),

          // 标签页内容区 - 使用 Expanded 提供高度约束
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  /// 构建主内容区包装器（根据内容类型决定是否使用滚动）
  Widget _buildMainContentWrapper() {
    // 不使用 SingleChildScrollView，让各个内容组件自己处理滚动
    return _buildMainContent();
  }

  /// 构建二级侧边栏（垂直标签）
  Widget _buildSecondLevelSidebar() {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF3A3F47),
        border: Border(
          right: BorderSide(color: Color(0xFF4E5562), width: 1),
        ),
      ),
      child: Column(
        children: [
          // 标签列表
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSecondLevelTabItem(Icons.category, '分类管理', 0),
                _buildSecondLevelTabItem(Icons.article, '文章列表', 1),
                _buildSecondLevelTabItem(Icons.slideshow, '轮播图管理', 2),
                _buildSecondLevelTabItem(Icons.money, '打赏记录', 3),
                _buildSecondLevelTabItem(Icons.payment, '付费管理', 4),
              ],
            ),
          ),

          // 底部分隔线
          Container(
            height: 1,
            color: const Color(0xFF4E5562),
          ),

          // 底部品牌标识（简化版）
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFF1A9B8E)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '唐极',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFFCCCCCC),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建二级侧边栏标签项
  Widget _buildSecondLevelTabItem(IconData icon, String label, int index) {
    final isSelected = _selectedSubTab == label;
    final tabIndex = ['分类管理', '文章列表', '打赏记录', '付费管理'].indexOf(label);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 将当前标签添加到导航栈（如果不是同一个标签且不是新增文章状态）
          if (_selectedSubTab != label && _selectedSubTab != '新增文章') {
            setState(() {
              _tabNavigationHistory.add(_selectedSubTab);
            });
          }

          // 切换标签
          setState(() {
            _selectedSubTab = label;
          });
          debugPrint('切换到标签：$label');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
            border: isSelected
                ? const Border(
                    left: BorderSide(color: Color(0xFF1A9B8E), width: 4),
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建二级标签页（旧的横向标签，已弃用）
  Widget _buildSecondLevelTabs() {
    final tabs = ['分类管理', '文章列表', '打赏记录', '付费管理'];

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedSubTab == tab;
          return Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubTab = tab;
                  });
                  debugPrint('切换到标签：$tab');
                },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
                    border: isSelected
                        ? const Border(
                            bottom: BorderSide(color: Color(0xFF1A9B8E), width: 3),
                          )
                        : null,
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建标签页内容
  Widget _buildTabContent() {
    switch (_selectedSubTab) {
      case '分类管理':
        return _buildCategoryManagementContent();
      case '文章列表':
        return const ArticleListContent();
      case '轮播图管理':
        return const CarouselManagementContent();
      case '打赏记录':
        return const RewardRecordsContent();
      case '付费管理':
        return const PaymentManagementPage();
      default:
        return _buildCategoryManagementContent();
    }
  }

  /// 构建分类管理内容（原有内容）
  Widget _buildCategoryManagementContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部控制栏
        _buildTopControlBar(),

        const SizedBox(height: 24),

        // 核心配置区（左右分栏）- 使用 SizedBox 固定高度
        SizedBox(
          height: 850,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧：实时预览区
              Expanded(
                flex: 1,
                child: _buildPreviewPanel(),
              ),

              const SizedBox(width: 24),

              // 右侧：配置操作区
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: _buildConfigurationPanel(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 底部保存按钮
        Center(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                await _saveConfig();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1890FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '保存',
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

        const SizedBox(height: 24),
      ],
    );
  }

  /// 构建即将推出内容
  Widget _buildComingSoonContent(String featureName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '$featureName 功能即将推出',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '敬请期待...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建主内容区（旧版，保留用于兼容）

  /// 构建面包屑导航
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        _buildBreadcrumbItem('管理首页', isActive: false),
        const Text(' / ', style: TextStyle(color: Color(0xFF999999))),
        _buildBreadcrumbItem('模块管理', isActive: false),
        const Text(' / ', style: TextStyle(color: Color(0xFF999999))),
        _buildBreadcrumbItem('文章管理', isActive: true),
      ],
    );
  }

  Widget _buildBreadcrumbItem(String text, {bool isActive = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            debugPrint('点击面包屑：$text');
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? const Color(0xFF333333) : const Color(0xFF1890FF),
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 构建顶部控制栏
  Widget _buildTopControlBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 功能标签页
          Row(
            children: [
              _buildTab('幻灯图管理', isActive: false),
              const SizedBox(width: 8),
              _buildTab('分类链接', isActive: true),
            ],
          ),

          const Spacer(),

          // 是否启用打赏开关
          Row(
            children: [
              const Text(
                '是否启用打赏',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _isRewardEnabled,
                onChanged: (value) {
                  setState(() {
                    _isRewardEnabled = value;
                  });
                  debugPrint('切换打赏功能：$value');
                },
                activeColor: const Color(0xFF52C41A),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {bool isActive = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = text;
          });
          debugPrint('点击标签：$text');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1890FF) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建左侧预览面板
  Widget _buildPreviewPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '实时预览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildPhonePreview(),
        ],
      ),
    );
  }

  /// 构建手机预览器
  Widget _buildPhonePreview() {
    return SizedBox(
      width: 375,
      height: 750,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFF333333), width: 8),
        ),
        child: Column(
          children: [
            // 顶部状态栏
            _buildPhoneStatusBar(),

            // 导航栏
            _buildPhoneNavigationBar(),

            // 分类 Tab 栏 - 显示所有分类（支持横向滑动）
            _buildPhoneCategoryTabs(_categories),

            // 内容列表区
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: _buildArticleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建手机状态栏
  Widget _buildPhoneStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '19:14',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
              const SizedBox(width: 4),
              const Text('中国移动 4G', style: TextStyle(fontSize: 12, color: Colors.black)),
              const SizedBox(width: 8),
              const Text('61%', style: TextStyle(fontSize: 12, color: Colors.black)),
              const Icon(Icons.battery_full, size: 16, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建手机导航栏
  Widget _buildPhoneNavigationBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          const Text(
            '分类预览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.more_horiz, size: 24, color: Colors.black),
        ],
      ),
    );
  }

  /// 构建手机分类 Tab 栏
  Widget _buildPhoneCategoryTabs(List<ArticleCategory> categories) {
    // 过滤掉空名称的分类
    final validCategories = categories.where((cat) => cat.name.trim().isNotEmpty).toList();

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: validCategories.length,
        itemBuilder: (context, index) {
          final category = validCategories[index];
          // 找到原始索引
          final originalIndex = _categories.indexWhere((cat) => cat.id == category.id);
          final isSelected = originalIndex == _selectedCategoryIndex;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = originalIndex;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1890FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建文章列表（根据选中的样式）
  Widget _buildArticleList() {
    switch (_listStyle) {
      case '上图下文':
        return _buildImageTopTextBottomList();
      case '一左一右':
        return _buildAlternatingList();
      case '左图右文':
        return _buildLeftImageRightTextList();
      case '左文右图':
        return _buildLeftTextRightImageList();
      case '高级版 (信息流)':
        return _buildAdvancedFeedList();
      default:
        return _buildImageTopTextBottomList();
    }
  }

  /// 样式1: 上图下文
  Widget _buildImageTopTextBottomList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  color: const Color(0xFFE5E5E5),
                  child: const Icon(Icons.image, size: 48, color: Color(0xFF999999)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '文章标题 ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '文章相关简介内容，这里显示文章的摘要信息...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 样式2: 一左一右（交替）
  Widget _buildAlternatingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isLeftImage = index % 2 == 0;
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (isLeftImage) ...[
                // 左图
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.image, size: 32, color: Color(0xFF999999)),
                ),
                // 右文
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '文章标题 ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '文章相关简介内容...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // 左文
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '文章标题 ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '文章相关简介内容...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // 右图
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.image, size: 32, color: Color(0xFF999999)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 样式3: 左图右文
  Widget _buildLeftImageRightTextList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Icon(Icons.image, size: 32, color: Color(0xFF999999)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '文章标题 ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '文章相关简介内容...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 样式4: 左文右图
  Widget _buildLeftTextRightImageList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '文章标题 ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '文章相关简介内容...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Icon(Icons.image, size: 32, color: Color(0xFF999999)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 样式5: 高级版（信息流）- 3种不同布局
  Widget _buildAdvancedFeedList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // 模拟3种不同类型：0=单图, 1=视频, 2=多图
        final type = index % 3;

        if (type == 0) {
          // 类型1: 单图模式 - 左侧标题+信息，右侧大图
          return _buildSingleImageFeedItem(index);
        } else if (type == 1) {
          // 类型2: 视频模式 - 标题在上，视频在下
          return _buildVideoFeedItem(index);
        } else {
          // 类型3: 多图模式 - 标题在上，3张图片在下
          return _buildMultipleImagesFeedItem(index);
        }
      },
    );
  }

  /// 单图模式 - 左侧标题+信息，右侧大图
  Widget _buildSingleImageFeedItem(int index) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 左侧：标题+信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    '文章标题 ${index + 1}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  // 底部信息行（一排小元素）
                  Row(
                    children: [
                      const Icon(Icons.visibility, size: 14, color: Color(0xFF999999)),
                      const SizedBox(width: 4),
                      Text(
                        '${1234 + index}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.thumb_up, size: 14, color: Color(0xFF999999)),
                      const SizedBox(width: 4),
                      Text(
                        '${56 + index}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '2小时前',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 右侧：大图
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E5E5),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Icon(Icons.image, size: 40, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// 视频模式 - 标题在上，视频在下
  Widget _buildVideoFeedItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '视频文章标题 ${index + 1}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 视频播放器
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 视频封面
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color(0xFF333333),
                  child: const Icon(Icons.play_circle_outline, size: 80, color: Color(0xFF666666)),
                ),
                // 播放按钮
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                // 时长标签
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '05:32',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 多图模式 - 标题在上，3张图片在下
  Widget _buildMultipleImagesFeedItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '多图文章标题 ${index + 1}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 3张图片横向排列
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: List.generate(
                3,
                (imgIndex) => Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(right: imgIndex < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.image, size: 32, color: Color(0xFF999999)),
                  ),
                ),
              ),
            ),
          ),

          // 底部信息
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                const Icon(Icons.visibility, size: 14, color: Color(0xFF999999)),
                const SizedBox(width: 4),
                Text(
                  '${2345 + index}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.thumb_up, size: 14, color: Color(0xFF999999)),
                const SizedBox(width: 4),
                Text(
                  '${89 + index}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建右侧配置面板
  Widget _buildConfigurationPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '配置操作',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),

          // 管理分类
          _buildCategoryManagement(),

          const SizedBox(height: 32),

          // 资讯列表展示样式
          _buildListStyleSelector(),
        ],
      ),
    );
  }

  /// 构建分类管理模块
  Widget _buildCategoryManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '管理分类',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '(左侧预览会显示所有分类，手机端可横向滑动，拖动分类可以进行排序)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),

        // 添加分类按钮
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                final newCategory = ArticleCategory(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '',
                  sortOrder: _categories.length,
                );
                _categories.add(newCategory);
              });
              debugPrint('添加分类');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1890FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '添加分类',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 分类列表
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final controller = TextEditingController(text: category.name);
            return _buildCategoryCard(category, index, controller);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(ArticleCategory category, int index, TextEditingController controller) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 删除按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _categories.removeAt(index);
                  if (_selectedCategoryIndex >= _categories.length) {
                    _selectedCategoryIndex = _categories.length > 0 ? _categories.length - 1 : 0;
                  }
                });
                debugPrint('删除分类：${category.name}');
              },
              child: const Icon(
                Icons.close,
                size: 16,
                color: Color(0xFF999999),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 输入框
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '分类名称',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E5E5)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _categories[index] = category.copyWith(name: value);
              });
            },
          ),
        ],
      ),
    );
  }

  /// 构建列表样式选择器
  Widget _buildListStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '资讯列表展示样式',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),

        // 单选按钮组
        Column(
          children: [
            _buildStyleRadio('上图下文', Icons.image),
            _buildStyleRadio('一左一右', Icons.swap_horiz),
            _buildStyleRadio('左图右文', Icons.format_align_left),
            _buildStyleRadio('左文右图', Icons.format_align_right),
            _buildStyleRadio('高级版 (信息流)', Icons.grid_view),
          ],
        ),
      ],
    );
  }

  Widget _buildStyleRadio(String label, IconData icon) {
    final isSelected = _listStyle == label;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _listStyle = label;
          });
          debugPrint('选择样式：$label');
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE5E5E5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF999999),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF666666),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Color(0xFF1890FF),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 保存配置到缓存
  Future<void> _saveConfig() async {
    try {
      // 创建配置对象
      final config = ArticleManagementConfig(
        categories: _categories,
        rewardEnabled: _isRewardEnabled,
        listStyle: _listStyle,
        lastUpdateTime: DateTime.now(),
        syncedWithServer: false, // 标记为未同步到服务器
      );

      // 保存到缓存
      await _cacheService.saveArticleManagementConfig(config);

      // TODO: 这里还需要上传到服务器
      // await _uploadConfigToServer(config);

      // 显示成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('配置已保存到本地'),
            backgroundColor: Color(0xFF52C41A),
            duration: Duration(seconds: 2),
          ),
        );
      }

      debugPrint('配置保存成功，分类数量: ${_categories.length}');
    } catch (e) {
      debugPrint('保存配置失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: const Color(0xFFFF4D4F),
          ),
        );
      }
    }
  }

  /// 上传配置到服务器（预留接口）
  Future<void> _uploadConfigToServer(ArticleManagementConfig config) async {
    // TODO: 实现服务器上传逻辑
    // 这里应该调用 API 接口上传配置
    // 成功后设置 syncedWithServer = true 并更新缓存
    debugPrint('上传配置到服务器: ${config.categories.length} 个分类');
  }
}
