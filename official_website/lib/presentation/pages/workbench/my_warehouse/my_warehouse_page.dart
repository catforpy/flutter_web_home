import 'package:flutter/material.dart';
import '../product_detail/product_detail_page.dart';

/// 商品模型
class Product {
  final String id;
  final String name;
  final String? image;
  final String? category; // 货架（基础分类）
  final String? userCategory; // 自定义分组
  final double price;
  final double? originalPrice;
  int stock;
  int salesCount;
  bool isActive;
  bool isRecommended;
  bool isNew;
  final DateTime createTime;

  Product({
    required this.id,
    required this.name,
    this.image,
    this.category,
    this.userCategory,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.salesCount,
    required this.isActive,
    required this.isRecommended,
    required this.isNew,
    required this.createTime,
  });

  /// 复制并更新部分字段
  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? category,
    String? userCategory,
    double? price,
    double? originalPrice,
    int? stock,
    int? salesCount,
    bool? isActive,
    bool? isRecommended,
    bool? isNew,
    DateTime? createTime,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      userCategory: userCategory ?? this.userCategory,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stock: stock ?? this.stock,
      salesCount: salesCount ?? this.salesCount,
      isActive: isActive ?? this.isActive,
      isRecommended: isRecommended ?? this.isRecommended,
      isNew: isNew ?? this.isNew,
      createTime: createTime ?? this.createTime,
    );
  }
}

/// 我的仓库页面
/// 用于管理所有商品
class MyWarehousePage extends StatefulWidget {
  const MyWarehousePage({super.key});

  @override
  State<MyWarehousePage> createState() => _MyWarehousePageState();
}

class _MyWarehousePageState extends State<MyWarehousePage> {
  // 搜索关键词
  String _searchKeyword = '';

  // 筛选条件
  String? _selectedCategory;
  String? _selectedUserCategory;
  bool? _selectedStatus;

  // 排序方式
  String _sortBy = 'createTime'; // createTime, name, price, sales

  // 模拟商品数据
  final List<Product> _products = [
    Product(
      id: 'p001',
      name: '时尚纯棉T恤',
      image: '',
      category: '服装鞋帽 > 男装 > 上衣 > T恤',
      userCategory: '热销商品',
      price: 99.00,
      originalPrice: 199.00,
      stock: 100,
      salesCount: 568,
      isActive: true,
      isRecommended: true,
      isNew: true,
      createTime: DateTime(2026, 3, 1),
    ),
    Product(
      id: 'p002',
      name: '休闲牛仔裤',
      image: '',
      category: '服装鞋帽 > 男装 > 裤装 > 牛仔裤',
      userCategory: '热销商品',
      price: 159.00,
      originalPrice: 299.00,
      stock: 80,
      salesCount: 342,
      isActive: true,
      isRecommended: true,
      isNew: false,
      createTime: DateTime(2026, 2, 20),
    ),
    Product(
      id: 'p003',
      name: '连衣裙 夏季新款',
      image: '',
      category: '服装鞋帽 > 女装 > 连衣裙 > 长裙',
      userCategory: '新品推荐',
      price: 299.00,
      originalPrice: 499.00,
      stock: 50,
      salesCount: 128,
      isActive: true,
      isRecommended: false,
      isNew: true,
      createTime: DateTime(2026, 3, 8),
    ),
    Product(
      id: 'p004',
      name: '智能手机 iPhone 15',
      image: '',
      category: '数码电器 > 手机 > 智能手机 > 苹果',
      userCategory: '促销活动',
      price: 5999.00,
      originalPrice: 6999.00,
      stock: 30,
      salesCount: 89,
      isActive: true,
      isRecommended: true,
      isNew: false,
      createTime: DateTime(2026, 2, 15),
    ),
    Product(
      id: 'p005',
      name: '笔记本电脑 华为MateBook',
      image: '',
      category: '数码电器 > 电脑 > 笔记本电脑',
      userCategory: '热销商品',
      price: 4999.00,
      originalPrice: 5999.00,
      stock: 20,
      salesCount: 234,
      isActive: true,
      isRecommended: true,
      isNew: false,
      createTime: DateTime(2026, 1, 30),
    ),
    Product(
      id: 'p006',
      name: '护肤套装 补水保湿',
      image: '',
      category: '美妆护肤 > 护肤品 > 面部护理',
      userCategory: '新品推荐',
      price: 199.00,
      originalPrice: 399.00,
      stock: 0,
      salesCount: 67,
      isActive: false,
      isRecommended: false,
      isNew: true,
      createTime: DateTime(2026, 3, 5),
    ),
  ];

