import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'merchant_models.dart';

/// 商户进件进度详情页
/// 包含垂直时间轴、二维码授权等
class MerchantProgressDetailPage extends StatefulWidget {
  final MerchantInfo merchant;

  const MerchantProgressDetailPage({
    super.key,
    required this.merchant,
  });

  @override
  State<MerchantProgressDetailPage> createState() => _MerchantProgressDetailPageState();
}

class _MerchantProgressDetailPageState extends State<MerchantProgressDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A9B8E),
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: Text(
          '${widget.merchant.shortName} - 进件进度',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // 刷新按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // 模拟刷新
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已刷新最新状态')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.refresh, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商户基本信息卡片
            _buildMerchantInfoCard(),

            const SizedBox(height: 24),

            // 进度时间轴
            _buildProgressTimeline(),
          ],
        ),
      ),
    );
  }

  /// 构建商户信息卡片
  Widget _buildMerchantInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：商户名称 + 状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.merchant.subjectType.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.merchant.shortName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.merchant.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge(widget.merchant.status),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF0F0F0)),
          const SizedBox(height: 24),

          // 详细信息
          _buildInfoRow('主体类型', widget.merchant.subjectType.label),
          const SizedBox(height: 12),
          _buildInfoRow('客服电话', widget.merchant.servicePhone),
          const SizedBox(height: 12),
          _buildInfoRow('经营场景', widget.merchant.businessScenes.join('、')),
          const SizedBox(height: 12),
          _buildInfoRow('超级管理员', '${widget.merchant.adminName} (${widget.merchant.adminPhone})'),
          const SizedBox(height: 12),
          _buildInfoRow('提交时间', _formatDateTime(widget.merchant.submitTime!)),
          if (widget.merchant.reviewTime != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow('审核通过时间', _formatDateTime(widget.merchant.reviewTime!)),
          ],
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label：',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建状态标签
  Widget _buildStatusBadge(MerchantStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(status.color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Color(status.color),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 15,
              color: Color(status.color),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建进度时间轴
  Widget _buildProgressTimeline() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '进件进度',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 32),

          // 时间轴
          ...ProgressStep.values.map((step) {
            final isCompleted = widget.merchant.completedSteps.contains(step);
            final isCurrent = widget.merchant.currentStep == step;

            return _buildTimelineItem(
              step: step,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              showQrCode: isCurrent &&
                  (step == ProgressStep.pendingVerification ||
                   step == ProgressStep.pendingContract),
            );
          }),
        ],
      ),
    );
  }

  /// 构建时间轴项
  Widget _buildTimelineItem({
    required ProgressStep step,
    required bool isCompleted,
    required bool isCurrent,
    bool showQrCode = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间轴图标 + 内容
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧：时间轴图标
            _buildTimelineIcon(isCompleted: isCompleted, isCurrent: isCurrent),

            const SizedBox(width: 16),

            // 右侧：内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent
                          ? const Color(0xFF07C160)
                          : const Color(0xFF333333),
                    ),
                  ),
                  if (isCompleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '已完成',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF52C41A),
                        ),
                      ),
                    ),
                  if (isCurrent) ...[
                    const SizedBox(height: 12),
                    _buildCurrentStepAction(step),
                  ],
                  if (showQrCode) ...[
                    const SizedBox(height: 16),
                    _buildQrCodeSection(step),
                  ],
                ],
              ),
            ),
          ],
        ),

        // 下一个节点之间的连接线
        if (step != ProgressStep.completed)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              width: 2,
              height: 40,
              color: isCompleted ? const Color(0xFF07C160) : const Color(0xFFE8E8E8),
            ),
          ),
      ],
    );
  }

  /// 构建时间轴图标
  Widget _buildTimelineIcon({required bool isCompleted, required bool isCurrent}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF07C160)
            : isCompleted
                ? const Color(0xFF52C41A)
                : const Color(0xFFE8E8E8),
        shape: BoxShape.circle,
        border: isCurrent
            ? Border.all(color: const Color(0xFF07C160), width: 3)
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : isCurrent
                ? Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  /// 构建当前步骤操作提示
  Widget _buildCurrentStepAction(ProgressStep step) {
    String message = '';
    Color color = const Color(0xFF1890FF);

    switch (step) {
      case ProgressStep.pendingVerification:
        message = '请超级管理员使用微信扫描下方二维码，完成账户验证';
        break;
      case ProgressStep.pendingContract:
        message = '请超级管理员使用微信扫描下方二维码，完成签约';
        color = const Color(0xFFFF7A45);
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: color,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建二维码区域
  Widget _buildQrCodeSection(ProgressStep step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 二维码
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: QrImageView(
              data: widget.merchant.authUrl ?? 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=mock',
              version: QrVersions.auto,
              size: 180.0,
            ),
          ),
          const SizedBox(height: 12),

          // 操作提示
          const Text(
            '请使用微信扫描上方二维码',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),

          // 刷新二维码按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // 模拟刷新二维码
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('二维码已刷新')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1890FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '刷新二维码',
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

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
