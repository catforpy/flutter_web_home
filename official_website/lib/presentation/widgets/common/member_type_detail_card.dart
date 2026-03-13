import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:official_website/domain/entities/member_type_entity.dart';

/// 会员类型详情卡片组件
///
/// 这是一个可复用的详情展示组件，用于展示会员类型的完整信息
/// 可以在弹窗、页面、侧边栏等多种场景使用
class MemberTypeDetailCard extends StatelessWidget {
  /// 会员类型数据
  final MemberTypeEntity memberType;

  /// 是否显示操作按钮
  final bool showActions;

  /// 编辑回调
  final VoidCallback? onEdit;

  /// 删除回调
  final VoidCallback? onDelete;

  /// 启用/禁用回调
  final VoidCallback? onToggleEnabled;

  /// 购买记录回调
  final VoidCallback? onViewPurchaseRecords;

  const MemberTypeDetailCard({
    super.key,
    required this.memberType,
    this.showActions = true,
    this.onEdit,
    this.onDelete,
    this.onToggleEnabled,
    this.onViewPurchaseRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部封面区
          _buildCoverSection(context),

          // 基本信息区
          _buildBasicInfoSection(context),

          // 权益说明区
          if (memberType.benefits.isNotEmpty)
            _buildBenefitsSection(context),

          // 统计数据区
          _buildStatisticsSection(context),

          // 操作按钮区
          if (showActions) _buildActionsSection(context),
        ],
      ),
    );
  }

  /// 构建封面区域
  Widget _buildCoverSection(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A9B8E),
            const Color(0xFF1A9B8E).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          // 背景装饰
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          // 内容
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 类型标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      memberType.type.displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 标题
                  Text(
                    memberType.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 价格
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        memberType.priceText,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '/ ${memberType.durationText}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 状态标签
          Positioned(
            top: 16,
            right: 16,
            child: _buildStatusChip(),
          ),
        ],
      ),
    );
  }

  /// 构建状态标签
  Widget _buildStatusChip() {
    final isEnabled = memberType.isEnabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isEnabled
            ? const Color(0xFF52C41A).withValues(alpha: 0.1)
            : const Color(0xFFFF4D4F).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled ? const Color(0xFF52C41A) : const Color(0xFFFF4D4F),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isEnabled ? const Color(0xFF52C41A) : const Color(0xFFFF4D4F),
          ),
          const SizedBox(width: 4),
          Text(
            isEnabled ? '已上架' : '已下架',
            style: TextStyle(
              fontSize: 12,
              color: isEnabled ? const Color(0xFF52C41A) : const Color(0xFFFF4D4F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建基本信息区
  Widget _buildBasicInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '基本信息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2329),
            ),
          ),
          const SizedBox(height: 20),

          // 信息网格
          _buildInfoGrid(),
        ],
      ),
    );
  }

  /// 构建信息网格
  Widget _buildInfoGrid() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 描述
          if (memberType.description != null &&
              memberType.description!.isNotEmpty)
            _buildInfoRow(
              '描述说明',
              memberType.description!,
              const Icon(Icons.description_outlined, size: 18),
            ),
          if (memberType.description != null &&
              memberType.description!.isNotEmpty)
            const SizedBox(height: 16),

          const Divider(height: 1),
          const SizedBox(height: 16),

          // 创建时间
          _buildInfoRow(
            '创建时间',
            DateFormat('yyyy-MM-dd HH:mm').format(memberType.createTime),
            const Icon(Icons.access_time, size: 18),
          ),
          const SizedBox(height: 16),

          // 排序序号
          _buildInfoRow(
            '排序序号',
            '${memberType.sortOrder}',
            const Icon(Icons.sort, size: 18),
          ),
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value, Icon icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Icon(
            icon.icon,
            size: icon.size,
            color: const Color(0xFF1A9B8E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF86909C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F2329),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建权益说明区
  Widget _buildBenefitsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '会员权益',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2329),
            ),
          ),
          const SizedBox(height: 20),

          // 权益列表
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD666),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: const Color(0xFFFF8800),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '购买此会员类型，用户可享受以下权益：',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF8800),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...memberType.benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: const Icon(
                              Icons.check_circle,
                              color: Color(0xFF52C41A),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2329),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计数据区
  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '数据统计',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2329),
            ),
          ),
          const SizedBox(height: 20),

          // 统计卡片
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatCard(
                    '购买人数',
                    '${memberType.purchaseCount}',
                    '人',
                    Icons.people_outline,
                    const Color(0xFF1890FF),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    '总收入',
                    '¥${memberType.totalRevenue.toStringAsFixed(2)}',
                    '',
                    Icons.payments_outlined,
                    const Color(0xFF52C41A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF86909C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (unit.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮区
  Widget _buildActionsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              '查看购买记录',
              Icons.list_alt,
              const Color(0xFF1890FF),
              () {
                if (onViewPurchaseRecords != null) {
                  onViewPurchaseRecords!();
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              memberType.isEnabled ? '下架' : '上架',
              memberType.isEnabled ? Icons.block : Icons.check_circle,
              memberType.isEnabled ? const Color(0xFFFF4D4F) : const Color(0xFF52C41A),
              () {
                if (onToggleEnabled != null) {
                  onToggleEnabled!();
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              '编辑',
              Icons.edit_outlined,
              const Color(0xFF1A9B8E),
              () {
                if (onEdit != null) {
                  onEdit!();
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              '删除',
              Icons.delete_outline,
              const Color(0xFF999999),
              () {
                if (onDelete != null) {
                  onDelete!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
