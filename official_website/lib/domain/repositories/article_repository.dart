import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 文章仓储接口
abstract class ArticleRepository {
  /// 获取文章列表
  Future<Either<Failure, List<Article>>> getArticles({
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  });

  /// 获取文章详情
  Future<Either<Failure, Article>> getArticleById(String id);

  /// 创建文章
  Future<Either<Failure, Article>> createArticle(Article article);

  /// 更新文章
  Future<Either<Failure, Article>> updateArticle(Article article);

  /// 删除文章
  Future<Either<Failure, Unit>> deleteArticle(String id);

  /// 获取分类列表
  Future<Either<Failure, List<ArticleCategory>>> getCategories();

  /// 获取分类详情
  Future<Either<Failure, ArticleCategory>> getCategoryById(String id);

  /// 添加分类
  Future<Either<Failure, ArticleCategory>> addCategory(
    String name,
    int sortOrder,
  );

  /// 更新分类
  Future<Either<Failure, ArticleCategory>> updateCategory(
    ArticleCategory category,
  );

  /// 删除分类
  Future<Either<Failure, Unit>> deleteCategory(String id);

  /// 获取文章管理配置
  Future<Either<Failure, ArticleManagementConfig>> getArticleManagementConfig();

  /// 保存文章管理配置
  Future<Either<Failure, Unit>> saveArticleManagementConfig(
    ArticleManagementConfig config,
  );
}
