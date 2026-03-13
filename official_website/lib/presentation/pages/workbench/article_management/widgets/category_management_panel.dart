import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/article/article_bloc.dart';
import 'package:official_website/application/blocs/article/article_event.dart';
import 'package:official_website/application/blocs/article/article_state.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 分类管理面板
class CategoryManagementPanel extends StatelessWidget {
  const CategoryManagementPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        if (state is! ArticleManagementLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = state.categories;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '配置操作',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),
              _buildCategoryManagement(context, categories),
              const SizedBox(height: 32),
              const _ListStyleSelector(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryManagement(BuildContext context, List<ArticleCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '管理分类',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '(左侧预览会显示所有分类，手机端可横向滑动，拖动分类可以进行排序)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        _buildAddCategoryButton(context),
        const SizedBox(height: 16),
        _buildCategoryList(context, categories),
      ],
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final newCategory = ArticleCategory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: '',
            sortOrder: context.read<ArticleBloc>().state is ArticleManagementLoaded
                ? (context.read<ArticleBloc>().state as ArticleManagementLoaded).categories.length
                : 0,
          );
          context.read<ArticleBloc>().add(
                UpdateCategoryEvent(newCategory),
              );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1890FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '添加分类',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<ArticleCategory> categories) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        return _CategoryCard(
          category: category,
          index: index,
          onDelete: () {
            context.read<ArticleBloc>().add(
                  DeleteCategoryEvent(category.id),
                );
          },
          onUpdate: (name) {
            context.read<ArticleBloc>().add(
                  UpdateCategoryEvent(category.copyWith(name: name)),
                );
          },
        );
      }).toList(),
    );
  }
}

class _ListStyleSelector extends StatelessWidget {
  const _ListStyleSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        final currentStyle = state is ArticleManagementLoaded
            ? state.config.listStyle
            : ArticleListStyle.imageTopTextBottom;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '资讯列表展示样式',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: ArticleListStyle.values.map((style) {
                return _StyleRadioItem(
                  label: style.displayName,
                  icon: _getIconForStyle(style),
                  isSelected: currentStyle == style,
                  onTap: () {
                    context.read<ArticleBloc>().add(
                          UpdateListStyleEvent(style),
                        );
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForStyle(ArticleListStyle style) {
    switch (style) {
      case ArticleListStyle.imageTopTextBottom:
        return Icons.image;
      case ArticleListStyle.alternating:
        return Icons.swap_horiz;
      case ArticleListStyle.leftImageRightText:
        return Icons.format_align_left;
      case ArticleListStyle.leftTextRightImage:
        return Icons.format_align_right;
      case ArticleListStyle.advancedFeed:
        return Icons.grid_view;
    }
  }
}

class _CategoryCard extends StatefulWidget {
  final ArticleCategory category;
  final int index;
  final VoidCallback onDelete;
  final Function(String) onUpdate;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: const Icon(
                Icons.close,
                size: 16,
                color: Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '分类名称',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E5E5)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
            ),
            onChanged: widget.onUpdate,
          ),
        ],
      ),
    );
  }
}

class _StyleRadioItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleRadioItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE5E5E5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF999999),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF666666),
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Color(0xFF1890FF),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
