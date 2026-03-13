import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/article/article_event.dart';
import 'package:official_website/application/blocs/article/article_state.dart';
import 'package:official_website/domain/repositories/article_repository.dart';

/// 文章管理 BLoC
class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository repository;

  ArticleBloc({required this.repository}) : super(const ArticleInitial()) {
    on<LoadArticlesEvent>(_onLoadArticles);
    on<LoadArticleDetailEvent>(_onLoadArticleDetail);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<UpdateListStyleEvent>(_onUpdateListStyle);
    on<ToggleRewardEvent>(_onToggleReward);
    on<SaveConfigEvent>(_onSaveConfig);
  }

  Future<void> _onLoadArticles(
    LoadArticlesEvent event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());

    final result = await repository.getArticles(
      categoryId: event.categoryId,
      page: event.page,
      pageSize: event.pageSize,
    );

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (articles) => emit(ArticlesLoaded(
        articles: articles,
        page: event.page,
        hasMore: articles.length >= event.pageSize,
      )),
    );
  }

  Future<void> _onLoadArticleDetail(
    LoadArticleDetailEvent event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());

    final result = await repository.getArticleById(event.articleId);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (article) {
        // 返回文章详情，这里简化处理
        emit(ArticlesLoaded(
          articles: [article],
          page: 1,
          hasMore: false,
        ));
      },
    );
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());

    final result = await repository.getCategories();

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (categories) => emit(CategoriesLoaded(
        categories: categories,
        selectedCategoryId: categories.isNotEmpty ? categories.first.id : null,
      )),
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final result = await repository.addCategory(event.name, event.sortOrder);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (newCategory) {
        final updatedCategories = [...currentState.categories, newCategory];
        final updatedConfig = currentState.config.copyWith(
          categories: updatedCategories,
        );

        emit(currentState.copyWith(
          categories: updatedCategories,
          config: updatedConfig,
        ));
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final result = await repository.updateCategory(event.category);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (_) {
        final updatedCategories = currentState.categories.map((cat) {
          return cat.id == event.category.id ? event.category : cat;
        }).toList();

        final updatedConfig = currentState.config.copyWith(
          categories: updatedCategories,
        );

        emit(currentState.copyWith(
          categories: updatedCategories,
          config: updatedConfig,
        ));
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final result = await repository.deleteCategory(event.categoryId);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (_) {
        final updatedCategories = currentState.categories
            .where((cat) => cat.id != event.categoryId)
            .toList();

        final updatedConfig = currentState.config.copyWith(
          categories: updatedCategories,
        );

        final newSelectedId = currentState.selectedCategoryId == event.categoryId
            ? (updatedCategories.isNotEmpty ? updatedCategories.first.id : null)
            : currentState.selectedCategoryId;

        emit(currentState.copyWith(
          categories: updatedCategories,
          selectedCategoryId: newSelectedId,
          config: updatedConfig,
        ));
      },
    );
  }

  Future<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    emit(currentState.copyWith(selectedCategoryId: event.categoryId));
  }

  Future<void> _onUpdateListStyle(
    UpdateListStyleEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final updatedConfig = currentState.config.copyWith(
      listStyle: event.listStyle,
    );

    emit(currentState.copyWith(config: updatedConfig));
  }

  Future<void> _onToggleReward(
    ToggleRewardEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final updatedConfig = currentState.config.copyWith(
      rewardEnabled: event.enabled,
    );

    emit(currentState.copyWith(config: updatedConfig));
  }

  Future<void> _onSaveConfig(
    SaveConfigEvent event,
    Emitter<ArticleState> emit,
  ) async {
    if (state is! ArticleManagementLoaded) return;

    final currentState = state as ArticleManagementLoaded;

    final result = await repository.saveArticleManagementConfig(currentState.config);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (_) => emit(currentState), // 保持当前状态
    );
  }

  /// 初始化文章管理页面
  Future<void> initializeManagement(Emitter<ArticleState> emit) async {
    // 加载配置
    final configResult = await repository.getArticleManagementConfig();

    configResult.fold(
      (failure) => emit(ArticleError(failure.message)),
      (config) async {
        // 加载文章列表
        final articlesResult = await repository.getArticles(
          categoryId: config.categories.firstOrNull?.id,
          page: 1,
          pageSize: 10,
        );

        articlesResult.fold(
          (failure) => emit(ArticleError(failure.message)),
          (articles) => emit(ArticleManagementLoaded(
            categories: config.categories,
            selectedCategoryId: config.categories.firstOrNull?.id,
            config: config,
            articles: articles,
          )),
        );
      },
    );
  }
}
