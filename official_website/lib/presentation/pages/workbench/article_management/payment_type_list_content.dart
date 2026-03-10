import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 付费会员类型列表内容组件
class PaymentTypeListContent extends StatefulWidget {
  const PaymentTypeListContent({super.key});

  @override
  State<PaymentTypeListContent> createState() => _PaymentTypeListContentState();
}

class _PaymentTypeListContentState extends State<PaymentTypeListContent> {
  // 会员类型列表数据
  final List<Map<String, dynamic>> _memberTypes = [
    {
      'id': '1',
      'title': '日卡',
      'price': 9.9,
      'type': '日卡',
      'duration': '1',
      'createTime': DateTime(2026, 3, 8, 10, 30),
    },
    {
      'id': '2',
      'title': '月卡',
      'price': 99.0,
      'type': '月卡',
      'duration': '1',
      'createTime': DateTime(2026, 3, 7, 14, 20),
    },
    {
      'id': '3',
      'title': '年卡',
      'price': 999.0,
      'type': '年卡',
      'duration': '1',
      'createTime': DateTime(2026, 3, 6, 9, 15),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  // 表单控制器
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String _selectedType = '日卡';

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 顶部按钮区
            _buildTopBar(),

            const SizedBox(height: 16),

            // 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 构建顶部按钮栏
  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            _showAddTypeDialog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A9B8E),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '添加会员类型',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建数据表格
  Widget _buildDataTable() {
    if (_memberTypes.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('暂无会员类型', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          ...List.generate(_memberTypes.length, (index) {
            return _buildTableRow(_memberTypes[index], index);
          }),
        ],
      ),
    );
  }

  /// 构建表头
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('标题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('价格', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('类型', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 3, child: Text('创建时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('操作', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> memberType, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _hoveredIndex == index
              ? const Color(0xFFE6F7FF)
              : (index % 2 == 0 ? Colors.white : const Color(0xFFF9F9F9)),
          border: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
        ),
        child: Row(
          children: [
            // 标题
            Expanded(
              flex: 2,
              child: Text(
                memberType['title'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
            ),

            // 价格
            Expanded(
              flex: 2,
              child: Text(
                '¥ ${(memberType['price'] as double).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Color(0xFFFF4D4F), fontWeight: FontWeight.w500),
              ),
            ),

            // 类型
            Expanded(
              flex: 2,
              child: Text(
                memberType['type'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 时间
            Expanded(
              flex: 2,
              child: Text(
                '${memberType['duration']}个${memberType['type']}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 创建时间
            Expanded(
              flex: 3,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(memberType['createTime']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 操作
            Expanded(
              flex: 2,
              child: Wrap(
                spacing: 16,
                children: [
                  _buildActionLink('编辑', const Color(0xFF1890FF), () {
                    _showEditTypeDialog(memberType);
                  }),
                  _buildActionLink('删除', const Color(0xFFFF4D4F), () {
                    _showDeleteConfirmDialog(memberType);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建操作链接
  Widget _buildActionLink(String text, Color color, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  /// 显示添加会员类型对话框
  void _showAddTypeDialog() {
    _titleController.clear();
    _priceController.clear();
    _durationController.clear();
    _selectedType = '日卡';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                const Text(
                  '添加分类',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
                ),
                const Divider(height: 24),

                // 标题输入框
                _buildFormField('标题', '请填写标题，例如：日卡、月卡、年卡', _titleController),
                const SizedBox(height: 16),

                // 价格输入框
                _buildFormField('价格', '请填写价格', _priceController, keyboardType: TextInputType.number),
                const SizedBox(height: 16),

                // 类型下拉选择框
                _buildTypeDropdown(),
                const SizedBox(height: 16),

                // 时间输入框
                _buildFormField(
                  '时间',
                  '请填写会员卡时长，表示N天，N个月，N年',
                  _durationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // 底部按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildDialogButton('取消', const Color(0xFF999999), () {
                      Navigator.of(dialogContext).pop();
                    }),
                    const SizedBox(width: 12),
                    _buildDialogButton('确定', const Color(0xFF1A9B8E), () {
                      _handleSubmit(dialogContext);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示编辑会员类型对话框
  void _showEditTypeDialog(Map<String, dynamic> memberType) {
    _titleController.text = memberType['title'];
    _priceController.text = (memberType['price'] as double).toString();
    _durationController.text = memberType['duration'];
    _selectedType = memberType['type'];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                const Text(
                  '编辑分类',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
                ),
                const Divider(height: 24),

                // 标题输入框
                _buildFormField('标题', '请填写标题，例如：日卡、月卡、年卡', _titleController),
                const SizedBox(height: 16),

                // 价格输入框
                _buildFormField('价格', '请填写价格', _priceController, keyboardType: TextInputType.number),
                const SizedBox(height: 16),

                // 类型下拉选择框
                _buildTypeDropdown(),
                const SizedBox(height: 16),

                // 时间输入框
                _buildFormField(
                  '时间',
                  '请填写会员卡时长，表示N天，N个月，N年',
                  _durationController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // 底部按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildDialogButton('取消', const Color(0xFF999999), () {
                      Navigator.of(dialogContext).pop();
                    }),
                    const SizedBox(width: 12),
                    _buildDialogButton('确定', const Color(0xFF1A9B8E), () {
                      _handleEdit(dialogContext, memberType);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建表单字段
  Widget _buildFormField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  /// 构建类型下拉选择框
  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('类型', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: const ['日卡', '月卡', '年卡'].map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 构建对话框按钮
  Widget _buildDialogButton(String text, Color color, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// 处理添加提交
  void _handleSubmit(BuildContext dialogContext) {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入标题')),
      );
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入价格')),
      );
      return;
    }
    if (_durationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入时间')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入有效的价格')),
      );
      return;
    }

    Navigator.of(dialogContext).pop();
    setState(() {
      _memberTypes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'price': price,
        'type': _selectedType,
        'duration': _durationController.text.trim(),
        'createTime': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加成功')),
    );
  }

  /// 处理编辑提交
  void _handleEdit(BuildContext dialogContext, Map<String, dynamic> memberType) {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入标题')),
      );
      return;
    }
    if (_priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入价格')),
      );
      return;
    }
    if (_durationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入时间')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('请输入有效的价格')),
      );
      return;
    }

    Navigator.of(dialogContext).pop();
    setState(() {
      final index = _memberTypes.indexWhere((m) => m['id'] == memberType['id']);
      if (index != -1) {
        _memberTypes[index] = {
          ...memberType,
          'title': _titleController.text.trim(),
          'price': price,
          'type': _selectedType,
          'duration': _durationController.text.trim(),
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('修改成功')),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(Map<String, dynamic> memberType) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除会员类型"${memberType['title']}"吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _memberTypes.removeWhere((m) => m['id'] == memberType['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('删除成功')),
                );
              },
              child: const Text('确定', style: TextStyle(color: Color(0xFFFF4D4F))),
            ),
          ],
        );
      },
    );
  }
}
