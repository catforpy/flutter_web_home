import 'package:official_website/domain/entities/product_review.dart';

/// 商品评价模拟数据源
///
/// 所有假数据集中管理，方便替换为真实 API
class ProductReviewMockDatasource {
  /// 获取评价列表
  static List<ProductReview> getReviews({
    int page = 1,
    int pageSize = 10,
    String? productId,
    int? minRating,
    int? maxRating,
    ReviewStatus? status,
    bool? hasImages,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final allReviews = _getAllReviews();

    // 应用筛选
    var filteredReviews = allReviews;

    if (productId != null && productId.isNotEmpty) {
      filteredReviews = filteredReviews
          .where((r) => r.productId == productId)
          .toList();
    }

    if (minRating != null) {
      filteredReviews = filteredReviews
          .where((r) => r.rating >= minRating!)
          .toList();
    }

    if (maxRating != null) {
      filteredReviews = filteredReviews
          .where((r) => r.rating <= maxRating!)
          .toList();
    }

    if (status != null) {
      filteredReviews = filteredReviews
          .where((r) => r.status == status)
          .toList();
    }

    if (hasImages == true) {
      filteredReviews = filteredReviews
          .where((r) => r.images.isNotEmpty)
          .toList();
    }

    if (startDate != null) {
      filteredReviews = filteredReviews
          .where((r) => r.createTime.isAfter(startDate!))
          .toList();
    }

    if (endDate != null) {
      filteredReviews = filteredReviews
          .where((r) => r.createTime.isBefore(endDate!))
          .toList();
    }

    // 分页
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= filteredReviews.length) {
      return [];
    }

    return filteredReviews.sublist(
      start,
      end.clamp(0, filteredReviews.length),
    );
  }

  /// 获取评价统计
  static ReviewStatistics getStatistics({String? productId}) {
    final allReviews = _getAllReviews();

    final filteredReviews = productId != null && productId.isNotEmpty
        ? allReviews.where((r) => r.productId == productId).toList()
        : allReviews;

    final totalCount = filteredReviews.length;
    final fiveStarCount =
        filteredReviews.where((r) => r.rating == 5).length;
    final fourStarCount =
        filteredReviews.where((r) => r.rating == 4).length;
    final threeStarCount =
        filteredReviews.where((r) => r.rating == 3).length;
    final twoStarCount =
        filteredReviews.where((r) => r.rating == 2).length;
    final oneStarCount =
        filteredReviews.where((r) => r.rating == 1).length;

    final totalRating = filteredReviews.fold<int>(
        0, (sum, r) => sum + r.rating);
    final averageRating =
        totalCount > 0 ? totalRating / totalCount : 0.0;

    final pendingCount = filteredReviews
        .where((r) => r.status == ReviewStatus.pending)
        .length;

    return ReviewStatistics(
      totalCount: totalCount,
      fiveStarCount: fiveStarCount,
      fourStarCount: fourStarCount,
      threeStarCount: threeStarCount,
      twoStarCount: twoStarCount,
      oneStarCount: oneStarCount,
      averageRating: averageRating,
      pendingCount: pendingCount,
    );
  }

  /// 获取评价总数
  static int getReviewCount({
    String? productId,
    ReviewStatus? status,
  }) {
    return getReviews(productId: productId, status: status).length;
  }

  /// 获取单个评价详情
  static ProductReview? getReviewById(String id) {
    return _getAllReviews().firstWhere(
      (r) => r.id == id,
      orElse: () => throw StateError("Value not found"),
    );
  }

  // ==================== 模拟数据 ====================

