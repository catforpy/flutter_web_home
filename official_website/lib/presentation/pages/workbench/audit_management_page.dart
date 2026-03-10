import 'package:flutter/material.dart';
import '../../../../core/auth/auth_state.dart';
import 'route_manager.dart';
import 'components/audit_info_banner.dart';
import 'components/online_version_card.dart';
import 'components/audit_version_card.dart';
import 'components/experience_version_card.dart';
import 'components/code_update_card.dart';

/// 审核管理页面
/// 展示线上版、审核中版、体验版、待提交版的完整状态与操作入口
class AuditManagementPage extends StatefulWidget {
  const AuditManagementPage({super.key});

  @override
  State<AuditManagementPage> createState() => _AuditManagementPageState();
}

class _AuditManagementPageState extends State<AuditManagementPage> {
  // 当前选中的菜单项
  String _selectedMenuItem = '审核管理';

  // 展开的子菜单
  final Set<String> _expandedMenus = {'小程序管理'};

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
                  } else {
                    // 其他父级菜单项使用路由管理器
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
                color: (_expandedMenus.contains(label) || isActive) ? const Color(0xFF2D343A) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: (_expandedMenus.contains(label) || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: (_expandedMenus.contains(label) || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  if (hasSubmenu)
                    Icon(
                      _expandedMenus.contains(label) ? Icons.expand_less : Icons.keyboard_arrow_down,
                      size: 18,
                      color: (_expandedMenus.contains(label) || isActive) ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 子菜单列表
        if (hasSubmenu && submenu != null && _expandedMenus.contains(label))
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: submenu.map((subItem) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenuItem = subItem;
                      });
                      // 使用路由管理器处理导航
                      if (subItem != '审核管理') {
                        WorkbenchRouteManager.handleSubMenuItemClick(context, subItem);
                      }
                      // 如果是"审核管理"，已经在当前页面，不需要跳转
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
              _buildHeaderButton('消息通知'),
              const SizedBox(width: 16),
              _buildHeaderButton('店铺设置'),
              const SizedBox(width: 16),
              _buildHeaderButton('管理中心'),
              const SizedBox(width: 16),
              _buildHeaderButton('退出'),
              const SizedBox(width: 16),
              _buildHeaderButton('', isMoreButton: true),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildHeaderButton(String text, {bool isMoreButton = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击按钮：$text');
          if (text == '管理中心') {
            Navigator.pop(context);
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

  /// 构建主内容区
  Widget _buildMainContent() {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 绿色提示横幅
          const AuditInfoBanner(),

          const SizedBox(height: 24),

          // 线上版本卡片
          const OnlineVersionCard(),

          const SizedBox(height: 24),

          // 审核版本卡片
          const AuditVersionCard(),

          const SizedBox(height: 24),

          // 体验版本卡片
          const ExperienceVersionCard(),

          const SizedBox(height: 24),

          // 代码更新卡片
          const CodeUpdateCard(),
        ],
      ),
    );
  }
}
