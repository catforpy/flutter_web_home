import 'package:flutter/material.dart';

/// 音视频文件预览对话框
class MediaPreviewDialog extends StatefulWidget {
  final Map<String, dynamic> file;

  const MediaPreviewDialog({super.key, required this.file});

  @override
  State<MediaPreviewDialog> createState() => _MediaPreviewDialogState();
}

class _MediaPreviewDialogState extends State<MediaPreviewDialog> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.file['type'] == 'mp4';
    final fileUrl = widget.file['url'] as String;

    return Dialog(
      child: Container(
        width: isVideo ? 800 : 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '文件预览',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.file['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 预览区域
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isVideo ? _buildVideoPlayer(fileUrl) : _buildAudioPlayer(fileUrl),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 文件信息
            _buildFileInfo(),
          ],
        ),
      ),
    );
  }

  /// 视频播放器
  Widget _buildVideoPlayer(String url) {
    return Stack(
      children: [
        // 视频播放器（这里用占位符，实际需要使用 video_player 插件）
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                _isPlaying ? '播放中' : '点击播放',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // 进度条占位
              Container(
                width: 300,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _isPlaying ? 0.3 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 播放控制按钮覆盖层
        Positioned.fill(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 音频播放器
  Widget _buildAudioPlayer(String url) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 音频波形占位
          Icon(
            Icons.graphic_eq,
            size: 100,
            color: _isPlaying ? const Color(0xFF52C41A) : Colors.grey[600],
          ),
          const SizedBox(height: 24),
          Text(
            widget.file['title'] as String,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 播放控制
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 32,
                onPressed: () {
                  // TODO: 实现上一个
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white,
                ),
                iconSize: 64,
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 32,
                onPressed: () {
                  // TODO: 实现下一个
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 进度条
          Column(
            children: [
              Slider(
                value: _isPlaying ? 0.3 : 0.0,
                onChanged: (value) {
                  // TODO: 实现进度控制
                },
                activeColor: const Color(0xFF52C41A),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_isPlaying ? 36 : 0),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _formatDuration(widget.file['duration'] as int),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 文件信息
  Widget _buildFileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '文件信息',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('文件名', widget.file['title'] as String),
          const SizedBox(height: 8),
          _buildInfoRow('文件类型', (widget.file['type'] as String).toUpperCase()),
          const SizedBox(height: 8),
          _buildInfoRow('时长', _formatDuration(widget.file['duration'] as int)),
          const SizedBox(height: 8),
          _buildInfoRow('文件大小', _formatFileSize()),
          const SizedBox(height: 8),
          _buildInfoRow('最近更新', _formatDateTime()),
        ],
      ),
    );
  }

  /// 信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label：',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  /// 格式化时长
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// 格式化文件大小（模拟）
  String _formatFileSize() {
    // 这里返回模拟值，实际应该从文件元数据获取
    final sizeInMB = (widget.file['duration'] as int) * 0.5;
    return '${sizeInMB.toStringAsFixed(1)} MB';
  }

  /// 格式化日期时间
  String _formatDateTime() {
    final dateTime = widget.file['lastUpdated'] as DateTime;
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
