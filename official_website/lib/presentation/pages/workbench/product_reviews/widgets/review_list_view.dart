import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_event.dart';
import 'package:official_website/application/blocs/product_review/product_review_state.dart';
import 'package:official_website/domain/entities/product_review.dart';
import 'package:official_website/presentation/pages/workbench/product_reviews/widgets/review_card.dart';

/// 评价列表视图
class ReviewListView extends StatelessWidget {
  const ReviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductReviewBloc, ProductReviewState>(
      builder: (context, state) {
        if (state is ProductReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductReviewError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('错误: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductReviewBloc>().add(
                          const LoadReviewsEvent(page: 1, pageSize: 10),
                        );
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is ProductReviewLoaded) {
          if (state.reviews.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('暂无评价数据'),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 统计信息
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '共 ${state.totalCount} 条评价',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),

              // 评价列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return ReviewCard(
                      review: review,
                      onApprove: () => _approveReview(context, review.id),
                      onReject: () => _rejectReview(context, review.id),
                      onReply: () => _replyReview(context, review),
                      onDelete: () => _deleteReview(context, review.id),
                    );
                  },
                ),
              ),

              // 分页控制
              _buildPagination(context, state),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPagination(BuildContext context, ProductReviewLoaded state) {
    final totalPages = (state.totalCount / state.pageSize).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.currentPage > 1
                ? () {
                    context.read<ProductReviewBloc>().add(
                          LoadReviewsEvent(
                            page: state.currentPage - 1,
                            pageSize: state.pageSize,
                            productId: state.productId,
                            minRating: state.minRating,
                            maxRating: state.maxRating,
                            status: state.status,
                            hasImages: state.hasImages,
                          ),
                        );
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${state.currentPage} / $totalPages',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.hasMore
                ? () {
                    context.read<ProductReviewBloc>().add(
                          LoadReviewsEvent(
                            page: state.currentPage + 1,
                            pageSize: state.pageSize,
                            productId: state.productId,
                            minRating: state.minRating,
                            maxRating: state.maxRating,
                            status: state.status,
                            hasImages: state.hasImages,
                          ),
                        );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _approveReview(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('审核通过'),
        content: const Text('确定要通过这条评价吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductReviewBloc>().add(
                    ApproveReviewEvent(id),
                  );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _rejectReview(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('拒绝评价'),
        content: const Text('确定要拒绝这条评价吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductReviewBloc>().add(
                    RejectReviewEvent(id),
                  );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _replyReview(BuildContext context, ProductReview review) {
    final controller = TextEditingController(text: review.reply);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('回复评价'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '请输入回复内容',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                context.read<ProductReviewBloc>().add(
                      ReplyReviewEvent(
                        id: review.id,
                        reply: controller.text.trim(),
                      ),
                    );
              }
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  void _deleteReview(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条评价吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductReviewBloc>().add(
                    DeleteReviewEvent(id),
                  );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
