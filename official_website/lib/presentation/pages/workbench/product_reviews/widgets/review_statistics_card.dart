import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_event.dart';
import 'package:official_website/application/blocs/product_review/product_review_state.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 评价统计卡片
class ReviewStatisticsCard extends StatelessWidget {
  const ReviewStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReviewBloc, ProductReviewState>(
      builder: (context, state) {
        final statistics = state is ProductReviewLoaded
            ? state.statistics
            : null;

        if (statistics == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 总体评分
              Row(
                children: [
                  Text(
                    '平均评分',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statistics.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 评价分布
              _buildRatingDistribution(context, statistics),

              const SizedBox(height: 16),

              // 统计信息
              _buildStatisticsInfo(context, statistics),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingDistribution(
    BuildContext context,
    ReviewStatistics statistics,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '评分分布',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (index) {
          final stars = 5 - index;
          final count = statistics.getStarCount(stars);
          final percentage = statistics.getStarPercentage(stars);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // 星级
                SizedBox(
                  width: 60,
                  child: Row(
                    children: List.generate(
                      stars,
                      (i) => const Icon(Icons.star, size: 14, color: Colors.amber),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 进度条
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 数量
                SizedBox(
                  width: 40,
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatisticsInfo(
    BuildContext context,
    ReviewStatistics statistics,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildInfoChip(context, Icons.reviews, '总评价', statistics.totalCount),
        _buildInfoChip(
          context,
          Icons.pending,
          '待审核',
          statistics.pendingCount,
          color: Colors.orange,
        ),
        _buildInfoChip(context, Icons.star, '5星评价', statistics.fiveStarCount),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    int value, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey[200])!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
