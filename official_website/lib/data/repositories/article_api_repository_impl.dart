import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/network/api_config.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';
import 'package:official_website/domain/repositories/article_repository.dart';

/// 文章仓储实现 - API 版本
///
/// 这是接口对接的示例
/// 展示如何从 Mock 数据切换到真实 API
///
/// 对比原来的 article_repository_impl.dart (Mock 版本)
/// 这个版本使用真实的后端 API
class ArticleApiRepositoryImpl implements ArticleRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<Either<Failure, List<Article>>> getArticles({
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) async {
    return _apiClient.get<List<Article>>(
      ApiConfig.articleList,
      queryParameters: {
        if (categoryId != null) 'categoryId': categoryId,
        'page': page,
        'pageSize': pageSize,
      },
      fromJson: (json) {
        // 解析后端返回的文章列表
        final data = json as Map<String, dynamic>;
        final list = data['list'] as List? ?? data['articles'] as List? ?? [];

        return list.map((item) {
          return Article.fromJson(item as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String id) async {
    return _apiClient.get<Article>(
      '${ApiConfig.articleDetail}/$id',
      fromJson: (json) {
        return Article.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, Article>> createArticle(Article article) async {
    return _apiClient.post<Article>(
      ApiConfig.articleList,
      data: article.toJson(),
      fromJson: (json) {
        return Article.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, Article>> updateArticle(Article article) async {
    return _apiClient.put<Article>(
      '${ApiConfig.articleDetail}/${article.id}',
      data: article.toJson(),
      fromJson: (json) {
        return Article.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteArticle(String id) async {
    return _apiClient.delete<Unit>(
      '${ApiConfig.articleDetail}/$id',
    );
  }

  @override
  Future<Either<Failure, List<ArticleCategory>>> getCategories() async {
    return _apiClient.get<List<ArticleCategory>>(
      ApiConfig.articleCategories,
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        final list = data['list'] as List? ?? data['categories'] as List? ?? [];

        return list.map((item) {
          return ArticleCategory.fromJson(item as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ArticleCategory>> getCategoryById(String id) async {
    return _apiClient.get<ArticleCategory>(
      '${ApiConfig.articleCategories}/$id',
      fromJson: (json) {
        return ArticleCategory.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, ArticleCategory>> addCategory(
    String name,
    int sortOrder,
  ) async {
    return _apiClient.post<ArticleCategory>(
      ApiConfig.articleCategories,
      data: {
        'name': name,
        'sortOrder': sortOrder,
      },
      fromJson: (json) {
        return ArticleCategory.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, ArticleCategory>> updateCategory(
    ArticleCategory category,
  ) async {
    return _apiClient.put<ArticleCategory>(
      '${ApiConfig.articleCategories}/${category.id}',
      data: category.toJson(),
      fromJson: (json) {
        return ArticleCategory.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    return _apiClient.delete<Unit>(
      '${ApiConfig.articleCategories}/$id',
    );
  }

  @override
  Future<Either<Failure, ArticleManagementConfig>> getArticleManagementConfig() async {
    return _apiClient.get<ArticleManagementConfig>(
      ApiConfig.workbenchArticleConfig,
      fromJson: (json) {
        return ArticleManagementConfig.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> saveArticleManagementConfig(
    ArticleManagementConfig config,
  ) async {
    return _apiClient.post<Unit>(
      ApiConfig.workbenchArticleConfig,
      data: config.toJson(),
    );
  }
}
