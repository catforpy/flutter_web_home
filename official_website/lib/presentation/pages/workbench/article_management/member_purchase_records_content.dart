import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 会员购买记录内容组件
class MemberPurchaseRecordsContent extends StatefulWidget {
  const MemberPurchaseRecordsContent({super.key});

  @override
  State<MemberPurchaseRecordsContent> createState() => _MemberPurchaseRecordsContentState();
}

class _MemberPurchaseRecordsContentState extends State<MemberPurchaseRecordsContent> {
  // 购买记录列表数据
  final List<Map<String, dynamic>> _purchaseRecords = [
    {
      'id': '1',
      'memberTitle': '年卡',
      'userName': '张三',
      'amount': 999.0,
      'paymentTime': DateTime(2026, 3, 8, 14, 30),
    },
    {
      'id': '2',
      'memberTitle': '月卡',
      'userName': '李四',
      'amount': 99.0,
      'paymentTime': DateTime(2026, 3, 7, 10, 15),
    },
    {
      'id': '3',
      'memberTitle': '日卡',
      'userName': '王五',
      'amount': 9.9,
      'paymentTime': DateTime(2026, 3, 6, 16, 45),
    },
    {
      'id': '4',
      'memberTitle': '年卡',
      'userName': '赵六',
      'amount': 999.0,
      'paymentTime': DateTime(2026, 3, 5, 9, 20),
    },
    {
      'id': '5',
      'memberTitle': '月卡',
      'userName': '孙七',
      'amount': 99.0,
      'paymentTime': DateTime(2026, 3, 4, 11, 50),
    },
    {
      'id': '6',
      'memberTitle': '年卡',
      'userName': '周八',
      'amount': 999.0,
      'paymentTime': DateTime(2026, 3, 3, 15, 30),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // 计算统计数据
    final totalIncome = _purchaseRecords.fold<double>(0.0, (sum, record) => sum + (record['amount'] as double));
    final totalCount = _purchaseRecords.length;

    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 统计卡片
            _buildStatisticsCards(totalIncome, totalCount),

            const SizedBox(height: 16),

            // 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatisticsCards(double totalIncome, int totalCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('总收入金额', '¥ ${totalIncome.toStringAsFixed(2)}', const Color(0xFF1A9B8E)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('购买总次数', '$totalCount次', const Color(0xFFFF6B35)),
          ),
        ],
      ),
    );
  }

  /// 构建单个统计卡片
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建数据表格
  Widget _buildDataTable() {
    if (_purchaseRecords.isEmpty) {
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
            Text('暂无购买记录', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
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
          ...List.generate(_purchaseRecords.length, (index) {
            return _buildTableRow(_purchaseRecords[index], index);
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
          Expanded(flex: 2, child: Text('会员标题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
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
            // 会员标题
            Expanded(
              flex: 2,
              child: Text(
                record['memberTitle'],
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
