import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 付费会员列表内容组件
class PaidMembersContent extends StatefulWidget {
  const PaidMembersContent({super.key});

  @override
  State<PaidMembersContent> createState() => _PaidMembersContentState();
}

class _PaidMembersContentState extends State<PaidMembersContent> {
  // 会员列表数据
  final List<Map<String, dynamic>> _members = [
    {
      'id': '1',
      'avatar': 'https://via.placeholder.com/40',
      'nickname': '张三',
      'type': '年卡',
      'expiryDate': DateTime(2027, 3, 8),
      'status': '未到期',
      'purchaseDate': DateTime(2026, 3, 8, 10, 30),
    },
    {
      'id': '2',
      'avatar': 'https://via.placeholder.com/40',
      'nickname': '李四',
      'type': '月卡',
      'expiryDate': DateTime(2026, 4, 15),
      'status': '未到期',
      'purchaseDate': DateTime(2026, 3, 15, 14, 20),
    },
    {
      'id': '3',
      'avatar': 'https://via.placeholder.com/40',
      'nickname': '王五',
      'type': '日卡',
      'expiryDate': DateTime(2026, 3, 5),
      'status': '已到期',
      'purchaseDate': DateTime(2026, 3, 4, 9, 15),
    },
    {
      'id': '4',
      'avatar': 'https://via.placeholder.com/40',
      'nickname': '赵六',
      'type': '年卡',
      'expiryDate': DateTime(2027, 1, 20),
      'status': '未到期',
      'purchaseDate': DateTime(2026, 1, 20, 16, 45),
    },
    {
      'id': '5',
      'avatar': 'https://via.placeholder.com/40',
      'nickname': '孙七',
      'type': '月卡',
      'expiryDate': DateTime(2026, 2, 10),
      'status': '已到期',
      'purchaseDate': DateTime(2026, 1, 10, 11, 30),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // 计算统计数据
    final totalCount = _members.length;
    final activeCount = _members.where((m) => m['status'] == '未到期').length;
    final expiredCount = _members.where((m) => m['status'] == '已到期').length;

    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 统计卡片
            _buildStatisticsCards(totalCount, activeCount, expiredCount),

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
  Widget _buildStatisticsCards(int totalCount, int activeCount, int expiredCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('会员总数', totalCount, const Color(0xFF1A9B8E)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('未到期会员', activeCount, const Color(0xFF52C41A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard('已到期会员', expiredCount, const Color(0xFFFF4D4F)),
          ),
        ],
      ),
    );
  }

  /// 构建单个统计卡片
  Widget _buildStatCard(String title, int value, Color color) {
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
            '$value',
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
    if (_members.isEmpty) {
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
            Text('暂无会员记录', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
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
          ...List.generate(_members.length, (index) {
            return _buildTableRow(_members[index], index);
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
          SizedBox(width: 60, child: Text('会员头像', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('会员昵称', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('类型', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('到期时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('会员状态', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 3, child: Text('购买时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> member, int index) {
    final bool isExpired = member['status'] == '已到期';

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
            // 会员头像
            SizedBox(
              width: 60,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(member['avatar']),
                onBackgroundImageError: (exception, stackTrace) {},
                child: member['avatar'].isEmpty
                    ? const Text('?', style: TextStyle(fontSize: 20, color: Color(0xFF999999)))
                    : null,
              ),
            ),

            // 会员昵称
            Expanded(
              flex: 2,
              child: Text(
                member['nickname'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
            ),

            // 类型
            Expanded(
              flex: 2,
              child: Text(
                member['type'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 到期时间
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('yyyy-MM-dd').format(member['expiryDate']),
                style: TextStyle(
                  fontSize: 14,
                  color: isExpired ? const Color(0xFF999999) : const Color(0xFF1F2329),
                ),
              ),
            ),

            // 会员状态
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExpired ? const Color(0xFFFFF7D9) : const Color(0xFFE6F7FF),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isExpired ? const Color(0xFFFFD666) : const Color(0xFF91D5FF),
                    width: 1,
                  ),
                ),
                child: Text(
                  member['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isExpired ? const Color(0xFFFF8800) : const Color(0xFF1890FF),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // 购买时间
            Expanded(
              flex: 3,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(member['purchaseDate']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
