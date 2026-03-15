import 'package:flutter/material.dart';

/// 商品详情设置页面
/// 用于设置商品的所有信息
class ProductDetailPage extends StatefulWidget {
  final String? productId; // 如果有ID则是编辑，否则是新增

  const ProductDetailPage({
    super.key,
    this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _formKey = GlobalKey<FormState>();

  // 基本信息
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();
  String? _selectedBaseCategory; // 选中的基础分类（货架）
  String? _selectedUserCategory; // 选中的用户分类
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _salesCountController = TextEditingController(text: '0');

  // 商品详情
  final _descriptionController = TextEditingController();

  // 规格信息
  final List<ProductSpec> _specs = [];

  // 商品图片
  final List<String> _images = [];

  // 商品状态
  bool _isActive = true;
  bool _isRecommended = false;
  bool _isNew = false;
  bool _isHot = false;

  // 运费设置
  String? _selectedFreightTemplate;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProductData();
    }
  }

  void _loadProductData() {
    // TODO: 从API加载商品数据
    // 这里先用模拟数据
    setState(() {
      _nameController.text = '时尚纯棉T恤';
      _subtitleController.text = '夏季新款 舒适透气';
      _selectedBaseCategory = '服装鞋帽 > 男装 > 上衣 > T恤';
      _priceController.text = '99.00';
      _originalPriceController.text = '199.00';
      _stockController.text = '100';
      _descriptionController.text = '这是一款舒适的纯棉T恤，采用优质面料制作...';
      _specs.addAll([
        ProductSpec(name: '颜色', values: ['白色', '黑色', '灰色']),
        ProductSpec(name: '尺码', values: ['S', 'M', 'L', 'XL', 'XXL']),
      ]);
      _images.addAll(['img1.jpg', 'img2.jpg', 'img3.jpg']);
      _isRecommended = true;
      _isNew = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _salesCountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Column(
        children: [
          // 顶部标题栏
          _buildTopBar(),

          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 基本信息
                    _buildBasicInfoSection(),

                    const SizedBox(height: 24),

                    // 商品图片
                    _buildImagesSection(),

                    const SizedBox(height: 24),

                    // 规格信息
                    _buildSpecsSection(),

                    const SizedBox(height: 24),

                    // 商品详情
                    _buildDescriptionSection(),

                    const SizedBox(height: 24),

                    // 其他设置
                    _buildOtherSettingsSection(),

                    const SizedBox(height: 24),

                    // 保存按钮
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建顶部标题栏
  Widget _buildTopBar() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(width: 16),
          Text(
            widget.productId == null ? '添加商品' : '编辑商品',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const Spacer(),
          // 保存按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _saveProduct,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.save, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '保存',
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

  /// 构建基本信息区域
  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '基本信息',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          // 商品名称
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '商品名称',
              hintText: '请输入商品名称',
              border: OutlineInputBorder(),
              counterText: '',
            ),
            maxLength: 100,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入商品名称';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 商品副标题
          TextFormField(
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: '商品副标题',
              hintText: '请输入商品副标题（选填）',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // 商品分类（货架）
          Row(
            children: [
              Expanded(
                child: _buildCategoryDropdown(
                  label: '所属货架（基础分类）',
                  value: _selectedBaseCategory,
                  items: const [
                    '服装鞋帽 > 男装 > 上衣 > T恤',
                    '服装鞋帽 > 男装 > 上衣 > 衬衫',
                    '服装鞋帽 > 女装 > 连衣裙 > 长裙',
                    '数码电器 > 手机 > 智能手机 > 苹果',
                    '数码电器 > 手机 > 智能手机 > 华为',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBaseCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCategoryDropdown(
                  label: '自定义分组',
                  value: _selectedUserCategory,
                  items: const [
                    '热销商品',
                    '新品推荐',
                    '促销活动',
                    '季节特惠',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedUserCategory = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 价格和库存
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: '销售价格',
                    hintText: '请输入销售价格',
                    border: OutlineInputBorder(),
                    prefixText: '¥ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入销售价格';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return '请输入有效的价格';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _originalPriceController,
                  decoration: const InputDecoration(
                    labelText: '原价',
                    hintText: '请输入原价',
                    border: OutlineInputBorder(),
                    prefixText: '¥ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: '库存数量',
                    hintText: '请输入库存数量',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入库存数量';
                    }
                    final stock = int.tryParse(value);
                    if (stock == null || stock < 0) {
                      return '请输入有效的库存数量';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建分类下拉框
  Widget _buildCategoryDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: value == null ? const Color(0xFFF5F5F5) : Colors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  /// 构建商品图片区域
  Widget _buildImagesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品图片',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          // 图片上传区域
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: _images.length + 1,
            itemBuilder: (context, index) {
              if (index == _images.length) {
                // 上传按钮
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _uploadImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 32,
                            color: Color(0xFF999999),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '上传图片',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // 已上传的图片
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                      ),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 删除按钮
                  Positioned(
                    top: 4,
                    right: 4,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 第一张图片标记
                  if (index == 0)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '主图',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          const Text(
            '提示：第一张图片将作为商品主图，建议尺寸800x800像素，支持jpg、png格式',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建规格信息区域
  Widget _buildSpecsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '规格信息',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _addSpec,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1A9B8E)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 16, color: Color(0xFF1A9B8E)),
                        SizedBox(width: 4),
                        Text(
                          '添加规格',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A9B8E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 规格列表
          if (_specs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.playlist_add,
                      size: 48,
                      color: Color(0xFFCCCCCC),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '暂无规格，点击上方"添加规格"按钮添加',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            )
        else
          ..._specs.asMap().entries.map((entry) {
            final index = entry.key;
            final spec = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spec.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _editSpec(index),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _specs.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Color(0xFFFF4D4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: spec.values.map((value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
      ],
    ),
  );
  }

  /// 构建商品详情区域
  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '商品详情',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: '请输入商品详细描述...',
              border: OutlineInputBorder(),
            ),
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  /// 构建其他设置区域
  Widget _buildOtherSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '其他设置',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          // 商品状态
          _buildSwitchTile('上架商品', '开启后商品将在前台显示', _isActive, (value) {
            setState(() {
              _isActive = value;
            });
          }),

          const SizedBox(height: 16),

          // 运费模板
          DropdownButtonFormField<String>(
            value: _selectedFreightTemplate,
            decoration: const InputDecoration(
              labelText: '运费模板',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: '1', child: Text('模板1：全国包邮')),
              DropdownMenuItem(value: '2', child: Text('模板2：按重量计费')),
              DropdownMenuItem(value: '3', child: Text('模板3：按件数计费')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFreightTemplate = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // 商品标签
          const Text(
            '商品标签',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildLabelChip('推荐', _isRecommended, (value) {
                setState(() {
                  _isRecommended = value;
                });
              }),
              _buildLabelChip('新品', _isNew, (value) {
                setState(() {
                  _isNew = value;
                });
              }),
              _buildLabelChip('热销', _isHot, (value) {
                setState(() {
                  _isHot = value;
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建开关项
  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1A9B8E),
        ),
      ],
    );
  }

  /// 构建标签芯片
  Widget _buildLabelChip(
    String label,
    bool isSelected,
    void Function(bool) onChanged,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!isSelected),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF999999),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建保存按钮
  Widget _buildSaveButton() {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _saveProduct,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A9B8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '保存商品',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// 上传图片
  void _uploadImage() {
    debugPrint('上传图片');
    // TODO: 实现图片上传
  }

  /// 添加规格
  void _addSpec() {
    showDialog(
      context: context,
      builder: (context) => _SpecDialog(onConfirm: (name, values) {
        if (mounted) {
          setState(() {
            _specs.add(ProductSpec(name: name, values: values));
          });
        }
      }),
    );
  }

  /// 编辑规格
  void _editSpec(int index) {
    final spec = _specs[index];
    showDialog(
      context: context,
      builder: (context) => _SpecDialog(
        initialName: spec.name,
        initialValues: spec.values,
        onConfirm: (name, values) {
          if (mounted) {
            setState(() {
              _specs[index] = ProductSpec(name: name, values: values);
            });
          }
        },
      ),
    );
  }

  /// 保存商品
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: 保存商品到API
    debugPrint('保存商品');
    Navigator.of(context).pop();
  }
}

/// 商品规格模型
class ProductSpec {
  final String name;
  final List<String> values;

  ProductSpec({
    required this.name,
    required this.values,
  });
}

/// 规格对话框
class _SpecDialog extends StatefulWidget {
  final String? initialName;
  final List<String>? initialValues;
  final void Function(String, List<String>) onConfirm;

  const _SpecDialog({
    this.initialName,
    this.initialValues,
    required this.onConfirm,
  });

  @override
  State<_SpecDialog> createState() => _SpecDialogState();
}

class _SpecDialogState extends State<_SpecDialog> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final List<String> _values = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    if (widget.initialValues != null) {
      _values.addAll(widget.initialValues!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? '添加规格' : '编辑规格'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '规格名称',
                  hintText: '例如：颜色、尺码',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入规格名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                '规格值',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        hintText: '输入规格值',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _addValue,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _values.map((value) {
                  return Chip(
                    label: Text(value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _values.remove(value);
                      });
                    },
                  );
                }).toList(),
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
            if (_formKey.currentState!.validate() && _values.isNotEmpty) {
              widget.onConfirm(_nameController.text.trim(), _values);
              Navigator.of(context).pop();
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }

  void _addValue() {
    final value = _valueController.text.trim();
    if (value.isNotEmpty && !_values.contains(value)) {
      setState(() {
        _values.add(value);
        _valueController.clear();
      });
    }
  }
}
