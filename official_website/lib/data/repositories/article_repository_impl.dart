import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/data/datasources/article_mock_datasource.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';
import 'package:official_website/domain/repositories/article_repository.dart';

/// 文章仓储实现
class ArticleRepositoryImpl implements ArticleRepository {
  @override
  Future<Either<Failure, List<Article>>> getArticles({
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final articles = ArticleMockDatasource.getArticles(
        categoryId: categoryId,
        page: page,
        pageSize: pageSize,
      );
      return Right(articles);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleById(String id) async {
    try {
      final article = ArticleMockDatasource.getArticleById(id);
      if (article == null) {
        return const Left(NotFoundFailure(message: '文章不存在'));
      }
      return Right(article);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> createArticle(Article article) async {
    try {
      // Mock 实现
      return Right(article);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Article>> updateArticle(Article article) async {
    try {
      // Mock 实现
      return Right(article);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteArticle(String id) async {
    try {
      // Mock 实现
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleCategory>>> getCategories() async {
    try {
      final categories = ArticleMockDatasource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleCategory>> getCategoryById(String id) async {
    try {
      final category = ArticleMockDatasource.getCategoryById(id);
      if (category == null) {
        return const Left(NotFoundFailure(message: '分类不存在'));
      }
      return Right(category);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleCategory>> addCategory(
    String name,
    int sortOrder,
  ) async {
    try {
      final category = ArticleMockDatasource.addCategory(name, sortOrder);
      return Right(category);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleCategory>> updateCategory(
    ArticleCategory category,
  ) async {
    try {
      final success = ArticleMockDatasource.updateCategory(category);
      if (!success) {
        return const Left(ServerFailure(message: '更新分类失败'));
      }
      return Right(category);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      final success = ArticleMockDatasource.deleteCategory(id);
      if (!success) {
        return const Left(ServerFailure(message: '删除分类失败'));
      }
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleManagementConfig>> getArticleManagementConfig() async {
    try {
      final config = ArticleMockDatasource.getArticleManagementConfig();
      return Right(config);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveArticleManagementConfig(
    ArticleManagementConfig config,
  ) async {
    try {
      final success = ArticleMockDatasource.saveArticleManagementConfig(config);
      if (!success) {
        return const Left(ServerFailure(message: '保存配置失败'));
      }
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
