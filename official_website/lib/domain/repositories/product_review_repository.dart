import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 商品评价仓储接口
abstract class ProductReviewRepository {
  /// 获取评价列表
  Future<Either<Failure, List<ProductReview>>> getReviews({
    required int page,
    required int pageSize,
    String? productId,
    int? minRating,
    int? maxRating,
    ReviewStatus? status,
    bool? hasImages,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// 获取评价统计
  Future<Either<Failure, ReviewStatistics>> getStatistics({
    String? productId,
  });

  /// 获取评价详情
  Future<Either<Failure, ProductReview>> getReviewById(String id);

  /// 审核评价
  Future<Either<Failure, Unit>> approveReview(String id);

  /// 拒绝评价
  Future<Either<Failure, Unit>> rejectReview(String id);

  /// 回复评价
  Future<Either<Failure, Unit>> replyReview(String id, String reply);

  /// 删除评价
  Future<Either<Failure, Unit>> deleteReview(String id);

  /// 获取评价总数
  Future<Either<Failure, int>> getReviewCount({
    String? productId,
    ReviewStatus? status,
  });

  /// 获取商品列表
  Future<Either<Failure, List<Map<String, dynamic>>>> getProducts();
}
