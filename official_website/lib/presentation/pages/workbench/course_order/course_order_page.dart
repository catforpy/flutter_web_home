import 'package:flutter/material.dart';

/// 课程订单状态
enum CourseOrderStatus {
  all('全部订单', Colors.grey),
  pendingPayment('待付款', Color(0xFFFF9800)),
  paid('已付款', Color(0xFF2196F3)),
  completed('已完成', Color(0xFF4CAF50)),
  cancelled('已取消', Color(0xFF9E9E9E)),
  refunding('退款中', Color(0xFFF44336)),
  refunded('已退款', Color(0xFF9E9E9E));

  final String label;
  final Color color;

  const CourseOrderStatus(this.label, this.color);
}

/// 课程订单数据模型
class CourseOrder {
  final String orderNo; // 订单号
  final String courseName; // 课程名称
  final String courseCover; // 课程封面
  final String userName; // 用户名
  final String userPhone; // 用户手机
  final double amount; // 订单金额
  final CourseOrderStatus status; // 订单状态
  final DateTime createTime; // 下单时间
  final DateTime? payTime; // 支付时间
  final String? industryCategory; // 行业分类
  final String? formatCategory; // 形式分类
  final String? typeCategory; // 类型分类

  CourseOrder({
    required this.orderNo,
    required this.courseName,
    required this.courseCover,
    required this.userName,
    required this.userPhone,
    required this.amount,
    required this.status,
    required this.createTime,
    this.payTime,
    this.industryCategory,
    this.formatCategory,
    this.typeCategory,
  });
}

/// 课程订单管理页面
/// 参考课程列表的设计，包含状态筛选、搜索功能、订单列表
class CourseOrderPage extends StatefulWidget {
  const CourseOrderPage({super.key});

  @override
  State<CourseOrderPage> createState() => _CourseOrderPageState();
}

class _CourseOrderPageState extends State<CourseOrderPage> {
  // 当前选中的订单状态
  CourseOrderStatus _selectedStatus = CourseOrderStatus.all;

  // 搜索关键词
  String _searchKeyword = '';

  // 模拟订单数据
  final List<CourseOrder> _orders = [
    CourseOrder(
      orderNo: 'ORD20260310001',
      courseName: 'Python编程入门到精通',
      courseCover: '',
      userName: '张三',
      userPhone: '138****8888',
      amount: 299.00,
      status: CourseOrderStatus.completed,
      createTime: DateTime(2026, 3, 10, 10, 30),
      payTime: DateTime(2026, 3, 10, 10, 35),
      industryCategory: '科技培训 > 计算机 > Python',
      formatCategory: '视频 > 录播视频',
      typeCategory: '套课 > 系列课',
    ),
    CourseOrder(
      orderNo: 'ORD20260310002',
      courseName: 'Java高级开发实战',
      courseCover: '',
      userName: '李四',
      userPhone: '139****9999',
      amount: 499.00,
      status: CourseOrderStatus.paid,
      createTime: DateTime(2026, 3, 10, 11, 15),
      payTime: DateTime(2026, 3, 10, 11, 20),
      industryCategory: '科技培训 > 计算机 > Java',
      formatCategory: '视频 > 直播回放',
      typeCategory: '套课 > 专题课',
    ),
    CourseOrder(
      orderNo: 'ORD20260310003',
      courseName: 'Web前端开发全套教程',
      courseCover: '',
      userName: '王五',
      userPhone: '137****7777',
      amount: 399.00,
      status: CourseOrderStatus.pendingPayment,
      createTime: DateTime(2026, 3, 10, 12, 00),
      industryCategory: '科技培训 > 计算机 > Web开发',
      formatCategory: '视频 > 录播视频',
      typeCategory: '套课 > 训练营',
    ),
    CourseOrder(
      orderNo: 'ORD20260310004',
      courseName: '心理健康与情绪管理',
      courseCover: '',
      userName: '赵六',
      userPhone: '136****6666',
      amount: 199.00,
      status: CourseOrderStatus.refunding,
      createTime: DateTime(2026, 3, 9, 15, 30),
      payTime: DateTime(2026, 3, 9, 15, 35),
      industryCategory: '科技培训 > 心理健康',
      formatCategory: '音频 > 讲座',
      typeCategory: '单课 > 付费单课',
    ),
    CourseOrder(
      orderNo: 'ORD20260310005',
      courseName: '美食烹饪技巧大全',
      courseCover: '',
      userName: '孙七',
      userPhone: '135****5555',
      amount: 99.00,
      status: CourseOrderStatus.cancelled,
      createTime: DateTime(2026, 3, 9, 16, 00),
      industryCategory: '科技培训 > 美食',
      formatCategory: '图文 > 图文混排',
      typeCategory: '单课 > 免费单课',
    ),
    CourseOrder(
      orderNo: 'ORD20260310006',
      courseName: 'AI大模型应用实战',
      courseCover: '',
      userName: '周八',
      userPhone: '134****4444',
      amount: 699.00,
      status: CourseOrderStatus.completed,
      createTime: DateTime(2026, 3, 8, 10, 00),
      payTime: DateTime(2026, 3, 8, 10, 05),
      industryCategory: '科技培训 > 计算机 > Python',
      formatCategory: '视频 > 录播视频',
      typeCategory: '套课 > 年度会员',
    ),
    CourseOrder(
      orderNo: 'ORD20260310007',
      courseName: '数据分析与可视化',
      courseCover: '',
      userName: '吴九',
      userPhone: '133****3333',
      amount: 599.00,
      status: CourseOrderStatus.refunded,
      createTime: DateTime(2026, 3, 8, 11, 30),
      payTime: DateTime(2026, 3, 8, 11, 35),
      industryCategory: '科技培训 > 计算机 > Web开发',
      formatCategory: '视频 > 录播视频',
      typeCategory: '套课 > 系列课',
    ),
  ];

