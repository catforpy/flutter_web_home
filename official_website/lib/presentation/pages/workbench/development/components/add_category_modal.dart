import 'package:flutter/material.dart';
import 'add_category_selector.dart';
import 'qualification_form.dart';

/// 添加类目弹窗
class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  // 弹窗状态：selector=选择器, qualification=资质上传
  String _modalState = 'selector';

  // 选中的类目
  String? _selectedCategory;
  String? _selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800,
        constraints: const BoxConstraints(minHeight: 500),
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

            // 提示语
            _buildHint(),

            // 主内容区
            Flexible(
              child: _modalState == 'selector'
                  ? AddCategorySelector(
                      onCategorySelected: (category, subCategory) {
                        setState(() {
                          _selectedCategory = category;
                          _selectedSubCategory = subCategory;
                          _modalState = 'qualification';
                        });
                      },
                    )
                  : QualificationForm(
                      category: _selectedCategory ?? '',
                      subCategory: _selectedSubCategory ?? '',
                      onBack: () {
                        setState(() {
                          _modalState = 'selector';
                        });
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '添加类目',
            style: TextStyle(
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

  /// 构建提示语
  Widget _buildHint() {
    return const Padding(
      padding: EdgeInsets.only(left: 24, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '请根据小程序的服务范围，准确选择类目',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
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
                Navigator.of(context).pop();
              },
              child: Container(
                width: 80,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF52C41A),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '确定',
                  style: TextStyle(
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

/// 显示添加类目弹窗
void showAddCategoryModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => const AddCategoryModal(),
  );
}
