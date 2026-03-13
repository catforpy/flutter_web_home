import 'package:equatable/equatable.dart';

/// 文章分类实体
class ArticleCategory extends Equatable {
  final String id;
  final String name;
  final int sortOrder;
  final int articleCount;

  const ArticleCategory({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.articleCount = 0,
  });

  ArticleCategory copyWith({
    String? id,
    String? name,
    int? sortOrder,
    int? articleCount,
  }) {
    return ArticleCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      articleCount: articleCount ?? this.articleCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sortOrder': sortOrder,
        'articleCount': articleCount,
      };

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      sortOrder: json['sortOrder'] as int,
      articleCount: json['articleCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, sortOrder, articleCount];
}

/// 文章列表展示样式
enum ArticleListStyle {
  imageTopTextBottom('上图下文'),
  alternating('一左一右'),
  leftImageRightText('左图右文'),
  leftTextRightImage('左文右图'),
  advancedFeed('高级版 (信息流)');

  final String displayName;
  const ArticleListStyle(this.displayName);
}

/// 文章管理配置
class ArticleManagementConfig {
  final List<ArticleCategory> categories;
  final bool rewardEnabled;
  final ArticleListStyle listStyle;
  final DateTime lastUpdateTime;
  final bool syncedWithServer;

  const ArticleManagementConfig({
    required this.categories,
    this.rewardEnabled = true,
    this.listStyle = ArticleListStyle.imageTopTextBottom,
    required this.lastUpdateTime,
    this.syncedWithServer = false,
  });

  ArticleManagementConfig copyWith({
    List<ArticleCategory>? categories,
    bool? rewardEnabled,
    ArticleListStyle? listStyle,
    DateTime? lastUpdateTime,
    bool? syncedWithServer,
  }) {
    return ArticleManagementConfig(
      categories: categories ?? this.categories,
      rewardEnabled: rewardEnabled ?? this.rewardEnabled,
      listStyle: listStyle ?? this.listStyle,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      syncedWithServer: syncedWithServer ?? this.syncedWithServer,
    );
  }

  Map<String, dynamic> toJson() => {
        'categories': categories.map((c) => c.toJson()).toList(),
        'rewardEnabled': rewardEnabled,
        'listStyle': listStyle.name,
        'lastUpdateTime': lastUpdateTime.toIso8601String(),
        'syncedWithServer': syncedWithServer,
      };

  factory ArticleManagementConfig.fromJson(Map<String, dynamic> json) {
    return ArticleManagementConfig(
      categories: (json['categories'] as List)
          .map((c) => ArticleCategory.fromJson(c as Map<String, dynamic>))
          .toList(),
      rewardEnabled: json['rewardEnabled'] as bool? ?? true,
      listStyle: ArticleListStyle.values.firstWhere(
        (e) => e.name == json['listStyle'],
        orElse: () => ArticleListStyle.imageTopTextBottom,
      ),
      lastUpdateTime: DateTime.parse(json['lastUpdateTime'] as String),
      syncedWithServer: json['syncedWithServer'] as bool? ?? false,
    );
  }

  /// 默认配置
  static ArticleManagementConfig defaultConfig() {
    return ArticleManagementConfig(
      categories: const [
        ArticleCategory(id: '1', name: '推荐', sortOrder: 0),
        ArticleCategory(id: '2', name: '热点', sortOrder: 1),
        ArticleCategory(id: '3', name: '科技', sortOrder: 2),
        ArticleCategory(id: '4', name: '财经', sortOrder: 3),
        ArticleCategory(id: '5', name: '生活', sortOrder: 4),
      ],
      rewardEnabled: true,
      listStyle: ArticleListStyle.imageTopTextBottom,
      lastUpdateTime: DateTime.now(),
    );
  }
}
