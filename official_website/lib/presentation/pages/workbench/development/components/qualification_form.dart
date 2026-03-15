import 'package:flutter/material.dart';

/// 资质上传表单
class QualificationForm extends StatefulWidget {
  final String category;
  final String subCategory;
  final VoidCallback onBack;

  const QualificationForm({
    super.key,
    required this.category,
    required this.subCategory,
    required this.onBack,
  });

  @override
  State<QualificationForm> createState() => _QualificationFormState();
}

class _QualificationFormState extends State<QualificationForm> {
  // 选中的资质选项
  int? _selectedQualification;

  // 是否已上传文件
  bool _hasUploadedFile = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 服务类目确认
          _buildCategorySelectRow(),
          const SizedBox(height: 24),

          // 适用范围说明
          _buildScopeInfoRow(),
          const SizedBox(height: 24),

          // 选择资质
          _buildQualificationSelectRow(),
          const SizedBox(height: 24),

          // 资质文件上传
          _buildFileUploadRow(),
        ],
      ),
    );
  }

  /// 构建服务类目确认行
  Widget _buildCategorySelectRow() {
    return Row(
      children: [
        const SizedBox(
          width: 100,
          child: Text(
            '服务类目',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        Container(
          width: 400,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.category} > ${widget.subCategory}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建适用范围说明行
  Widget _buildScopeInfoRow() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '适用范围',
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
                '适用于提供电台/网络电台/FM/广播收听平台/音频节目等服务。',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  height: 1.6,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '注：',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '1.如提供时政信息服务，需补充：时政信息类目；\n'
                '2.选择该类目后首次提交代码审核，需经当地互联网主管机关审核确认，预计审核时长7天左右。',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
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
              const Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(text: '上传原件或复印件，复印件务必加盖公司公章，文件格式为'),
                    TextSpan(
                      text: 'jpg、jpeg、bmp、gif或png',
                      style: TextStyle(color: Color(0xFF1890FF)),
                    ),
                    TextSpan(text: '，文件大小'),
                    TextSpan(
                      text: '不超过10M',
                      style: TextStyle(color: Color(0xFFFF4D4F)),
                    ),
                    TextSpan(text: '，可拼图上传。'),
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
}
