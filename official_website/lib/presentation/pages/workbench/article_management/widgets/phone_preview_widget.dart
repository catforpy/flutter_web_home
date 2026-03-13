import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/article.dart';
import 'package:official_website/domain/entities/article_category.dart';

/// 手机预览器组件
class PhonePreviewWidget extends StatelessWidget {
  final List<ArticleCategory> categories;
  final String? selectedCategoryId;
  final ArticleListStyle listStyle;
  final List<Article> articles;

  const PhonePreviewWidget({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.listStyle,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '实时预览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildPhonePreview(),
        ],
      ),
    );
  }

  Widget _buildPhonePreview() {
    return SizedBox(
      width: 375,
      height: 750,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFF333333), width: 8),
        ),
        child: Column(
          children: [
            _buildPhoneStatusBar(),
            _buildPhoneNavigationBar(),
            _buildPhoneCategoryTabs(),
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: _buildArticleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '19:14',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
              const SizedBox(width: 4),
              const Text('中国移动 4G', style: TextStyle(fontSize: 12, color: Colors.black)),
              const SizedBox(width: 8),
              const Text('61%', style: TextStyle(fontSize: 12, color: Colors.black)),
              const Icon(Icons.battery_full, size: 16, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNavigationBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          const Text(
            '分类预览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.more_horiz, size: 24, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildPhoneCategoryTabs() {
    final validCategories = categories.where((cat) => cat.name.trim().isNotEmpty).toList();

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: validCategories.length,
        itemBuilder: (context, index) {
          final category = validCategories[index];
          final originalIndex = categories.indexWhere((cat) => cat.id == category.id);
          final isSelected = originalIndex.toString() == selectedCategoryId;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1890FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : const Color(0xFF666666),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleList() {
    // 根据列表样式返回不同的列表
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: articles.length > 3 ? 3 : articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(article, index);
      },
    );
  }

  Widget _buildArticleCard(Article article, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              color: const Color(0xFFE5E5E5),
              child: article.coverImage != null
                  ? Image.network(
                      article.coverImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 48, color: Color(0xFF999999));
                      },
                    )
                  : const Icon(Icons.image, size: 48, color: Color(0xFF999999)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  article.summary ?? '文章相关简介内容，这里显示文章的摘要信息...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
