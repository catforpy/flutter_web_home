import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 文章付费记录内容组件
class ArticlePaymentRecordsContent extends StatefulWidget {
  const ArticlePaymentRecordsContent({super.key});

  @override
  State<ArticlePaymentRecordsContent> createState() => _ArticlePaymentRecordsContentState();
}

class _ArticlePaymentRecordsContentState extends State<ArticlePaymentRecordsContent> {
  // 搜索筛选条件
  final TextEditingController _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // 付费记录列表数据
  final List<Map<String, dynamic>> _paymentRecords = [
    {
      'id': '1',
      'articleTitle': '论抖音视频对生活的影响',
      'userName': '张三',
      'amount': 9.9,
      'paymentTime': DateTime(2026, 3, 8, 14, 30),
    },
    {
      'id': '2',
      'articleTitle': '如何高效学习编程',
      'userName': '李四',
      'amount': 19.9,
      'paymentTime': DateTime(2026, 3, 7, 10, 15),
    },
    {
      'id': '3',
      'articleTitle': 'Flutter 开发实战指南',
      'userName': '王五',
      'amount': 29.9,
      'paymentTime': DateTime(2026, 3, 6, 16, 45),
    },
    {
      'id': '4',
      'articleTitle': 'Web 前端架构设计思路',
      'userName': '赵六',
      'amount': 9.9,
      'paymentTime': DateTime(2026, 3, 5, 9, 20),
    },
    {
      'id': '5',
      'articleTitle': '2024年行业发展趋势分析',
      'userName': '孙七',
      'amount': 19.9,
      'paymentTime': DateTime(2026, 3, 4, 11, 50),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  @override
  void dispose() {
    _titleController.dispose();
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

            // 搜索筛选区
            _buildSearchFilterBar(),

            const SizedBox(height: 16),

            // 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 构建搜索筛选栏
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
          // 文章标题搜索
          Expanded(
            flex: 3,
            child: _buildSearchField('文章标题', '请输入文章标题', _titleController),
          ),
          const SizedBox(width: 12),

          // 支付时间范围
          Expanded(flex: 4, child: _buildDateRangePicker()),
          const SizedBox(width: 12),

          // 查询按钮
          _buildQueryButton(),
        ],
      ),
    );
  }

  /// 构建搜索输入框
  Widget _buildSearchField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
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
        const Text('支付时间', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
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
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2027),
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
                          _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '开始时间',
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
            const Text('到', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            const SizedBox(width: 8),
            // 截止时间
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2027),
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
                          _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '截止时间',
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
              debugPrint('查询文章付费记录');
              debugPrint('文章标题: ${_titleController.text}');
              debugPrint('开始时间: $_startDate');
              debugPrint('截止时间: $_endDate');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A9B8E),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '查询',
                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建数据表格
  Widget _buildDataTable() {
    if (_paymentRecords.isEmpty) {
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
            Text('暂无付费记录', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
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
          ...List.generate(_paymentRecords.length, (index) {
            return _buildTableRow(_paymentRecords[index], index);
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
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('文章标题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('用户昵称', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('支付金额', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 3, child: Text('支付时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
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
          color: _hoveredIndex == index
              ? const Color(0xFFE6F7FF)
              : (index % 2 == 0 ? Colors.white : const Color(0xFFF9F9F9)),
          border: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
        ),
        child: Row(
          children: [
            // 文章标题
            Expanded(
              flex: 3,
              child: Text(
                record['articleTitle'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
            ),

            // 用户昵称
            Expanded(
              flex: 2,
              child: Text(
                record['userName'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 支付金额
            Expanded(
              flex: 2,
              child: Text(
                '¥ ${(record['amount'] as double).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Color(0xFFFF4D4F), fontWeight: FontWeight.w500),
              ),
            ),

            // 支付时间
            Expanded(
              flex: 3,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(record['paymentTime']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
