import 'package:flutter/material.dart';

/// 售后工单状态
enum AfterSaleStatus {
  all('全部工单', Colors.grey),
  pending('待处理', Color(0xFFFF9800)),
  processing('处理中', Color(0xFF2196F3)),
  completed('已完成', Color(0xFF4CAF50)),
  closed('已关闭', Color(0xFF9E9E9E));

  final String label;
  final Color color;

  const AfterSaleStatus(this.label, this.color);
}

/// 售后工单类型
enum AfterSaleType {
  refund('仅退款'),
  returnGoods('退货退款'),
  exchange('换货'),
  complaint('投诉'),
  consult('咨询');

  final String label;

  const AfterSaleType(this.label);
}

/// 售后工单模型
class AfterSaleTicket {
  final String id;
  final String orderNo; // 订单号
  final String productName; // 商品名称
  final String userName; // 用户名称
  final String userPhone; // 用户电话
  final AfterSaleType type; // 工单类型
  final String reason; // 售后原因
  final String description; // 详细描述
  final List<String> images; // 图片凭证
  final AfterSaleStatus status; // 工单状态
  final DateTime createTime; // 创建时间
  final DateTime? updateTime; // 更新时间
  final String? handler; // 处理人
  final String? remark; // 处理备注

  AfterSaleTicket({
    required this.id,
    required this.orderNo,
    required this.productName,
    required this.userName,
    required this.userPhone,
    required this.type,
    required this.reason,
    required this.description,
    required this.images,
    required this.status,
    required this.createTime,
    this.updateTime,
    this.handler,
    this.remark,
  });
}

/// 售后处理页面
class AfterSalePage extends StatefulWidget {
  const AfterSalePage({super.key});

  @override
  State<AfterSalePage> createState() => _AfterSalePageState();
}

class _AfterSalePageState extends State<AfterSalePage> {
  // 当前选中的状态筛选
  AfterSaleStatus _selectedStatus = AfterSaleStatus.all;

  // 工单类型筛选
  AfterSaleType? _selectedType;

  // 搜索关键词
  String _searchKeyword = '';

  // 模拟售后工单数据
  final List<AfterSaleTicket> _tickets = [
    AfterSaleTicket(
      id: 't001',
      orderNo: 'ORD20260310001',
      productName: '时尚纯棉T恤',
      userName: '张三',
      userPhone: '138****8888',
      type: AfterSaleType.refund,
      reason: '不喜欢',
      description: '收到货后发现不喜欢，想退款',
      images: [],
      status: AfterSaleStatus.pending,
      createTime: DateTime(2026, 3, 10, 10, 30),
    ),
    AfterSaleTicket(
      id: 't002',
      orderNo: 'ORD20260310002',
      productName: '休闲牛仔裤',
      userName: '李四',
      userPhone: '139****9999',
      type: AfterSaleType.returnGoods,
      reason: '质量问题',
      description: '裤子有线头，质量不好',
      images: ['img1.jpg'],
      status: AfterSaleStatus.processing,
      createTime: DateTime(2026, 3, 9, 15, 20),
      updateTime: DateTime(2026, 3, 9, 16, 00),
      handler: '客服小王',
    ),
    AfterSaleTicket(
      id: 't003',
      orderNo: 'ORD20260310003',
      productName: '连衣裙 夏季新款',
      userName: '王五',
      userPhone: '137****7777',
      type: AfterSaleType.exchange,
      reason: '尺码不合适',
      description: '尺码买大了，想换个M码',
      images: [],
      status: AfterSaleStatus.completed,
      createTime: DateTime(2026, 3, 8, 9, 15),
      updateTime: DateTime(2026, 3, 8, 14, 30),
      handler: '客服小李',
      remark: '已安排换货',
    ),
    AfterSaleTicket(
      id: 't004',
      orderNo: 'ORD20260310004',
      productName: '智能手机 iPhone 15',
      userName: '赵六',
      userPhone: '136****6666',
      type: AfterSaleType.complaint,
      reason: '物流太慢',
      description: '等了一个星期还没收到货',
      images: [],
      status: AfterSaleStatus.processing,
      createTime: DateTime(2026, 3, 7, 16, 45),
      handler: '客服小王',
    ),
  ];

  /// 获取筛选后的工单列表
  List<AfterSaleTicket> get _filteredTickets {
    var filtered = List<AfterSaleTicket>.from(_tickets);

    // 按状态筛选
    if (_selectedStatus != AfterSaleStatus.all) {
      filtered = filtered.where((ticket) => ticket.status == _selectedStatus).toList();
    }

    // 按类型筛选
    if (_selectedType != null) {
      filtered = filtered.where((ticket) => ticket.type == _selectedType).toList();
    }

    // 按关键词搜索
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      filtered = filtered.where((ticket) {
        return ticket.orderNo.toLowerCase().contains(keyword) ||
               ticket.productName.toLowerCase().contains(keyword) ||
               ticket.userName.toLowerCase().contains(keyword) ||
               ticket.userPhone.contains(keyword);
      }).toList();
    }

