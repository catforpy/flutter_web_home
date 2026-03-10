import 'package:flutter/material.dart';
import 'case_card_grid_widget.dart';

/// 案例分类标签栏组件
/// 支持多标签切换，带悬停和选中动画
/// 支持二级行业标签横向滑动
class CaseCategoryWidget extends StatefulWidget {
  const CaseCategoryWidget({super.key});

  @override
  State<CaseCategoryWidget> createState() => _CaseCategoryWidgetState();
}

class _CaseCategoryWidgetState extends State<CaseCategoryWidget> {
  // 当前选中的一级标签索引
  int _selectedPrimaryIndex = 0;

  // 当前选中的二级标签索引
  int _selectedSecondaryIndex = 0;

  // 一级分类列表
  final List<_PrimaryCategoryItem> _primaryCategories = const [
    _PrimaryCategoryItem(
      label: '企业官网定制',
      icon: Icons.business,
      categoryKey: 'website',
    ),
    _PrimaryCategoryItem(
      label: '小程序app开发',
      icon: Icons.phone_android,
      categoryKey: 'app',
    ),
  ];

  // 二级行业列表（所有行业）- 始终显示所有选项
  final List<_IndustryItem> _allIndustries = const [
    _IndustryItem(
      label: '物流交通',
      industryKey: 'logistics',
    ),
    _IndustryItem(
      label: '科技培训',
      industryKey: 'tech_training',
    ),
    _IndustryItem(
      label: '餐饮生活',
      industryKey: 'catering',
    ),
    _IndustryItem(
      label: '生活娱乐',
      industryKey: 'entertainment',
    ),
    _IndustryItem(
      label: '电商平台',
      industryKey: 'ecommerce',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 标签栏容器
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              // 标题
              const Text(
                '精选案例',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 40),

              // 一级标签栏
              Wrap(
                spacing: 20,
                children: List.generate(_primaryCategories.length, (index) {
                  return _CategoryTab(
                    label: _primaryCategories[index].label,
                    icon: _primaryCategories[index].icon,
                    isSelected: _selectedPrimaryIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedPrimaryIndex = index;
                        _selectedSecondaryIndex = 0; // 重置二级标签
                      });
                    },
                  );
                }),
              ),

              const SizedBox(height: 30),

              // 二级行业标签栏（横向滑动，居中显示）
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 让Row根据内容大小调整
                    children: List.generate(_allIndustries.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: 16,
                          left: index == 0 ? 0 : 0,
                        ),
                        child: _IndustryTab(
                          label: _allIndustries[index].label,
                          isSelected: _selectedSecondaryIndex == index,
                          onTap: () {
                            setState(() {
                              _selectedSecondaryIndex = index;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 案例卡片网格（根据选中的标签显示对应分类和行业）
        CaseCardGridWidget(
          category: _primaryCategories[_selectedPrimaryIndex].categoryKey,
          industry: _allIndustries[_selectedSecondaryIndex].industryKey,
        ),
      ],
    );
  }
}

/// 一级分类标签组件
class _CategoryTab extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSelected || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFD93025) // 选中：红色背景
                : Colors.white, // 未选中：白色背景
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFD93025)
                  : const Color(0xFFE0E0E0),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isHovered ? 0.1 : 0.05,
                ),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isSelected
                    ? Colors.white // 选中：白色图标
                    : const Color(0xFF666666), // 未选中：灰色图标
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isSelected
                      ? Colors.white // 选中：白色文字
                      : const Color(0xFF333333), // 未选中：黑色文字
                  fontWeight: isActive
                      ? FontWeight.bold // 悬停或选中时加粗
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 二级行业标签组件
class _IndustryTab extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _IndustryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_IndustryTab> createState() => _IndustryTabState();
}

class _IndustryTabState extends State<_IndustryTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFD93025) // 选中：红色背景
                : _isHovered
                    ? const Color(0xFFF5F5F5) // 悬停：浅灰背景
                    : Colors.white, // 未选中：白色背景
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFD93025)
                  : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              color: widget.isSelected
                  ? Colors.white
                  : const Color(0xFF333333),
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 一级分类数据项
class _PrimaryCategoryItem {
  final String label;
  final IconData icon;
  final String categoryKey;

  const _PrimaryCategoryItem({
    required this.label,
    required this.icon,
    required this.categoryKey,
  });
}

/// 二级行业数据项
class _IndustryItem {
  final String label;
  final String industryKey;

  const _IndustryItem({
    required this.label,
    required this.industryKey,
  });
}
