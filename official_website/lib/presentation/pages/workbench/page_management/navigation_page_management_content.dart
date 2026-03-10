import 'package:flutter/material.dart';
import 'dart:ui';
import 'page_editor.dart';

/// 导航页面管理内容组件
class NavigationPageManagementContent extends StatefulWidget {
  const NavigationPageManagementContent({super.key});

  @override
  State<NavigationPageManagementContent> createState() => _NavigationPageManagementContentState();
}

class _NavigationPageManagementContentState extends State<NavigationPageManagementContent> {
  // 页面类型筛选
  String _selectedPageType = '全部';

  // 行业筛选
  String _selectedIndustry = '全部';

  // 页面类型列表（从后端获取，前端不可设置）
  final List<String> _pageTypes = [
    '全部',
    '首页',
    '课程',
    '商城',
    '视频',
    '消息',
    '直播',
  ];

  // 行业列表（从后端获取，前端不可设置）
  final List<String> _industries = [
    '全部',
    '物流交通',
    '科技培训',
    '餐饮生活',
    '生活娱乐',
    '电商平台',
  ];

  // 页面模板列表数据
  final List<Map<String, dynamic>> _templates = [
    {
      'id': '1',
      'name': '现代简约首页模板',
      'pageType': '首页',
      'industry': '科技培训',
      'thumbnail': 'https://via.placeholder.com/400x300/1890FF/FFFFFF?text=现代简约首页',
      'isCustom': false,
      'isActive': true,
    },
    {
      'id': '2',
      'name': '课程列表展示模板',
      'pageType': '课程',
      'industry': '科技培训',
      'thumbnail': 'https://via.placeholder.com/400x300/52C41A/FFFFFF?text=课程列表',
      'isCustom': false,
      'isActive': false,
    },
    {
      'id': '3',
      'name': '直播大厅模板',
      'pageType': '直播',
      'industry': '生活娱乐',
      'thumbnail': 'https://via.placeholder.com/400x300/FA541C/FFFFFF?text=直播大厅',
      'isCustom': false,
      'isActive': false,
    },
    {
      'id': '4',
      'name': '视频点播模板',
      'pageType': '视频',
      'industry': '科技培训',
      'thumbnail': 'https://via.placeholder.com/400x300/722ED1/FFFFFF?text=视频点播',
      'isCustom': false,
      'isActive': false,
    },
    {
      'id': '5',
      'name': '消息中心模板',
      'pageType': '消息',
      'industry': '电商平台',
      'thumbnail': 'https://via.placeholder.com/400x300/EB2F96/FFFFFF?text=消息中心',
      'isCustom': false,
      'isActive': false,
    },
    {
      'id': '6',
      'name': '商城首页模板',
      'pageType': '商城',
      'industry': '电商平台',
      'thumbnail': 'https://via.placeholder.com/400x300/FAAD14/FFFFFF?text=商城首页',
      'isCustom': false,
      'isActive': false,
    },
    {
      'id': '999',
      'name': '自定义模板',
      'pageType': '自定义',
      'industry': '自定义',
      'thumbnail': 'https://via.placeholder.com/400x300/8C8C8C/FFFFFF?text=自定义模板',
      'isCustom': true,
      'isActive': false,
    },
  ];

  // 悬停的模板ID
  String? _hoveredTemplateId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // 面包屑导航
          _buildBreadcrumb(),

          const SizedBox(height: 24),

          // 筛选栏
          _buildFilterBar(),

          const SizedBox(height: 24),

