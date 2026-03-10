import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_state.dart';
import 'store_settings_page.dart';
import 'development/development_settings_routes.dart';
import 'route_manager.dart';
import 'development/development_settings_content.dart';
import 'audit_management_content.dart';
import 'menu_navigation/menu_navigation_content.dart';
import 'payment/payment_config_content.dart';
import 'course_order/course_order_page.dart';
import 'product_category/product_category_management_page.dart';
import 'product_detail/product_detail_page.dart';
import 'my_warehouse/my_warehouse_page.dart';
import 'product_reviews/product_reviews_page.dart';
import 'freight_template/freight_template_page.dart';
import 'order_settings/order_settings_page.dart';
import 'after_sale/after_sale_page.dart';
import 'article_management/article_management_page.dart';
import 'article_management/article_list_content.dart';
import 'article_management/reward_records_content.dart';
import 'course_category/course_category_management_page.dart';
import 'instructor_management/instructor_management_page.dart';
import 'course_qa_management/course_qa_management_page.dart';
import 'course_list/course_list_page.dart';
import 'media_storage/media_list_content.dart';
import 'page_management/navigation_page_management_content.dart';
import 'page_management/page_editor.dart';
import '../../routes/app_router.dart';

/// 商户工作台首页 - 唐极课得管理后台
/// 采用三栏布局：左侧导航 + 顶部标题栏 + 主内容区
class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  // 当前选中的菜单项
  String _selectedMenuItem = '管理中心';

  // 当前选中的子菜单项（用于统一路由架构）
  String _selectedSubMenuItem = '';

  // 关注公众号开关状态
  bool _isFollowOfficialAccount = true;

  // 消息通知弹窗状态
  bool _showNotificationPopover = false;
  final GlobalKey _notificationButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  // 展开的子菜单
  final Set<String> _expandedMenus = {};

  // 消息列表数据
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 1,
      'title': '订单付款通知',
      'isRead': false,
      'content': '你管理的店铺唐极课得有新的订单已付款，订单金额20.00，订单号：8473202602269028254252',
      'time': '2026-02-26 11:32:29',
    },
    {
      'id': 2,
      'title': '小程序审核通知',
      'isRead': true,
      'content': '1:小程序可用性和完整性不符合规则: (1):你好，你的小程序实际展示为测试商品/内容，请上架正式运营商品/内容后再提交代码审核。',
      'time': '2026-02-25 16:20:15',
    },
    {
      'id': 3,
      'title': '续费提醒',
      'isRead': false,
      'content': '您的小程序服务即将到期，请及时续费以避免影响使用。',
      'time': '2026-02-24 09:15:00',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 延迟一帧，确保路由参数已经可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedTabFromRoute();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedTabFromRoute();
  }

  /// 从路由参数更新选中的标签
  void _updateSelectedTabFromRoute() {
    final state = GoRouterState.of(context);
    final tabParam = state.uri.queryParameters['tab'];
    debugPrint('========== _updateSelectedTabFromRoute: tabParam = $tabParam ==========');
    if (tabParam != null && tabParam != _selectedSubMenuItem) {
      setState(() {
        _selectedMenuItem = tabParam;
        _selectedSubMenuItem = tabParam;
        debugPrint('========== _selectedSubMenuItem 更新为: $tabParam ==========');
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  /// 显示 Overlay 弹窗
  void _showOverlay() {
    debugPrint('准备显示 Overlay');
    _overlayEntry = OverlayEntry(
      builder: (context) {
        debugPrint('Overlay Entry builder 被调用');
        return _buildNotificationOverlay();
      },
    );

    try {
      Overlay.of(context).insert(_overlayEntry!);
      debugPrint('Overlay 已插入');
    } catch (e) {
      debugPrint('Overlay 插入失败: $e');
    }
  }

  /// 移除 Overlay 弹窗
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 显示退出登录确认对话框
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
              authState.logout(); // 退出登录
              context.go(AppRouter.home); // 跳转到首页
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧导航栏（220px，无左右padding）
                _buildSidebar(),

                // 主内容区（包含顶部标题栏 + 主内容）
                Expanded(
                  child: Column(
                    children: [
                      // 顶部标题栏（60px）
                      _buildTopHeader(),

                      // 主内容区
                      Expanded(
                        child: _buildContentArea(),
                    ),
                    ],
                  ),
                ),
              ],
            ),

            // 消息通知弹窗
            _buildNotificationPopover(),
          ],
        ),
      ),
    );
  }

  /// 构建左侧导航栏（200px，深灰黑背景）
  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
          // 菜单项列表（无上下padding）
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.store, '管理中心', isActive: true, hasSubmenu: false),
                _buildMenuItem(Icons.phone_android, '小程序管理', hasSubmenu: true,
                  submenu: ['开发设置', '审核管理', '菜单导航', '订阅消息', '跳转小程序', '开发者模式']),
                _buildMenuItem(Icons.settings, '配置管理', hasSubmenu: true,
                  submenu: ['支付配置', '分享海报设置', '客服设置', '短信设置', '音视频存储', '广告位配置']),
                _buildMenuItem(Icons.extension, '模块管理', hasSubmenu: true,
                  submenu: ['文章管理', '留言管理', '启动图管理', '活动页配置', '经典语录管理']),
                _buildMenuItem(Icons.image, '页面管理', hasSubmenu: true,
                  submenu: ['导航页面管理', '功能页面管理', '个人中心管理']),
                _buildMenuItem(Icons.menu_book, '课程管理', hasSubmenu: true,
                  submenu: ['课程分类', '课程列表', '讲师管理', '课程问答管理', '评论管理']),
                _buildMenuItem(Icons.shopping_cart, '订单管理', hasSubmenu: true,
                  submenu: ['课程订单', '商品订单', '租赁业务订单']),
                _buildMenuItem(Icons.storefront, '商城管理', hasSubmenu: true,
                  submenu: ['货架管理', '我的仓库', '商品评价', '运费模板', '订单设置']),
                _buildMenuItem(Icons.people, '用户管理', hasSubmenu: true,
                  submenu: ['用户列表', '用户分类', '用户等级', '签到记录', '搜索历史管理']),
                _buildMenuItem(Icons.headset_mic, '客服管理', hasSubmenu: true,
                  submenu: ['售后处理', '维权订单', '客服话术', '咨询记录']),
                _buildMenuItem(Icons.business_center, '业务管理', hasSubmenu: true,
                  submenu: ['租赁管理', '合作管理']),
                _buildMenuItem(Icons.card_membership, '会员卡管理', hasSubmenu: true,
                  submenu: ['会员卡', '储值卡', '会员对话码']),
                _buildMenuItem(Icons.campaign, '营销工具', hasSubmenu: true,
                  submenu: ['优惠券', '拼团', '秒杀']),
                _buildMenuItem(Icons.bar_chart, '商户概览', hasSubmenu: false),
                _buildMenuItem(Icons.edit_note, '操作日志', hasSubmenu: false),
                _buildMenuItem(Icons.notifications, '推送消息配置', hasSubmenu: false),
                _buildMenuItem(Icons.lock, '权限设置', hasSubmenu: false),
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
                // 模拟彩色波浪形Logo
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
                Text(
                  '唐极课得',
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xFFCCCCCC),
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
  /// 构建菜单项（支持展开子菜单）
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
                _selectedMenuItem = label;
                if (hasSubmenu) {
                  if (_expandedMenus.contains(label)) {
                    _expandedMenus.remove(label);
                  } else {
                    _expandedMenus.add(label);
                  }
                } else {
                  // 没有子菜单的父级菜单项点击处理
                  if (label == '管理中心') {
                    Navigator.pop(context);
                  }
                }
              });
              debugPrint('点击菜单：$label, 展开状态: ${_expandedMenus.contains(label)}');
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
                      debugPrint('========== 点击子菜单：$subItem ==========');
                      // 更新选中状态
                      setState(() {
                        _selectedSubMenuItem = subItem;
                      });
                      // 更新URL的query parameter
                      context.push('${AppRouter.merchantDashboard}?tab=$subItem');
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        subItem,
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedMenuItem == subItem ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                          fontWeight: _selectedMenuItem == subItem ? FontWeight.w500 : FontWeight.normal,
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

  /// 构建顶部标题栏（60px，青绿色背景）
  Widget _buildTopHeader() {
    return Container(
      height: 60,
      color: const Color(0xFF1A9B8E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo + 系统名称
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // 点击标题跳转到管理中心首页
                if (_selectedSubMenuItem.isNotEmpty) {
                  context.go(AppRouter.merchantDashboard);
                }
              },
              child: Row(
                children: [
                  // Logo（圆形图标）
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
                    '唐极课得 管理系统 | 小程序',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // 右侧功能按钮组
          Row(
            children: [
              _buildHeaderButton('预览'),
              const SizedBox(width: 16),
              _buildHeaderButton('提交'),
              const SizedBox(width: 16),
              _buildNotificationButton(),
              const SizedBox(width: 16),
              _buildHeaderButton('店铺设置', isSettings: true),
              const SizedBox(width: 16),
              _buildHeaderButton('管理中心', isManagementCenter: true),
              const SizedBox(width: 16),
              // 用户头像
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // 跳转到个人中心页面（ProfilePage）
                    context.go(AppRouter.profile);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildHeaderButton('退出', isLogout: true),
              const SizedBox(width: 16),
              _buildHeaderButton('更多操作', isMoreButton: true),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildHeaderButton(String text, {bool hasBadge = false, int badgeCount = 0, bool isMoreButton = false, bool isSettings = false, bool isManagementCenter = false, bool isLogout = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (isSettings) {
            // 跳转到店铺设置页
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StoreSettingsPage(),
              ),
            );
          } else if (isManagementCenter) {
            // 返回管理中心首页
            if (_selectedSubMenuItem.isNotEmpty) {
              context.go(AppRouter.merchantDashboard);
            }
          } else if (isLogout) {
            // 退出登录
            _showLogoutDialog();
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
              if (hasBadge)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4F),
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
                )
              else if (!isMoreButton)
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
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
          // 基本信息区 + 小程序数据助手（并排）
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧：基本信息区
              Expanded(
                flex: 1,
                child: _buildBasicInfoCard(),
              ),
              const SizedBox(width: 16),

              // 右侧：小程序数据助手
              Expanded(
                flex: 1,
                child: _buildMiniProgramAssistant(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 常用工具网格区
          _buildCommonToolsGrid(),
        ],
      ),
    );
  }

  /// 构建内容区（根据选中的子菜单项动态切换）
  Widget _buildContentArea() {
    debugPrint('========== _buildContentArea: _selectedSubMenuItem = $_selectedSubMenuItem ==========');

    // 如果没有选中任何子菜单项，显示管理中心主页
    if (_selectedSubMenuItem.isEmpty) {
      return SingleChildScrollView(
        child: _buildMainContent(),
      );
    }

    // 根据选中的子菜单项显示对应的内容组件
    switch (_selectedSubMenuItem) {
      // 小程序管理相关页面
      case '开发设置':
        return const DevelopmentSettingsContent();
      case '审核管理':
        return const AuditManagementContent();
      case '菜单导航':
        return const MenuNavigationContent();

      // 配置管理相关页面
      case '支付配置':
        return const PaymentConfigContent();
      case '音视频存储':
        return const MediaListContent();

      // 模块管理相关页面
      case '文章管理':
        return const ArticleManagementPage(showFullNavigation: false); // 不显示一级导航栏和顶部标题栏
      case '文章列表':
        return const ArticleListContent();
      case '打赏记录':
        return const RewardRecordsContent();

      // 课程管理相关页面
      case '课程分类':
        return const CourseCategoryManagementContent();
      case '讲师管理':
        return const InstructorManagementContent();
      case '课程问答管理':
        return const CourseQAManagementContent();
      case '课程列表':
        return const CourseListContent();
      case '作者列表':
      case '作者列表':
      case '评论管理':

      // 订单管理相关页面
      case '课程订单':
        return const CourseOrderContent();

      // 商城管理相关页面
      case '货架管理':
        return const ProductCategoryManagementContent();
      case '我的仓库':
        return const MyWarehouseContent();
      case '商品评价':
        return const ProductReviewsContent();
      case '运费模板':
        return const FreightTemplateContent();
      case '订单设置':
        return const OrderSettingsContent();

      // 客服管理相关页面
      case '售后处理':
        return const AfterSaleContent();

      // 页面管理相关页面
      case '导航页面管理':
        return const NavigationPageManagementContent();
      case '个人中心管理':
        return const PageEditor(initialPageType: '个人中心');

      // 其他未实现的页面显示"即将推出"
      default:
        return _buildComingSoonContent(_selectedSubMenuItem);
    }
  }

  /// 构建"即将推出"内容区
  Widget _buildComingSoonContent(String featureName) {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 80,
              color: Color(0xFF1890FF),
            ),
            const SizedBox(height: 24),
            Text(
              '"$featureName" 功能即将推出',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '该功能正在开发中，敬请期待',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建基本信息区卡片
  Widget _buildBasicInfoCard() {
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            // 左侧：基本信息区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  const Text(
                    '基本信息',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),

                  // 店铺名称
                  Row(
                    children: [
                      const Text(
                        '店铺名称：',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '唐极课得',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('编辑店铺名称');
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 开通时间和到期时间
                  const Text(
                    '开通时间：2018-06-19 到期时间：2027-07-30',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 当前版本
                  Row(
                    children: [
                      const Text(
                        '当前版本:4.2.2 (',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('升级版本');
                          },
                          child: const Text(
                            '最新版本4.2.5',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1890FF),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        ')',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 右侧：关注公众号 + 续费按钮（Column，上下对齐）
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 关注公众号开关（和基本信息顶部对齐）
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '关注公众号',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: _isFollowOfficialAccount,
                      onChanged: (value) {
                        setState(() {
                          _isFollowOfficialAccount = value;
                        });
                        debugPrint('切换关注公众号：$value');
                      },
                      activeColor: const Color(0xFF52C41A),
                    ),
                  ],
                ),

                const Spacer(),

                // 续费按钮（在底部）
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('点击续费');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1890FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '续费',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
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
    );
  }

  /// 构建小程序数据助手卡片
  Widget _buildMiniProgramAssistant() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 二维码图标（圆形）
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1A9B8E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_2,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // 标题
          const Text(
            '小程序数据助手',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          // 描述文本
          const Text(
            '微信公众平台发布的官方小程序，帮助相关开发和运营人员查看自身小程序的运营数据，扫描下面小程序码即可体验。',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建常用工具网格区（4列x3行，共12个工具卡片）
  Widget _buildCommonToolsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        const Text(
          '常用工具',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),

        // 工具网格
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3.5,
          children: [
            _buildToolCard(Icons.home, '页面管理-主页管理'),
            _buildToolCard(Icons.person, '页面管理-个人中心管理'),
            _buildToolCard(Icons.category, '课程管理-课程分类'),
            _buildToolCard(Icons.list, '课程管理-课程列表'),
            _buildToolCard(Icons.people, '课程管理-作者列表'),
            _buildToolCard(Icons.comment, '课程管理-评论管理'),
            _buildToolCard(Icons.receipt, '订单管理-课程订单'),
            _buildToolCard(Icons.shopping_bag, '订单管理-商品订单'),
            _buildToolCard(Icons.cottage, '订单管理-租赁业务订单'),
            _buildToolCard(Icons.group, '用户管理-用户列表'),
            _buildToolCard(Icons.group_work, '用户管理-用户分类'),
            _buildToolCard(Icons.stars, '用户管理-用户等级'),
            _buildToolCard(Icons.event, '用户管理-签到记录'),
            _buildToolCard(Icons.search, '用户管理-搜索历史管理'),
            _buildToolCard(Icons.business_center, '业务管理-租赁管理'),
            _buildToolCard(Icons.handshake, '业务管理-合作管理'),
          ],
        ),
      ],
    );
  }

  /// 构建单个工具卡片
  Widget _buildToolCard(IconData icon, String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击工具：$label');
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFF1890FF),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建消息通知按钮（带弹窗功能）
  Widget _buildNotificationButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (_showNotificationPopover) {
            _removeOverlay();
          } else {
            _showOverlay();
          }
          setState(() {
            _showNotificationPopover = !_showNotificationPopover;
          });
          debugPrint('点击消息通知：$_showNotificationPopover');
        },
        child: Container(
          key: _notificationButtonKey,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '消息通知',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4D4F),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${_messages.where((m) => !m['isRead']).length}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建 Overlay 消息通知弹窗
  Widget _buildNotificationOverlay() {
    // 获取按钮位置
    final RenderBox? buttonRenderBox =
        _notificationButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (buttonRenderBox == null) {
      debugPrint('无法获取按钮位置');
      return const SizedBox.shrink();
    }

    final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
    final buttonSize = buttonRenderBox.size;

    debugPrint('按钮位置: $buttonPosition, 大小: $buttonSize');

    return GestureDetector(
      onTap: () {
        // 点击弹窗外部关闭
        debugPrint('点击弹窗外部，关闭弹窗');
        _removeOverlay();
        setState(() {
          _showNotificationPopover = false;
        });
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: buttonPosition.dy + buttonSize.height + 8,
              left: buttonPosition.dx + (buttonSize.width / 2) - 200, // 居中对齐（弹窗宽度400的一半）
              child: GestureDetector(
                onTap: () {
                  // 阻止冒泡，点击弹窗内容不关闭
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 400,
                      maxWidth: 400,
                      maxHeight: 500,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 头部操作区
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '消息通知',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      for (var message in _messages) {
                                        message['isRead'] = true;
                                      }
                                    });
                                    debugPrint('全部已读');
                                  },
                                  child: const Text(
                                    '全部已读',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1890FF),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 消息列表区
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: SingleChildScrollView(
                            child: Column(
                              children: _messages.asMap().entries.map((entry) {
                                final index = entry.key;
                                final message = entry.value;
                                return _buildMessageItem(message, index);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建消息通知弹窗（旧版本，保留用于兼容）
  Widget _buildNotificationPopover() {
    return const SizedBox.shrink();
  }

  /// 构建单条消息卡片
  Widget _buildMessageItem(Map<String, dynamic> message, int index) {
    final isRead = message['isRead'] as bool;
    final title = message['title'] as String;
    final content = message['content'] as String;
    final time = message['time'] as String;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: index < _messages.length - 1
                ? const Color(0xFFF5F5F5)
                : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isRead ? const Color(0xFF666666) : const Color(0xFF333333),
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                isRead ? '[已读]' : '[未读]',
                style: TextStyle(
                  fontSize: 14,
                  color: isRead ? const Color(0xFF999999) : const Color(0xFF1890FF),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 摘要内容
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isRead ? const Color(0xFF999999) : const Color(0xFF666666),
              height: 1.6,
              decoration: TextDecoration.none,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // 时间与操作行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  decoration: TextDecoration.none,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('查看详情：${message['id']}');
                    // 标记为已读
                    setState(() {
                      message['isRead'] = true;
                    });
                  },
                  child: const Text(
                    '查看详情',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1890FF),
                      decoration: TextDecoration.none,
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
}

/// 顶部箭头绘制器
class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
