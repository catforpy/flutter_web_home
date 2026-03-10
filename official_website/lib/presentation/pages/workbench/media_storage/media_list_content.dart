import 'package:flutter/material.dart';
import 'qiniu_config_page.dart';
import 'upload_dialog.dart';
import 'preview_dialog.dart';

/// 音视频文件列表页内容
class MediaListContent extends StatefulWidget {
  const MediaListContent({super.key});

  @override
  State<MediaListContent> createState() => _MediaListContentState();
}

class _MediaListContentState extends State<MediaListContent> {
  // 当前存储服务商
  String _currentProvider = 'qiniu'; // qiniu 或 tencent

  // 音视频文件列表数据
  final List<Map<String, dynamic>> _mediaFiles = [
    {
      'id': 1,
      'title': 'introduction_video.mp4',
      'type': 'mp4',
      'url': 'https://feixing.zyzcc.cn/introduction_video.mp4',
      'duration': 120, // 秒
      'lastUpdated': DateTime(2025, 1, 15, 10, 30),
    },
    {
      'id': 2,
      'title': 'background_music.mp3',
      'type': 'mp3',
      'url': 'https://feixing.zyzcc.cn/background_music.mp3',
      'duration': 180,
      'lastUpdated': DateTime(2025, 1, 14, 15, 45),
    },
    {
      'id': 3,
      'title': 'course_demo.mp4',
      'type': 'mp4',
      'url': 'https://feixing.zyzcc.cn/course_demo.mp4',
      'duration': 240,
      'lastUpdated': DateTime(2025, 1, 13, 9, 20),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // A. 顶部提示区 (Alert Banner)
          _buildAlertBanner(),

          const SizedBox(height: 24),

          // B. 配置概览卡片
          _buildConfigSummaryCard(),

          const SizedBox(height: 24),

          // C. 工具栏
          _buildToolbar(),

          const SizedBox(height: 16),

          // D. 数据表格
          Expanded(
            child: _buildDataTable(),
          ),
        ],
      ),
    );
  }

  /// A. 顶部提示区
  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Row(
        children: [
          // 七牛云 Logo 图标
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF00B4EF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // 提示信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '七牛云对象存储',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: Colors.red[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '视频文件必须以英文字母名字，否则会出现不能播放的情况！',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 切换腾讯云按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentProvider = _currentProvider == 'qiniu' ? 'tencent' : 'qiniu';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_currentProvider == 'qiniu' ? '已切换到七牛云' : '已切换到腾讯云'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _currentProvider == 'qiniu' ? Icons.cloud_queue : Icons.cloud,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '切换腾讯云',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// B. 配置概览卡片
  Widget _buildConfigSummaryCard() {
    return Container(
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
          // 左侧：图标 + 标题
          const Icon(
            Icons.video_library,
            size: 32,
            color: Color(0xFF1A9B8E),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '音视频管理',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentProvider == 'qiniu'
                      ? '您已配置七牛信息，修改时会有 5 分钟左右的延迟，请稍后刷新重试'
                      : '您已配置腾讯云信息，修改时会有 5 分钟左右的延迟，请稍后刷新重试',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // 右侧操作组
          Row(
            children: [
              // 七牛配置按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QiniuConfigPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52C41A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '七牛配置',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 重置服务器域名按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _showResetDomainDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52C41A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '重置服务器域名',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  /// C. 工具栏
  Widget _buildToolbar() {
    return Row(
      children: [
        // 文件上传按钮
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              _showUploadDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF52C41A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    '文件上传',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
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

  /// D. 数据表格
  Widget _buildDataTable() {
    return Container(
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
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _TableHeader('文件名')),
                Expanded(flex: 2, child: _TableHeader('类型')),
                Expanded(flex: 4, child: _TableHeader('地址')),
                Expanded(flex: 2, child: _TableHeader('时长')),
                Expanded(flex: 3, child: _TableHeader('最近更新')),
                Expanded(flex: 3, child: _TableHeader('操作')),
              ],
            ),
          ),

          // 表格内容
          Expanded(
            child: ListView.builder(
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                final file = _mediaFiles[index];
                return _buildTableRow(file, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 表格行
  Widget _buildTableRow(Map<String, dynamic> file, int index) {
    final isEven = index % 2 == 0;
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isEven ? Colors.white : const Color(0xFFFAFAFA),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
        ),
        child: Row(
          children: [
            // 文件名
            Expanded(
              flex: 3,
              child: Text(
                file['title'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 类型
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: file['type'] == 'mp4'
                      ? const Color(0xFFE6F7FF)
                      : const Color(0xFFF6FFED),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  (file['type'] as String).toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: file['type'] == 'mp4'
                        ? const Color(0xFF1890FF)
                        : const Color(0xFF52C41A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // 地址
            Expanded(
              flex: 4,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _copyToClipboard(file['url'] as String);
                  },
                  child: Tooltip(
                    message: file['url'] as String,
                    child: Text(
                      file['url'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1890FF),
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),

            // 时长
            Expanded(
              flex: 2,
              child: Text(
                _formatDuration(file['duration'] as int),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),

            // 最近更新
            Expanded(
              flex: 3,
              child: Text(
                _formatDateTime(file['lastUpdated'] as DateTime),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ),

            // 操作
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // 重传按钮
                  _buildActionButton(
                    '重传',
                    const Color(0xFF52C41A),
                    Icons.refresh,
                    () => _reuploadFile(file),
                  ),
                  const SizedBox(width: 8),

                  // 复制链接按钮
                  _buildActionButton(
                    '复制链接',
                    const Color(0xFF52C41A),
                    Icons.link,
                    () => _copyToClipboard(file['url'] as String),
                  ),
                  const SizedBox(width: 8),

                  // 预览按钮
                  _buildActionButton(
                    '预览',
                    const Color(0xFF52C41A),
                    Icons.play_arrow,
                    () => _previewFile(file),
                  ),
                  const SizedBox(width: 8),

                  // 删除按钮
                  _buildActionButton(
                    '删除',
                    const Color(0xFFFF4D4F),
                    Icons.delete,
                    () => _deleteFile(file),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 操作按钮
  Widget _buildActionButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示上传对话框
  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => const MediaUploadDialog(),
    );
  }

  /// 重传文件
  void _reuploadFile(Map<String, dynamic> file) {
    // TODO: 实现重传功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('重传：${file['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 复制到剪贴板
  void _copyToClipboard(String text) {
    // TODO: 实现复制到剪贴板
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('链接已复制到剪贴板'),
        duration: const Duration(seconds: 2),
        backgroundColor: Color(0xFF52C41A),
      ),
    );
  }

  /// 预览文件
  void _previewFile(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => MediaPreviewDialog(file: file),
    );
  }

  /// 删除文件
  void _deleteFile(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除文件 "${file['title']}" 吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mediaFiles.removeWhere((item) => item['id'] == file['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('文件已删除'),
                  backgroundColor: Color(0xFF52C41A),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D4F),
              foregroundColor: Colors.white,
            ),
            child: const Text('确定删除'),
          ),
        ],
      ),
    );
  }

  /// 显示重置域名对话框
  void _showResetDomainDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置服务器域名'),
        content: const Text('确定要重置服务器域名吗？此操作会更新所有音视频文件的URL前缀。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现重置域名逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('服务器域名重置成功'),
                  backgroundColor: Color(0xFF52C41A),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 格式化时长
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}分${remainingSeconds}秒';
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// 表头组件
class _TableHeader extends StatelessWidget {
  final String title;

  const _TableHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }
}