          // 模板列表
          Expanded(
            child: _buildTemplateGrid(),
          ),
        ],
      ),
    );
  }

  /// 构建面包屑导航
  Widget _buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            '页面管理',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const Text(' / ', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
          const Text(
            '导航页面管理',
            style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E)),
          ),
        ],
      ),
    );
  }

  /// 构建筛选栏
  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // 页面类型筛选
          const Text('页面类型：', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: _buildDropdown(
              _pageTypes,
              _selectedPageType,
              (value) {
                setState(() {
                  _selectedPageType = value;
                });
              },
            ),
          ),

          const SizedBox(width: 32),

          // 行业筛选
          const Text('行业：', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: _buildDropdown(
              _industries,
              _selectedIndustry,
              (value) {
                setState(() {
                  _selectedIndustry = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdown(List<String> items, String value, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  /// 构建模板网格
  Widget _buildTemplateGrid() {
    // 筛选模板
    var filteredTemplates = _templates.where((template) {
      bool matchPageType = _selectedPageType == '全部' || template['pageType'] == _selectedPageType;
      bool matchIndustry = _selectedIndustry == '全部' || template['industry'] == _selectedIndustry || template['pageType'] == '自定义';

      // 自定义模板始终显示
      if (template['isCustom']) return true;

      return matchPageType && matchIndustry;
    }).toList();

    if (filteredTemplates.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: Color(0xFFCCCCCC)),
              SizedBox(height: 16),
              Text('暂无模板', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.7, // 调整为0.7，让卡片保持手机竖屏比例且高度为屏幕3/7
        ),
        itemCount: filteredTemplates.length,
        itemBuilder: (context, index) {
          return _buildTemplateCard(filteredTemplates[index]);
        },
      ),
    );
  }

  /// 构建模板卡片
  Widget _buildTemplateCard(Map<String, dynamic> template) {
    final isCustom = template['isCustom'] as bool;
    final isHovered = _hoveredTemplateId == template['id'];

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredTemplateId = template['id']),
      onExit: (_) => setState(() => _hoveredTemplateId = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isHovered ? 16 : 6,
              offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 手机外壳
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 模板预览图
                        Image.network(
                          template['thumbnail'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF0F0F0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isCustom ? Icons.add : Icons.broken_image,
                                      size: 48,
                                      color: const Color(0xFFCCCCCC),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isCustom ? '自定义模板' : '加载失败',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // 启用标记
                        if (template['isActive'] == true && !isCustom)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF52C41A),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                '已启用',
                                style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),

                        // 模板名称标签（底部）
                        if (!isHovered)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    template['name'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      if (!isCustom) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1890FF).withValues(alpha: 0.9),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                            template['pageType'],
                                            style: const TextStyle(fontSize: 10, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF52C41A).withValues(alpha: 0.9),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                            template['industry'],
                                            style: const TextStyle(fontSize: 10, color: Colors.white),
                                          ),
                                        ),
                                      ] else ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8C8C8C).withValues(alpha: 0.9),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: const Text(
                                            '自定义',
                                            style: TextStyle(fontSize: 10, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // 悬浮层（从底部滑上来）
              if (isHovered)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF1A9B8E).withValues(alpha: 0.85),
                              const Color(0xFF1A9B8E),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: isCustom
                              ? [
                                  _buildActionButton(Icons.edit, '编辑', () {
                                    _handleEdit(template);
                                  }),
                                ]
                              : [
                                  _buildActionButton(Icons.visibility, '预览', () {
                                    _handlePreview(template);
                                  }),
                                  _buildActionButton(
                                    template['isActive'] == true ? Icons.block : Icons.check_circle,
                                    template['isActive'] == true ? '停用' : '启用',
                                    () {
                                      _handleToggleActive(template);
                                    },
                                  ),
                                  _buildActionButton(Icons.edit, '编辑', () {
                                    _handleEdit(template);
                                  }),
                                ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 处理预览
  void _handlePreview(Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: 400,
            height: 700,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // 顶部栏
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        template['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Navigator.of(dialogContext).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 20, color: Color(0xFF666666)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 手机屏幕预览
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      template['thumbnail'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F6F7),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 64, color: Color(0xFFCCCCCC)),
                                SizedBox(height: 16),
                                Text('无法加载预览', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 处理启用/停用
  void _handleToggleActive(Map<String, dynamic> template) {
    final currentState = template['isActive'] as bool;
    setState(() {
      template['isActive'] = !currentState;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentState ? '已停用模板' : '已启用模板'),
        backgroundColor: currentState ? const Color(0xFFFF4D4F) : const Color(0xFF52C41A),
      ),
    );
  }

  /// 处理编辑
  void _handleEdit(Map<String, dynamic> template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageEditor(
          templateId: template['id'],
          templateName: template['name'],
        ),
      ),
    );
  }
}
