import 'package:flutter/material.dart';
import '../../../core/auth/auth_state.dart';

/// 服务商工作台
/// 专注于授权业务：模板管理、客户管理、授权管理
class ServiceProviderWorkbench extends StatefulWidget {
  const ServiceProviderWorkbench({super.key});

  @override
  State<ServiceProviderWorkbench> createState() => _ServiceProviderWorkbenchState();
}

class _ServiceProviderWorkbenchState extends State<ServiceProviderWorkbench> {
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
            // 左侧导航栏
            _buildSidebar(),

            // 主内容区
            Expanded(
              child: Column(
                children: [
                  // 顶部标题栏
                  _buildTopHeader(),

                  // 主内容
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
      width: 220,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
          // 菜单项列表
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.dashboard, '工作台首页', isActive: true),
                _buildMenuItem(Icons.apps, '模板管理', hasSubmenu: true,
                  submenu: ['我的模板', '模板上架', '模板统计']),
                _buildMenuItem(Icons.shopping_bag, '订单中心', hasSubmenu: true,
                  submenu: ['全部订单', '待处理', '已完成', '退款订单']),
                _buildMenuItem(Icons.people, '客户管理', hasSubmenu: true,
                  submenu: ['客户列表', '客户分析', '客户反馈']),
                _buildMenuItem(Icons.vpn_key, '授权管理', hasSubmenu: true,
                  submenu: ['我的授权', '授权申请', '授权记录']),
                _buildMenuItem(Icons.analytics, '数据统计', hasSubmenu: true,
                  submenu: ['服务概览', '收入统计', '客户分析']),
                _buildMenuItem(Icons.settings, '账户设置', hasSubmenu: false),
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
                  '都达网',
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
  Widget _buildMenuItem(
    IconData icon,
    String label, {
    bool isActive = false,
    bool hasSubmenu = false,
    List<String>? submenu,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 父级菜单项
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              debugPrint('点击菜单：$label');
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2D343A) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  if (hasSubmenu)
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Color(0xFFCCCCCC),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 子菜单列表（示例：暂时展开）
        if (hasSubmenu && submenu != null)
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
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        subItem,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFFCCCCCC),
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
          const Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A9B8E),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '服务商工作台',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // 右侧用户信息
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18,
                      color: Color(0xFF1A9B8E),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      authState.nickname,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildHeaderButton('退出'),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildHeaderButton(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (text == '退出') {
            authState.logout();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建主内容区
  Widget _buildContentArea() {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 服务数据概览
            _buildServiceOverview(),

            const SizedBox(height: 24),

            // 快捷功能入口
            _buildQuickActions(),

            const SizedBox(height: 24),

            // 最近订单
            _buildRecentOrders(),

            const SizedBox(height: 24),

            // 授权范围提醒
            _buildAuthorizationReminder(),
          ],
        ),
      ),
    );
  }

  /// 构建服务数据概览
  Widget _buildServiceOverview() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '服务数据概览',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDataCard('完成订单', '156', Icons.shopping_bag, const Color(0xFF4CAF50))),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('服务评分', '4.8', Icons.star, const Color(0xFFFFC107))),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('客户数量', '89', Icons.people, const Color(0xFF2196F3))),
              const SizedBox(width: 16),
              Expanded(child: _buildDataCard('本月收入', '¥23,450', Icons.account_balance_wallet, const Color(0xFF9C27B0))),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建数据卡片
  Widget _buildDataCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建快捷功能入口
  Widget _buildQuickActions() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '快捷功能',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildActionCard('发布模板', Icons.dashboard_customize, const Color(0xFF2196F3)),
              _buildActionCard('查看订单', Icons.shopping_bag, const Color(0xFF4CAF50)),
              _buildActionCard('客户管理', Icons.people, const Color(0xFFFF9800)),
              _buildActionCard('授权申请', Icons.vpn_key, const Color(0xFF9C27B0)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作卡片
  Widget _buildActionCard(String label, IconData icon, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击：$label');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建最近订单
  Widget _buildRecentOrders() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '最近订单',
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
                    debugPrint('查看全部订单');
                  },
                  child: const Text(
                    '查看全部 >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOrderList(),
        ],
      ),
    );
  }

  /// 构建订单列表
  Widget _buildOrderList() {
    final orders = [
      {'order': '模板购买 - 电商小程序', 'customer': '某科技公司', 'amount': '¥299', 'status': '已完成'},
      {'order': '模板购买 - 餐饮系统', 'customer': '某餐饮连锁', 'amount': '¥599', 'status': '进行中'},
      {'order': '定制开发 - 教育平台', 'customer': '某教育机构', 'amount': '¥2,999', 'status': '待确认'},
    ];

    return Column(
      children: orders.map((order) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['order'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '客户：${order['customer']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order['amount'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['status'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: order['status'] == '已完成'
                          ? const Color(0xFF4CAF50)
                          : order['status'] == '进行中'
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建授权范围提醒
  Widget _buildAuthorizationReminder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A9B8E), Color(0xFF2C5F8D)],
        ),
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
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 24, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                '授权范围提醒',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAuthScopeInfo('授权模块', '3个模块', Icons.apps),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAuthScopeInfo('授权地区', '2个地区', Icons.location_on),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAuthScopeInfo('授权行业', '3个行业', Icons.business),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                debugPrint('申请扩大授权范围');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '申请扩大授权范围',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A9B8E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建授权范围信息
  Widget _buildAuthScopeInfo(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
