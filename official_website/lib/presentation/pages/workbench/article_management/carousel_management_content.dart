import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

/// 轮播图管理内容组件
class CarouselManagementContent extends StatefulWidget {
  const CarouselManagementContent({super.key});

  @override
  State<CarouselManagementContent> createState() => _CarouselManagementContentState();
}

class _CarouselManagementContentState extends State<CarouselManagementContent> {
  // 搜索筛选条件
  String _selectedCategory = '全部分类';

  // 排序权重控制器
  final TextEditingController _sortController = TextEditingController();

  // 分类列表（模拟从分类管理获取）
  final List<String> _categories = [
    '全部分类',
    '部门简介',
    '老师介绍',
    '最新资讯',
    '活动通知',
  ];

  // 文章列表（模拟从文章列表获取）
  final List<Map<String, dynamic>> _articles = [
    {'id': '1', 'title': '论抖音视频对生活的影响'},
    {'id': '2', 'title': '如何高效学习编程'},
    {'id': '3', 'title': 'Flutter 开发实战指南'},
    {'id': '4', 'title': 'Web 前端架构设计思路'},
    {'id': '5', 'title': '2024年行业发展趋势分析'},
  ];

  // 轮播图列表数据
  final List<Map<String, dynamic>> _carousels = [
    {
      'id': '1',
      'image': 'https://via.placeholder.com/720x360',
      'category': '最新资讯',
      'sort': 100,
      'articleId': '1',
      'articleTitle': '论抖音视频对生活的影响',
      'createTime': DateTime(2026, 3, 8, 10, 30),
    },
    {
      'id': '2',
      'image': 'https://via.placeholder.com/720x360',
      'category': '部门简介',
      'sort': 90,
      'articleId': '2',
      'articleTitle': '如何高效学习编程',
      'createTime': DateTime(2026, 3, 7, 14, 20),
    },
    {
      'id': '3',
      'image': 'https://via.placeholder.com/720x360',
      'category': '最新资讯',
      'sort': 80,
      'articleId': null,
      'articleTitle': null,
      'createTime': DateTime(2026, 3, 6, 9, 15),
    },
  ];

  // 悬停行索引
  int? _hoveredIndex;

