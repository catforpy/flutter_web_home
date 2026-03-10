import 'package:flutter/material.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../routes/app_router.dart';

/// 我的订单页面
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // 当前选中的标签索引
  int _selectedTabIndex = 0;

  // 订单数据
  final List<Map<String, dynamic>> _orders = [
    {
      'orderNo': '2508101843515267',
      'time': '2025-08-10 18:43:51',
      'title': 'AI大模型对话助手小程序',
      'coverColor': const Color(0xFFFF6B6B), // 橙色系
      'originalPrice': 699.00,
      'discount': 129.95,
      'paidPrice': 569.05,
      'status': '已完成',
      'paymentMethod': '微信支付',
    },
    {
      'orderNo': '2508101843515268',
      'time': '2025-08-09 14:22:30',
      'title': '智能客服机器人系统',
      'coverColor': const Color(0xFF4ECDC4), // 蓝色系
      'originalPrice': 888.00,
      'discount': 200.00,
      'paidPrice': 688.00,
      'status': '已完成',
      'paymentMethod': '支付宝支付',
    },
    {
      'orderNo': '2508101843515269',
      'time': '2025-08-08 09:15:12',
      'title': '数据分析可视化工具',
      'coverColor': const Color(0xFF45B7D1), // 蓝绿色系
      'originalPrice': 458.00,
      'discount': 59.00,
      'paidPrice': 399.00,
      'status': '已完成',
      'paymentMethod': '支付宝支付',
    },
    {
      'orderNo': '2508101843515270',
      'time': '2025-08-07 16:30:45',
      'title': 'OCR文字识别小程序',
      'coverColor': const Color(0xFFFFA07A), // 橙红色
      'originalPrice': 299.00,
      'discount': 50.00,
      'paidPrice': 249.00,
      'status': '未支付',
      'paymentMethod': '',
    },
    {
      'orderNo': '2508101843515271',
      'time': '2025-08-06 11:20:18',
      'title': '智能翻译助手Pro版',
      'coverColor': const Color(0xFF6C5CE7), // 紫色系
      'originalPrice': 199.00,
      'discount': 41.00,
      'paidPrice': 158.00,
      'status': '已完成',
      'paymentMethod': '微信支付',
    },
    {
      'orderNo': '2508101843515272',
      'time': '2025-08-05 15:50:33',
      'title': '企业级报表系统',
      'coverColor': const Color(0xFF26C6DA), // 青色系
      'originalPrice': 1299.00,
      'discount': 300.00,
      'paidPrice': 999.00,
      'status': '已完成',
      'paymentMethod': '支付宝支付',
    },
    {
      'orderNo': '2508101843515273',
      'time': '2025-08-04 10:05:28',
      'title': '语音识别转文字工具',
      'coverColor': const Color(0xFF2EC4B6), // 绿色系
      'originalPrice': 358.00,
      'discount': 109.00,
      'paidPrice': 249.00,
      'status': '已失效',
      'paymentMethod': '',
    },
  ];

  // 菜单项
  final List<Map<String, dynamic>> _menuItems = [
    {'label': '我的订单', 'icon': Icons.receipt_long},
    {'label': '我的余额', 'icon': Icons.account_balance_wallet},
    {'label': '电子兑换码', 'icon': Icons.card_giftcard},
    {'label': '优惠券/红包', 'icon': Icons.local_offer},
    {'label': '客服咨询', 'icon': Icons.question_answer},
    {'label': '发票管理', 'icon': Icons.description},
    {'label': '消费记录', 'icon': Icons.history},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 导航栏
            const UnifiedNavigationBar(
              currentPath: AppRouter.home,
            ),

            // 主内容区
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 左侧导航栏
                    _buildLeftSidebar(),

                    const SizedBox(width: 20),

                    // 右侧内容区
                    Expanded(
                      child: _buildRightContent(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  /// 构建左侧导航栏
  Widget _buildLeftSidebar() {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 菜单项
          for (int i = 0; i < _menuItems.length; i++)
            _buildMenuItem(_menuItems[i]['label'], _menuItems[i]['icon'], i == 0),
        ],
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(String label, IconData icon, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击菜单：$label');
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: const Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建右侧内容区
  Widget _buildRightContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部功能区
          _buildTopActionBar(),

          const SizedBox(height: 24),

          // 订单列表
          ..._buildOrderList(),
        ],
      ),
    );
  }

  /// 构建顶部功能区
  Widget _buildTopActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 标题与标签页
        Row(
          children: [
            const Text(
              '我的订单',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 24),
            _buildTab('全部 ${_orders.length}', 0),
            const SizedBox(width: 16),
            _buildTab('未支付', 1),
            const SizedBox(width: 16),
            _buildTab('已完成', 2),
            const SizedBox(width: 16),
            _buildTab('已失效', 3),
          ],
        ),

        // 右侧功能按钮
        Row(
          children: [
            _buildActionButton(Icons.people, '我的拼团'),
            const SizedBox(width: 24),
            _buildActionButton(Icons.delete_outline, '订单回收站'),
          ],
        ),
      ],
    );
  }

  /// 构建标签页
  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF333333) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建功能按钮
  Widget _buildActionButton(IconData icon, String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击：$label');
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF666666),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建订单列表
  List<Widget> _buildOrderList() {
    // 根据选中的标签筛选订单
    List<Map<String, dynamic>> filteredOrders = _orders;

    if (_selectedTabIndex == 1) {
      // 未支付
      filteredOrders = _orders.where((order) => order['status'] == '未支付').toList();
    } else if (_selectedTabIndex == 2) {
      // 已完成
      filteredOrders = _orders.where((order) => order['status'] == '已完成').toList();
    } else if (_selectedTabIndex == 3) {
      // 已失效
      filteredOrders = _orders.where((order) => order['status'] == '已失效').toList();
    }

    return List.generate(filteredOrders.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildOrderCard(filteredOrders[index]),
      );
    });
  }

  /// 构建订单卡片
  Widget _buildOrderCard(Map<String, dynamic> order) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击订单：${order['orderNo']}');
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 订单信息头
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFEEEEEE),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt,
                          size: 16,
                          color: Color(0xFFFF4D4F),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '订单编号：${order['orderNo']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order['time'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 订单主体内容
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧：封面
                  Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      color: order['coverColor'] as Color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        _getCoverTitle(order['title']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 中间：课程详情与价格
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              '实付',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '¥${order['paidPrice'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4D4F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 右侧：原价/折扣/支付方式
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (order['originalPrice'] != null && order['originalPrice'] > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '原价',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '¥${order['originalPrice'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      if (order['discount'] != null && order['discount'] > 0)
                        const SizedBox(height: 8),
                      if (order['discount'] != null && order['discount'] > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '折扣',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '– ¥${order['discount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      if (order['paymentMethod'] != null && order['paymentMethod'].toString().isNotEmpty)
                        Text(
                          order['paymentMethod'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  // 状态栏
                  SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order['status'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: order['status'] == '未支付'
                                ? const Color(0xFFFFA940) // 橙色
                                : order['status'] == '已失效'
                                    ? const Color(0xFF999999) // 灰色
                                    : const Color(0xFF333333), // 黑色
                          ),
                        ),
                      ],
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

  /// 获取封面标题缩写
  String _getCoverTitle(String title) {
    // 取前两个字作为缩写
    if (title.length >= 2) {
      return title.substring(0, 2);
    }
    return title;
  }
}
