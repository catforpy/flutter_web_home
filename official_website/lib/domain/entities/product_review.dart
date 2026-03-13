/// 商品评价实体
class ProductReview {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String content;
  final List<String> images;
  final DateTime createTime;
  final ReviewStatus status;
  final String? reply; // 商家回复
  final DateTime? replyTime;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.content,
    required this.images,
    required this.createTime,
    required this.status,
    this.reply,
    this.replyTime,
  });

  ProductReview copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    String? userId,
    String? userName,
    String? userAvatar,
    int? rating,
    String? content,
    List<String>? images,
    DateTime? createTime,
    ReviewStatus? status,
    String? reply,
    DateTime? replyTime,
  }) {
    return ProductReview(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      content: content ?? this.content,
      images: images ?? this.images,
      createTime: createTime ?? this.createTime,
      status: status ?? this.status,
      reply: reply ?? this.reply,
      replyTime: replyTime ?? this.replyTime,
    );
  }

  /// 是否已回复
  bool get hasReply => reply != null && reply!.isNotEmpty;
}

/// 评价状态
enum ReviewStatus {
  pending('待审核'),
  approved('已通过'),
  rejected('已拒绝'),
  deleted('已删除');

  final String displayName;

  const ReviewStatus(this.displayName);
}

/// 评价筛选条件
class ReviewFilter {
  final String? productId;
  final int? minRating;
  final int? maxRating;
  final ReviewStatus? status;
  final bool? hasImages;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReviewFilter({
    this.productId,
    this.minRating,
    this.maxRating,
    this.status,
    this.hasImages,
    this.startDate,
    this.endDate,
  });

  ReviewFilter copyWith({
    String? productId,
    int? minRating,
    int? maxRating,
    ReviewStatus? status,
    bool? hasImages,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ReviewFilter(
      productId: productId ?? this.productId,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      status: status ?? this.status,
      hasImages: hasImages ?? this.hasImages,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// 评价统计
class ReviewStatistics {
  final int totalCount;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;
  final double averageRating;
  final int pendingCount;

  const ReviewStatistics({
    required this.totalCount,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
    required this.averageRating,
    required this.pendingCount,
  });

  /// 获取某个星级的数量
  int getStarCount(int stars) {
    switch (stars) {
      case 5:
        return fiveStarCount;
      case 4:
        return fourStarCount;
      case 3:
        return threeStarCount;
      case 2:
        return twoStarCount;
      case 1:
        return oneStarCount;
      default:
        return 0;
    }
  }

  /// 获取某个星级占比
  double getStarPercentage(int stars) {
    if (totalCount == 0) return 0;
    return getStarCount(stars) / totalCount;
  }
}
