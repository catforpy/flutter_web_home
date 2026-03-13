import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 文章事件基类
abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object?> get props => [];
}

/// 加载文章列表
class LoadArticlesEvent extends ArticleEvent {
  final String? categoryId;
  final int page;
  final int pageSize;

  const LoadArticlesEvent({
    this.categoryId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [categoryId, page, pageSize];
}

/// 加载文章详情
class LoadArticleDetailEvent extends ArticleEvent {
  final String articleId;

  const LoadArticleDetailEvent(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

/// 加载分类列表
class LoadCategoriesEvent extends ArticleEvent {
  const LoadCategoriesEvent();
}

/// 添加分类
class AddCategoryEvent extends ArticleEvent {
  final String name;
  final int sortOrder;

  const AddCategoryEvent(this.name, this.sortOrder);

  @override
  List<Object?> get props => [name, sortOrder];
}

/// 更新分类
class UpdateCategoryEvent extends ArticleEvent {
  final ArticleCategory category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// 删除分类
class DeleteCategoryEvent extends ArticleEvent {
  final String categoryId;

  const DeleteCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// 选择分类
class SelectCategoryEvent extends ArticleEvent {
  final String categoryId;

  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// 更新列表样式
class UpdateListStyleEvent extends ArticleEvent {
  final ArticleListStyle listStyle;

  const UpdateListStyleEvent(this.listStyle);

  @override
  List<Object?> get props => [listStyle];
}

/// 切换打赏功能
class ToggleRewardEvent extends ArticleEvent {
  final bool enabled;

  const ToggleRewardEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// 保存配置
class SaveConfigEvent extends ArticleEvent {
  const SaveConfigEvent();
}
