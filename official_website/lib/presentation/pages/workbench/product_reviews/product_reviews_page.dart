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

/// 评价类型（好评/中评/差评）
enum ReviewType {
  all('全部评价', Icons.reviews, Colors.grey),
  good('好评', Icons.sentiment_very_satisfied, Color(0xFF4CAF50)),
  medium('中评', Icons.sentiment_satisfied, Color(0xFFFF9800)),
  bad('差评', Icons.sentiment_very_dissatisfied, Color(0xFFFF4D4F));

  final String label;
  final IconData icon;
  final Color color;

  const ReviewType(this.label, this.icon, this.color);

  /// 根据评分获取评价类型
  static ReviewType fromRating(int rating) {
    if (rating >= 4) return ReviewType.good;
    if (rating == 3) return ReviewType.medium;
    return ReviewType.bad;
  }
}

/// 内容类型（有图/无图）
enum ReviewContentType {
  all('全部', Icons.rate_review, Colors.grey),
  withImage('有图评价', Icons.image, Color(0xFF2196F3)),
  withoutImage('文字评价', Icons.text_snippet, Color(0xFF9E9E9E));

  final String label;
  final IconData icon;
  final Color color;

  const ReviewContentType(this.label, this.icon, this.color);
}

/// 商品评价模型
class ProductReview {
  final String id;
  final String productId; // 商品ID
  final String productName; // 商品名称
  final String? productImage; // 商品图片
  final String? baseCategoryPath; // 基础分类路径（如：服装鞋帽 > 男装 > 上衣 > T恤）
  final String? userCategoryPath; // 客户自定义分类路径（如：热销商品 > 夏季热卖）
  final String? manufacturer; // 厂家
  final String? brand; // 品牌
  final String userName; // 评价用户
  final String? userAvatar; // 用户头像
  final int rating; // 评分 1-5
  final ReviewType reviewType; // 评价类型
  final String content; // 评价内容
  final List<String> images; // 评价图片
  final DateTime createTime; // 评价时间
  final ReviewStatus status; // 审核状态
  final String? reply; // 商家回复
  final DateTime? replyTime; // 回复时间
  final int likes; // 点赞数

  ProductReview({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    this.baseCategoryPath,
    this.userCategoryPath,
    this.manufacturer,
    this.brand,
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
  }) : reviewType = ReviewType.fromRating(rating);

  /// 是否有图片
  bool get hasImages => images.isNotEmpty;

  /// 获取最末级基础分类名称（用于显示）
  String? get lastBaseCategoryName {
    if (baseCategoryPath == null || baseCategoryPath!.isEmpty) return null;
    final parts = baseCategoryPath!.split(' > ');
    return parts.last;
  }

  /// 获取最末级自定义分类名称（用于显示）
  String? get lastUserCategoryName {
    if (userCategoryPath == null || userCategoryPath!.isEmpty) return null;
    final parts = userCategoryPath!.split(' > ');
    return parts.last;
  }
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

  // 评价类型筛选
  ReviewType _selectedReviewType = ReviewType.all;

  // 内容类型筛选
  ReviewContentType _selectedContentType = ReviewContentType.all;

  // 商品筛选
  String? _selectedProductId;

  // 分类筛选
  String? _selectedBaseCategory; // 基础分类路径筛选
  String? _selectedUserCategory; // 客户自定义分类路径筛选

  // 厂家筛选
  String? _selectedManufacturer;

  // 评分筛选
  int? _selectedRating;

  // 搜索关键词
  String _searchKeyword = '';

