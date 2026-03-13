/// 文章实体
class Article {
  final String id;
  final String title;
  final String? summary;
  final String? coverImage;
  final String categoryId;
  final ArticleStatus status;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final DateTime publishTime;
  final ArticleType type;
  final List<String>? images;
  final int? videoDuration; // 视频时长(秒)
  final bool isPremium;
  final int? price; // 价格(分)

  const Article({
    required this.id,
    required this.title,
    this.summary,
    this.coverImage,
    required this.categoryId,
    required this.status,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.publishTime,
    this.type = ArticleType.article,
    this.images,
    this.videoDuration,
    this.isPremium = false,
    this.price,
  });

  Article copyWith({
    String? id,
    String? title,
    String? summary,
    String? coverImage,
    String? categoryId,
    ArticleStatus? status,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    DateTime? publishTime,
    ArticleType? type,
    List<String>? images,
    int? videoDuration,
    bool? isPremium,
    int? price,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      coverImage: coverImage ?? this.coverImage,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      publishTime: publishTime ?? this.publishTime,
      type: type ?? this.type,
      images: images ?? this.images,
      videoDuration: videoDuration ?? this.videoDuration,
      isPremium: isPremium ?? this.isPremium,
      price: price ?? this.price,
    );
  }

  /// 格式化价格
  String? get formattedPrice {
    if (price == null) return null;
    return '¥${(price! / 100).toStringAsFixed(2)}';
  }

  /// 格式化视频时长
  String? get formattedVideoDuration {
    if (videoDuration == null) return null;
    final minutes = videoDuration! ~/ 60;
    final seconds = videoDuration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// 文章状态
enum ArticleStatus {
  draft('草稿'),
  published('已发布'),
  archived('已归档');

  final String displayName;
  const ArticleStatus(this.displayName);
}

/// 文章类型
enum ArticleType {
  article('图文'),
  video('视频'),
  multipleImages('多图');

  final String displayName;
  const ArticleType(this.displayName);
}
