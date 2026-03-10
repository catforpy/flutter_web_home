import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:official_website/presentation/widgets/my_gallery_dialog.dart';
import 'package:official_website/presentation/services/image_manager.dart';
import 'dart:html' as html show FileUploadInputElement, FileReader;

/// 图片上传对话框
class ImageUploadDialog extends StatefulWidget {
  final Function(String)? onImageSelected;
  final bool allowMultiple; // 是否允许多图上传（动态图）

  const ImageUploadDialog({
    super.key,
    this.onImageSelected,
    this.allowMultiple = false,
  });

  @override
  State<ImageUploadDialog> createState() => _ImageUploadDialogState();
}

class _ImageUploadDialogState extends State<ImageUploadDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _uploadedImages = []; // 已上传的图片（base64）
  final ImageManager _imageManager = ImageManager();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 初始化 ImageManager
    _imageManager.initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '图片上传',
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

            // 标签页
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1A9B8E),
                unselectedLabelColor: const Color(0xFF666666),
                indicatorColor: const Color(0xFF1A9B8E),
                tabs: const [
                  Tab(text: '静态图片'),
                  Tab(text: '动态图片'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 标签内容
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStaticImageTab(),
                  _buildDynamicImageTab(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 底部按钮
            Row(
              children: [
                // 我的图库按钮
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _showMyGalleryDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1A9B8E)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '我的图库',
                        style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // 取消按钮
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text('取消', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 确定按钮
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _handleConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _uploadedImages.isNotEmpty
                            ? const Color(0xFF1A9B8E)
                            : const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('确定',
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 静态图片标签
  Widget _buildStaticImageTab() {
    return Column(
      children: [
        // 上传区域
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _uploadedImages.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _uploadedImages.length,
                    itemBuilder: (context, index) {
                      return _buildImageItem(_uploadedImages[index], index);
                    },
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _uploadStaticImage,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFF1A9B8E)),
                            SizedBox(height: 12),
                            Text('点击上传图片', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // 提示文字
        const Text(
          '仅支持jpg\\gif\\png三种格式，（建议尺寸：750x400像素）(请将图片大小控制在2M以内，否则将上传失败)',
          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  /// 动态图片标签
  Widget _buildDynamicImageTab() {
    return Column(
      children: [
        // 上传区域
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _uploadedImages.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _uploadedImages.length,
                    itemBuilder: (context, index) {
                      return _buildImageItem(_uploadedImages[index], index);
                    },
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _uploadedImages.length >= 8 ? null : _uploadDynamicImage,
                      child: AbsorbPointer(
                        absorbing: _uploadedImages.length >= 8,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  size: 48,
                                  color: _uploadedImages.length >= 8
                                      ? const Color(0xFFCCCCCC)
                                      : const Color(0xFF1A9B8E)),
                              const SizedBox(height: 12),
                              Text('点击上传图片',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _uploadedImages.length >= 8
                                          ? const Color(0xFFCCCCCC)
                                          : const Color(0xFF666666))),
                              if (_uploadedImages.length >= 8)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text('已达到最大数量(8张)',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // 提示文字
        const Text(
          '仅支持gif格式，最多上传8张（请将图片大小控制在10M以内，否则将上传失败）',
          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  /// 构建图片项
  Widget _buildImageItem(String imageUrl, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                );
              },
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
                    _uploadedImages.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 上传静态图片
  Future<void> _uploadStaticImage() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('本地上传仅支持Web平台')),
      );
      return;
    }

    // ignore: deprecated_member_use
    final upload = html.FileUploadInputElement();
    upload.accept = 'image/jpeg, image/gif, image/png';
    upload.click();

    upload.onChange.listen((e) {
      final files = upload.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        // ignore: deprecated_member_use
        final reader = html.FileReader();

        reader.onLoad.listen((e) {
          final result = reader.result as String?;
          if (result != null && mounted) {
            setState(() {
              _uploadedImages.clear();
              _uploadedImages.add(result);
            });

            // 保存到图库
            final image = GalleryImage(
              id: 'img_${DateTime.now().millisecondsSinceEpoch}',
              name: file.name.replaceAll('.jpg', '').replaceAll('.png', '').replaceAll('.gif', ''),
              url: result,
            );
            _imageManager.addImage(image);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('图片上传成功')),
              );
            }
          }
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  /// 上传动态图片
  Future<void> _uploadDynamicImage() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('本地上传仅支持Web平台')),
      );
      return;
    }

    // ignore: deprecated_member_use
    final upload = html.FileUploadInputElement();
    upload.accept = 'image/gif';
    upload.click();

    upload.onChange.listen((e) {
      final files = upload.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        // ignore: deprecated_member_use
        final reader = html.FileReader();

        reader.onLoad.listen((e) {
          final result = reader.result as String?;
          if (result != null && mounted) {
            setState(() {
              _uploadedImages.add(result);
            });

            // 保存到图库
            final image = GalleryImage(
              id: 'img_${DateTime.now().millisecondsSinceEpoch}_${_uploadedImages.length}',
              name: file.name.replaceAll('.gif', ''),
              url: result,
            );
            _imageManager.addImage(image);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('图片上传成功')),
              );
            }
          }
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  /// 显示我的图库对话框
  void _showMyGalleryDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => MyGalleryDialog(
        onImageSelected: (imageUrl) {
          setState(() {
            _uploadedImages.clear();
            _uploadedImages.add(imageUrl);
          });
          // 关闭图库对话框，返回到图片上传对话框
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  /// 确定按钮处理
  void _handleConfirm() {
    if (_uploadedImages.isEmpty) return;

    final selectedImage = widget.allowMultiple ? _uploadedImages.join(',') : _uploadedImages.first;
    if (widget.onImageSelected != null) {
      widget.onImageSelected!(selectedImage);
    }
    Navigator.of(context).pop();
  }
}
