import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/cache/workbench_cache_service.dart';
import '../../../routes/app_router.dart';
import 'reward_records_content.dart';
import 'article_list_content.dart';

/// 文章列表页面
/// 展示所有资讯文章的数据列表，提供筛选、统计概览、批量操作及单条管理功能
class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  // 展开的子菜单
  final Set<String> _expandedMenus = {'模块管理'};

  // 当前选中的二级标签
  String _selectedSubTab = '文章列表';

  // 搜索筛选条件
  String _searchKeyword = '';
  String _selectedCategory = '全部分类';
  String _sortOrder = '最近更新';
  DateTime? _startDate;
  DateTime? _endDate;

  // 文章列表数据
  final List<Map<String, dynamic>> _articles = [
    {
      'id': '1',
      'title': '论抖音视频对生活的影响',
      'source': '后台添加',
      'category': '老师介绍',
      'views': 123,
      'sort': 1,
      'updateTime': DateTime(2026, 3, 8, 14, 30),
      'isRecommended': false,
    },
    {
      'id': '2',
      'title': '如何高效学习编程',
      'source': '后台添加',
      'category': '部门简介',
      'views': 256,
      'sort': 2,
      'updateTime': DateTime(2026, 3, 7, 9, 15),
      'isRecommended': true,
    },
    {
      'id': '3',
      'title': '2024年行业发展趋势分析',
      'source': '后台添加',
      'category': '最新资讯',
      'views': 89,
      'sort': 3,
      'updateTime': DateTime(2026, 3, 6, 16, 45),
      'isRecommended': false,
    },
  ];

  // 全选状态
  bool _isAllSelected = false;
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧一级导航栏
            _buildSidebar(),

            // 二级标签栏（垂直）
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
  }

  /// 构建左侧一级导航栏
  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
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
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),
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

  Widget _buildMenuItem(IconData icon, String label, {bool isActive = false, bool hasSubmenu = false, List<String>? submenu}) {
    final isExpanded = _expandedMenus.contains(label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    context.go(AppRouter.merchantDashboard);
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
                      // 点击子菜单导航
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
                          color: const Color(0xFFCCCCCC),
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSecondLevelTabItem(Icons.category, '分类管理', 0),
                _buildSecondLevelTabItem(Icons.article, '文章列表', 1),
                _buildSecondLevelTabItem(Icons.money, '打赏记录', 2),
                _buildSecondLevelTabItem(Icons.payment, '付费管理', 3),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFF4E5562),
          ),
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

  Widget _buildSecondLevelTabItem(IconData icon, String label, int index) {
    final isSelected = _selectedSubTab == label;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 点击二级菜单进行导航
          if (label == '分类管理') {
            // TODO: 导航到分类管理页面
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('分类管理页面即将推出')),
            );
          } else if (label == '文章列表') {
            // 当前页面，无需操作
            setState(() {
              _selectedSubTab = label;
            });
          } else if (label == '打赏记录') {
            // 导航到打赏记录页面
            context.push('${AppRouter.merchantDashboard}/reward-records');
          } else if (label == '付费管理') {
            // TODO: 导航到付费管理页面
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('付费管理页面即将推出')),
            );
          }
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

  /// 构建顶部标题栏
  Widget _buildTopHeader() {
    return Container(
      height: 60,
      color: const Color(0xFF1A9B8E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
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
    // 根据选中的二级标签显示不同的内容
    switch (_selectedSubTab) {
      case '打赏记录':
        return const RewardRecordsContent();
      case '文章列表':
        return const ArticleListContent(); // 使用可复用的内容组件
      case '分类管理':
      case '付费管理':
      default:
        return const ArticleListContent();
    }
  }

  /// 文章列表内容区
  Widget _buildArticleListContent() {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 顶部提示栏
          _buildAlertBar(),

          const SizedBox(height: 16),

          // 2. 搜索筛选区
          _buildSearchFilterBar(),

          const SizedBox(height: 16),

          // 3. 数据统计看板
          _buildStatisticsDashboard(),

          const SizedBox(height: 16),

          // 4. 数据表格
          _buildDataTable(),

          const SizedBox(height: 16),

          // 5. 底部批量操作栏
          _buildBatchActionBar(),
        ],
      ),
    );
  }

  /// 1. 顶部提示栏
  Widget _buildAlertBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFF7D9), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Color(0xFFFFA940),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                children: [
                  const TextSpan(text: '注：新增资讯时记得选择'),
                  TextSpan(
                    text: '『文章类别』',
                    style: const TextStyle(
                      color: Color(0xFFFF4D4F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: '。当不选择『文章类别』时该条资讯则在手机端资讯列表不显示'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. 搜索筛选区
  Widget _buildSearchFilterBar() {
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
          // 标题搜索
          Expanded(
            child: _buildSearchField(),
          ),
          const SizedBox(width: 12),

          // 分类筛选
          SizedBox(
            width: 150,
            child: _buildDropdown('全部分类', ['全部分类', '部门简介', '培训师资', '抖音视频', '最新资讯', '老师介绍'], _selectedCategory, (value) {
              setState(() {
                _selectedCategory = value;
              });
            }),
          ),
          const SizedBox(width: 12),

          // 排序方式
          SizedBox(
            width: 150,
            child: _buildDropdown('最近更新', ['最近更新', '阅读量', '点赞量', '评论数'], _sortOrder, (value) {
              setState(() {
                _sortOrder = value;
              });
            }),
          ),
          const SizedBox(width: 12),

          // 时间范围
          _buildDateRangePicker(),
          const SizedBox(width: 12),

          // 查询按钮
          _buildQueryButton(),
          const SizedBox(width: 12),

          // 新增按钮
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '文章标题',
                hintStyle: TextStyle(color: Color(0xFF999999)),
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF999999)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String value, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
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
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _selectDate(context, 'start'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _startDate != null
                          ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                          : '开始日期',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Text('  到  ', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
        SizedBox(
          width: 130,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _selectDate(context, 'end'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _endDate != null
                          ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                          : '截止日期',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (type == 'start') {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildQueryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('查询文章');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('查询功能开发中...')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF52C41A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '查询',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('新增文章');
          // 导航到文章编辑页面
          context.go(AppRouter.articleEdit);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1890FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '新增',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 3. 数据统计看板
  Widget _buildStatisticsDashboard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Expanded(
            child: _buildStatItem('13', '总文章数', const Color(0xFFFF6B35)),
          ),
          Container(
            width: 1,
            height: 60,
            color: const Color(0xFFE5E5E5),
          ),
          Expanded(
            child: _buildStatItem('165', '总阅读量', const Color(0xFFFF6B35)),
          ),
          Container(
            width: 1,
            height: 60,
            color: const Color(0xFFE5E5E5),
          ),
          Expanded(
            child: _buildStatItem('6', '总评论数', const Color(0xFF1890FF)),
          ),
          Container(
            width: 1,
            height: 60,
            color: const Color(0xFFE5E5E5),
          ),
          Expanded(
            child: _buildStatItem('1', '总点赞数', const Color(0xFFFF6B35)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  /// 4. 数据表格
  Widget _buildDataTable() {
    return Container(
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
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          ..._articles.asMap().entries.map((entry) {
            final index = entry.key;
            final article = entry.value;
            return _buildTableRow(article, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: _isAllSelected,
              onChanged: (value) {
                setState(() {
                  _isAllSelected = value ?? false;
                  if (_isAllSelected) {
                    _selectedIds.addAll(_articles.map((a) => a['id'] as String));
                  } else {
                    _selectedIds.clear();
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: Text('标题', style: _getTableHeaderStyle())),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: Text('来源', style: _getTableHeaderStyle())),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: Text('分类', style: _getTableHeaderStyle())),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: Center(child: Text('阅读量', style: _getTableHeaderStyle()))),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: Center(child: Text('排序', style: _getTableHeaderStyle()))),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: Text('最近更新', style: _getTableHeaderStyle())),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: Center(child: Text('操作', style: _getTableHeaderStyle()))),
        ],
      ),
    );
  }

  TextStyle _getTableHeaderStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF333333),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> article, int index) {
    final isSelected = _selectedIds.contains(article['id'] as String);
    final isEven = index % 2 == 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedIds.contains(article['id'] as String)) {
              _selectedIds.remove(article['id'] as String);
            } else {
              _selectedIds.add(article['id'] as String);
            }
            _updateSelectAll();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF0F7FF)
                : (isEven ? const Color(0xFFFFFFFF) : const Color(0xFFFAFAFA)),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedIds.add(article['id'] as String);
                      } else {
                        _selectedIds.remove(article['id'] as String);
                      }
                      _updateSelectAll();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1890FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: Text(article['source'] as String, style: _getCellStyle())),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: Text(article['category'] as String, style: _getCellStyle())),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: Center(child: Text('${article['views']}', style: _getCellStyle()))),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: Center(child: Text('${article['sort']}', style: _getCellStyle()))),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      '${article['updateTime'].year}-'
                      '${article['updateTime'].month.toString().padLeft(2, '0')}-'
                      '${article['updateTime'].day.toString().padLeft(2, '0')} '
                      '${article['updateTime'].hour.toString().padLeft(2, '0')}:'
                      '${article['updateTime'].minute.toString().padLeft(2, '0')}',
                      style: _getCellStyle(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF999999)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionLink('编辑', const Color(0xFF1890FF), () {}),
                    _buildActionLink('评论', const Color(0xFF1890FF), () {}),
                    _buildActionLink('删除', const Color(0xFFFF4D4F), () {
                      _showDeleteDialog(article['id'] as String);
                    }),
                    _buildActionLink('页面路径', const Color(0xFF999999), () {}),
                    _buildActionLink('设置推荐', const Color(0xFF1890FF), () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getCellStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Color(0xFF666666),
    );
  }

  Widget _buildActionLink(String text, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _updateSelectAll() {
    setState(() {
      _isAllSelected = _selectedIds.length == _articles.length;
    });
  }

  void _showDeleteDialog(String articleId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning,
                size: 48,
                color: Color(0xFFFFA940),
              ),
              const SizedBox(height: 16),
              const Text(
                '确认删除',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '删除后无法恢复，是否继续？',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('取消', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _articles.removeWhere((a) => a['id'] == articleId);
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('删除成功')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D4F),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('确认', style: TextStyle(fontSize: 14, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 5. 底部批量操作栏
  Widget _buildBatchActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildBatchButton('批量修改分类', const Color(0xFF1890FF), () {}),
          const SizedBox(width: 12),
          _buildBatchButton('批量修改阅读量', const Color(0xFF1890FF), () {}),
          const SizedBox(width: 12),
          _buildBatchButton('批量删除', const Color(0xFFFF4D4F), () {}),
        ],
      ),
    );
  }

  Widget _buildBatchButton(String text, Color color, VoidCallback onTap) {
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
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
