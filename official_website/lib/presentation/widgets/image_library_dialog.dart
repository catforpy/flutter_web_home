import 'package:flutter/material.dart';
import 'package:official_website/presentation/models/cloud_storage_config.dart';
import 'package:official_website/presentation/services/cloud_storage_manager.dart';

/// 云存储图库浏览器对话框
class ImageLibraryDialog extends StatefulWidget {
  final CloudStorageConfig config;
  final Function(String url, String name)? onImageSelected;

  const ImageLibraryDialog({
    super.key,
    required this.config,
    this.onImageSelected,
  });

  @override
  State<ImageLibraryDialog> createState() => _ImageLibraryDialogState();
}

class _ImageLibraryDialogState extends State<ImageLibraryDialog> {
  final CloudStorageManager _storageManager = CloudStorageManager();

  // 导航状态
  List<BucketInfo> _buckets = [];
  List<FolderInfo> _folders = [];
  List<CloudFileItem> _files = [];

  BucketInfo? _selectedBucket;
  FolderInfo? _currentFolder;
  List<String> _breadcrumb = []; // 面包屑导航

  bool _isLoading = false;
  String _currentView = 'buckets'; // buckets, folders, files

  @override
  void initState() {
    super.initState();
    _loadBuckets();
  }

  /// 加载所有buckets
  Future<void> _loadBuckets() async {
    setState(() {
      _isLoading = true;
      _currentView = 'buckets';
      _breadcrumb = ['所有Bucket'];
    });

    final buckets = await _storageManager.getBuckets(widget.config);

    setState(() {
      _buckets = buckets;
      _folders = [];
      _files = [];
      _selectedBucket = null;
      _currentFolder = null;
      _isLoading = false;
    });
  }

  /// 选择bucket，加载文件夹
  Future<void> _selectBucket(BucketInfo bucket) async {
    setState(() {
      _isLoading = true;
      _selectedBucket = bucket;
      _currentView = 'folders';
      _breadcrumb = ['所有Bucket', bucket.name];
    });

    final folders = await _storageManager.getFolders(widget.config, bucket.name);

    setState(() {
      _folders = folders;
      _files = [];
      _currentFolder = null;
      _isLoading = false;
    });
  }

  /// 选择文件夹，加载文件
  Future<void> _selectFolder(FolderInfo folder) async {
    setState(() {
      _isLoading = true;
      _currentFolder = folder;
      _currentView = 'files';
      _breadcrumb = ['所有Bucket', _selectedBucket!.name, folder.name];
    });

    // TODO: 实际应该调用API获取文件夹中的文件
    // 这里使用模拟数据
    await Future.delayed(const Duration(milliseconds: 500));

    final mockFiles = _generateMockFiles(folder.path);

    setState(() {
      _files = mockFiles;
      _isLoading = false;
    });
  }

