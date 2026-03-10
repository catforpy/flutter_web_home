import 'package:flutter/material.dart';
import 'merchant_models.dart';

/// 进件工作台顶部状态概览区
class PaymentConfigDashboard extends StatelessWidget {
  final MerchantStatistics statistics;
  final VoidCallback onAddMerchant;

  const PaymentConfigDashboard({
    super.key,
    required this.statistics,
    required this.onAddMerchant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '特约商户进件管理',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '管理您的特约商户进件流程，跟踪审核进度',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              // 新增商户按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onAddMerchant,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF07C160), Color(0xFF06AD56)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF07C160).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '新增商户进件',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 统计卡片行
          Row(
            children: [
              Expanded(child: _buildStatCard('进件总数', statistics.totalInProgress.toString(), Icons.folder_open, 0xFF1890FF)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  '待验证',
                  statistics.pendingVerification.toString(),
                  Icons.verified_user,
                  0xFF1890FF,
                  showBadge: statistics.pendingVerification > 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  '待签约',
                  statistics.pendingContract.toString(),
                  Icons.description,
                  0xFFFF7A45,
                  showBadge: statistics.pendingContract > 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('今日完成', statistics.completedToday.toString(), Icons.check_circle, 0xFF52C41A)),
            ],
          ),

          // 待办提醒
          if (statistics.pendingVerification > 0 || statistics.pendingContract > 0)
            _buildTodoReminder(),
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatCard(String label, String value, IconData icon, int color, {bool showBadge = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 24,
              color: Color(color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(color),
                  ),
                ),
                const SizedBox(height: 4),
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
          if (showBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '待办',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建待办提醒
  Widget _buildTodoReminder() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFD591),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active,
            size: 24,
            color: Color(0xFFFF9800),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getReminderText(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFE67300),
                height: 1.5,
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '立即处理',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取提醒文案
  String _getReminderText() {
    final parts = <String>[];
    if (statistics.pendingVerification > 0) {
      parts.add('🔴 ${statistics.pendingVerification} 个商户等待您扫码验证');
    }
    if (statistics.pendingContract > 0) {
      parts.add('🟠 ${statistics.pendingContract} 个商户等待超管签约');
    }
    return parts.join('，请尽快处理，以免超时驳回。');
  }
}
