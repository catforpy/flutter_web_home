import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'merchant_models.dart';
import 'merchant_progress_detail.dart';

/// 商户列表视图（卡片式布局）
class MerchantListView extends StatelessWidget {
  final List<MerchantInfo> merchants;
  final Future<void> Function() onRefresh;

  const MerchantListView({
    super.key,
    required this.merchants,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (merchants.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: merchants.length,
        itemBuilder: (context, index) {
          return _buildMerchantCard(context, merchants[index]);
        },
      ),
    );
  }

  /// 构建商户卡片
  Widget _buildMerchantCard(BuildContext context, MerchantInfo merchant) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部：商户名称 + 状态标签
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      merchant.subjectType.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        merchant.shortName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(merchant.status),
            ],
          ),

          const SizedBox(height: 16),

          // 中间：主体类型 + 时间信息
          Row(
            children: [
              const Icon(
                Icons.business,
                size: 16,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 6),
              Text(
                merchant.subjectType.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time,
                size: 16,
                color: Color(0xFF999999),
              ),
              const SizedBox(width: 6),
              Text(
                _formatTime(merchant.submitTime!),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 底部：操作按钮
          Row(
            children: [
              // 查看详情
              Expanded(
                child: _buildActionButton(
                  context,
                  label: '查看详情',
                  icon: Icons.visibility,
                  color: 0xFF1890FF,
                  onTap: () => _showDetailPage(context, merchant),
                ),
              ),
              const SizedBox(width: 8),

              // 条件按钮 - 已驳回
              if (merchant.status == MerchantStatus.rejected)
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '上传资料',
                    icon: Icons.upload_file,
                    color: 0xFFFF7A45,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('上传补充资料功能开发中...')),
                      );
                    },
                  ),
                ),

              // 条件按钮 - 待验证/待签约
              if (merchant.status == MerchantStatus.pendingVerification ||
                  merchant.status == MerchantStatus.pendingContract)
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: '获取授权码',
                    icon: Icons.qr_code_2,
                    color: 0xFF07C160,
                    onTap: () => _showAuthQrCode(context, merchant),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建状态标签
  Widget _buildStatusBadge(MerchantStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(status.color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.icon,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 13,
              color: Color(status.color),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required int color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Color(color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: Color(color),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(color),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示详情页
  void _showDetailPage(BuildContext context, MerchantInfo merchant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MerchantProgressDetailPage(merchant: merchant),
      ),
    );
  }

  /// 显示授权二维码
  void _showAuthQrCode(BuildContext context, MerchantInfo merchant) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '扫码授权',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 二维码
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QrImageView(
                  data: merchant.authUrl ?? 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=mock',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 16),

              // 提示文案
              Text(
                merchant.status == MerchantStatus.pendingVerification
                    ? '请超级管理员使用微信扫描上方二维码，完成账户验证'
                    : '请超级管理员使用微信扫描上方二维码，完成签约',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 关闭按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '关闭',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            '暂无商户数据',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '点击上方"新增商户进件"按钮开始',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFCCCCCC),
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}天前';
    } else {
      return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
    }
  }
}
