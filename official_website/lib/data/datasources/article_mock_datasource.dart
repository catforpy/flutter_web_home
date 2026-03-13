import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 文章 Mock 数据源
class ArticleMockDatasource {
  /// 获取文章列表
  static List<Article> getArticles({
    String? categoryId,
    int page = 1,
    int pageSize = 10,
  }) {
    // 模拟数据
    final allArticles = [
      Article(
        id: '1',
        title: 'Flutter 3.0 正式发布，带来重大更新',
        summary: 'Flutter 3.0 正式发布，带来了许多令人兴奋的新特性和改进...',
        coverImage: 'https://via.placeholder.com/300x200',
        categoryId: '3',
        status: ArticleStatus.published,
        viewCount: 1234,
        likeCount: 56,
        commentCount: 23,
        publishTime: DateTime.now().subtract(const Duration(hours: 2)),
        type: ArticleType.article,
        images: [
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
        ],
      ),
      Article(
        id: '2',
        title: '深入理解 Dart 异步编程',
        summary: 'Dart 的异步编程模型非常强大，本文将深入讲解...',
        coverImage: 'https://via.placeholder.com/300x200',
        categoryId: '3',
        status: ArticleStatus.published,
        viewCount: 2345,
        likeCount: 89,
        commentCount: 45,
        publishTime: DateTime.now().subtract(const Duration(hours: 5)),
        type: ArticleType.video,
        videoDuration: 332,
      ),
      Article(
        id: '3',
        title: '2023年全球经济形势分析',
        summary: '本文分析了2023年全球经济的主要趋势和挑战...',
        coverImage: 'https://via.placeholder.com/300x200',
        categoryId: '4',
        status: ArticleStatus.published,
        viewCount: 3456,
        likeCount: 123,
        commentCount: 67,
        publishTime: DateTime.now().subtract(const Duration(days: 1)),
        type: ArticleType.multipleImages,
        images: [
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
        ],
      ),
      Article(
        id: '4',
        title: '健康生活方式的养成指南',
        summary: '养成健康的生活方式对于每个人都很重要...',
        coverImage: 'https://via.placeholder.com/300x200',
        categoryId: '5',
        status: ArticleStatus.published,
        viewCount: 4567,
        likeCount: 234,
        commentCount: 89,
        publishTime: DateTime.now().subtract(const Duration(days: 2)),
        type: ArticleType.article,
        isPremium: true,
        price: 9900, // 99.00元
      ),
      Article(
        id: '5',
        title: '最新科技产品推荐',
        summary: '本文推荐了一些最新最热的科技产品...',
        coverImage: 'https://via.placeholder.com/300x200',
        categoryId: '3',
        status: ArticleStatus.published,
        viewCount: 5678,
        likeCount: 345,
        commentCount: 123,
        publishTime: DateTime.now().subtract(const Duration(days: 3)),
        type: ArticleType.multipleImages,
        images: [
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
          'https://via.placeholder.com/300x200',
        ],
      ),
    ];

    // 按分类筛选
    var filteredArticles = allArticles;
    if (categoryId != null) {
      filteredArticles = allArticles
          .where((article) => article.categoryId == categoryId)
          .toList();
    }

    // 分页
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= filteredArticles.length) {
      return [];
    }

    return filteredArticles.sublist(
      start,
      end.clamp(0, filteredArticles.length),
    );
  }

  /// 获取文章详情
  static Article? getArticleById(String id) {
    final articles = getArticles();
    try {
      return articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取分类列表
  static List<ArticleCategory> getCategories() {
    return [
      const ArticleCategory(
        id: '1',
        name: '推荐',
        sortOrder: 0,
        articleCount: 23,
      ),
      const ArticleCategory(
        id: '2',
        name: '热点',
        sortOrder: 1,
        articleCount: 45,
      ),
      const ArticleCategory(
        id: '3',
        name: '科技',
        sortOrder: 2,
        articleCount: 67,
      ),
      const ArticleCategory(
        id: '4',
        name: '财经',
        sortOrder: 3,
        articleCount: 34,
      ),
      const ArticleCategory(
        id: '5',
        name: '生活',
        sortOrder: 4,
        articleCount: 56,
      ),
    ];
  }

  /// 获取分类详情
  static ArticleCategory? getCategoryById(String id) {
    final categories = getCategories();
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 添加分类
  static ArticleCategory addCategory(String name, int sortOrder) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return ArticleCategory(
      id: id,
      name: name,
      sortOrder: sortOrder,
      articleCount: 0,
    );
  }

  /// 更新分类
  static bool updateCategory(ArticleCategory category) {
    // Mock 实现，返回 true 表示成功
    return true;
  }

  /// 删除分类
  static bool deleteCategory(String id) {
    // Mock 实现，返回 true 表示成功
    return true;
  }

  /// 获取文章管理配置
  static ArticleManagementConfig getArticleManagementConfig() {
    return ArticleManagementConfig(
      categories: getCategories(),
      rewardEnabled: true,
      listStyle: ArticleListStyle.imageTopTextBottom,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// 保存文章管理配置
  static bool saveArticleManagementConfig(ArticleManagementConfig config) {
    // Mock 实现，返回 true 表示成功
    return true;
  }
}
