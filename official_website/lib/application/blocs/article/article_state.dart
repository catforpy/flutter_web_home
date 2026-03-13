import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 文章状态基类
abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

/// 加载中
class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

/// 文章列表已加载
class ArticlesLoaded extends ArticleState {
  final List<Article> articles;
  final int page;
  final bool hasMore;

  const ArticlesLoaded({
    required this.articles,
    required this.page,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [articles, page, hasMore];
}

/// 分类列表已加载
class CategoriesLoaded extends ArticleState {
  final List<ArticleCategory> categories;
  final String? selectedCategoryId;

  const CategoriesLoaded({
    required this.categories,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [categories, selectedCategoryId];
}

/// 配置已加载
class ArticleConfigLoaded extends ArticleState {
  final ArticleManagementConfig config;

  const ArticleConfigLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

/// 错误状态
class ArticleError extends ArticleState {
  final String message;

  const ArticleError(this.message);

  @override
  List<Object?> get props => [message];
}

/// 综合状态（用于文章管理页面）
class ArticleManagementLoaded extends ArticleState {
  final List<ArticleCategory> categories;
  final String? selectedCategoryId;
  final ArticleManagementConfig config;
  final List<Article> articles;

  const ArticleManagementLoaded({
    required this.categories,
    this.selectedCategoryId,
    required this.config,
    required this.articles,
  });

  @override
  List<Object?> get props => [categories, selectedCategoryId, config, articles];

  ArticleManagementLoaded copyWith({
    List<ArticleCategory>? categories,
    String? selectedCategoryId,
    ArticleManagementConfig? config,
    List<Article>? articles,
  }) {
    return ArticleManagementLoaded(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      config: config ?? this.config,
      articles: articles ?? this.articles,
    );
  }
}
