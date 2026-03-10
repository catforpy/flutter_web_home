import 'package:flutter/material.dart';

/// 运费计费方式
enum FreightType {
  byWeight('按重量', Icons.scale),
  byQuantity('按件数', Icons.inventory_2_outlined),
  byVolume('按体积', Icons.view_in_ar),
  byPrice('按金额', Icons.payments_outlined);

  final String label;
  final IconData icon;

  const FreightType(this.label, this.icon);
}

/// 运费模板
class FreightTemplate {
  final String id;
  final String name;
  final FreightType type;
  final bool isFreeShipping; // 是否包邮
  final double? freeShippingAmount; // 包邮金额（按金额包邮时）
  final List<FreightRule> rules; // 运费规则
  final DateTime createTime;
  final int useCount; // 使用次数

  FreightTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.isFreeShipping,
    this.freeShippingAmount,
    required this.rules,
    required this.createTime,
    this.useCount = 0,
  });

  /// 复制并更新
  FreightTemplate copyWith({
    String? id,
    String? name,
    FreightType? type,
    bool? isFreeShipping,
    double? freeShippingAmount,
    List<FreightRule>? rules,
    DateTime? createTime,
    int? useCount,
  }) {
    return FreightTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isFreeShipping: isFreeShipping ?? this.isFreeShipping,
      freeShippingAmount: freeShippingAmount ?? this.freeShippingAmount,
      rules: rules ?? this.rules,
      createTime: createTime ?? this.createTime,
      useCount: useCount ?? this.useCount,
    );
  }
}

/// 运费规则
class FreightRule {
  final List<String> regions; // 配送区域（省/市）
  final double baseCharge; // 首重/首件费用
  final double baseUnit; // 首重/首件
  final double additionalCharge; // 续重/续件费用
  final double additionalUnit; // 续重/续件

  FreightRule({
    required this.regions,
    required this.baseCharge,
    required this.baseUnit,
    required this.additionalCharge,
    required this.additionalUnit,
  });
}

/// 运费模板管理页面
class FreightTemplatePage extends StatefulWidget {
  const FreightTemplatePage({super.key});

  @override
  State<FreightTemplatePage> createState() => _FreightTemplatePageState();
}

class _FreightTemplatePageState extends State<FreightTemplatePage> {
  // 模拟运费模板数据
  final List<FreightTemplate> _templates = [
    FreightTemplate(
      id: 't1',
      name: '全国包邮',
      type: FreightType.byQuantity,
      isFreeShipping: true,
      createTime: DateTime(2026, 3, 1),
      useCount: 45,
      rules: [],
    ),
    FreightTemplate(
      id: 't2',
      name: '按重量计费',
      type: FreightType.byWeight,
      isFreeShipping: false,
      createTime: DateTime(2026, 2, 15),
      useCount: 23,
      rules: [
        FreightRule(
          regions: ['全国（除偏远地区）'],
          baseCharge: 10.0,
          baseUnit: 1.0,
          additionalCharge: 5.0,
          additionalUnit: 1.0,
        ),
        FreightRule(
          regions: ['西藏', '新疆', '青海'],
          baseCharge: 20.0,
          baseUnit: 1.0,
          additionalCharge: 10.0,
          additionalUnit: 1.0,
        ),
      ],
    ),
    FreightTemplate(
      id: 't3',
      name: '按件数计费',
      type: FreightType.byQuantity,
      isFreeShipping: false,
      createTime: DateTime(2026, 2, 20),
      useCount: 18,
      rules: [
        FreightRule(
          regions: ['全国'],
          baseCharge: 8.0,
          baseUnit: 1,
          additionalCharge: 2.0,
          additionalUnit: 1,
        ),
      ],
    ),
    FreightTemplate(
      id: 't4',
      name: '满额包邮',
      type: FreightType.byPrice,
      isFreeShipping: true,
      freeShippingAmount: 99.0,
      createTime: DateTime(2026, 3, 5),
      useCount: 56,
      rules: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: Column(
        children: [
          // 顶部操作栏
          _buildTopBar(),

          // 运费模板列表
          Expanded(
            child: _buildTemplateList(),
          ),
        ],
      ),
    );
  }

  /// 构建顶部操作栏
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Text(
            '运费模板',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          // 添加模板按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showTemplateDialog(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '添加模板',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建模板列表
  Widget _buildTemplateList() {
    if (_templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 80,
              color: const Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无运费模板',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showTemplateDialog(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A9B8E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '创建第一个模板',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _templates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildTemplateCard(_templates[index]);
      },
    );
  }

