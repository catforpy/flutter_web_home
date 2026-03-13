import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/product_review/product_review_event.dart';
import 'package:official_website/application/blocs/product_review/product_review_state.dart';
import 'package:official_website/domain/repositories/product_review_repository.dart';

/// 商品评价管理 BLoC
class ProductReviewBloc
    extends Bloc<ProductReviewEvent, ProductReviewState> {
  final ProductReviewRepository repository;

  ProductReviewBloc({required this.repository})
      : super(const ProductReviewInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<LoadStatisticsEvent>(_onLoadStatistics);
    on<FilterReviewsEvent>(_onFilterReviews);
    on<ApproveReviewEvent>(_onApproveReview);
    on<RejectReviewEvent>(_onRejectReview);
    on<ReplyReviewEvent>(_onReplyReview);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<LoadProductsEvent>(_onLoadProducts);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(const ProductReviewLoading());

    final result = await repository.getReviews(
      page: event.page,
      pageSize: event.pageSize,
      productId: event.productId,
      minRating: event.minRating,
      maxRating: event.maxRating,
      status: event.status,
      hasImages: event.hasImages,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    final countResult = await repository.getReviewCount(
      productId: event.productId,
      status: event.status,
    );

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (reviews) {
        countResult.fold(
          (failure) => emit(ProductReviewError(failure.message)),
          (totalCount) {
            final hasMore = (event.page * event.pageSize) < totalCount;
            emit(ProductReviewLoaded(
              reviews: reviews,
              currentPage: event.page,
              pageSize: event.pageSize,
              totalCount: totalCount,
              hasMore: hasMore,
              productId: event.productId,
              minRating: event.minRating,
              maxRating: event.maxRating,
              status: event.status,
              hasImages: event.hasImages,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadStatistics(
    LoadStatisticsEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    if (state is ProductReviewLoaded) {
      final currentState = state as ProductReviewLoaded;

      final result =
          await repository.getStatistics(productId: event.productId);

      result.fold(
        (failure) => emit(ProductReviewError(failure.message)),
        (statistics) {
          emit(currentState.copyWith(statistics: statistics));
        },
      );
    }
  }

  Future<void> _onFilterReviews(
    FilterReviewsEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    if (state is ProductReviewLoaded) {
      final currentState = state as ProductReviewLoaded;

      add(LoadReviewsEvent(
        page: 1,
        pageSize: currentState.pageSize,
        productId: event.productId,
        minRating: event.minRating,
        maxRating: event.maxRating,
        status: event.status,
        hasImages: event.hasImages,
      ));
    }
  }

  Future<void> _onApproveReview(
    ApproveReviewEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    final result = await repository.approveReview(event.id);

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (_) {
        if (state is ProductReviewLoaded) {
          final currentState = state as ProductReviewLoaded;
          add(LoadReviewsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            productId: currentState.productId,
            minRating: currentState.minRating,
            maxRating: currentState.maxRating,
            status: currentState.status,
            hasImages: currentState.hasImages,
          ));
        }
      },
    );
  }

  Future<void> _onRejectReview(
    RejectReviewEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    final result = await repository.rejectReview(event.id);

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (_) {
        if (state is ProductReviewLoaded) {
          final currentState = state as ProductReviewLoaded;
          add(LoadReviewsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            productId: currentState.productId,
            minRating: currentState.minRating,
            maxRating: currentState.maxRating,
            status: currentState.status,
            hasImages: currentState.hasImages,
          ));
        }
      },
    );
  }

  Future<void> _onReplyReview(
    ReplyReviewEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    final result = await repository.replyReview(event.id, event.reply);

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (_) {
        if (state is ProductReviewLoaded) {
          final currentState = state as ProductReviewLoaded;
          add(LoadReviewsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            productId: currentState.productId,
            minRating: currentState.minRating,
            maxRating: currentState.maxRating,
            status: currentState.status,
            hasImages: currentState.hasImages,
          ));
        }
      },
    );
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    final result = await repository.deleteReview(event.id);

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (_) {
        if (state is ProductReviewLoaded) {
          final currentState = state as ProductReviewLoaded;
          add(LoadReviewsEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            productId: currentState.productId,
            minRating: currentState.minRating,
            maxRating: currentState.maxRating,
            status: currentState.status,
            hasImages: currentState.hasImages,
          ));
        }
      },
    );
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductReviewState> emit,
  ) async {
    final result = await repository.getProducts();

    result.fold(
      (failure) => emit(ProductReviewError(failure.message)),
      (products) {
        if (state is ProductReviewLoaded) {
          emit((state as ProductReviewLoaded).copyWith(products: products));
        }
      },
    );
  }
}