  /// 生成模拟文件数据
  List<CloudFileItem> _generateMockFiles(String folderPath) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return [
      CloudFileItem(
        id: 'file_${timestamp}_1',
        name: 'product_banner_01.jpg',
        url: 'https://via.placeholder.com/300x200/1A9B8E/FFFFFF?text=Product+Banner+1',
        type: 'image',
        size: '245KB',
        modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CloudFileItem(
        id: 'file_${timestamp}_2',
        name: 'product_detail_02.png',
        url: 'https://via.placeholder.com/300x200/E94B3C/FFFFFF?text=Product+Detail+2',
        type: 'image',
        size: '189KB',
        modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CloudFileItem(
        id: 'file_${timestamp}_3',
        name: 'promo_video_01.mp4',
        url: 'https://via.placeholder.com/300x200/6C5CE7/FFFFFF?text=Promo+Video+1',
        type: 'video',
        size: '5.2MB',
        modifiedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      CloudFileItem(
        id: 'file_${timestamp}_4',
        name: 'avatar_default.jpg',
        url: 'https://via.placeholder.com/300x200/00CEC9/FFFFFF?text=Avatar+Default',
        type: 'image',
        size: '98KB',
        modifiedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      CloudFileItem(
        id: 'file_${timestamp}_5',
        name: 'banner_wide.jpg',
        url: 'https://via.placeholder.com/300x200/FDCB6E/FFFFFF?text=Banner+Wide',
        type: 'image',
        size: '312KB',
        modifiedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CloudFileItem(
        id: 'file_${timestamp}_6',
        name: 'demo_video.mp4',
        url: 'https://via.placeholder.com/300x200/A29BFE/FFFFFF?text=Demo+Video',
        type: 'video',
        size: '8.7MB',
        modifiedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  /// 返回上一级
  void _navigateBack() {
    if (_currentView == 'files') {
      _selectFolder(_folders[0]); // 返回文件夹列表
    } else if (_currentView == 'folders') {
      _loadBuckets(); // 返回bucket列表
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 900,
        height: 650,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_queue, size: 24, color: Color(0xFF1A9B8E)),
                    const SizedBox(width: 12),
                    Text(
                      '我的图库',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2329),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A9B8E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.config.providerName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1A9B8E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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

            // 面包屑导航
            _buildBreadcrumb(),

            const SizedBox(height: 16),

            // 内容区域
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建面包屑导航
  Widget _buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_open, size: 18, color: Color(0xFF1A9B8E)),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              children: _breadcrumb.map((crumb) {
                final index = _breadcrumb.indexOf(crumb);
                final isLast = index == _breadcrumb.length - 1;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.chevron_right, size: 16, color: Color(0xFF999999)),
                      ),
                    MouseRegion(
                      cursor: isLast ? SystemMouseCursors.basic : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: isLast
                            ? null
                            : () {
                                if (index == 0) _loadBuckets();
                                if (index == 1) _selectBucket(_selectedBucket!);
                              },
                        child: Text(
                          crumb,
                          style: TextStyle(
                            fontSize: 13,
                            color: isLast ? const Color(0xFF1A9B8E) : const Color(0xFF666666),
                            fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
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

  /// 构建内容区域
  Widget _buildContent() {
    if (_currentView == 'buckets') {
      return _buildBucketsGrid();
    } else if (_currentView == 'folders') {
      return _buildFoldersGrid();
    } else {
      return _buildFilesGrid();
    }
  }

  /// 构建Buckets网格
  Widget _buildBucketsGrid() {
    if (_buckets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('暂无Bucket', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _buckets.length,
      itemBuilder: (context, index) {
        final bucket = _buckets[index];
        return _buildBucketCard(bucket);
      },
    );
  }

  /// 构建Bucket卡片
  Widget _buildBucketCard(BucketInfo bucket) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectBucket(bucket),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.storage, size: 28, color: Color(0xFF1A9B8E)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bucket.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (bucket.region != null)
                Text(
                  bucket.region!,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
              const SizedBox(height: 12),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('查看文件夹', style: TextStyle(fontSize: 12, color: Color(0xFF1A9B8E))),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: const Color(0xFF1A9B8E)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建文件夹网格
  Widget _buildFoldersGrid() {
    if (_folders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 16),
            const Text('暂无文件夹', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF1A9B8E)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('关闭', style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return _buildFolderCard(folder);
      },
    );
  }

  /// 构建文件夹卡片
  Widget _buildFolderCard(FolderInfo folder) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectFolder(folder),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.folder, size: 48, color: Color(0xFF1A9B8E)),
              const SizedBox(height: 12),
              Text(
                folder.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text('查看文件', style: TextStyle(fontSize: 11, color: Color(0xFF999999))),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建文件网格
  Widget _buildFilesGrid() {
    if (_files.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('暂无文件', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        return _buildFileCard(file);
      },
    );
  }

  /// 构建文件卡片
  Widget _buildFileCard(CloudFileItem file) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.onImageSelected != null) {
            widget.onImageSelected!(file.url, file.name);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文件预览
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: file.type == 'video'
                          ? const Center(
                              child: Icon(Icons.play_circle_outline,
                                  size: 48, color: Color(0xFF1A9B8E)),
                            )
                          : Image.network(
                              file.url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 48, color: Color(0xFFCCCCCC)),
                                );
                              },
                            ),
                    ),
                    // 类型标签
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: file.type == 'video'
                              ? const Color(0xFF6C5CE7)
                              : const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          file.type == 'video' ? '视频' : '图片',
                          style: const TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 文件信息
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          file.size,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, size: 3, color: Color(0xFFDDDDDD)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDate(file.modifiedAt),
                            style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
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
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }
}

/// 云存储文件项
class CloudFileItem {
  final String id;
  final String name;
  final String url;
  final String type; // 'image' or 'video'
  final String size;
  final DateTime modifiedAt;

  CloudFileItem({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    required this.modifiedAt,
  });
}
