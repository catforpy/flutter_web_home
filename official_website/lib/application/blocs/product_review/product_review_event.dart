import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/product_review.dart';

/// 商品评价管理事件基类
abstract class ProductReviewEvent extends Equatable {
  const ProductReviewEvent();

  @override
  List<Object?> get props => [];
}

/// 加载评价列表
class LoadReviewsEvent extends ProductReviewEvent {
  final int page;
  final int pageSize;
  final String? productId;
  final int? minRating;
  final int? maxRating;
  final ReviewStatus? status;
  final bool? hasImages;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadReviewsEvent({
    this.page = 1,
    this.pageSize = 10,
    this.productId,
    this.minRating,
    this.maxRating,
    this.status,
    this.hasImages,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        page,
        pageSize,
        productId,
        minRating,
        maxRating,
        status,
        hasImages,
        startDate,
        endDate,
      ];
}

/// 加载统计数据
class LoadStatisticsEvent extends ProductReviewEvent {
  final String? productId;

  const LoadStatisticsEvent({this.productId});

  @override
  List<Object?> get props => [productId];
}

/// 筛选评价
class FilterReviewsEvent extends ProductReviewEvent {
  final String? productId;
  final int? minRating;
  final int? maxRating;
  final ReviewStatus? status;
  final bool? hasImages;

  const FilterReviewsEvent({
    this.productId,
    this.minRating,
    this.maxRating,
    this.status,
    this.hasImages,
  });

  @override
  List<Object?> get props =>
      [productId, minRating, maxRating, status, hasImages];
}

/// 审核通过
class ApproveReviewEvent extends ProductReviewEvent {
  final String id;

  const ApproveReviewEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// 拒绝评价
class RejectReviewEvent extends ProductReviewEvent {
  final String id;

  const RejectReviewEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// 回复评价
class ReplyReviewEvent extends ProductReviewEvent {
  final String id;
  final String reply;

  const ReplyReviewEvent({
    required this.id,
    required this.reply,
  });

  @override
  List<Object?> get props => [id, reply];
}

/// 删除评价
class DeleteReviewEvent extends ProductReviewEvent {
  final String id;

  const DeleteReviewEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// 加载商品列表
class LoadProductsEvent extends ProductReviewEvent {
  const LoadProductsEvent();
}
