import 'package:flutter/material.dart';

/// 添加类目选择器（双栏布局）
class AddCategorySelector extends StatefulWidget {
  final Function(String category, String subCategory) onCategorySelected;

  const AddCategorySelector({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<AddCategorySelector> createState() => _AddCategorySelectorState();
}

class _AddCategorySelectorState extends State<AddCategorySelector> {
  // 搜索关键词
  String _searchKeyword = '';

  // 当前选中的类目索引
  int _selectedCategoryIndex = 0;

  // 当前选中的子类目索引
  int? _selectedSubCategoryIndex;

  // 类目列表
  final List<Map<String, dynamic>> _categories = [
    {
      'label': '餐饮服务',
      'subCategories': ['餐饮服务场所/餐饮...', '餐厅排队', '点餐平台', '外卖平台'],
    },
    {
      'label': '物流服务',
      'subCategories': ['快递服务', '物流查询', '仓储服务'],
    },
    {
      'label': '交通服务',
      'subCategories': ['打车服务', '租车服务', '停车服务'],
    },
    {
      'label': '房地产服务',
      'subCategories': ['新房销售', '二手房交易', '房屋租赁'],
    },
    {
      'label': '资讯',
      'subCategories': ['新闻资讯', '科技资讯', '财经资讯'],
    },
    {
      'label': '生活服务',
      'subCategories': ['家政服务', '美容服务', '维修服务'],
    },
    {
      'label': '深度合成',
      'subCategories': ['AI生成', '图像处理', '视频合成'],
    },
  ];

  // 过滤后的类目列表
  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchKeyword.isEmpty) {
      return _categories;
    }
    return _categories
        .where((cat) => cat['label'].toString().toLowerCase().contains(_searchKeyword.toLowerCase()))
        .toList();
  }

  // 当前子类目列表
  List<String> get _currentSubCategories {
    if (_filteredCategories.isEmpty) return [];
    return List<String>.from(_filteredCategories[_selectedCategoryIndex]['subCategories']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左栏：类目列表（40%）
          SizedBox(
            width: 280,
            child: Column(
              children: [
                // 搜索框
                _buildSearchInput(),
                const SizedBox(height: 16),

                // 类目列表
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(index);
                    },
                  ),
                ),
              ],
            ),
          ),

          // 分隔线
          Container(
            width: 1,
            height: double.infinity,
            color: const Color(0xFFEEEEEE),
          ),

          const SizedBox(width: 24),

          // 右栏：子类目列表（60%）
          Expanded(
            child: ListView.builder(
              itemCount: _currentSubCategories.length,
              itemBuilder: (context, index) {
                return _buildSubCategoryItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建搜索输入框
  Widget _buildSearchInput() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF52C41A), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchKeyword = value;
            _selectedCategoryIndex = 0;
            _selectedSubCategoryIndex = null;
          });
        },
        decoration: const InputDecoration(
          hintText: '请选择或者输入关键词搜索',
          hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
      ),
    );
  }

  /// 构建类目项
  Widget _buildCategoryItem(int index) {
    final isSelected = index == _selectedCategoryIndex;
    final category = _filteredCategories[index];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryIndex = index;
            _selectedSubCategoryIndex = null;
          });
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF6FFED) : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  category['label'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF52C41A) : const Color(0xFF333333),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 16,
                color: Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建子类目项
  Widget _buildSubCategoryItem(int index) {
    final isSelected = index == _selectedSubCategoryIndex;
    final subCategory = _currentSubCategories[index];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSubCategoryIndex = index;
          });
          // 触发回调，进入资质上传页面
          widget.onCategorySelected(
            _filteredCategories[_selectedCategoryIndex]['label'],
            subCategory,
          );
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6F7FF) : Colors.white,
          ),
          child: Text(
            subCategory,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}
