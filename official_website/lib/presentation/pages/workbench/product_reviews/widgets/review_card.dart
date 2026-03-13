import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 评价卡片组件
class ReviewCard extends StatelessWidget {
  final ProductReview review;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onReply;
  final VoidCallback onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onApprove,
    required this.onReject,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：用户信息和评分
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFF5F5F5),
                  backgroundImage: review.userAvatar.isNotEmpty
                      ? NetworkImage(review.userAvatar)
                      : null,
                  child: review.userAvatar.isEmpty
                      ? const Icon(Icons.person, size: 24)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        review.productName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        review.rating,
                        (index) => const Icon(Icons.star,
                            size: 16, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 评价内容
            Text(
              review.content,
              style: const TextStyle(fontSize: 14),
            ),

            // 评价图片
            if (review.images.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // 商家回复
            if (review.hasReply) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '商家回复',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.reply!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // 底部操作栏
            Row(
              children: [
                Text(
                  _formatDate(review.createTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                if (review.status == ReviewStatus.pending)
                  TextButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('通过', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                if (review.status == ReviewStatus.pending)
                  TextButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel, size: 18),
                    label: const Text('拒绝', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                TextButton.icon(
                  onPressed: onReply,
                  icon: const Icon(Icons.reply, size: 18),
                  label: const Text('回复', style: TextStyle(fontSize: 12)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete,
                  tooltip: '删除',
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    String label;

    switch (review.status) {
      case ReviewStatus.pending:
        backgroundColor = Colors.orange;
        label = '待审核';
        break;
      case ReviewStatus.approved:
        backgroundColor = Colors.green;
        label = '已通过';
        break;
      case ReviewStatus.rejected:
        backgroundColor = Colors.red;
        label = '已拒绝';
        break;
      case ReviewStatus.deleted:
        backgroundColor = Colors.grey;
        label = '已删除';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}天前';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
