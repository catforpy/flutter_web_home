import 'package:flutter/material.dart';

/// 评价状态
enum ReviewStatus {
  all('全部评价', Colors.grey),
  pending('待审核', Color(0xFFFF9800)),
  displayed('已显示', Color(0xFF4CAF50)),
  hidden('已隐藏', Color(0xFF9E9E9E));

  final String label;
  final Color color;

  const ReviewStatus(this.label, this.color);
}

/// 商品评价模型
class ProductReview {
  final String id;
  final String productName; // 商品名称
  final String? productImage; // 商品图片
  final String userName; // 评价用户
  final String? userAvatar; // 用户头像
  final int rating; // 评分 1-5
  final String content; // 评价内容
  final List<String> images; // 评价图片
  final DateTime createTime; // 评价时间
  final ReviewStatus status; // 审核状态
  final String? reply; // 商家回复
  final DateTime? replyTime; // 回复时间
  final int likes; // 点赞数

  ProductReview({
    required this.id,
    required this.productName,
    this.productImage,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.content,
    required this.images,
    required this.createTime,
    required this.status,
    this.reply,
    this.replyTime,
    this.likes = 0,
  });
}

/// 商品评价管理页面
class ProductReviewsPage extends StatefulWidget {
  const ProductReviewsPage({super.key});

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  // 当前选中的筛选状态
  ReviewStatus _selectedStatus = ReviewStatus.all;

  // 评分筛选
  int? _selectedRating;

  // 搜索关键词
  String _searchKeyword = '';

  // 模拟评价数据
  final List<ProductReview> _reviews = [
    ProductReview(
      id: 'r001',
      productName: '时尚纯棉T恤',
      productImage: '',
      userName: '张三',
      rating: 5,
      content: '质量很好，穿着舒适，物流也很快，下次还会购买！',
      images: [],
      createTime: DateTime(2026, 3, 10, 10, 30),
      status: ReviewStatus.displayed,
      reply: '感谢您的评价，我们会继续努力提供优质的产品和服务！',
      replyTime: DateTime(2026, 3, 10, 14, 20),
      likes: 12,
    ),
    ProductReview(
      id: 'r002',
      productName: '休闲牛仔裤',
      productImage: '',
      userName: '李四',
      rating: 4,
      content: '裤子款式不错，就是尺码稍微偏大了一点，总体还是满意的。',
      images: ['image1.jpg'],
      createTime: DateTime(2026, 3, 9, 15, 20),
      status: ReviewStatus.displayed,
      likes: 8,
    ),
    ProductReview(
      id: 'r003',
      productName: '连衣裙 夏季新款',
      productImage: '',
      userName: '王五',
      rating: 5,
      content: '裙子很漂亮，面料柔软透气，穿上很显气质，强烈推荐！',
      images: ['image1.jpg', 'image2.jpg'],
      createTime: DateTime(2026, 3, 8, 9, 15),
      status: ReviewStatus.pending,
      likes: 15,
    ),
    ProductReview(
      id: 'r004',
      productName: '智能手机 iPhone 15',
      productImage: '',
      userName: '赵六',
      rating: 5,
      content: '手机收到了，正品无疑，用起来很流畅，物流也很快，满分！',
      images: [],
      createTime: DateTime(2026, 3, 7, 16, 45),
      status: ReviewStatus.displayed,
      reply: '感谢您的支持！',
      replyTime: DateTime(2026, 3, 7, 18, 00),
      likes: 23,
    ),
    ProductReview(
      id: 'r005',
      productName: '护肤套装 补水保湿',
      productImage: '',
      userName: '孙七',
      rating: 3,
      content: '效果还行，但是发货有点慢，包装也不是很好。',
      images: [],
      createTime: DateTime(2026, 3, 6, 11, 30),
      status: ReviewStatus.pending,
      likes: 3,
    ),
    ProductReview(
      id: 'r006',
      productName: '笔记本电脑 华为MateBook',
      productImage: '',
      userName: '周八',
      rating: 4,
      content: '电脑性能不错，就是价格稍微有点贵，整体还是满意的。',
      images: [],
      createTime: DateTime(2026, 3, 5, 14, 20),
      status: ReviewStatus.displayed,
      likes: 6,
    ),
  ];

