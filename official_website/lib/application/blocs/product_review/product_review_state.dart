import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 商品评价管理状态基类
abstract class ProductReviewState extends Equatable {
  const ProductReviewState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class ProductReviewInitial extends ProductReviewState {
  const ProductReviewInitial();
}

/// 加载中
class ProductReviewLoading extends ProductReviewState {
  const ProductReviewLoading();
}

/// 已加载
class ProductReviewLoaded extends ProductReviewState {
  final List<ProductReview> reviews;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
  final ReviewStatistics? statistics;
  final List<Map<String, dynamic>>? products;

  // 筛选条件
  final String? productId;
  final int? minRating;
  final int? maxRating;
  final ReviewStatus? status;
  final bool? hasImages;

  const ProductReviewLoaded({
    this.reviews = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.hasMore = false,
    this.statistics,
    this.products,
    this.productId,
    this.minRating,
    this.maxRating,
    this.status,
    this.hasImages,
  });

  @override
  List<Object?> get props => [
        reviews,
        currentPage,
        pageSize,
        totalCount,
        hasMore,
        statistics,
        products,
        productId,
        minRating,
        maxRating,
        status,
        hasImages,
      ];

  ProductReviewLoaded copyWith({
    List<ProductReview>? reviews,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    bool? hasMore,
    ReviewStatistics? statistics,
    List<Map<String, dynamic>>? products,
    String? productId,
    int? minRating,
    int? maxRating,
    ReviewStatus? status,
    bool? hasImages,
  }) {
    return ProductReviewLoaded(
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      statistics: statistics ?? this.statistics,
      products: products ?? this.products,
      productId: productId ?? this.productId,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      status: status ?? this.status,
      hasImages: hasImages ?? this.hasImages,
    );
  }
}

/// 错误状态
class ProductReviewError extends ProductReviewState {
  final String message;

  const ProductReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