  // 模拟商品列表（用于筛选下拉框）
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'p001',
      'name': '时尚纯棉T恤',
      'baseCategoryPath': '服装鞋帽 > 男装 > 上衣 > T恤',
      'userCategoryPath': '热销商品 > 夏季热卖',
      'manufacturer': '优衣库',
      'brand': 'UNIQLO',
    },
    {
      'id': 'p002',
      'name': '休闲牛仔裤',
      'baseCategoryPath': '服装鞋帽 > 男装 > 裤装 > 牛仔裤',
      'userCategoryPath': '热销商品 > 春秋新款',
      'manufacturer': '李维斯',
      'brand': 'Levi\'s',
    },
    {
      'id': 'p003',
      'name': '连衣裙 夏季新款',
      'baseCategoryPath': '服装鞋帽 > 女装 > 连衣裙 > 长裙',
      'userCategoryPath': '热销商品 > 夏季热卖',
      'manufacturer': 'ONLY',
      'brand': 'ONLY',
    },
    {
      'id': 'p004',
      'name': '智能手机 iPhone 15',
      'baseCategoryPath': '数码电器 > 手机 > 智能手机 > 苹果',
      'userCategoryPath': '新品推荐 > 数码家电',
      'manufacturer': '苹果公司',
      'brand': 'Apple',
    },
    {
      'id': 'p005',
      'name': '护肤套装 补水保湿',
      'baseCategoryPath': '美妆护肤',
      'userCategoryPath': '新品推荐 > 美妆个护',
      'manufacturer': '兰蔻',
      'brand': 'Lancôme',
    },
    {
      'id': 'p006',
      'name': '笔记本电脑 华为MateBook',
      'baseCategoryPath': '数码电器',
      'userCategoryPath': '促销活动 > 电脑办公',
      'manufacturer': '华为',
      'brand': 'HUAWEI',
    },
  ];

  // 基础分类树（4级结构）
  final Map<String, List<String>> _baseCategoryTree = {
    '服装鞋帽': ['男装', '女装'],
    '服装鞋帽 > 男装': ['上衣', '裤装', '鞋帽'],
    '服装鞋帽 > 男装 > 上衣': ['T恤', '衬衫', '夹克'],
    '服装鞋帽 > 男装 > 裤装': ['牛仔裤', '休闲裤', '西裤'],
    '服装鞋帽 > 女装': ['连衣裙', '上衣', '裤装'],
    '服装鞋帽 > 女装 > 连衣裙': ['长裙', '短裙'],
    '数码电器': ['手机', '电脑', '家电'],
    '数码电器 > 手机': ['智能手机', '功能手机'],
    '数码电器 > 手机 > 智能手机': ['苹果', '华为', '小米', 'OPPO'],
    '数码电器 > 电脑': ['笔记本', '台式机', '平板'],
    '美妆护肤': ['护肤品', '彩妆', '香水'],
    '家居用品': ['厨房用品', '家居装饰', '家纺'],
    '食品饮料': ['零食', '饮料', '保健品'],
  };

  // 客户自定义分类树（也支持多级）
  final Map<String, List<String>> _userCategoryTree = {
    '热销商品': ['夏季热卖', '春秋新款', '冬季爆款'],
    '新品推荐': ['数码家电', '美妆个护', '服装鞋包'],
    '促销活动': ['电脑办公', '手机通讯', '生活用品'],
    '季节特惠': ['春季特惠', '夏季清仓', '秋季换新', '冬季保暖'],
  };

  // 厂家列表
  final List<String> _manufacturers = [
    '苹果公司',
    '华为',
    '小米',
    '优衣库',
    '李维斯',
    'ONLY',
    '兰蔻',
    '耐克',
    '阿迪达斯',
  ];

  // 模拟评价数据
  final List<ProductReview> _reviews = [
    ProductReview(
      id: 'r001',
      productId: 'p001',
      productName: '时尚纯棉T恤',
      baseCategoryPath: '服装鞋帽 > 男装 > 上衣 > T恤',
      userCategoryPath: '热销商品 > 夏季热卖',
      manufacturer: '优衣库',
      brand: 'UNIQLO',
      productImage: '',
      userName: '张三',
      rating: 5,
      content: '质量很好，穿着舒适，物流也很快，下次还会购买！',
      images: const [],
      createTime: DateTime(2026, 3, 10, 10, 30),
      status: ReviewStatus.displayed,
      reply: '感谢您的评价，我们会继续努力提供优质的产品和服务！',
      replyTime: DateTime(2026, 3, 10, 14, 20),
      likes: 12,
    ),
    ProductReview(
      id: 'r002',
      productId: 'p002',
      productName: '休闲牛仔裤',
      baseCategoryPath: '服装鞋帽 > 男装 > 裤装 > 牛仔裤',
      userCategoryPath: '热销商品 > 春秋新款',
      manufacturer: '李维斯',
      brand: 'Levi\'s',
      productImage: '',
      userName: '李四',
      rating: 4,
      content: '裤子款式不错，就是尺码稍微偏大了一点，总体还是满意的。',
      images: const ['image1.jpg'],
      createTime: DateTime(2026, 3, 9, 15, 20),
      status: ReviewStatus.displayed,
      likes: 8,
    ),
    ProductReview(
      id: 'r003',
      productId: 'p003',
      productName: '连衣裙 夏季新款',
      baseCategoryPath: '服装鞋帽 > 女装 > 连衣裙 > 长裙',
      userCategoryPath: '热销商品 > 夏季热卖',
      manufacturer: 'ONLY',
      brand: 'ONLY',
      productImage: '',
      userName: '王五',
      rating: 5,
      content: '裙子很漂亮，面料柔软透气，穿上很显气质，强烈推荐！',
      images: const ['image1.jpg', 'image2.jpg'],
      createTime: DateTime(2026, 3, 8, 9, 15),
      status: ReviewStatus.pending,
      likes: 15,
    ),
    ProductReview(
      id: 'r004',
      productId: 'p004',
      productName: '智能手机 iPhone 15',
      baseCategoryPath: '数码电器 > 手机 > 智能手机 > 苹果',
      userCategoryPath: '新品推荐 > 数码家电',
      manufacturer: '苹果公司',
      brand: 'Apple',
      productImage: '',
      userName: '赵六',
      rating: 5,
      content: '手机收到了，正品无疑，用起来很流畅，物流也很快，满分！',
      images: const [],
      createTime: DateTime(2026, 3, 7, 16, 45),
      status: ReviewStatus.displayed,
      reply: '感谢您的支持！',
      replyTime: DateTime(2026, 3, 7, 18, 00),
      likes: 23,
    ),
    ProductReview(
      id: 'r005',
      productId: 'p005',
      productName: '护肤套装 补水保湿',
      baseCategoryPath: '美妆护肤',
      userCategoryPath: '新品推荐 > 美妆个护',
      manufacturer: '兰蔻',
      brand: 'Lancôme',
      productImage: '',
      userName: '孙七',
      rating: 3,
      content: '效果还行，但是发货有点慢，包装也不是很好。',
      images: const [],
      createTime: DateTime(2026, 3, 6, 11, 30),
      status: ReviewStatus.pending,
      likes: 3,
    ),
    ProductReview(
      id: 'r006',
      productId: 'p006',
      productName: '笔记本电脑 华为MateBook',
      baseCategoryPath: '数码电器',
      userCategoryPath: '促销活动 > 电脑办公',
      manufacturer: '华为',
      brand: 'HUAWEI',
      productImage: '',
      userName: '周八',
      rating: 4,
      content: '电脑性能不错，就是价格稍微有点贵，整体还是满意的。',
      images: const [],
      createTime: DateTime(2026, 3, 5, 14, 20),
      status: ReviewStatus.displayed,
      likes: 6,
    ),
    ProductReview(
      id: 'r007',
      productId: 'p002',
      productName: '休闲牛仔裤',
      baseCategoryPath: '服装鞋帽 > 男装 > 裤装 > 牛仔裤',
      userCategoryPath: '热销商品 > 春秋新款',
      manufacturer: '李维斯',
      brand: 'Levi\'s',
      productImage: '',
      userName: '吴九',
      rating: 2,
      content: '质量太差了，穿了一天就破了，不推荐购买！',
      images: const ['image1.jpg', 'image2.jpg', 'image3.jpg'],
      createTime: DateTime(2026, 3, 4, 10, 15),
      status: ReviewStatus.pending,
      likes: 1,
    ),
  ];

  /// 获取筛选后的评价列表
  List<ProductReview> get _filteredReviews {
    var filtered = List<ProductReview>.from(_reviews);

    // 按状态筛选
    if (_selectedStatus != ReviewStatus.all) {
      filtered = filtered.where((review) => review.status == _selectedStatus).toList();
    }

    // 按评价类型筛选
    if (_selectedReviewType != ReviewType.all) {
      filtered = filtered.where((review) => review.reviewType == _selectedReviewType).toList();
    }

    // 按内容类型筛选
    if (_selectedContentType == ReviewContentType.withImage) {
      filtered = filtered.where((review) => review.hasImages).toList();
    } else if (_selectedContentType == ReviewContentType.withoutImage) {
      filtered = filtered.where((review) => !review.hasImages).toList();
    }

    // 按商品筛选
    if (_selectedProductId != null) {
      filtered = filtered.where((review) => review.productId == _selectedProductId).toList();
    }

    // 按基础分类筛选（支持层级筛选，如选中"服装鞋帽 > 男装"会筛选出所有属于该分类及其子分类的评价）
    if (_selectedBaseCategory != null) {
      filtered = filtered.where((review) {
        if (review.baseCategoryPath == null || review.baseCategoryPath!.isEmpty) return false;
        // 如果基础分类路径以选中的分类开头（支持层级筛选）
        return review.baseCategoryPath!.startsWith(_selectedBaseCategory!);
      }).toList();
    }

    // 按客户自定义分类筛选
    if (_selectedUserCategory != null) {
      filtered = filtered.where((review) {
        if (review.userCategoryPath == null || review.userCategoryPath!.isEmpty) return false;
        return review.userCategoryPath!.startsWith(_selectedUserCategory!);
      }).toList();
    }

    // 按厂家筛选
    if (_selectedManufacturer != null) {
      filtered = filtered.where((review) => review.manufacturer == _selectedManufacturer).toList();
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
               review.userName.toLowerCase().contains(keyword) ||
               (review.baseCategoryPath?.toLowerCase().contains(keyword) ?? false) ||
               (review.userCategoryPath?.toLowerCase().contains(keyword) ?? false) ||
               (review.manufacturer?.toLowerCase().contains(keyword) ?? false) ||
               (review.brand?.toLowerCase().contains(keyword) ?? false);
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

  /// 获取各类型评价数量
  Map<ReviewType, int> get _reviewTypeCounts {
    final counts = <ReviewType, int>{};
    for (final type in ReviewType.values) {
      if (type == ReviewType.all) {
        counts[type] = _reviews.length;
      } else {
        counts[type] = _reviews.where((review) => review.reviewType == type).length;
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

          // 商品/分类筛选栏
          _buildProductCategoryFilterBar(),

          // 评价类型筛选栏
          _buildReviewTypeFilterBar(),

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
                hintText: '搜索商品、分类、厂家、品牌、用户或评价内容',
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
    final typeCounts = _reviewTypeCounts;

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

          // 中间：评分分布
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

          const SizedBox(width: 40),

          // 分隔线
          Container(
            height: 80,
            width: 1,
            color: const Color(0xFFE0E0E0),
          ),

          const SizedBox(width: 40),

          // 右侧：评价类型统计
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '评价类型',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildTypeStatChip('好评', typeCounts[ReviewType.good] ?? 0, ReviewType.good.color),
                    _buildTypeStatChip('中评', typeCounts[ReviewType.medium] ?? 0, ReviewType.medium.color),
                    _buildTypeStatChip('差评', typeCounts[ReviewType.bad] ?? 0, ReviewType.bad.color),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建类型统计芯片
  Widget _buildTypeStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
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

  /// 构建商品/分类筛选栏
  Widget _buildProductCategoryFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          // 商品筛选
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '商品：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildProductSelector(),
            ],
          ),

          // 基础分类筛选（级联选择）
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '基础分类：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildBaseCategorySelector(),
            ],
          ),

          // 客户自定义分类筛选（级联选择）
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '自定义分类：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildUserCategorySelector(),
            ],
          ),

          // 厂家筛选
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '厂家：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildManufacturerSelector(),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建商品选择器
  Widget _buildProductSelector() {
    final selectedProduct = _products.firstWhere(
      (p) => p['id'] == _selectedProductId,
      orElse: () => {},
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showProductSelectorDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  _selectedProductId == null
                      ? '全部商品'
                      : (selectedProduct['name'] as String? ?? '未知商品'),
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedProductId == null
                        ? const Color(0xFF666666)
                        : const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建基础分类选择器
  Widget _buildBaseCategorySelector() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showBaseCategoryDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  _selectedBaseCategory ?? '全部分类',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedBaseCategory == null
                        ? const Color(0xFF666666)
                        : const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建客户自定义分类选择器
  Widget _buildUserCategorySelector() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showUserCategoryDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  _selectedUserCategory ?? '全部',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedUserCategory == null
                        ? const Color(0xFF666666)
                        : const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建厂家选择器
  Widget _buildManufacturerSelector() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showManufacturerDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  _selectedManufacturer ?? '全部厂家',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedManufacturer == null
                        ? const Color(0xFF666666)
                        : const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建评价类型筛选栏
  Widget _buildReviewTypeFilterBar() {
    final typeCounts = _reviewTypeCounts;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          // 评价类型筛选
          Row(
            children: [
              const Text(
                '评价类型：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              ...ReviewType.values.map((type) {
                final isSelected = _selectedReviewType == type;
                final count = typeCounts[type] ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedReviewType = type;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? type.color : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected ? type.color : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(type.icon, size: 16, color: isSelected ? Colors.white : type.color),
                            const SizedBox(width: 6),
                            Text(
                              type.label,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.white : const Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 8),

          // 内容类型筛选
          Row(
            children: [
              const Text(
                '内容类型：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              ...ReviewContentType.values.map((type) {
                final isSelected = _selectedContentType == type;
                final count = type == ReviewContentType.all
                    ? _reviews.length
                    : (type == ReviewContentType.withImage
                        ? _reviews.where((r) => r.hasImages).length
                        : _reviews.where((r) => !r.hasImages).length);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedContentType = type;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? type.color : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected ? type.color : const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(type.icon, size: 16, color: isSelected ? Colors.white : type.color),
                            const SizedBox(width: 6),
                            Text(
                              type.label,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.white : const Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF999999),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 80,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
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
          // 顶部：商品信息 + 分类 + 状态
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  review.productName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // 基础分类标签（显示最末级分类，鼠标悬停显示完整路径）
                              if (review.lastBaseCategoryName != null) ...[
                                const SizedBox(width: 8),
                                Tooltip(
                                  message: review.baseCategoryPath ?? '',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      review.lastBaseCategoryName!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF1A9B8E),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              // 客户自定义分类标签
                              if (review.lastUserCategoryName != null) ...[
                                const SizedBox(width: 4),
                                Tooltip(
                                  message: review.userCategoryPath ?? '',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      review.lastUserCategoryName!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFFF9800),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              // 厂家/品牌标签
                              if (review.manufacturer != null) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9E9E9E).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    review.manufacturer!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 评价类型标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: review.reviewType.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: review.reviewType.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          review.reviewType.icon,
                          size: 14,
                          color: review.reviewType.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          review.reviewType.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: review.reviewType.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 审核状态标签
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      Row(
                        children: [
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
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image, size: 14, color: Color(0xFF2196F3)),
                                const SizedBox(width: 4),
                                Text(
                                  '${review.images.length}张',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 12),

                    // 底部操作栏
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_outlined,
                          size: 16,
                          color: Color(0xFF999999),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${review.likes}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
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
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        if (review.reply != null) {
          controller.text = review.reply!;
        }

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
              onPressed: () {
                controller.dispose();  // ✅ 释放controller
                Navigator.of(dialogContext).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  final replyText = controller.text.trim();
                  controller.dispose();  // ✅ 释放controller
                  Navigator.of(dialogContext).pop();
                  setState(() {
                    final index = _reviews.indexWhere((r) => r.id == review.id);
                    if (index != -1) {
                      _reviews[index] = ProductReview(
                        id: review.id,
                        productId: review.productId,
                        productName: review.productName,
                        productImage: review.productImage,
                        baseCategoryPath: review.baseCategoryPath,
                        userCategoryPath: review.userCategoryPath,
                        manufacturer: review.manufacturer,
                        brand: review.brand,
                        userName: review.userName,
                        userAvatar: review.userAvatar,
                        rating: review.rating,
                        content: review.content,
                        images: review.images,
                        createTime: review.createTime,
                        status: review.status,
                        reply: replyText,
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
          productId: review.productId,
          productName: review.productName,
          productImage: review.productImage,
          baseCategoryPath: review.baseCategoryPath,
          userCategoryPath: review.userCategoryPath,
          manufacturer: review.manufacturer,
          brand: review.brand,
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
        content: const Text('确定要删除该评价吗？'),
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

  /// 显示商品选择对话框
  void _showProductSelectorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择商品'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: ListView(
            children: [
              // 全部商品选项
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProductId = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedProductId == null
                          ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                          : Colors.white,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedProductId == null ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: _selectedProductId == null
                              ? const Color(0xFF1A9B8E)
                              : const Color(0xFF999999),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '全部商品',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 商品列表
              ..._products.map((product) {
                final productId = product['id'] as String;
                final productName = product['name'] as String;
                final isSelected = _selectedProductId == productId;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProductId = productId;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                            : Colors.white,
                        border: const Border(
                          bottom: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFF999999),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (product['baseCategoryPath'] != null)
                                  Text(
                                    product['baseCategoryPath'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示基础分类选择对话框（级联选择）
  void _showBaseCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => _BaseCategoryDialog(
        initialSelection: _selectedBaseCategory,
        categoryTree: _baseCategoryTree,
        onSelected: (path) {
          setState(() {
            _selectedBaseCategory = path;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 显示客户自定义分类选择对话框（级联选择）
  void _showUserCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => _BaseCategoryDialog(
        initialSelection: _selectedUserCategory,
        categoryTree: _userCategoryTree,
        title: '选择自定义分类',
        onSelected: (path) {
          setState(() {
            _selectedUserCategory = path;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 显示厂家选择对话框
  void _showManufacturerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择厂家'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: ListView(
            children: [
              // 全部厂家选项
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedManufacturer = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedManufacturer == null
                          ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                          : Colors.white,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedManufacturer == null
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: _selectedManufacturer == null
                              ? const Color(0xFF1A9B8E)
                              : const Color(0xFF999999),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '全部厂家',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 厂家列表
              ..._manufacturers.map((manufacturer) {
                final isSelected = _selectedManufacturer == manufacturer;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedManufacturer = manufacturer;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                            : Colors.white,
                        border: const Border(
                          bottom: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFF999999),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            manufacturer,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

/// 级联分类选择对话框
class _BaseCategoryDialog extends StatefulWidget {
  final String? initialSelection;
  final Map<String, List<String>> categoryTree;
  final String title;
  final void Function(String?) onSelected;

  const _BaseCategoryDialog({
    required this.initialSelection,
    required this.categoryTree,
    this.title = '选择基础分类',
    required this.onSelected,
  });

  @override
  State<_BaseCategoryDialog> createState() => _BaseCategoryDialogState();
}

class _BaseCategoryDialogState extends State<_BaseCategoryDialog> {
  // 当前选择的路径（最多4级）
  final List<String> _selectedPath = [];

  // 搜索关键词
  String _searchKeyword = '';

  // 搜索结果
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      _selectedPath.addAll(widget.initialSelection!.split(' > '));
    }
  }

  /// 获取当前层级的子分类
  List<String> _getCurrentLevelChildren() {
    if (_selectedPath.isEmpty) {
      // 第1级：获取所有顶级分类
      final topLevels = widget.categoryTree.keys
          .where((key) => !key.contains(' > '))
          .toList();
      topLevels.sort();
      return topLevels;
    } else {
      // 获取当前路径的子分类
      final currentPath = _selectedPath.join(' > ');
      return widget.categoryTree[currentPath] ?? [];
    }
  }

  /// 搜索分类
  void _searchCategory(String keyword) {
    _searchKeyword = keyword;
    if (keyword.trim().isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = widget.categoryTree.keys
          .where((path) => path.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      _searchResults.sort();
    }
    setState(() {});
  }

  /// 选择分类路径
  void _selectPath(List<String> path) {
    setState(() {
      _selectedPath.clear();
      _selectedPath.addAll(path);
    });
  }

  /// 确认选择
  void _confirmSelection() {
    if (_selectedPath.isEmpty) {
      widget.onSelected(null);
    } else {
      widget.onSelected(_selectedPath.join(' > '));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 12),
          // 搜索框
          TextField(
            decoration: InputDecoration(
              hintText: '搜索分类名称',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchKeyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => _searchCategory(''),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: _searchCategory,
          ),
        ],
      ),
      content: SizedBox(
        width: 700,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 已选择的路径显示
            if (_selectedPath.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ..._selectedPath.asMap().entries.map((entry) {
                      final index = entry.key;
                      final part = entry.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index > 0)
                            const Text(
                              ' > ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF999999),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A9B8E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              part,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    // 清除选择按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPath.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // 分类列表
            Expanded(
              child: _searchKeyword.isEmpty
                  ? _buildCategoryTree()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _confirmSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A9B8E),
          ),
          child: const Text('确定'),
        ),
      ],
    );
  }

  /// 构建分类树（级联显示）
  Widget _buildCategoryTree() {
    final children = _getCurrentLevelChildren();

    if (children.isEmpty) {
      return const Center(
        child: Text(
          '暂无子分类',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: children.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final category = children[index];
        final fullPath = _selectedPath.isEmpty
            ? category
            : '${_selectedPath.join(' > ')} > $category';

        // 检查是否有子分类
        final hasChildren = widget.categoryTree.containsKey(fullPath);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (hasChildren) {
                // 进入下一级
                _selectPath([..._selectedPath, category]);
              } else {
                // 没有子分类，直接选择
                _selectPath([..._selectedPath, category]);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: _selectedPath.isNotEmpty && _selectedPath.last == category
                  ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                  : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _selectedPath.isNotEmpty && _selectedPath.last == category
                            ? const Color(0xFF1A9B8E)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  if (hasChildren)
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF999999),
                    )
                  else
                    Icon(
                      _selectedPath.isNotEmpty && _selectedPath.last == category
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: _selectedPath.isNotEmpty && _selectedPath.last == category
                          ? const Color(0xFF1A9B8E)
                          : const Color(0xFF999999),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建搜索结果
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          '未找到匹配的分类',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final path = _searchResults[index];
        final parts = path.split(' > ');

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              _selectPath(parts);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: _selectedPath.join(' > ') == path
                  ? const Color(0xFF1A9B8E).withValues(alpha: 0.1)
                  : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parts.last,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _selectedPath.join(' > ') == path
                                ? const Color(0xFF1A9B8E)
                                : const Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          path,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _selectedPath.join(' > ') == path
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: _selectedPath.join(' > ') == path
                        ? const Color(0xFF1A9B8E)
                        : const Color(0xFF999999),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