  /// 获取筛选后的订单列表
  List<CourseOrder> get _filteredOrders {
    var filtered = _orders;

    // 按状态筛选
    if (_selectedStatus != CourseOrderStatus.all) {
      filtered = filtered.where((order) => order.status == _selectedStatus).toList();
    }

    // 按关键词搜索
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      filtered = filtered.where((order) {
        return order.orderNo.toLowerCase().contains(keyword) ||
               order.courseName.toLowerCase().contains(keyword) ||
               order.userName.toLowerCase().contains(keyword) ||
               order.userPhone.contains(keyword);
      }).toList();
    }

    return filtered;
  }

  /// 获取各状态订单数量
  Map<CourseOrderStatus, int> get _statusCounts {
    final counts = <CourseOrderStatus, int>{};
    for (final status in CourseOrderStatus.values) {
      if (status == CourseOrderStatus.all) {
        counts[status] = _orders.length;
      } else {
        counts[status] = _orders.where((order) => order.status == status).length;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: Column(
        children: [
          // 顶部操作栏
          _buildTopBar(),

          // 订单状态Tab筛选
          _buildStatusFilter(),

          // 订单列表
          Expanded(
            child: _buildOrderList(),
          ),
        ],
      ),
    );
  }

  /// 构建顶部操作栏
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // 标题
          const Text(
            '课程订单',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          // 搜索框
          SizedBox(
            width: 400,
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索订单号、课程名称、用户名',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchKeyword = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),

          const SizedBox(width: 16),

          // 导出按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                debugPrint('导出订单');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.download, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '导出',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建订单状态筛选Tab
  Widget _buildStatusFilter() {
    final counts = _statusCounts;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: CourseOrderStatus.values.map((status) {
            final isSelected = _selectedStatus == status;
            final count = counts[status] ?? 0;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? status.color : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? status.color : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.3)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建订单列表
  Widget _buildOrderList() {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: const Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无订单数据',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  /// 构建订单卡片
  Widget _buildOrderCard(CourseOrder order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 订单头部：订单号 + 状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '订单号：',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  Text(
                    order.orderNo,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // 复制订单号
                      },
                      child: const Icon(
                        Icons.content_copy,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: order.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 订单主体内容
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 课程封面（占位符）
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  size: 40,
                  color: Color(0xFFCCCCCC),
                ),
              ),

              const SizedBox(width: 20),

              // 课程信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 课程名称
                    Text(
                      order.courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // 分类标签
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (order.industryCategory != null)
                          _buildCategoryChip(
                            Icons.category,
                            order.industryCategory!,
                            const Color(0xFF2196F3),
                          ),
                        if (order.formatCategory != null)
                          _buildCategoryChip(
                            Icons.video_library,
                            order.formatCategory!,
                            const Color(0xFFFF9800),
                          ),
                        if (order.typeCategory != null)
                          _buildCategoryChip(
                            Icons.bookmark,
                            order.typeCategory!,
                            const Color(0xFF4CAF50),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // 用户信息和金额
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 用户信息
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.userName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 14,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.userPhone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 订单金额
                    Text(
                      '¥${order.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF4D4F),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 操作按钮
                    _buildActionButtons(order),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 订单时间信息
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 4),
              Text(
                '下单时间：${_formatDateTime(order.createTime)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              if (order.payTime != null) ...[
                const SizedBox(width: 24),
                const Icon(
                  Icons.payment,
                  size: 14,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Text(
                  '支付时间：${_formatDateTime(order.payTime!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// 构建分类标签
  Widget _buildCategoryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(CourseOrder order) {
    switch (order.status) {
      case CourseOrderStatus.pendingPayment:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton('取消订单', Colors.grey, () {
              _cancelOrder(order);
            }),
            const SizedBox(width: 8),
            _buildActionButton('确认付款', const Color(0xFF2196F3), () {
              _confirmPayment(order);
            }),
          ],
        );

      case CourseOrderStatus.paid:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton('申请退款', const Color(0xFFFF9800), () {
              _requestRefund(order);
            }),
            const SizedBox(width: 8),
            _buildActionButton('完成订单', const Color(0xFF4CAF50), () {
              _completeOrder(order);
            }),
          ],
        );

      case CourseOrderStatus.refunding:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton('拒绝退款', Colors.grey, () {
              _rejectRefund(order);
            }),
            const SizedBox(width: 8),
            _buildActionButton('同意退款', const Color(0xFFFF4D4F), () {
              _approveRefund(order);
            }),
          ],
        );

      case CourseOrderStatus.completed:
      case CourseOrderStatus.cancelled:
      case CourseOrderStatus.refunded:
        return _buildActionButton('查看详情', const Color(0xFF1A9B8E), () {
          _viewOrderDetail(order);
        });

      default:
        return const SizedBox.shrink();
    }
  }

  /// 构建操作按钮
  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 取消订单
  void _cancelOrder(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认取消订单'),
        content: Text('确定要取消订单 ${order.orderNo} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API取消订单
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订单已取消')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 确认付款
  void _confirmPayment(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认付款'),
        content: Text('确定要确认订单 ${order.orderNo} 已付款吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API确认付款
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('付款确认成功')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 完成订单
  void _completeOrder(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认完成订单'),
        content: Text('确定要完成订单 ${order.orderNo} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API完成订单
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订单已完成')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 申请退款
  void _requestRefund(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('申请退款'),
        content: Text('确定要为订单 ${order.orderNo} 申请退款吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API申请退款
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('退款申请已提交')),
              );
            },
            child: const Text('确定申请'),
          ),
        ],
      ),
    );
  }

  /// 同意退款
  void _approveRefund(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('同意退款'),
        content: const Text('确定要同意该退款申请吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API同意退款
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('退款成功')),
              );
            },
            child: const Text('确定退款', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }

  /// 拒绝退款
  void _rejectRefund(CourseOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('拒绝退款'),
        content: const Text('确定要拒绝该退款申请吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // TODO: 调用API拒绝退款
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已拒绝退款申请')),
              );
            },
            child: const Text('确定拒绝'),
          ),
        ],
      ),
    );
  }

  /// 查看订单详情
  void _viewOrderDetail(CourseOrder order) {
    debugPrint('查看订单详情：${order.orderNo}');
    // TODO: 跳转到订单详情页面
  }
}

/// 课程订单管理内容组件（嵌入在merchant_dashboard中使用）
class CourseOrderContent extends StatelessWidget {
  const CourseOrderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseOrderPage();
  }
}