    // 按时间倒序
    filtered.sort((a, b) => b.createTime.compareTo(a.createTime));

    return filtered;
  }

  /// 获取各状态工单数量
  Map<AfterSaleStatus, int> get _statusCounts {
    final counts = <AfterSaleStatus, int>{};
    for (final status in AfterSaleStatus.values) {
      if (status == AfterSaleStatus.all) {
        counts[status] = _tickets.length;
      } else {
        counts[status] = _tickets.where((ticket) => ticket.status == status).length;
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

          // 状态筛选
          _buildStatusFilter(),

          // 工单列表
          Expanded(
            child: _buildTicketList(),
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
          const Text(
            '售后处理',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          // 工单类型筛选
          Row(
            children: [
              const Text(
                '类型：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildTypeChip('全部', null),
              const SizedBox(width: 8),
              _buildTypeChip('退款', AfterSaleType.refund),
              const SizedBox(width: 8),
              _buildTypeChip('退货', AfterSaleType.returnGoods),
              const SizedBox(width: 8),
              _buildTypeChip('换货', AfterSaleType.exchange),
              const SizedBox(width: 8),
              _buildTypeChip('投诉', AfterSaleType.complaint),
            ],
          ),

          const SizedBox(width: 24),

          // 搜索框
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索订单号、商品、用户',
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
        ],
      ),
    );
  }

  /// 构建类型筛选芯片
  Widget _buildTypeChip(String label, AfterSaleType? type) {
    final isSelected = _selectedType == type;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = isSelected ? null : type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建状态筛选
  Widget _buildStatusFilter() {
    final counts = _statusCounts;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: AfterSaleStatus.values.map((status) {
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

  /// 构建工单列表
  Widget _buildTicketList() {
    final tickets = _filteredTickets;

    if (tickets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: 80,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
              '暂无售后工单',
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index]);
      },
    );
  }

  /// 构建工单卡片
  Widget _buildTicketCard(AfterSaleTicket ticket) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部：订单信息 + 状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 20,
                    color: Color(0xFF1A9B8E),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ticket.orderNo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.type.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A9B8E),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ticket.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ticket.status.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: ticket.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 用户和商品信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 8),
              Text(
                '${ticket.userName} (${ticket.userPhone})',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 16,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ticket.productName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 售后原因
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '售后原因：${ticket.reason}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 底部：时间和操作
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(ticket.createTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              if (ticket.handler != null) ...[
                const SizedBox(width: 24),
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 4),
                Text(
                  '处理人：${ticket.handler}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
              const Spacer(),
              if (ticket.status == AfterSaleStatus.pending)
                _buildActionButton('处理', const Color(0xFF2196F3), () => _handleTicket(ticket))
              else if (ticket.status == AfterSaleStatus.processing)
                _buildActionButton('完成', const Color(0xFF4CAF50), () => _completeTicket(ticket)),
            ],
          ),
        ],
      ),
    );
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
              fontSize: 12,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 处理工单
  void _handleTicket(AfterSaleTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('处理售后工单'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('订单号：${ticket.orderNo}'),
            const SizedBox(height: 8),
            Text('商品：${ticket.productName}'),
            const SizedBox(height: 8),
            Text('原因：${ticket.reason}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '处理备注',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                final index = _tickets.indexWhere((t) => t.id == ticket.id);
                if (index != -1) {
                  _tickets[index] = AfterSaleTicket(
                    id: ticket.id,
                    orderNo: ticket.orderNo,
                    productName: ticket.productName,
                    userName: ticket.userName,
                    userPhone: ticket.userPhone,
                    type: ticket.type,
                    reason: ticket.reason,
                    description: ticket.description,
                    images: ticket.images,
                    status: AfterSaleStatus.processing,
                    createTime: ticket.createTime,
                    updateTime: DateTime.now(),
                    handler: '当前用户',
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('工单已接受处理')),
              );
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  /// 完成工单
  void _completeTicket(AfterSaleTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('完成工单'),
        content: const Text('确定要完成该售后工单吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                final index = _tickets.indexWhere((t) => t.id == ticket.id);
                if (index != -1) {
                  _tickets[index] = AfterSaleTicket(
                    id: ticket.id,
                    orderNo: ticket.orderNo,
                    productName: ticket.productName,
                    userName: ticket.userName,
                    userPhone: ticket.userPhone,
                    type: ticket.type,
                    reason: ticket.reason,
                    description: ticket.description,
                    images: ticket.images,
                    status: AfterSaleStatus.completed,
                    createTime: ticket.createTime,
                    updateTime: DateTime.now(),
                    handler: ticket.handler,
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('工单已完成')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

/// 售后处理内容组件（嵌入在merchant_dashboard中使用）
class AfterSaleContent extends StatelessWidget {
  const AfterSaleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const AfterSalePage();
  }
}
