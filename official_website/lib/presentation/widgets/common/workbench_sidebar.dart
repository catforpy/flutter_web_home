import 'package:flutter/material.dart';

/// 工作台左侧导航栏组件
class WorkbenchSidebar extends StatefulWidget {
  final String selectedMenuItem;
  final Function(String) onMenuItemTap;
  final Function(String)? onSubMenuItemTap;

  const WorkbenchSidebar({
    super.key,
    required this.selectedMenuItem,
    required this.onMenuItemTap,
    this.onSubMenuItemTap,
  });

  @override
  State<WorkbenchSidebar> createState() => _WorkbenchSidebarState();
}

class _WorkbenchSidebarState extends State<WorkbenchSidebar> {
  final Set<String> _expandedMenus = {'小程序管理'};

  @override
  Widget build(BuildContext context) {
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
                _buildMenuItem(Icons.store, '管理中心', hasSubmenu: false),
                _buildMenuItem(Icons.phone_android, '小程序管理', hasSubmenu: true,
                  submenu: ['开发设置', '审核管理', '菜单导航', '订阅消息', '跳转小程序', '开发者模式']),
                _buildMenuItem(Icons.settings, '配置管理', hasSubmenu: true,
                  submenu: ['支付配置', '分享海报设置', '客服设置', '短信设置', '音视频存储', '广告位配置']),
                _buildMenuItem(Icons.extension, '模块管理', hasSubmenu: true,
                  submenu: ['咨询管理', '留言管理', '启动图管理', '活动页配置', '经典语录管理']),
                _buildMenuItem(Icons.image, '页面管理', hasSubmenu: true,
                  submenu: ['主页管理', '个人中心管理']),
                _buildMenuItem(Icons.menu_book, '课程管理', hasSubmenu: true,
                  submenu: ['课程分类', '课程列表', '作者列表', '评论管理']),
                _buildMenuItem(Icons.shopping_cart, '订单管理', hasSubmenu: true,
                  submenu: ['课程订单']),
                _buildMenuItem(Icons.storefront, '商城管理', hasSubmenu: true,
                  submenu: ['商品分类', '商品列表', '运费模板', '商品评价', '商城订单', '维权订单', '订单设置', '留言模版']),
                _buildMenuItem(Icons.people, '用户管理', hasSubmenu: true,
                  submenu: ['用户列表', '用户分类', '用户等级', '签到记录', '搜索历史管理']),
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
          _buildBrandFooter(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {bool hasSubmenu = false, List<String>? submenu}) {
    final isExpanded = _expandedMenus.contains(label);
    final isActive = widget.selectedMenuItem == label;

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
                }
                widget.onMenuItemTap(label);
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
                final isSubSelected = widget.selectedMenuItem == subItem;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      widget.onSubMenuItemTap?.call(subItem);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        subItem,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSubSelected ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                          fontWeight: isSubSelected ? FontWeight.w500 : FontWeight.normal,
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

  Widget _buildBrandFooter() {
    return Container(
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
    );
  }
}
