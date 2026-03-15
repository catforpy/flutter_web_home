import 'package:flutter/material.dart';
import 'components/phone_preview.dart';
import 'components/config_form.dart';

/// 菜单导航配置页面内容区
/// 只包含内容，不包含侧边栏和标题栏
class MenuNavigationContent extends StatefulWidget {
  const MenuNavigationContent({super.key});

  @override
  State<MenuNavigationContent> createState() => _MenuNavigationContentState();
}

class _MenuNavigationContentState extends State<MenuNavigationContent> {
  // 菜单管理标签：0=菜单导航，1=菜单列表
  int _menuManagementTabIndex = 0;

  // 菜单配置数据
  Map<String, dynamic> _config = {
    'navigationBarBgColor': const Color(0xFF1A9B8E),
    'navigationBarTextStyle': 'white',
    'tabBarTextColor': const Color(0xFF999999),
    'tabBarSelectedColor': const Color(0xFF52C41A),
    'tabBarBackgroundColor': const Color(0xFFFFFFFF),
    'tabBarBorderStyle': 'black',
    'items': [
      {
        'name': '首页',
        'iconPath': 'home',
        'selectedIconPath': 'home_active',
        'pagePath': 'pages/index/index',
        'isHomePage': true,
      },
      {
        'name': '课程',
        'iconPath': 'school',
        'selectedIconPath': 'school_active',
        'pagePath': 'pages/course/course',
        'isHomePage': false,
      },
      {
        'name': '订阅',
        'iconPath': 'subscriptions',
        'selectedIconPath': 'subscriptions_active',
        'pagePath': 'pages/subscription/subscription',
        'isHomePage': false,
      },
      {
        'name': '我的',
        'iconPath': 'person',
        'selectedIconPath': 'person_active',
        'pagePath': 'pages/profile/profile',
        'isHomePage': false,
      },
    ],
  };

  // 可用页面列表（模拟从后端获取）
  final List<Map<String, String>> _availablePages = [
    {'name': '首页', 'path': 'pages/index/index'},
    {'name': '课程', 'path': 'pages/course/course'},
    {'name': '订阅', 'path': 'pages/subscription/subscription'},
    {'name': '我的', 'path': 'pages/profile/profile'},
    {'name': '所有课程分类', 'path': 'pages/allFlGoods/allFlGoods'},
    {'name': '已订阅', 'path': 'pages/alreadyBuyTab/alreadyBuyTab'},
    {'name': '个人中心', 'path': 'pages/wode/wode'},
    {'name': '课程详情', 'path': 'pages/course/detail'},
    {'name': '订单列表', 'path': 'pages/order/list'},
  ];

  // 当前选中的Tab索引（用于手机预览）
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // 初始化选中首页的Tab索引
    _initHomeTabIndex();
  }

  /// 初始化首页Tab索引
  void _initHomeTabIndex() {
    final items = _config['items'] as List<Map<String, dynamic>>;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['isHomePage'] == true) {
        setState(() {
          _selectedTabIndex = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _config['items'] as List<Map<String, dynamic>>;

    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左列：菜单管理标签页
          _buildMenuManagementTabs(),

          const SizedBox(width: 24),

          // 中列：手机模拟器预览区
          _menuManagementTabIndex == 0
              ? SizedBox(
                  width: 350,
                  child: PhonePreview(
                    config: _config,
                    selectedTabIndex: _selectedTabIndex,
                    onTabTap: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                  ),
                )
              : const SizedBox.shrink(),

          const SizedBox(width: 24),

          // 右列：配置表单区 或 菜单列表
          Expanded(
            child: _menuManagementTabIndex == 0
                ? ConfigForm(
                    config: _config,
                    onConfigChanged: (newConfig) {
                      setState(() {
                        _config = newConfig;
                      });
                    },
                  )
                : _buildMenuListTable(items),
          ),
        ],
      ),
    );
  }

  /// 构建菜单管理标签页
  Widget _buildMenuManagementTabs() {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: const Text(
              '菜单管理',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),

          // 标签页按钮
          _buildTabButton('菜单导航', 0),
          _buildTabButton('菜单列表', 1),
        ],
      ),
    );
  }

  /// 构建标签页按钮
  Widget _buildTabButton(String text, int index) {
    final isSelected = _menuManagementTabIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _menuManagementTabIndex = index;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建菜单列表表格
  Widget _buildMenuListTable(List<Map<String, dynamic>> items) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 表格标题
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: const Text(
              '菜单列表',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),

          // 表格内容
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF5F5F5)),
              columns: const [
                DataColumn(
                  label: Text(
                    '名称',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '链接',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '操作',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
              rows: items.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item['pagePath'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _menuManagementTabIndex = 0;
                            });
                          },
                          child: const Text(
                            '编辑',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1890FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
