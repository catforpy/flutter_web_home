import 'package:flutter/material.dart';

/// 音视频文件上传对话框
class MediaUploadDialog extends StatefulWidget {
  const MediaUploadDialog({super.key});

  @override
  State<MediaUploadDialog> createState() => _MediaUploadDialogState();
}

class _MediaUploadDialogState extends State<MediaUploadDialog> {
  final List<String> _selectedFiles = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '上传音视频文件',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 文件命名提示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                border: Border.all(color: const Color(0xFFFFD591)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '文件名必须使用英文字母、数字、横杠或下划线，不能包含中文字符！',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 拖拽上传区域
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(
                  color: const Color(0xFFD9D9D9),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '拖拽文件到此处，或点击选择文件',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '支持 MP4、MP3、WAV 格式，单个文件不超过 2GB',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _selectFiles,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF52C41A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '选择文件',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              // 已选择的文件列表
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    return _buildFileItem(_selectedFiles[index], index);
                  },
                ),
              ),
            ],

            if (_isUploading) ...[
              const SizedBox(height: 16),
              // 上传进度条
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '上传中...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Text(
                        '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1890FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: const Color(0xFFE5E5E5),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF52C41A)),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // 底部按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _isUploading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    side: const BorderSide(color: Color(0xFFD9D9D9)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedFiles.isEmpty || _isUploading ? null : _startUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52C41A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('开始上传'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 文件项
  Widget _buildFileItem(String fileName, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(fileName),
            size: 24,
            color: const Color(0xFF1890FF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  _getFileType(fileName),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              setState(() {
                _selectedFiles.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  /// 选择文件
  void _selectFiles() {
    // TODO: 实现文件选择逻辑
    // 这里模拟添加文件
    setState(() {
      _selectedFiles.add('demo_video_${DateTime.now().millisecondsSinceEpoch}.mp4');
    });
  }

  /// 开始上传
  void _startUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // 模拟上传进度
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 100;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('文件上传成功'),
          backgroundColor: Color(0xFF52C41A),
        ),
      );

      Navigator.pop(context);
    }
  }

  /// 获取文件图标
  IconData _getFileIcon(String fileName) {
    if (fileName.endsWith('.mp4')) {
      return Icons.video_file;
    } else if (fileName.endsWith('.mp3') || fileName.endsWith('.wav')) {
      return Icons.audio_file;
    }
    return Icons.insert_drive_file;
  }

  /// 获取文件类型
  String _getFileType(String fileName) {
    if (fileName.endsWith('.mp4')) {
      return '视频文件 (MP4)';
    } else if (fileName.endsWith('.mp3')) {
      return '音频文件 (MP3)';
    } else if (fileName.endsWith('.wav')) {
      return '音频文件 (WAV)';
    }
    return '未知格式';
  }
}
