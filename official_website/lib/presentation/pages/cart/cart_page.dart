import 'package:flutter/material.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../routes/app_router.dart';

/// 购物车页面
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 选中的商品索引集合
  final Set<int> _selectedItems = {};

  // 购物车商品数据（假数据）
  final List<Map<String, dynamic>> _cartItems = [
    {
      'title': 'AI大模型对话助手',
      'description': '1个组合套餐可选择',
      'price': 348.00,
      'image': 'ai-assistant.jpg',
      'tag': '热门推荐',
    },
    {
      'title': '智能客服机器人',
      'description': '企业级客服解决方案',
      'price': 588.00,
      'image': 'customer-service.jpg',
      'tag': '新品',
    },
    {
      'title': '数据分析工具',
      'description': '大数据可视化分析',
      'price': 299.00,
      'image': 'data-analysis.jpg',
      'tag': '',
    },
    {
      'title': 'OCR识别小程序',
      'description': '高精度文字识别',
      'price': 199.00,
      'image': 'ocr-tool.jpg',
      'tag': '限时优惠',
    },
    {
      'title': '智能翻译助手',
      'description': '多语言实时翻译',
      'price': 158.00,
      'image': 'translation.jpg',
      'tag': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 导航栏
            const UnifiedNavigationBar(
              currentPath: AppRouter.home,
            ),

            // 主内容区
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    // 主体卡片
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // 顶部标题区
                          _buildHeader(),

                          const SizedBox(height: 20),

                          // 列表表头
                          _buildTableHeader(),

                          // 商品列表
                          _buildProductList(),

                          const SizedBox(height: 20),

                          // 底部结算栏
                          _buildFooterBar(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer
                    const FooterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部标题区
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '我的购物车',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '共 ${_cartItems.length} 门，已选择 ${_selectedItems.length} 门',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              AppRouter.goToOrders(context);
            },
            child: const Text(
              '我的订单历史',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建列表表头
  Widget _buildTableHeader() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 60, child: Center(child: Text(''))),
          Expanded(
            child: Text(
              '小程序',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '金额',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '操作',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建商品列表
  Widget _buildProductList() {
    return Column(
      children: List.generate(_cartItems.length, (index) {
        return _buildProductItem(index);
      }),
    );
  }

  /// 构建单个商品项
  Widget _buildProductItem(int index) {
    final item = _cartItems[index];
    final isSelected = _selectedItems.contains(index);

    return Container(
      height: 140,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 勾选列
          SizedBox(
            width: 60,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.remove(index);
                    } else {
                      _selectedItems.add(index);
                    }
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1890FF)
                          : const Color(0xFFDDDDDD),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isSelected ? const Color(0xFF1890FF) : Colors.white,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),

          // 课程信息列
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  // 小程序封面
                  Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.apps,
                      size: 40,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 小程序详情
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (item['tag'] != null && item['tag'].toString().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['tag'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF4D4F),
                              ),
                            ),
                          ),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 金额列
          SizedBox(
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      '${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 操作列
          SizedBox(
            width: 80,
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _cartItems.removeAt(index);
                      _selectedItems.clear();
                    });
                  },
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部结算栏
  Widget _buildFooterBar() {
    // 计算总金额
    double totalAmount = 0;
    for (var index in _selectedItems) {
      if (index < _cartItems.length) {
        totalAmount += _cartItems[index]['price'];
      }
    }

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '已选择 ${_selectedItems.length} 件商品    ',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const Text(
            '总计金额：',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            '¥ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF4D4F),
            ),
          ),
          const SizedBox(width: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                debugPrint('去结算，商品数量：${_selectedItems.length}');
                // TODO: 实现结算功能
              },
              child: Container(
                width: 140,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D4F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    '去结算',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
