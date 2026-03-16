import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:official_website/presentation/services/image_manager.dart';
import 'package:official_website/presentation/services/cloud_storage_manager.dart';
import 'package:official_website/presentation/models/cloud_storage_config.dart';
import 'package:official_website/presentation/widgets/image_library_dialog.dart';
import 'dart:html' as html show FileUploadInputElement, FileReader;
import 'dart:async';

/// 增强版图片上传对话框（支持云存储配置）
class EnhancedImageUploadDialog extends StatefulWidget {
  final Function(String)? onImageSelected;
  final bool allowMultiple;
  final VoidCallback? onGoToSettings; // 新增：跳转到设置的回调

  const EnhancedImageUploadDialog({
    super.key,
    this.onImageSelected,
    this.allowMultiple = false,
    this.onGoToSettings,
  });

  @override
  State<EnhancedImageUploadDialog> createState() => _EnhancedImageUploadDialogState();
}

class _EnhancedImageUploadDialogState extends State<EnhancedImageUploadDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _uploadedImages = [];
  final ImageManager _imageManager = ImageManager();
  final CloudStorageManager _storageManager = CloudStorageManager();

  // 云存储配置相关
  List<CloudStorageConfig> _storageConfigs = [];
  CloudStorageConfig? _selectedConfig;
  List<BucketInfo> _buckets = [];
  BucketInfo? _selectedBucket;
  List<FolderInfo> _folders = [];
  FolderInfo? _selectedFolder;
  final TextEditingController _fileNameController = TextEditingController();

  bool _isLoadingConfigs = true;
  bool _hasConfig = false; // 是否有配置

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _imageManager.initialize();
    _loadCloudStorageConfigs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  /// 加载云存储配置
  Future<void> _loadCloudStorageConfigs() async {
    setState(() {
      _isLoadingConfigs = true;
    });

    final configs = await _storageManager.getConfigs();
    setState(() {
      _storageConfigs = configs;
      _hasConfig = configs.isNotEmpty;
      if (configs.isNotEmpty) {
        _selectedConfig = configs[0];
      }
      _isLoadingConfigs = false;
    });
  }

  /// 选择云存储配置
  Future<void> _onConfigChanged(CloudStorageConfig? config) async {
    setState(() {
      _selectedConfig = config;
      _buckets = [];
      _selectedBucket = null;
      _folders = [];
      _selectedFolder = null;
    });

    if (config != null) {
      // 加载buckets
      final buckets = await _storageManager.getBuckets(config);
      setState(() {
        _buckets = buckets;
        if (buckets.isNotEmpty) {
          _selectedBucket = buckets[0];
        }
      });

      // 加载文件夹
      if (_selectedBucket != null) {
        _loadFolders(_selectedBucket!);
      }
    }
  }

  /// 选择bucket
  Future<void> _onBucketChanged(BucketInfo? bucket) async {
    setState(() {
      _selectedBucket = bucket;
      _folders = [];
      _selectedFolder = null;
    });

    if (bucket != null && _selectedConfig != null) {
      await _loadFolders(bucket);
    }
  }

  /// 加载文件夹列表
  Future<void> _loadFolders(BucketInfo bucket) async {
    if (_selectedConfig == null) return;

    final folders = await _storageManager.getFolders(_selectedConfig!, bucket.name);
    setState(() {
      _folders = folders;
      if (folders.isNotEmpty) {
        _selectedFolder = folders[0];
      }
    });
  }

  /// 生成默认文件名
  String _generateDefaultFileName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'image_$timestamp';
  }

  @override
  Widget build(BuildContext context) {
    // 如果没有配置，显示引导页面
    if (!_isLoadingConfigs && !_hasConfig) {
      return _buildNoConfigDialog();
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 700,
        height: 750,
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

            const SizedBox(height: 16),

            // 云存储选项
            _buildCloudStorageOptions(),

            const SizedBox(height: 12),

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

            const SizedBox(height: 12),

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

            const SizedBox(height: 12),

            // 底部按钮
            Row(
              children: [
                // 我的图库按钮
                if (_hasConfig)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _openImageLibrary,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1A9B8E)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library, size: 16, color: Color(0xFF1A9B8E)),
                            SizedBox(width: 6),
                            Text('我的图库', style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E))),
                          ],
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

  /// 构建无配置提示对话框
  Widget _buildNoConfigDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 64,
              color: Color(0xFFFF9800),
            ),
            const SizedBox(height: 24),
            const Text(
              '未配置云存储',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            const Text(
              '您还没有配置云存储服务，请先设置阿里云OSS、腾讯云COS或七牛云',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '取消',
                          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // 调用回调跳转到存储设置页面
                        if (widget.onGoToSettings != null) {
                          widget.onGoToSettings!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '去设置',
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  /// 构建云存储选项区域
  Widget _buildCloudStorageOptions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_queue, size: 18, color: Color(0xFF1A9B8E)),
              const SizedBox(width: 8),
              const Text(
                '云存储配置',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 配置选择
          _buildConfigSelector(),
          const SizedBox(height: 8),
          // Bucket和文件夹选择
          if (_selectedConfig != null) ...[
            Row(
              children: [
                Expanded(child: _buildBucketSelector()),
                const SizedBox(width: 12),
                Expanded(child: _buildFolderSelector()),
              ],
            ),
            const SizedBox(height: 8),
            // 文件名输入
            _buildFileNameInput(),
          ],
        ],
      ),
    );
  }

  /// 构建配置选择器
  Widget _buildConfigSelector() {
    return Row(
      children: [
        const SizedBox(
          width: 80,
          child: Text('配置:', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CloudStorageConfig>(
                isExpanded: true,
                value: _selectedConfig,
                hint: const Text('选择云存储配置', style: TextStyle(fontSize: 13)),
                items: _storageConfigs.map((config) {
                  return DropdownMenuItem<CloudStorageConfig>(
                    value: config,
                    child: Text(config.providerName, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: _onConfigChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建Bucket选择器
  Widget _buildBucketSelector() {
    return Row(
      children: [
        const SizedBox(
          width: 60,
          child: Text('Bucket:', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BucketInfo>(
                isExpanded: true,
                value: _selectedBucket,
                hint: const Text('选择Bucket', style: TextStyle(fontSize: 13)),
                items: _buckets.map((bucket) {
                  return DropdownMenuItem<BucketInfo>(
                    value: bucket,
                    child: Text(
                      bucket.region != null ? '${bucket.name} (${bucket.region})' : bucket.name,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: _onBucketChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建文件夹选择器
  Widget _buildFolderSelector() {
    return Row(
      children: [
        const SizedBox(
          width: 60,
          child: Text('文件夹:', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<FolderInfo>(
                isExpanded: true,
                value: _selectedFolder,
                hint: const Text('选择文件夹', style: TextStyle(fontSize: 13)),
                items: _folders.map((folder) {
                  return DropdownMenuItem<FolderInfo>(
                    value: folder,
                    child: Text(folder.name, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (folder) {
                  setState(() {
                    _selectedFolder = folder;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建文件名输入框
  Widget _buildFileNameInput() {
    return Row(
      children: [
        const SizedBox(
          width: 80,
          child: Text('文件名:', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: _fileNameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '输入文件名（可选）',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
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
                      onTap: _uploadWithCloudStorage,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload,
                              size: 48,
                              color: Color(0xFF1A9B8E),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '点击选择本地文件上传',
                              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                            ),
                            if (_selectedBucket != null && _selectedFolder != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '上传到: ${_selectedBucket?.name ?? ""}/${_selectedFolder?.name ?? ""}',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        const SizedBox(height: 16),
        // 提示文字
        Text(
          '支持 jpg/gif/png 格式，或点击"我的图库"从云存储选择',
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
                      onTap: _uploadedImages.length >= 8 ? null : _uploadWithCloudStorage,
                      child: AbsorbPointer(
                        absorbing: _uploadedImages.length >= 8,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 48,
                                color: _uploadedImages.length >= 8
                                    ? const Color(0xFFCCCCCC)
                                    : const Color(0xFF1A9B8E),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '点击选择本地文件上传',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: _uploadedImages.length >= 8
                                        ? const Color(0xFFCCCCCC)
                                        : const Color(0xFF666666)),
                              ),
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
        Text(
          '支持 gif 格式动态图片，最多上传8张（可从"我的图库"选择）',
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

    final upload = html.FileUploadInputElement();
    upload.accept = 'image/jpeg, image/gif, image/png';
    upload.click();

    upload.onChange.listen((e) {
      final files = upload.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
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

  /// 使用云存储上传
  Future<void> _uploadWithCloudStorage() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('本地上传仅支持Web平台')),
      );
      return;
    }

    // 检查是否选择了bucket和folder
    if (_selectedBucket == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择Bucket')),
      );
      return;
    }

    if (_selectedFolder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择文件夹')),
      );
      return;
    }

    final upload = html.FileUploadInputElement();
    upload.accept = 'image/jpeg, image/gif, image/png, video/mp4';
    upload.click();

    upload.onChange.listen((e) {
      final files = upload.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoad.listen((e) {
          final result = reader.result as String?;
          if (result != null && mounted) {
            setState(() {
              if (!widget.allowMultiple) {
                _uploadedImages.clear();
              }
              _uploadedImages.add(result);
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已选择: ${file.name}')),
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

    final upload = html.FileUploadInputElement();
    upload.accept = 'image/gif';
    upload.click();

    upload.onChange.listen((e) {
      final files = upload.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
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

  /// 确定按钮处理
  void _handleConfirm() async {
    if (_uploadedImages.isEmpty) return;

    if (_selectedConfig != null && _selectedBucket != null && _selectedFolder != null) {
      // 使用云存储上传
      try {
        // 获取第一张图片的base64数据
        final imageData = _uploadedImages.first;
        // 移除base64前缀
        final base64Data = imageData.contains(',') ? imageData.split(',')[1] : imageData;

        // 生成文件名
        final fileName = _fileNameController.text.isNotEmpty
            ? _fileNameController.text
            : _generateDefaultFileName();

        final folderPath = _selectedFolder?.path ?? '';

        // 上传到云存储
        final uploadedUrl = await _storageManager.uploadFile(
          config: _selectedConfig!,
          bucketName: _selectedBucket!.name,
          folderPath: folderPath,
          fileName: fileName,
          fileData: base64Data,
        );

        // 返回上传后的URL
        final selectedImage = widget.allowMultiple ? _uploadedImages.join(',') : uploadedUrl;
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(selectedImage);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片上传到云存储成功')),
          );
        }

        Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('上传失败: $e')),
          );
        }
      }
    } else {
      // 如果还没有选择bucket和folder，提示用户
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先选择Bucket和文件夹')),
        );
      }
    }
  }

  /// 打开我的图库
  void _openImageLibrary() {
    if (_selectedConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择云存储配置')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ImageLibraryDialog(
        config: _selectedConfig!,
        onImageSelected: (imageUrl, imageName) {
          setState(() {
            if (!widget.allowMultiple) {
              _uploadedImages.clear();
            }
            _uploadedImages.add(imageUrl);
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