  @override
  void dispose() {
    _sortController.dispose();
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

            // 搜索筛选区
            _buildSearchFilterBar(),

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
          onTap: _showAddCarouselDialog,
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
                  '新增',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建搜索筛选栏
  Widget _buildSearchFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
          const Text('分类：', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
          const SizedBox(width: 8),
          SizedBox(
            width: 200,
            child: _buildDropdownField(_categories, _selectedCategory, (value) {
              setState(() {
                _selectedCategory = value;
              });
            }),
          ),
          const SizedBox(width: 16),
          _buildQueryButton(),
        ],
      ),
    );
  }

  /// 构建查询按钮
  Widget _buildQueryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('查询轮播图');
          debugPrint('分类: $_selectedCategory');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A9B8E),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            '查询',
            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdownField(List<String> items, String value, Function(String) onChanged) {
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

  /// 构建数据表格
  Widget _buildDataTable() {
    if (_carousels.isEmpty) {
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
            Text('暂无轮播图', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
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
          _buildTableHeader(),
          ...List.generate(_carousels.length, (index) {
            return _buildTableRow(_carousels[index], index);
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
          Expanded(flex: 3, child: Text('图片', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('所属分类', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('排序权重', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 3, child: Text('编辑时间', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
          Expanded(flex: 2, child: Text('操作', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)))),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> carousel, int index) {
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
            // 图片
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  carousel['image'],
                  width: 120,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 60,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                    );
                  },
                ),
              ),
            ),

            // 所属分类
            Expanded(
              flex: 2,
              child: Text(
                carousel['category'],
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 排序权重
            Expanded(
              flex: 2,
              child: Text(
                '${carousel['sort']}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
            ),

            // 编辑时间
            Expanded(
              flex: 3,
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(carousel['createTime']),
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),

            // 操作
            Expanded(
              flex: 2,
              child: Wrap(
                spacing: 16,
                children: [
                  _buildActionLink('编辑', const Color(0xFF1890FF), () => _showEditCarouselDialog(carousel)),
                  _buildActionLink('删除', const Color(0xFFFF4D4F), () => _showDeleteConfirmDialog(carousel)),
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

  /// 显示新增轮播图对话框
  void _showAddCarouselDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _CarouselDialog(
          onSubmit: (image, category, articleId, sort) {
            _handleAddSubmit(image, category, articleId, sort);
          },
        );
      },
    );
  }

  /// 处理新增提交
  void _handleAddSubmit(String image, String category, String? articleId, int sort) {
    setState(() {
      _carousels.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'image': image,
        'category': category,
        'sort': sort,
        'articleId': articleId,
        'articleTitle': articleId != null ? _articles.firstWhere((a) => a['id'] == articleId)['title'] : null,
        'createTime': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加成功')),
    );
  }

  /// 处理编辑提交
  void _handleEditSubmit(String carouselId, String image, String category, String? articleId, int sort) {
    setState(() {
      final index = _carousels.indexWhere((c) => c['id'] == carouselId);
      if (index != -1) {
        _carousels[index] = {
          ..._carousels[index],
          'image': image,
          'category': category,
          'sort': sort,
          'articleId': articleId,
          'articleTitle': articleId != null ? _articles.firstWhere((a) => a['id'] == articleId)['title'] : null,
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('修改成功')),
    );
  }

  /// 显示编辑轮播图对话框
  void _showEditCarouselDialog(Map<String, dynamic> carousel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _CarouselEditDialog(
          carousel: carousel,
          categories: _categories,
          articles: _articles,
          onSubmit: (image, category, articleId, sort) {
            _handleEditSubmit(carousel['id'], image, category, articleId, sort);
          },
        );
      },
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(Map<String, dynamic> carousel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: const Text('确定要删除这条轮播图吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _carousels.removeWhere((c) => c['id'] == carousel['id']);
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

/// 轮播图对话框（新增）
class _CarouselDialog extends StatefulWidget {
  final Function(String image, String category, String? articleId, int sort) onSubmit;

  const _CarouselDialog({required this.onSubmit});

  @override
  State<_CarouselDialog> createState() => _CarouselDialogState();
}

class _CarouselDialogState extends State<_CarouselDialog> {
  final TextEditingController _sortController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _selectedImage = '';
  Uint8List? _imageBytes;
  String _selectedCategory = '部门简介';
  String? _selectedArticleId;
  bool _imageSelected = false;

  final List<String> _categories = [
    '部门简介',
    '老师介绍',
    '最新资讯',
    '活动通知',
  ];

  final List<Map<String, dynamic>> _articles = [
    {'id': '1', 'title': '论抖音视频对生活的影响'},
    {'id': '2', 'title': '如何高效学习编程'},
    {'id': '3', 'title': 'Flutter 开发实战指南'},
    {'id': '4', 'title': 'Web 前端架构设计思路'},
    {'id': '5', 'title': '2024年行业发展趋势分析'},
  ];

  @override
  void dispose() {
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '轮播图',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageUploadField(),
                    const SizedBox(height: 16),
                    _buildDropdownFormField('所属分类', _categories, _selectedCategory, (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildTextFormField('排序权重', '请输入整数，越大越靠前', _sortController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildArticleDropdown(_selectedArticleId, (articleId) {
                      setState(() {
                        _selectedArticleId = articleId;
                      });
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDialogButton('取消', const Color(0xFF999999), () => Navigator.of(context).pop()),
                const SizedBox(width: 12),
                _buildDialogButton('确定', const Color(0xFF1A9B8E), () => _handleSubmit()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片上传字段
  Widget _buildImageUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('图片', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                  const SizedBox(height: 8),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F7),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _imageSelected
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: _imageBytes != null
                                ? Image.memory(
                                    _imageBytes!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image, size: 48, color: Color(0xFFCCCCCC)),
                                      );
                                    },
                                  )
                                : Image.network(
                                    _selectedImage,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image, size: 48, color: Color(0xFFCCCCCC)),
                                      );
                                    },
                                  ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFFCCCCCC)),
                                SizedBox(height: 8),
                                Text('点击上传图片', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('建议尺寸', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                const SizedBox(height: 4),
                const Text('720 × 360', style: TextStyle(fontSize: 12, color: Color(0xFF1F2329))),
                const SizedBox(height: 16),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                        );

                        if (image != null) {
                          // 在Web上，读取图片字节数据
                          final bytes = await image.readAsBytes();

                          if (!mounted) return;

                          setState(() {
                            _imageBytes = bytes;
                            _selectedImage = image.name;
                            _imageSelected = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('图片选择成功')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('图片选择失败: $e')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A9B8E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text('选择图片', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 构建下拉表单字段
  Widget _buildDropdownFormField(String label, List<String> items, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        Container(
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
        ),
      ],
    );
  }

  /// 构建文本表单字段
  Widget _buildTextFormField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType}) {
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

  /// 构建文章下拉选择框
  Widget _buildArticleDropdown(String? selectedArticleId, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('链接文章', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: selectedArticleId,
              isExpanded: true,
              hint: const Text('选择文章（可跳转）', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('不跳转', style: TextStyle(fontSize: 14)),
                ),
                ..._articles.map((article) {
                  return DropdownMenuItem<String?>(
                    value: article['id'],
                    child: Text(article['title'], style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
              ],
              onChanged: onChanged,
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

  /// 处理提交
  void _handleSubmit() {
    if (!_imageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择图片')),
      );
      return;
    }

    final sort = int.tryParse(_sortController.text);
    if (sort == null || sort < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的排序权重')),
      );
      return;
    }

    Navigator.of(context).pop();
    widget.onSubmit(_selectedImage, _selectedCategory, _selectedArticleId, sort);
  }
}

/// 轮播图编辑对话框
class _CarouselEditDialog extends StatefulWidget {
  final Map<String, dynamic> carousel;
  final List<String> categories;
  final List<Map<String, dynamic>> articles;
  final Function(String image, String category, String? articleId, int sort) onSubmit;

  const _CarouselEditDialog({
    required this.carousel,
    required this.categories,
    required this.articles,
    required this.onSubmit,
  });

  @override
  State<_CarouselEditDialog> createState() => _CarouselEditDialogState();
}

class _CarouselEditDialogState extends State<_CarouselEditDialog> {
  late TextEditingController _sortController;
  final ImagePicker _picker = ImagePicker();
  late String _selectedImage;
  Uint8List? _imageBytes;
  late String _selectedCategory;
  String? _selectedArticleId;
  late bool _imageSelected;

  @override
  void initState() {
    super.initState();
    _sortController = TextEditingController(text: widget.carousel['sort'].toString());
    _selectedImage = widget.carousel['image'];
    _selectedCategory = widget.carousel['category'];
    _selectedArticleId = widget.carousel['articleId'];
    _imageSelected = true;
  }

  @override
  void dispose() {
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = widget.categories.where((c) => c != '全部分类').toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '轮播图',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2329)),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageUploadField(),
                    const SizedBox(height: 16),
                    _buildDropdownFormField('所属分类', filteredCategories, _selectedCategory, (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildTextFormField('排序权重', '请输入整数，越大越靠前', _sortController,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildArticleDropdown(_selectedArticleId, (articleId) {
                      setState(() {
                        _selectedArticleId = articleId;
                      });
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDialogButton('取消', const Color(0xFF999999), () => Navigator.of(context).pop()),
                const SizedBox(width: 12),
                _buildDialogButton('确定', const Color(0xFF1A9B8E), () => _handleSubmit()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片上传字段
  Widget _buildImageUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('图片', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                  const SizedBox(height: 8),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F7),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _imageSelected
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: _imageBytes != null
                                ? Image.memory(
                                    _imageBytes!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image, size: 48, color: Color(0xFFCCCCCC)),
                                      );
                                    },
                                  )
                                : Image.network(
                                    _selectedImage,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image, size: 48, color: Color(0xFFCCCCCC)),
                                      );
                                    },
                                  ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFFCCCCCC)),
                                SizedBox(height: 8),
                                Text('点击上传图片', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('建议尺寸', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                const SizedBox(height: 4),
                const Text('720 × 360', style: TextStyle(fontSize: 12, color: Color(0xFF1F2329))),
                const SizedBox(height: 16),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 85,
                        );

                        if (image != null) {
                          // 在Web上，读取图片字节数据
                          final bytes = await image.readAsBytes();

                          if (!mounted) return;

                          setState(() {
                            _imageBytes = bytes;
                            _selectedImage = image.name;
                            _imageSelected = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('图片选择成功')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('图片选择失败: $e')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A9B8E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text('选择图片', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 构建下拉表单字段
  Widget _buildDropdownFormField(String label, List<String> items, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        Container(
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
        ),
      ],
    );
  }

  /// 构建文本表单字段
  Widget _buildTextFormField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType}) {
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

  /// 构建文章下拉选择框
  Widget _buildArticleDropdown(String? selectedArticleId, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('链接文章', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: selectedArticleId,
              isExpanded: true,
              hint: const Text('选择文章（可跳转）', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('不跳转', style: TextStyle(fontSize: 14)),
                ),
                ...widget.articles.map((article) {
                  return DropdownMenuItem<String?>(
                    value: article['id'],
                    child: Text(article['title'], style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
              ],
              onChanged: onChanged,
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

  /// 处理提交
  void _handleSubmit() {
    if (!_imageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择图片')),
      );
      return;
    }

    final sort = int.tryParse(_sortController.text);
    if (sort == null || sort < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的排序权重')),
      );
      return;
    }

    Navigator.of(context).pop();
    widget.onSubmit(_selectedImage, _selectedCategory, _selectedArticleId, sort);
  }
}
