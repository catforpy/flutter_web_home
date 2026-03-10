import 'package:flutter/material.dart';

/// 类目选择对话框（用于修改/删除时选择类目）
class CategorySelectDialog extends StatefulWidget {
  final String title;
  final String buttonText;
  final Function(String) onCategorySelected;

  const CategorySelectDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelectDialog> createState() => _CategorySelectDialogState();
}

class _CategorySelectDialogState extends State<CategorySelectDialog> {
  int? _selectedIndex;

  // 类目列表
  final List<Map<String, dynamic>> _categories = [
    {'name': '工具类 > 信息查询', 'approved': true},
    {'name': '生活服务 > 家政服务', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 美甲', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 美容', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 美睫', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 美发', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 纹身', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 祛痘', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 纤体瘦身', 'approved': true},
    {'name': '生活服务 > 丽人服务 > spa', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 舞蹈', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 瑜伽', 'approved': true},
    {'name': '生活服务 > 丽人服务 > 其他', 'approved': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            _buildHeader(),

            // 类目列表
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(index);
                },
              ),
            ),

            // 底部按钮
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                size: 24,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建类目项
  Widget _buildCategoryItem(int index) {
    final category = _categories[index];
    final isSelected = _selectedIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF5F5F5) : Colors.white,
            border: const Border(
              bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
            ),
          ),
          child: Row(
            children: [
              // 选中图标
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 20,
                color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFDDDDDD),
              ),
              const SizedBox(width: 12),

              // 类目名称
              Expanded(
                child: Text(
                  category['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),

              // 状态标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: category['approved']
                      ? const Color(0xFFF0F9FF)
                      : const Color(0xFFFFF7E6),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: category['approved']
                        ? const Color(0xFF52C41A)
                        : const Color(0xFFFFA940),
                    width: 1,
                  ),
                ),
                child: Text(
                  category['approved'] ? '已审核' : '审核中',
                  style: TextStyle(
                    fontSize: 11,
                    color: category['approved']
                        ? const Color(0xFF52C41A)
                        : const Color(0xFFFFA940),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildFooter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 取消按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 80,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 确定按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (_selectedIndex != null) {
                  Navigator.of(context).pop();
                  widget.onCategorySelected(_categories[_selectedIndex!]['name']);
                }
              },
              child: Container(
                width: 80,
                height: 36,
                decoration: BoxDecoration(
                  color: _selectedIndex != null
                      ? const Color(0xFF1890FF)
                      : const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 显示类目选择对话框
void showCategorySelectDialog(
  BuildContext context,
  String title,
  String buttonText,
  Function(String) onCategorySelected,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => CategorySelectDialog(
      title: title,
      buttonText: buttonText,
      onCategorySelected: onCategorySelected,
    ),
  );
}
