import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/article/article_bloc.dart';
import 'package:official_website/application/blocs/article/article_event.dart';
import 'package:official_website/application/blocs/article/article_state.dart';
import 'package:official_website/data/repositories/article_repository_impl.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';
import 'package:official_website/presentation/pages/workbench/article_management/widgets/phone_preview_widget.dart';
import 'package:official_website/presentation/pages/workbench/article_management/widgets/category_management_panel.dart';

/// 文章管理页面 - 重构版
class ArticleManagementPageRefactored extends StatelessWidget {
  final bool showFullNavigation;

  const ArticleManagementPageRefactored({
    super.key,
    this.showFullNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(
        repository: ArticleRepositoryImpl(),
      )..add(const LoadCategoriesEvent()),
      child: const _ArticleManagementView(),
    );
  }
}

class _ArticleManagementView extends StatelessWidget {
  const _ArticleManagementView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArticleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ArticleBloc>().add(const LoadCategoriesEvent());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (state is! CategoriesLoaded && state is! ArticleManagementLoaded) {
            return const Center(child: Text('无数据'));
          }

          final categories = state is CategoriesLoaded
              ? state.categories
              : (state as ArticleManagementLoaded).categories;

          final selectedCategoryId = state is CategoriesLoaded
              ? state.selectedCategoryId
              : (state as ArticleManagementLoaded).selectedCategoryId;

          final config = state is ArticleManagementLoaded
              ? state.config
              : null;

          final articles = state is ArticleManagementLoaded
              ? state.articles
              : <Article>[];

          return _buildContent(
            context,
            categories,
            selectedCategoryId,
            config,
            articles,
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ArticleCategory> categories,
    String? selectedCategoryId,
    ArticleManagementConfig? config,
    List<Article> articles,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧一级导航栏（200px）
          _buildSidebar(context),

          // 二级标签栏（垂直，120px）
          _buildSecondLevelSidebar(context),

          // 主内容区
          Expanded(
            child: Column(
              children: [
                // 顶部标题栏
                _buildTopHeader(context),

                // 主内容区
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildMainContent(context, categories, selectedCategoryId, config, articles),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 200,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.store, '管理中心', false, false),
                _buildMenuItem(context, Icons.extension, '模块管理', true, true,
                    submenu: ['文章管理', '留言管理', '启动图管理']),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFF1A9B8E)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '唐极课得',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFCCCCCC),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    bool hasSubmenu, {
    List<String>? submenu,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2D343A) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasSubmenu && submenu != null)
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: submenu.map((subItem) {
                return Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    subItem,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSecondLevelSidebar(BuildContext context) {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF3A3F47),
        border: Border(
          right: BorderSide(color: Color(0xFF4E5562), width: 1),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSecondLevelTabItem(context, Icons.category, '分类管理', true),
          _buildSecondLevelTabItem(context, Icons.article, '文章列表', false),
          _buildSecondLevelTabItem(context, Icons.slideshow, '轮播图管理', false),
        ],
      ),
    );
  }

  Widget _buildSecondLevelTabItem(BuildContext context, IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1A9B8E) : Colors.transparent,
        border: isActive
            ? const Border(
                left: BorderSide(color: Color(0xFF1A9B8E), width: 4),
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : const Color(0xFFCCCCCC),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white : const Color(0xFFCCCCCC),
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFF1A9B8E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            '唐极课得 管理系统 | 文章管理',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          _buildHeaderButton(context, '保存', true),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(BuildContext context, String text, bool isPrimary) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isPrimary
            ? () {
                context.read<ArticleBloc>().add(const SaveConfigEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('配置已保存'),
                    backgroundColor: Color(0xFF52C41A),
                  ),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isPrimary ? const Color(0xFF1A9B8E) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    List<ArticleCategory> categories,
    String? selectedCategoryId,
    ArticleManagementConfig? config,
    List<Article> articles,
  ) {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(),
          const SizedBox(height: 24),
          _buildTopControlBar(context),
          const SizedBox(height: 24),
          SizedBox(
            height: 850,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧：实时预览区
                Expanded(
                  flex: 1,
                  child: PhonePreviewWidget(
                    categories: categories,
                    selectedCategoryId: selectedCategoryId,
                    listStyle: config?.listStyle ?? ArticleListStyle.imageTopTextBottom,
                    articles: articles,
                  ),
                ),
                const SizedBox(width: 24),
                // 右侧：配置操作区
                Expanded(
                  flex: 1,
                  child: const CategoryManagementPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        _buildBreadcrumbItem('管理首页'),
        const Text(' / ', style: TextStyle(color: Color(0xFF999999))),
        _buildBreadcrumbItem('模块管理'),
        const Text(' / ', style: TextStyle(color: Color(0xFF999999))),
        _buildBreadcrumbItem('文章管理', isActive: true),
      ],
    );
  }

  Widget _buildBreadcrumbItem(String text, {bool isActive = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: isActive ? const Color(0xFF333333) : const Color(0xFF1890FF),
        fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTopControlBar(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        final rewardEnabled = state is ArticleManagementLoaded
            ? state.config.rewardEnabled
            : true;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  _buildTab(context, '幻灯图管理', false),
                  const SizedBox(width: 8),
                  _buildTab(context, '分类链接', true),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Text(
                    '是否启用打赏',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: rewardEnabled,
                    onChanged: (value) {
                      context.read<ArticleBloc>().add(ToggleRewardEvent(value));
                    },
                    activeColor: const Color(0xFF52C41A),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(BuildContext context, String text, bool isActive) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1890FF) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}
