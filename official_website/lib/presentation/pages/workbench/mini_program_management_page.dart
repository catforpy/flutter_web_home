import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'development/development_settings_content.dart';
import 'audit_management_content.dart';
import 'menu_navigation/menu_navigation_content.dart';
import 'payment/payment_config_content.dart';
import 'personal_center_management_content.dart';
import 'page_management/page_editor.dart';
import 'route_manager.dart';

/// 小程序管理页面容器
/// 包含：侧边栏、顶部标题栏、内容区
/// 内容区根据选中的子菜单动态切换
class MiniProgramManagementPage extends StatefulWidget {
  final String initialTab;

  const MiniProgramManagementPage({
    super.key,
    this.initialTab = '开发设置',
  });

  @override
  State<MiniProgramManagementPage> createState() => _MiniProgramManagementPageState();
}

class _MiniProgramManagementPageState extends State<MiniProgramManagementPage> {
  // 当前选中的菜单项
  late String _selectedMenuItem;

  // 展开的子菜单
  final Set<String> _expandedMenus = {'小程序管理'};

  // 消息数据
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 1,
      'title': '新订单通知',
      'content': '您有3个新订单待处理',
      'time': '5分钟前',
      'isRead': false,
    },
    {
      'id': 2,
      'title': '系统通知',
      'content': '您的店铺已通过审核',
      'time': '1小时前',
      'isRead': false,
    },
    {
      'id': 3,
      'title': '活动提醒',
      'content': '双11活动即将开始',
      'time': '2天前',
      'isRead': true,
    },
  ];

  // 消息通知弹窗状态
  bool _showNotificationPopover = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _notificationButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedMenuItem = widget.initialTab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听路由参数变化，当用户点击浏览器返回按钮时更新选中的菜单项
    final state = GoRouterState.of(context);
    final tabParam = state.uri.queryParameters['tab'];
    if (tabParam != null && tabParam != _selectedMenuItem) {
      setState(() {
        _selectedMenuItem = tabParam;
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

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
            // 左侧导航栏（200px）
            _buildSidebar(),

            // 右侧内容区
            Expanded(
              child: Column(
                children: [
                  // 顶部标题栏
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
      ),
    );
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
                _buildMenuItem(Icons.extension, '模块管理', isActive: false, hasSubmenu: true,
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
                // Logo
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
                  // 点击"管理中心"返回上一页
                  if (label == '管理中心') {
                    Navigator.pop(context);
                  } else {
                    // 其他父级菜单项也使用路由管理器（可以扩展为在当前页面内切换）
                    WorkbenchRouteManager.handleSubMenuItemClick(context, label);
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
                      debugPrint('点击子菜单：$subItem');

                      // 只更新选中的标签，不进行路由跳转
                      setState(() {
                        _selectedMenuItem = subItem;
                      });
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
              _buildHeaderButton('退出'),
              const SizedBox(width: 16),
              _buildHeaderButton('更多操作', isMoreButton: true),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建消息通知按钮
  Widget _buildNotificationButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: _notificationButtonKey,
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

  /// 显示消息通知弹窗
  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildNotificationOverlay(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 移除消息通知弹窗
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 构建消息通知弹窗
  Widget _buildNotificationOverlay() {
    // 获取按钮位置
    final RenderBox? buttonRenderBox =
        _notificationButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (buttonRenderBox == null) {
      return const SizedBox.shrink();
    }

    final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
    final buttonSize = buttonRenderBox.size;

    return Positioned(
      top: buttonPosition.dy + buttonSize.height + 8,
      left: buttonPosition.dx + buttonSize.width - 320,
      child: Material(
        color: Colors.transparent,
        child: MouseRegion(
          onExit: (_) {
            _removeOverlay();
            setState(() {
              _showNotificationPopover = false;
            });
          },
          child: Container(
            width: 320,
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题栏
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
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
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // 全部标记为已读
                          setState(() {
                            for (var msg in _messages) {
                              msg['isRead'] = true;
                            }
                          });
                        },
                        child: const Text(
                          '全部已读',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1890FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 消息列表
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              message['isRead'] = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: message['isRead'] ? Colors.white : const Color(0xFFF5F5F5),
                              border: const Border(
                                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 图标
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: BoxDecoration(
                                    color: message['isRead']
                                        ? const Color(0xFFCCCCCC)
                                        : const Color(0xFFFF4D4F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // 内容
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['title'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: message['isRead']
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          color: const Color(0xFF333333),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message['content'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message['time'] as String,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildHeaderButton(String text, {bool isMoreButton = false, bool isSettings = false, bool isManagementCenter = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击按钮：$text');
          if (isSettings) {
            // 跳转到店铺设置页
            WorkbenchRouteManager.handleSubMenuItemClick(context, text);
          } else if (isManagementCenter) {
            // 返回到平台接入中心页面
            Navigator.popUntil(context, (route) {
              return route.isFirst || route.settings.name == 'PlatformInitializationPage';
            });
          } else if (text == '退出') {
            // TODO: 实现退出登录
            WorkbenchRouteManager.handleSubMenuItemClick(context, text);
          } else if (text.isNotEmpty) {
            // 其他按钮显示"即将推出"
            WorkbenchRouteManager.handleSubMenuItemClick(context, text);
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

  /// 构建内容区（根据选中的子菜单动态切换）
  Widget _buildContentArea() {
    switch (_selectedMenuItem) {
      case '开发设置':
        return const DevelopmentSettingsContent();
      case '审核管理':
        return const AuditManagementContent();
      case '菜单导航':
        return const MenuNavigationContent();
      case '支付配置':
        return const PaymentConfigContent();
      case '主页管理':
        return const PageEditor(initialPageType: '首页');
      case '个人中心管理':
        return const PersonalCenterManagementContent();
      case '订阅消息':
      case '跳转小程序':
      case '开发者模式':
        return _buildComingSoonContent(_selectedMenuItem);
      default:
        return _buildComingSoonContent(_selectedMenuItem);
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
}