  /// 构建模板卡片
  Widget _buildTemplateCard(FreightTemplate template) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行：模板名称 + 计费方式 + 操作
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    template.type.icon,
                    size: 20,
                    color: const Color(0xFF1A9B8E),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      template.type.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1A9B8E),
                      ),
                    ),
                  ),
                  if (template.isFreeShipping)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '包邮',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _editTemplate(template),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _deleteTemplate(template),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Color(0xFFFF4D4F),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 包邮金额
          if (template.isFreeShipping && template.freeShippingAmount != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 16,
                    color: const Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '满¥${template.freeShippingAmount!.toStringAsFixed(0)}包邮',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ),

          if (template.isFreeShipping && template.freeShippingAmount != null)
            const SizedBox(height: 16),

          // 运费规则
          if (template.rules.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '全国包邮',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            )
          else
            ...template.rules.asMap().entries.map((entry) {
              final index = entry.key;
              final rule = entry.value;
              return Container(
                margin: EdgeInsets.only(top: index > 0 ? 8 : 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.regions.join('、'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${rule.baseCharge.toStringAsFixed(2)}元 / ${_formatUnit(rule.baseUnit, template.type)} '
                      '+ ${rule.additionalCharge.toStringAsFixed(2)}元 / 续${_formatUnit(rule.additionalUnit, template.type)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

          const SizedBox(height: 16),

          // 底部信息
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: const Color(0xFF999999),
              ),
              const SizedBox(width: 4),
              Text(
                '使用 ${template.useCount} 次',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              const Spacer(),
              Text(
                '创建于 ${_formatDate(template.createTime)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 格式化单位
  String _formatUnit(double value, FreightType type) {
    switch (type) {
      case FreightType.byWeight:
        return '${value.toStringAsFixed(1)}kg';
      case FreightType.byQuantity:
        return '${value.toInt()}件';
      case FreightType.byVolume:
        return '${value.toStringAsFixed(2)}m³';
      case FreightType.byPrice:
        return '¥${value.toStringAsFixed(2)}';
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 显示模板对话框
  void _showTemplateDialog({FreightTemplate? template}) {
    final nameController = TextEditingController(text: template?.name ?? '');
    FreightType selectedType = template?.type ?? FreightType.byQuantity;
    bool isFreeShipping = template?.isFreeShipping ?? false;
    final freeAmountController = TextEditingController(
      text: template?.freeShippingAmount?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(template == null ? '添加运费模板' : '编辑运费模板'),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 模板名称
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '模板名称',
                        hintText: '请输入模板名称',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 计费方式
                    DropdownButtonFormField<FreightType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: '计费方式',
                        border: OutlineInputBorder(),
                      ),
                      items: FreightType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(type.icon, size: 18),
                              const SizedBox(width: 8),
                              Text(type.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // 是否包邮
                    CheckboxListTile(
                      title: const Text('开启包邮'),
                      subtitle: const Text('开启后满足条件可免运费'),
                      value: isFreeShipping,
                      onChanged: (value) {
                        setDialogState(() {
                          isFreeShipping = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    // 包邮金额
                    if (isFreeShipping)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextField(
                            controller: freeAmountController,
                            decoration: const InputDecoration(
                              labelText: '包邮金额（选填）',
                              hintText: '订单金额满多少元包邮',
                              prefixText: '¥ ',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('请输入模板名称')),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  setState(() {
                    if (template == null) {
                      _templates.add(FreightTemplate(
                        id: 't${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text.trim(),
                        type: selectedType,
                        isFreeShipping: isFreeShipping,
                        freeShippingAmount: freeAmountController.text.trim().isEmpty
                            ? null
                            : double.tryParse(freeAmountController.text.trim()),
                        rules: [],
                        createTime: DateTime.now(),
                      ));
                    } else {
                      final index = _templates.indexWhere((t) => t.id == template.id);
                      if (index != -1) {
                        _templates[index] = template.copyWith(
                          name: nameController.text.trim(),
                          type: selectedType,
                          isFreeShipping: isFreeShipping,
                          freeShippingAmount: freeAmountController.text.trim().isEmpty
                              ? null
                              : double.tryParse(freeAmountController.text.trim()),
                        );
                      }
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(template == null ? '模板已添加' : '模板已更新')),
                  );
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 编辑模板
  void _editTemplate(FreightTemplate template) {
    // TODO: 实现完整的编辑功能（包括编辑运费规则）
    _showTemplateDialog(template: template);
  }

  /// 删除模板
  void _deleteTemplate(FreightTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除运费模板"${template.name}"吗？'),
            if (template.useCount > 0) ...[
              const SizedBox(height: 12),
              Text(
                '注意：该模板正在被 ${template.useCount} 个商品使用',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFFF9800),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _templates.removeWhere((t) => t.id == template.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('模板已删除')),
              );
            },
            child: const Text('确定删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }
}

/// 运费模板管理内容组件（嵌入在merchant_dashboard中使用）
class FreightTemplateContent extends StatelessWidget {
  const FreightTemplateContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const FreightTemplatePage();
  }
}
