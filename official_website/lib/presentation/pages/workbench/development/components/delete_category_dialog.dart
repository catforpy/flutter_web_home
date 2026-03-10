import 'package:flutter/material.dart';

/// 删除类目确认弹窗
class DeleteCategoryDialog extends StatelessWidget {
  final String categoryName;

  const DeleteCategoryDialog({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
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
            // 标题
            const Text(
              '删除类目',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 24),

            // 提示内容
            Text(
              '确定要删除类目"$categoryName"吗？',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '删除后该类目将变为"审核中"状态，需要重新提交审核。删除操作不可恢复，请谨慎操作。',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFFF4D4F),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 按钮组
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      // TODO: 执行删除操作
                      debugPrint('删除类目：$categoryName');
                    },
                    child: Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '确定删除',
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
          ],
        ),
      ),
    );
  }
}

/// 显示删除类目确认弹窗
void showDeleteCategoryDialog(BuildContext context, String categoryName) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => DeleteCategoryDialog(categoryName: categoryName),
  );
}
