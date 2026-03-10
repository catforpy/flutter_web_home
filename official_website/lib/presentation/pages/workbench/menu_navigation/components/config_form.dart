import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 配置表单组件
/// 包含全局样式设置和菜单项列表
class ConfigForm extends StatefulWidget {
  final Map<String, dynamic> config;
  final Function(Map<String, dynamic>) onConfigChanged;

  const ConfigForm({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<ConfigForm> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<ConfigForm> {
  // 控制设置为首页的单选值（存储菜单项索引）
  int _homePageIndex = 0;

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

  @override
  void initState() {
    super.initState();
    // 初始化首页索引
    _initHomePageIndex();
  }

  /// 初始化首页索引
  void _initHomePageIndex() {
    final items = widget.config['items'] as List<Map<String, dynamic>>;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['isHomePage'] == true) {
        _homePageIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.config['items'] as List<Map<String, dynamic>>;

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部介绍提示
            _buildIntroBox(),
            const SizedBox(height: 24),

            // 全局样式设置
            _buildGlobalSettings(),

            const SizedBox(height: 24),

            // 底部图标列表
            _buildMenuItemsList(items),

            const SizedBox(height: 24),

            // 底部保存按钮
            _buildFooterAction(),
          ],
        ),
      ),
    );
  }

  /// 构建顶部介绍提示
  Widget _buildIntroBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        border: Border.all(color: const Color(0xFF52C41A), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF52C41A),
              ),
              const SizedBox(width: 8),
              const Text(
                '介绍',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '底部图标 (底部导航链接不能重复，且必须有一个链接到首页)\n'
            '该处修改底部菜单需要保存后重新提交审核（在小程序管理->审核管理点击）',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建全局样式设置
  Widget _buildGlobalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '全局样式设置',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),

        // 导航栏背景颜色 + 导航栏文字颜色
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildColorPicker(
                '导航栏背景颜色',
                widget.config['navigationBarBgColor'] as Color,
                (color) {
                  _updateConfig('navigationBarBgColor', color);
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildRadioGroup(
                '导航栏文字颜色',
                ['black', 'white'],
                widget.config['navigationBarTextStyle'] as String,
                (value) {
                  _updateConfig('navigationBarTextStyle', value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 16),

        // 底部菜单文字颜色 + 底部菜单文字选中颜色
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildColorPicker(
                '底部菜单文字颜色',
                widget.config['tabBarTextColor'] as Color,
                (color) {
                  _updateConfig('tabBarTextColor', color);
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildColorPicker(
                '底部菜单文字选中颜色',
                widget.config['tabBarSelectedColor'] as Color,
                (color) {
                  _updateConfig('tabBarSelectedColor', color);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 底部菜单背景色 + 底部菜单上边框颜色
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildColorPicker(
                '底部菜单背景色',
                widget.config['tabBarBackgroundColor'] as Color,
                (color) {
                  _updateConfig('tabBarBackgroundColor', color);
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildRadioGroup(
                '底部菜单上边框颜色',
                ['black', 'white'],
                widget.config['tabBarBorderStyle'] as String,
                (value) {
                  _updateConfig('tabBarBorderStyle', value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建菜单项列表
  Widget _buildMenuItemsList(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '底部图标配置',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),

        // 菜单项卡片列表
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildMenuItemCard(index, item);
        }).toList(),

        // 添加按钮
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _addMenuItem,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: Color(0xFF52C41A)),
                  SizedBox(width: 8),
                  Text(
                    '添加菜单项',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF52C41A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建单个菜单项卡片
  Widget _buildMenuItemCard(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行：序号 + 关闭按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '菜单项 ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _removeMenuItem(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 导航图标 + 设置为首页
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '导航图标',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 16),
              // 显示两个小图标
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  _getIconData(item['iconPath'] as String),
                  size: 12,
                  color: const Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  _getIconData(item['selectedIconPath'] as String),
                  size: 12,
                  color: const Color(0xFF52C41A),
                ),
              ),
              const SizedBox(width: 16),
              // 选择图标按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _openIconPicker(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF52C41A), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: Color(0xFF52C41A)),
                        SizedBox(width: 4),
                        Text(
                          '选择图标',
                          style: TextStyle(fontSize: 12, color: Color(0xFF52C41A)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // 设置为首页单选框
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Radio<int>(
                      value: index,
                      groupValue: _homePageIndex,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _homePageIndex = value;
                            _updateHomePageIndex(value);
                          });
                        }
                      },
                    ),
                  ),
                  const Text(
                    '设置为首页',
                    style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 导航名称
          _buildTextField('导航名称', item['name'] as String, (value) {
            _updateItem(index, 'name', value);
          }),
          const SizedBox(height: 16),

          // 链接到 + 复制路径
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdownField(
                  '链接到',
                  item['pagePath'] as String,
                  _availablePages,
                  (value) {
                    _updateItem(index, 'pagePath', value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _copyPath(item['pagePath'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '复制路径',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建底部保存按钮
  Widget _buildFooterAction() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _saveConfig,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF52C41A),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: const Text(
            '保存',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建颜色选择器
  Widget _buildColorPicker(String label, Color color, Function(Color) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              final selectedColor = await showDialog<Color>(
                context: context,
                builder: (context) => _ColorPickerDialog(
                  currentColor: color,
                  onColorSelected: (color) {
                    Navigator.of(context).pop(color);
                  },
                ),
              );
              if (selectedColor != null) {
                onChanged(selectedColor);
              }
            },
            child: Container(
              height: 36,
              width: 100,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.palette,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建单选按钮组
  Widget _buildRadioGroup(String label, List<String> options, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Radio<String>(
                    value: option,
                    groupValue: value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onChanged(newValue);
                      }
                    },
                  ),
                ),
                Text(
                  option == 'black' ? '黑色' : '白色',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                ),
                if (option != options.last) const SizedBox(width: 16),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建文本输入框
  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    final controller = TextEditingController(text: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdownField(
    String label,
    String value,
    List<Map<String, String>> options,
    Function(String) onChanged,
  ) {
    // 检查当前值是否在选项列表中
    final valueExists = value.isEmpty || options.any((page) => page['path'] == value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : (valueExists ? value : null),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: '',
              child: Text('请选择页面'),
            ),
            ...options.map((page) {
              return DropdownMenuItem(
                value: page['path'],
                child: Text('${page['name']} (${page['path']})'),
              );
            }),
          ],
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }

  /// 添加菜单项
  void _addMenuItem() {
    final items = List<Map<String, dynamic>>.from(widget.config['items'] as List<Map<String, dynamic>>);

    if (items.length >= 5) {
      _showMessage('底部菜单最多只能有 5 个！', isError: true);
      return;
    }

    items.add({
      'name': '',
      'iconPath': 'help',
      'selectedIconPath': 'help',
      'pagePath': '',
      'isHomePage': false,
    });

    _updateConfig('items', items);
    _showMessage('已添加新菜单项');
  }

  /// 删除菜单项
  void _removeMenuItem(int index) {
    final items = List<Map<String, dynamic>>.from(widget.config['items'] as List<Map<String, dynamic>>);

    if (items.length <= 2) {
      _showMessage('底部菜单最少需要 2 个！', isError: true);
      return;
    }

    items.removeAt(index);

    // 如果删除的是首页，调整首页索引
    if (_homePageIndex == index) {
      _homePageIndex = 0;
    } else if (_homePageIndex > index) {
      _homePageIndex--;
    }

    _updateConfig('items', items);
    _updateHomePageIndex(_homePageIndex);
    _showMessage('已删除菜单项');
  }

  /// 打开图标选择器
  void _openIconPicker(int index) {
    showDialog(
      context: context,
      builder: (context) => _IconPickerDialog(
        onIconSelected: (iconPath, selectedIconPath) {
          _updateItem(index, 'iconPath', iconPath);
          _updateItem(index, 'selectedIconPath', selectedIconPath);
        },
      ),
    );
  }

  /// 更新配置
  void _updateConfig(String key, dynamic value) {
    final newConfig = Map<String, dynamic>.from(widget.config);
    newConfig[key] = value;
    widget.onConfigChanged(newConfig);
  }

  /// 更新菜单项
  void _updateItem(int index, String key, dynamic value) {
    final items = List<Map<String, dynamic>>.from(widget.config['items'] as List<Map<String, dynamic>>);
    items[index][key] = value;
    _updateConfig('items', items);
  }

  /// 更新首页索引
  void _updateHomePageIndex(int index) {
    final items = List<Map<String, dynamic>>.from(widget.config['items'] as List<Map<String, dynamic>>);

    // 先清除所有首页标记
    for (int i = 0; i < items.length; i++) {
      items[i]['isHomePage'] = false;
    }

    // 设置新的首页
    items[index]['isHomePage'] = true;

    _updateConfig('items', items);
  }

  /// 复制路径
  void _copyPath(String path) {
    if (path.isEmpty) {
      _showMessage('请先选择页面', isError: true);
      return;
    }

    Clipboard.setData(ClipboardData(text: path));
    _showMessage('路径已复制：$path');
  }

  /// 保存配置
  void _saveConfig() {
    // 校验：必须有且只有一个首页
    final items = widget.config['items'] as List<Map<String, dynamic>>;
    int homeCount = 0;
    for (var item in items) {
      if (item['isHomePage'] == true) {
        homeCount++;
      }
    }

    if (homeCount != 1) {
      _showMessage('必须且只能设置一个首页！', isError: true);
      return;
    }

    // 模拟保存
    _showMessage('保存成功！请查看生成的 app.json');

    // TODO: 调用后端接口保存配置
    debugPrint('配置数据：${widget.config}');
  }

  /// 显示提示消息
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFFF4D4F) : const Color(0xFF52C41A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
      case 'home_active':
        return Icons.home;
      case 'school':
      case 'school_active':
        return Icons.school;
      case 'subscriptions':
      case 'subscriptions_active':
        return Icons.subscriptions;
      case 'person':
      case 'person_active':
        return Icons.person;
      case 'shopping_cart':
      case 'shopping_cart_active':
        return Icons.shopping_cart;
      case 'search':
      case 'search_active':
        return Icons.search;
      case 'favorite':
      case 'favorite_active':
        return Icons.favorite;
      case 'settings':
      case 'settings_active':
        return Icons.settings;
      case 'course':
      case 'course_active':
        return Icons.school;
      case 'subscription':
      case 'subscription_active':
        return Icons.subscriptions;
      case 'profile':
      case 'profile_active':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }
}

/// 颜色选择对话框
class _ColorPickerDialog extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorSelected;

  const _ColorPickerDialog({
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final predefinedColors = [
      const Color(0xFF000000),
      const Color(0xFFFFFFFF),
      const Color(0xFF1A9B8E),
      const Color(0xFF52C41A),
      const Color(0xFF1890FF),
      const Color(0xFFFF4D4F),
      const Color(0xFFFF9800),
      const Color(0xFF999999),
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '选择颜色',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: predefinedColors.map((color) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 图标选择对话框
class _IconPickerDialog extends StatelessWidget {
  final Function(String, String) onIconSelected;

  const _IconPickerDialog({
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      {'name': '首页', 'icon': 'home'},
      {'name': '课程', 'icon': 'school'},
      {'name': '订阅', 'icon': 'subscriptions'},
      {'name': '我的', 'icon': 'person'},
      {'name': '购物车', 'icon': 'shopping_cart'},
      {'name': '搜索', 'icon': 'search'},
      {'name': '收藏', 'icon': 'favorite'},
      {'name': '设置', 'icon': 'settings'},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择图标',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  final icon = icons[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        final iconKey = icon['icon'] ?? 'help';
                        onIconSelected(iconKey, '${iconKey}_active');
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(_getIconData(icon['icon'] ?? 'help'), size: 24, color: const Color(0xFF52C41A)),
                            const SizedBox(width: 12),
                            Text(
                              icon['name'] ?? '未知',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'subscriptions':
        return Icons.subscriptions;
      case 'person':
        return Icons.person;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'search':
        return Icons.search;
      case 'favorite':
        return Icons.favorite;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.help_outline;
    }
  }
}
