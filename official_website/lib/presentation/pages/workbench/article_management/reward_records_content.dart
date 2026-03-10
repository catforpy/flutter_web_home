import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 打赏记录内容组件（可复用的纯内容组件，不包含导航栏）
class RewardRecordsContent extends StatefulWidget {
  const RewardRecordsContent({super.key});

  @override
  State<RewardRecordsContent> createState() => _RewardRecordsContentState();
}

class _RewardRecordsContentState extends State<RewardRecordsContent> {
  // 搜索筛选条件
  final TextEditingController _memberNameController = TextEditingController();
  final TextEditingController _articleTitleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // 打赏记录数据（包含测试数据：小额、大额、长标题、跨年）
  final List<Map<String, dynamic>> _rewardRecords = [
    {
      'id': 'ORD20240308001',
      'articleTitle': '论抖音视频对生活的影响',
      'memberName': '张三',
      'amount': 0.10,
      'type': '资讯',
      'paymentMethod': '余额支付',
      'time': DateTime(2024, 3, 8, 14, 30),
    },
    {
      'id': 'ORD20240307002',
      'articleTitle': '如何高效学习编程 - 从零开始掌握核心技术，一步步成为编程高手',
      'memberName': '李四',
      'amount': 2.00,
      'type': '资讯',
      'paymentMethod': '微信支付',
      'time': DateTime(2024, 3, 7, 9, 15),
    },
    {
      'id': 'ORD20240306003',
      'articleTitle': 'Flutter 开发实战指南',
      'memberName': '王五',
      'amount': 1111.00,
      'type': '资讯',
      'paymentMethod': '支付宝',
      'time': DateTime(2023, 12, 15, 16, 45),
    },
    {
      'id': 'ORD20240305004',
      'articleTitle': '抖音小程序正式开放申请！快手小程序也即将上线，2024年将是小程序爆发元年',
      'memberName': '赵六',
      'amount': 333.00,
      'type': '资讯',
      'paymentMethod': '余额支付',
      'time': DateTime(2023, 11, 20, 11, 20),
    },
    {
      'id': 'ORD20240304005',
      'articleTitle': 'Web 前端架构设计思路',
      'memberName': '孙七',
      'amount': 5.50,
      'type': '资讯',
      'paymentMethod': '微信支付',
      'time': DateTime(2023, 10, 5, 8, 50),
    },
    {
      'id': 'ORD20240303006',
      'articleTitle': '论抖音视频对生活的影响',
      'memberName': '张三',
      'amount': 10.00,
      'type': '资讯',
      'paymentMethod': '余额支付',
      'time': DateTime(2020, 8, 12, 13, 25),
    },
    {
      'id': 'ORD20240302007',
      'articleTitle': '2019年行业发展趋势分析报告，深度解析未来走向',
      'memberName': '周八',
      'amount': 88.88,
      'type': '资讯',
      'paymentMethod': '支付宝',
      'time': DateTime(2019, 12, 30, 10, 15),
    },
    {
      'id': 'ORD20240301008',
      'articleTitle': '如何高效学习编程',
      'memberName': '吴九',
      'amount': 1.00,
      'type': '资讯',
      'paymentMethod': '微信支付',
      'time': DateTime(2019, 6, 18, 15, 40),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  // 每页显示数量
  final int _pageSize = 10;
  // 当前页码（从1开始）
  int _currentPage = 1;

  @override
  void dispose() {
    _memberNameController.dispose();
    _articleTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 1. 搜索筛选区
            _buildSearchFilterBar(),

            const SizedBox(height: 16),

            // 2. 金额统计区
            _buildAmountStatistics(),

            const SizedBox(height: 16),

            // 3. 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),

            // 4. 分页器
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  /// 1. 搜索筛选栏
  Widget _buildSearchFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 打赏会员搜索
          Expanded(
            flex: 3,
            child: _buildSearchField(
              '打赏会员',
              '请输入会员昵称',
              _memberNameController,
            ),
          ),
          const SizedBox(width: 12),

          // 文章标题搜索
          Expanded(
            flex: 3,
            child: _buildSearchField(
              '文章标题',
              '请输入文章标题',
              _articleTitleController,
            ),
          ),
          const SizedBox(width: 12),

          // 打赏时间范围
          Expanded(
            flex: 4,
            child: _buildDateRangePicker(),
          ),
          const SizedBox(width: 12),

          // 查询按钮
          _buildQueryButton(),
          const SizedBox(width: 12),

          // 导出Excel按钮（可选增强功能）
          _buildExportButton(),
        ],
      ),
    );
  }

  /// 构建搜索输入框
  Widget _buildSearchField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  /// 构建日期范围选择器
  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '打赏时间',
          style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // 开始时间
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _startDate != null
                              ? DateFormat('yyyy-MM-dd').format(_startDate!)
                              : '开始时间',
                          style: TextStyle(
                            fontSize: 14,
                            color: _startDate != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 连接符
            const Text('到', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            const SizedBox(width: 8),

            // 截止时间
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _endDate != null
                              ? DateFormat('yyyy-MM-dd').format(_endDate!)
                              : '截止时间',
                          style: TextStyle(
                            fontSize: 14,
                            color: _endDate != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建查询按钮
  Widget _buildQueryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' ', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              debugPrint('查询打赏记录');
              debugPrint('会员昵称: ${_memberNameController.text}');
              debugPrint('文章标题: ${_articleTitleController.text}');
              debugPrint('开始时间: $_startDate');
              debugPrint('截止时间: $_endDate');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A9B8E), // 使用系统主题绿色
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
        ),
      ],
    );
  }

  /// 构建导出按钮（可选功能）
  Widget _buildExportButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' ', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              debugPrint('导出Excel');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('导出功能开发中')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF1A9B8E)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 16, color: Color(0xFF1A9B8E)),
                  SizedBox(width: 4),
                  Text(
                    '导出',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A9B8E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 2. 金额统计区
  Widget _buildAmountStatistics() {
    // 计算总金额
    final totalAmount = _rewardRecords.fold<double>(0.0, (sum, record) => sum + (record['amount'] as double));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const Text(
            '金额总计：',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(width: 8),
          Text(
            '¥ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A9B8E),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '元',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const Spacer(),
          Text(
            '共 ${_rewardRecords.length} 条记录',
            style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// 3. 数据表格
  Widget _buildDataTable() {
    if (_rewardRecords.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text(
              '暂无打赏记录',
              style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          ...List.generate(_rewardRecords.length, (index) {
            return _buildTableRow(_rewardRecords[index], index);
          }),
        ],
      ),
    );
  }

  /// 构建表头
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5)),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('订单编号', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 3, child: Text('文章标题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('打赏会员', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('打赏金额', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)), textAlign: TextAlign.right)),
          Expanded(flex: 1, child: Center(child: Text('类型', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329))))),
          Expanded(flex: 2, child: Center(child: Text('支付方式', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329))))),
          Expanded(flex: 2, child: Text('打赏时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> record, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // 斑马纹效果 + 悬停效果
          color: _hoveredIndex == index
              ? const Color(0xFFE6F7FF) // 悬停时浅蓝色
              : (index % 2 == 0 ? Colors.white : const Color(0xFFF9F9F9)), // 偶数行浅灰背景
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
        ),
        child: Row(
          children: [
            // 订单编号
            Expanded(
              flex: 2,
              child: Text(
                record['id'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2329),
                  fontFamily: 'Courier', // 等宽字体显示订单号
                ),
              ),
            ),

            // 文章标题（超长换行）
            Expanded(
              flex: 3,
              child: Text(
                record['articleTitle'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 打赏会员
            Expanded(
              flex: 2,
              child: Text(
                record['memberName'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
            ),

            // 打赏金额（右对齐，保留两位小数）
            Expanded(
              flex: 2,
              child: Text(
                '¥ ${(record['amount'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF4D4F),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // 类型（居中，固定显示"资讯"）
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  record['type'],
                  style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
              ),
            ),

            // 支付方式（居中）
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  record['paymentMethod'],
                  style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
              ),
            ),

            // 打赏时间（右对齐，格式：YYYY-MM-DD HH:mm）
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(record['time']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. 分页器
  Widget _buildPagination() {
    final totalPages = (_rewardRecords.length / _pageSize).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '共 ${_rewardRecords.length} 条记录',
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(width: 16),
          const Text('每页 '),
          Text(
            '$_pageSize',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A9B8E)),
          ),
          const Text(' 条'),
          const SizedBox(width: 16),

          // 上一页按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _currentPage > 1 ? const Color(0xFFD9D9D9) : const Color(0xFFE5E5E5),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '上一页',
                  style: TextStyle(
                    fontSize: 14,
                    color: _currentPage > 1 ? const Color(0xFF1F2329) : const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 页码
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A9B8E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$_currentPage',
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '/ $totalPages',
            style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
          const SizedBox(width: 8),

          // 下一页按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _currentPage < totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _currentPage < totalPages ? const Color(0xFFD9D9D9) : const Color(0xFFE5E5E5),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '下一页',
                  style: TextStyle(
                    fontSize: 14,
                    color: _currentPage < totalPages ? const Color(0xFF1F2329) : const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