  /// 获取筛选和排序后的商品列表
  List<Product> get _filteredProducts {
    var filtered = List<Product>.from(_products);

    // 按关键词搜索
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(keyword) ||
               (product.category?.toLowerCase().contains(keyword) ?? false);
      }).toList();
    }

    // 按货架筛选
    if (_selectedCategory != null) {
      filtered = filtered.where((product) {
        return product.category == _selectedCategory;
      }).toList();
    }

    // 按自定义分组筛选
    if (_selectedUserCategory != null) {
      filtered = filtered.where((product) {
        return product.userCategory == _selectedUserCategory;
      }).toList();
    }

    // 按状态筛选
    if (_selectedStatus != null) {
      filtered = filtered.where((product) {
        return product.isActive == _selectedStatus;
      }).toList();
    }

    // 排序
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'sales':
        filtered.sort((a, b) => b.salesCount.compareTo(a.salesCount));
        break;
      case 'createTime':
      default:
        filtered.sort((a, b) => b.createTime.compareTo(a.createTime));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: Column(
        children: [
          // 顶部操作栏
          _buildTopBar(),

          // 筛选栏
          _buildFilterBar(),

          // 商品列表
          Expanded(
            child: _buildProductList(),
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
          // 标题
          const Text(
            '我的仓库',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const Spacer(),

          // 搜索框
          SizedBox(
            width: 400,
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索商品名称或货架',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchKeyword = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),

          const SizedBox(width: 16),

          // 添加商品按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDetailPage(),
                  ),
                ).then((_) {
                  if (mounted) {
                    setState(() {}); // 刷新列表
                  }
                });
              },
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
                      '添加商品',
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

  /// 构建筛选栏
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // 货架筛选
          _buildFilterDropdown(
            label: '全部货架',
            value: _selectedCategory,
            items: const [
              null,
              '服装鞋帽 > 男装 > 上衣 > T恤',
              '服装鞋帽 > 男装 > 裤装 > 牛仔裤',
              '服装鞋帽 > 女装 > 连衣裙 > 长裙',
              '数码电器 > 手机 > 智能手机 > 苹果',
              '美妆护肤 > 护肤品 > 面部护理',
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),

          const SizedBox(width: 16),

          // 自定义分组筛选
          _buildFilterDropdown(
            label: '全部分组',
            value: _selectedUserCategory,
            items: const [
              null,
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

          const SizedBox(width: 16),

          // 状态筛选
          _buildFilterDropdown(
            label: '全部状态',
            value: _selectedStatus,
            items: const [
              null,
              true, // 已上架
              false, // 已下架
            ],
            itemLabels: const {
              null: '全部状态',
              true: '已上架',
              false: '已下架',
            },
            onChanged: (value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),

          const Spacer(),

          // 排序
          Row(
            children: [
              const Text(
                '排序：',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              _buildSortChip('创建时间', 'createTime'),
              _buildSortChip('名称', 'name'),
              _buildSortChip('价格', 'price'),
              _buildSortChip('销量', 'sales'),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建筛选下拉框
  Widget _buildFilterDropdown({
    required String label,
    required dynamic value,
    required List<dynamic> items,
    Map<dynamic, String>? itemLabels,
    required void Function(dynamic?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          hint: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF333333),
          ),
          items: items.map((item) {
            return DropdownMenuItem<dynamic>(
              value: item,
              child: Text(
                itemLabels != null ? itemLabels[item]! : (item?.toString() ?? '全部'),
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF999999)),
          isDense: true,
        ),
      ),
    );
  }

  /// 构建排序芯片
  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _sortBy = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建商品列表
  Widget _buildProductList() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: const Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无商品',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  /// 构建商品卡片
  Widget _buildProductCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品图片
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: product.image != null && product.image!.isNotEmpty
                  ? Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shopping_bag_outlined,
                          size: 32,
                          color: Color(0xFFCCCCCC),
                        );
                      },
                    )
                  : const Icon(
                      Icons.shopping_bag_outlined,
                      size: 32,
                      color: Color(0xFFCCCCCC),
                    ),
            ),
          ),

          const SizedBox(height: 8),

          // 商品名称
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // 货架
          if (product.category != null)
            Row(
              children: [
                const Icon(
                  Icons.category,
                  size: 10,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    product.category!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 6),

          // 价格和销量
          Row(
            children: [
              Text(
                '¥${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF4D4F),
                ),
              ),
              const Spacer(),
              Text(
                '销${product.salesCount}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 库存和状态
          Row(
            children: [
              Icon(
                product.stock > 0 ? Icons.inventory_2_outlined : Icons.warning,
                size: 12,
                color: product.stock > 0 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  product.stock > 0 ? '库存${product.stock}' : '缺货',
                  style: TextStyle(
                    fontSize: 10,
                    color: product.stock > 0 ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              // 商品状态标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: product.isActive
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                      : const Color(0xFF999999).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  product.isActive ? '上架' : '下架',
                  style: TextStyle(
                    fontSize: 9,
                    color: product.isActive ? const Color(0xFF4CAF50) : const Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 商品标签
          Wrap(
            spacing: 3,
            runSpacing: 3,
            children: [
              if (product.isRecommended)
                _buildProductLabel('推荐', const Color(0xFFFF9800)),
              if (product.isNew)
                _buildProductLabel('新品', const Color(0xFF2196F3)),
            ],
          ),

          const Spacer(),

          // 操作按钮
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  Icons.edit_outlined,
                  '编辑',
                  const Color(0xFF2196F3),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          productId: product.id,
                        ),
                      ),
                    ).then((_) {
                      if (mounted) {
                        setState(() {}); // 刷新列表
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildActionButton(
                  Icons.delete_outline,
                  '删除',
                  const Color(0xFFFF4D4F),
                  () => _deleteProduct(product),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建商品标签
  Widget _buildProductLabel(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 删除商品
  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除商品"${product.name}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('商品已删除')),
              );
            },
            child: const Text('确定删除', style: TextStyle(color: Color(0xFFFF4D4F))),
          ),
        ],
      ),
    );
  }
}

/// 我的仓库内容组件（嵌入在merchant_dashboard中使用）
class MyWarehouseContent extends StatelessWidget {
  const MyWarehouseContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWarehousePage();
  }
}
