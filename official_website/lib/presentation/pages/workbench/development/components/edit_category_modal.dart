import 'package:flutter/material.dart';
import 'qualification_form.dart';

/// 修改类目弹窗
class EditCategoryModal extends StatefulWidget {
  final String categoryName;

  const EditCategoryModal({
    super.key,
    required this.categoryName,
  });

  @override
  State<EditCategoryModal> createState() => _EditCategoryModalState();
}

class _EditCategoryModalState extends State<EditCategoryModal> {
  // 选中的资质选项
  int? _selectedQualification;

  // 是否已上传文件
  bool _hasUploadedFile = false;

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
              child: _buildQualificationForm(),
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
            '修改类目',
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
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '当前类目：${widget.categoryName}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
      ),
    );
  }

  /// 构建资质表单
  Widget _buildQualificationForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 选择资质
          _buildQualificationSelectRow(),
          const SizedBox(height: 24),

          // 资质文件上传
          _buildFileUploadRow(),
        ],
      ),
    );
  }

  /// 构建选择资质行
  Widget _buildQualificationSelectRow() {
    return Row(
      children: [
        const SizedBox(
          width: 100,
          child: Text(
            '选择资质',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '2选1即可',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // 选项1
                  _buildRadioOption(
                    value: 0,
                    label: '《信息网络传播视听节目许可证》',
                  ),
                  const SizedBox(width: 40),

                  // 选项2
                  _buildRadioOption(
                    value: 1,
                    label: '《广播电视节目制作经营许可证》',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建单选按钮选项
  Widget _buildRadioOption({required int value, required String label}) {
    final isSelected = _selectedQualification == value;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedQualification = value;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 圆圈
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF52C41A) : const Color(0xFFDDDDDD),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF52C41A),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),

            // 文字
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建文件上传行
  Widget _buildFileUploadRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 100,
          child: Text(
            '资质文件',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedQualification == 0
                    ? '《信息网络传播视听节目许可证》'
                    : '《广播电视节目制作经营许可证》',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(text: '上传原件或复印件，复印件务必加盖公司公章，文件格式为'),
                    TextSpan(
                      text: 'jpg、jpeg、bmp、gif或png',
                      style: TextStyle(color: Color(0xFF1890FF)),
                    ),
                    const TextSpan(text: '，文件大小'),
                    TextSpan(
                      text: '不超过10M',
                      style: TextStyle(color: Color(0xFFFF4D4F)),
                    ),
                    const TextSpan(text: '，可拼图上传。'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasUploadedFile = true;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.attach_file,
                          size: 16,
                          color: Color(0xFF333333),
                        ),
                        const SizedBox(width: 4),
                        _hasUploadedFile
                            ? const Text(
                                '已上传',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF52C41A),
                                ),
                              )
                            : const Text(
                                '上传文件',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_hasUploadedFile) ...[
                const SizedBox(height: 8),
                const Text(
                  '示例文件.jpg (2.3MB)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
                // TODO: 提交修改
                debugPrint('修改类目资质：${widget.categoryName}');
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

/// 显示修改类目弹窗
void showEditCategoryModal(BuildContext context, String categoryName) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => EditCategoryModal(categoryName: categoryName),
  );
}
