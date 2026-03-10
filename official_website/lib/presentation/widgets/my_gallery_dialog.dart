import 'package:flutter/material.dart';
import 'package:official_website/presentation/services/image_manager.dart';

/// 我的图库对话框
class MyGalleryDialog extends StatefulWidget {
  final Function(String)? onImageSelected;

  const MyGalleryDialog({super.key, this.onImageSelected});

  @override
  State<MyGalleryDialog> createState() => _MyGalleryDialogState();
}

class _MyGalleryDialogState extends State<MyGalleryDialog> {
  String _selectedTab = 'all';
  final TextEditingController _searchController = TextEditingController();
  final int _pageSize = 15;
  final ImageManager _imageManager = ImageManager();

  List<GalleryImage> get _filteredImages {
    final images = _imageManager.getImagesByGroup(_selectedTab);
    if (_searchController.text.isEmpty) return images;
    return images.where((img) =>
      img.name.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  List<ImageGroup> get _sortedGroups {
    final groups = _imageManager.groups.where((g) => g.id != 'all').toList();
    groups.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 900,
        height: 600,
        color: Colors.white,
        child: Column(
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '我的图片',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
                    ),
                  ),
                ],
              ),
            ),

            // 主体内容
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧标签
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(right: BorderSide(color: const Color(0xFFE5E5E5))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSidebarTab('all', '全部图片', _imageManager.images.length),
                        ..._sortedGroups.map((group) => _buildSidebarTab(group.id, group.name, _imageManager.getImagesByGroup(group.id).length)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _buildAddGroupButton(),
                        ),
                      ],
                    ),
                  ),

                  // 右侧内容
                  Expanded(
                    child: _selectedTab == '全部图片'
                        ? _buildImageList()
                        : const Center(
                            child: Text('该标签内容开发中...',
                                style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                          ),
                  ),
                ],
              ),
            ),

            // 底部操作栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: Row(
                children: [
                  // 上传图片按钮
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('上传图片功能开发中')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.upload, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('上传图片', style: TextStyle(fontSize: 14, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 分页信息
                  Text('共${_imageManager.images.length}张，每页15张',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),

                  const SizedBox(width: 16),

                  // 分页按钮
                  Row(
                    children: [
                      _buildPageButton('1'),
                      _buildPageButton('2'),
                      _buildPageButton('...'),
                      _buildPageButton('70'),
                      _buildPageButton('下一页'),
                    ],
                  ),

                  const SizedBox(width: 24),

                  // 右侧操作按钮
                  Row(
                    children: [
                      _buildActionButton('修改图片名称'),
                      const SizedBox(width: 8),
                      _buildActionButton('设置图片分组'),
                      const SizedBox(width: 8),
                      _buildActionButton('删除'),
                      const SizedBox(width: 12),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A9B8E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('确定',
                                style: TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建侧边栏标签
  Widget _buildSidebarTab(String id, String name, int count) {
    final isSelected = _selectedTab == id;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = id;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6F7FF) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF1A9B8E) : const Color(0xFF666666),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$count张',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建添加分组按钮
  Widget _buildAddGroupButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showAddGroupDialog(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1A9B8E), style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            children: [
              Icon(Icons.add, size: 16, color: Color(0xFF1A9B8E)),
              SizedBox(width: 4),
              Text('添加分组', style: TextStyle(fontSize: 12, color: Color(0xFF1A9B8E))),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示添加分组对话框
  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    final sortController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '添加分组',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 分组名称
                const Text('分组名称', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: '请输入分组名称',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),

                const SizedBox(height: 16),

                // 排序权重
                const Text('排序权重', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                const SizedBox(height: 8),
                TextField(
                  controller: sortController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '数字越小越靠前',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),

                const SizedBox(height: 20),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          final group = ImageGroup(
                            id: 'group_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameController.text,
                            sortOrder: int.tryParse(sortController.text) ?? 0,
                          );
                          _imageManager.addGroup(group);
                          setState(() {});
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('已添加分组：${group.name}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A9B8E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text('确定', style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建图片列表
  Widget _buildImageList() {
    return Column(
      children: [
        // 搜索栏
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('图片名称', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入图片名称',
                      hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('搜索', style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 图片网格
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredImages.take(_pageSize).length,
            itemBuilder: (context, index) {
              final img = _filteredImages[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        img.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 24, color: Color(0xFFCCCCCC)),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: Text(
                          img.name,
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 构建分页按钮
  Widget _buildPageButton(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF1A9B8E))),
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$text功能开发中')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF1A9B8E))),
        ),
      ),
    );
  }
}