  static List<ProductReview> _getAllReviews() {
    final now = DateTime.now();

    return [
      ProductReview(
        id: '1',
        productId: 'p1',
        productName: 'Python 全栈开发实战',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u1',
        userName: '张三',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '课程内容非常丰富，老师讲得很详细，学到了很多东西！',
        images: [],
        createTime: now.subtract(const Duration(days: 5)),
        status: ReviewStatus.approved,
        reply: '感谢您的好评！我们会继续努力提供优质的课程内容。',
        replyTime: now.subtract(const Duration(days: 4)),
      ),
      ProductReview(
        id: '2',
        productId: 'p1',
        productName: 'Python 全栈开发实战',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u2',
        userName: '李四',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 4,
        content: '整体不错，但是有些章节讲得有点快，需要反复看几遍才能理解。',
        images: [
          'https://via.placeholder.com/300',
          'https://via.placeholder.com/300',
        ],
        createTime: now.subtract(const Duration(days: 10)),
        status: ReviewStatus.approved,
      ),
      ProductReview(
        id: '3',
        productId: 'p2',
        productName: 'Java 企业级应用开发',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u3',
        userName: '王五',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '非常好！老师的实战经验很丰富，项目案例也很实用。',
        images: [],
        createTime: now.subtract(const Duration(days: 15)),
        status: ReviewStatus.pending,
      ),
      ProductReview(
        id: '4',
        productId: 'p2',
        productName: 'Java 企业级应用开发',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u4',
        userName: '赵六',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 3,
        content: '课程还可以，但是对于初学者来说可能有点难度，建议增加一些基础内容的讲解。',
        images: [],
        createTime: now.subtract(const Duration(days: 20)),
        status: ReviewStatus.approved,
        reply: '感谢您的反馈！我们会考虑您的建议，优化课程内容。',
        replyTime: now.subtract(const Duration(days: 19)),
      ),
      ProductReview(
        id: '5',
        productId: 'p3',
        productName: 'Flutter 移动应用开发',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u5',
        userName: '孙七',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '超级棒！从零基础到能独立开发App，老师讲得很清楚，项目也很实用。',
        images: [
          'https://via.placeholder.com/300',
          'https://via.placeholder.com/300',
          'https://via.placeholder.com/300',
        ],
        createTime: now.subtract(const Duration(days: 25)),
        status: ReviewStatus.approved,
      ),
      ProductReview(
        id: '6',
        productId: 'p3',
        productName: 'Flutter 移动应用开发',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u6',
        userName: '周八',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 4,
        content: '课程内容很全面，涵盖了很多实用技巧。希望能增加更多实战项目。',
        images: [],
        createTime: now.subtract(const Duration(days: 30)),
        status: ReviewStatus.pending,
      ),
      ProductReview(
        id: '7',
        productId: 'p4',
        productName: '机器学习入门与实践',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u7',
        userName: '吴九',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '非常系统和全面的机器学习课程，老师讲得很细致，数学基础也讲得很清楚。',
        images: [],
        createTime: now.subtract(const Duration(days: 35)),
        status: ReviewStatus.approved,
      ),
      ProductReview(
        id: '8',
        productId: 'p4',
        productName: '机器学习入门与实践',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u8',
        userName: '郑十',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 4,
        content: '内容很好，但是编程难度有点高，需要有一定的编程基础。',
        images: ['https://via.placeholder.com/300'],
        createTime: now.subtract(const Duration(days: 40)),
        status: ReviewStatus.approved,
      ),
      ProductReview(
        id: '9',
        productId: 'p5',
        productName: 'UI/UX 设计基础',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u9',
        userName: '钱十一',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '设计课程讲得很好，学到了很多实用的设计技巧和理论。',
        images: [
          'https://via.placeholder.com/300',
          'https://via.placeholder.com/300',
        ],
        createTime: now.subtract(const Duration(days: 45)),
        status: ReviewStatus.approved,
      ),
      ProductReview(
        id: '10',
        productId: 'p5',
        productName: 'UI/UX 设计基础',
        productImage: 'https://via.placeholder.com/100',
        userId: 'u10',
        userName: '孙十二',
        userAvatar: 'https://via.placeholder.com/50',
        rating: 5,
        content: '非常实用的课程，案例都很接地气，学完就能应用到实际工作中。',
        images: [],
        createTime: now.subtract(const Duration(days: 50)),
        status: ReviewStatus.pending,
      ),
    ];
  }

  /// 获取商品列表
  static List<Map<String, dynamic>> getProducts() {
    return [
      {
        'id': 'p1',
        'name': 'Python 全栈开发实战',
        'image': 'https://via.placeholder.com/100',
      },
      {
        'id': 'p2',
        'name': 'Java 企业级应用开发',
        'image': 'https://via.placeholder.com/100',
      },
      {
        'id': 'p3',
        'name': 'Flutter 移动应用开发',
        'image': 'https://via.placeholder.com/100',
      },
      {
        'id': 'p4',
        'name': '机器学习入门与实践',
        'image': 'https://via.placeholder.com/100',
      },
      {
        'id': 'p5',
        'name': 'UI/UX 设计基础',
        'image': 'https://via.placeholder.com/100',
      },
    ];
  }
}