  /// 获取筛选后的评价列表
  List<ProductReview> get _filteredReviews {
    var filtered = List<ProductReview>.from(_reviews);

    // 按状态筛选
    if (_selectedStatus != ReviewStatus.all) {
      filtered = filtered.where((review) => review.status == _selectedStatus).toList();
    }

    // 按评分筛选
    if (_selectedRating != null) {
      filtered = filtered.where((review) => review.rating == _selectedRating).toList();
    }

    // 按关键词搜索
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      filtered = filtered.where((review) {
        return review.productName.toLowerCase().contains(keyword) ||
               review.content.toLowerCase().contains(keyword) ||
               review.userName.toLowerCase().contains(keyword);
      }).toList();
    }

    // 按时间倒序
    filtered.sort((a, b) => b.createTime.compareTo(a.createTime));

    return filtered;
  }

  /// 获取各状态评价数量
  Map<ReviewStatus, int> get _statusCounts {
    final counts = <ReviewStatus, int>{};
    for (final status in ReviewStatus.values) {
      if (status == ReviewStatus.all) {
        counts[status] = _reviews.length;
      } else {
        counts[status] = _reviews.where((review) => review.status == status).length;
      }
    }
    return counts;
  }

  /// 获取平均评分
  double get _averageRating {
    if (_reviews.isEmpty) return 0.0;
    final total = _reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / _reviews.length;
  }

  /// 获取评价统计
  Map<int, int> get _ratingStats {
    final stats = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in _reviews) {
      stats[review.rating] = (stats[review.rating] ?? 0) + 1;
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: Column(
        children: [
          // 顶部操作栏
          _buildTopBar(),

          // 评价统计卡片
          _buildStatsCard(),

          // 状态筛选
          _buildStatusFilter(),

          // 评价列表
          Expanded(
            child: _buildReviewList(),
          ),
        ],
      ),
    );
  }

  /// 构建顶部操作栏
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // 标题
          const Text(
            '商品评价',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          // 评分筛选
          Row(
            children: [
              const Text(
                '评分：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildRatingChip('全部', null),
              const SizedBox(width: 8),
              _buildRatingChip('5星', 5),
              const SizedBox(width: 8),
              _buildRatingChip('4星', 4),
              const SizedBox(width: 8),
              _buildRatingChip('3星', 3),
              const SizedBox(width: 8),
              _buildRatingChip('2星', 2),
              const SizedBox(width: 8),
              _buildRatingChip('1星', 1),
            ],
          ),

          const SizedBox(width: 24),

          // 搜索框
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索商品或评价内容',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchKeyword = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建评分筛选芯片
  Widget _buildRatingChip(String label, int? rating) {
    final isSelected = _selectedRating == rating;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRating = isSelected ? null : rating;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (rating != null) ...[
                const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建评价统计卡片
  Widget _buildStatsCard() {
    final avgRating = _averageRating;
    final ratingStats = _ratingStats;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // 左侧：总评分
          Container(
            width: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        i < avgRating.floor() ? Icons.star : Icons.star_border,
                        size: 18,
                        color: const Color(0xFFFFC107),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '共 ${_reviews.length} 条评价',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // 分隔线
          Container(
            height: 80,
            width: 1,
            color: const Color(0xFFE0E0E0),
          ),

          const SizedBox(width: 40),

          // 右侧：评分分布
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '评分分布',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                for (int star = 5; star >= 1; star--)
                  _buildRatingBar(star, ratingStats[star] ?? 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建评分条
  Widget _buildRatingBar(int star, int count) {
    final percentage = _reviews.isEmpty ? 0.0 : count / _reviews.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$star星',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建状态筛选
  Widget _buildStatusFilter() {
    final counts = _statusCounts;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ReviewStatus.values.map((status) {
            final isSelected = _selectedStatus == status;
            final count = counts[status] ?? 0;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? status.color : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? status.color : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.3)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建评价列表
  Widget _buildReviewList() {
    final reviews = _filteredReviews;

    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 80,
              color: const Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无评价数据',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildReviewCard(reviews[index]);
      },
    );
  }

  /// 构建评价卡片
  Widget _buildReviewCard(ProductReview review) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部：商品信息 + 状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: review.productImage != null && review.productImage!.isNotEmpty
                        ? Image.network(
                            review.productImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shopping_bag,
                                size: 30,
                                color: Color(0xFFCCCCCC),
                              );
                            },
                          )
                        : const Icon(
                            Icons.shopping_bag,
                            size: 30,
                            color: Color(0xFFCCCCCC),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.productName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              i < review.rating ? Icons.star : Icons.star_border,
                              size: 16,
                              color: const Color(0xFFFFC107),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDateTime(review.createTime),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // 状态标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: review.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  review.status.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: review.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 用户信息和评价内容
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 用户头像
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF5F5F5),
                child: review.userAvatar != null && review.userAvatar!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          review.userAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 24,
                              color: Color(0xFF999999),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 24,
                        color: Color(0xFF999999),
                      ),
              ),

              const SizedBox(width: 12),

              // 评价内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),

                    // 评价图片
                    if (review.images.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: review.images.map((image) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: const Icon(
                              Icons.image,
                              size: 32,
                              color: Color(0xFFCCCCCC),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // 底部操作栏
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 16,
                          color: const Color(0xFF999999),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${review.likes}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF999999),
                          ),
                        ),
                        const Spacer(),
                        _buildActionChip('回复', () => _replyToReview(review)),
                        const SizedBox(width: 8),
                        _buildActionChip(
                          review.status == ReviewStatus.pending ? '通过审核' : '隐藏',
                          () => _changeReviewStatus(review),
                        ),
                        const SizedBox(width: 8),
                        _buildActionChip('删除', () => _deleteReview(review), isDanger: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 商家回复
          if (review.reply != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        size: 16,
                        color: Color(0xFF1A9B8E),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '商家回复',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A9B8E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDateTime(review.replyTime!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.reply!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建操作芯片
  Widget _buildActionChip(String label, VoidCallback onTap, {bool isDanger = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDanger ? const Color(0xFFFF4D4F) : const Color(0xFF2196F3),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDanger ? const Color(0xFFFF4D4F) : const Color(0xFF2196F3),
            ),
          ),
        ),
      ),
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// 回复评价
  void _replyToReview(ProductReview review) {
    final controller = TextEditingController();
    if (review.reply != null) {
      controller.text = review.reply!;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('回复评价'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '回复内容',
              hintText: '请输入回复内容',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  setState(() {
                    final index = _reviews.indexWhere((r) => r.id == review.id);
                    if (index != -1) {
                      _reviews[index] = ProductReview(
                        id: review.id,
                        productName: review.productName,
                        productImage: review.productImage,
                        userName: review.userName,
                        userAvatar: review.userAvatar,
                        rating: review.rating,
                        content: review.content,
                        images: review.images,
                        createTime: review.createTime,
                        status: review.status,
                        reply: controller.text.trim(),
                        replyTime: DateTime.now(),
                        likes: review.likes,
                      );
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('回复成功')),
                  );
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 改变评价状态
  void _changeReviewStatus(ProductReview review) {
    final newStatus = review.status == ReviewStatus.pending
        ? ReviewStatus.displayed
        : ReviewStatus.hidden;

    setState(() {
      final index = _reviews.indexWhere((r) => r.id == review.id);
      if (index != -1) {
        _reviews[index] = ProductReview(
          id: review.id,
          productName: review.productName,
          productImage: review.productImage,
          userName: review.userName,
          userAvatar: review.userAvatar,
          rating: review.rating,
          content: review.content,
          images: review.images,
          createTime: review.createTime,
          status: newStatus,
          reply: review.reply,
          replyTime: review.replyTime,
          likes: review.likes,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(newStatus == ReviewStatus.displayed ? '评价已显示' : '评价已隐藏')),
    );
  }

  /// 删除评价
  void _deleteReview(ProductReview review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除该评价吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _reviews.removeWhere((r) => r.id == review.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('评价已删除')),
              );
            },
            child: const Text('确定删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }
}

/// 商品评价管理内容组件（嵌入在merchant_dashboard中使用）
class ProductReviewsContent extends StatelessWidget {
  const ProductReviewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductReviewsPage();
  }
}
