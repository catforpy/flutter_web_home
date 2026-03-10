import 'package:flutter/material.dart';

/// 代码更新卡片
class CodeUpdateCard extends StatelessWidget {
  const CodeUpdateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '代码更新',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),

          // 内容区域
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左列：版本号
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '版本号',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '4.2.5',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),

              // 右列：版本信息
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('行业名称', '知识付费'),
                    const SizedBox(height: 16),
                    _buildInfoRow('行业简介', '借助小程序强力搭建知识付费新生态，支持图文、音频和视频，并可快速传播'),
                    const SizedBox(height: 16),
                    _buildInfoRow('更新描述', '分享优化'),
                    const SizedBox(height: 16),
                    const Text(
                      '特别说明',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '如果你设置过底部菜单,代码更新时将你设置的底部菜单一并提交审核。',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF4D4F),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // 最右侧按钮
              Align(
                alignment: Alignment.topCenter,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('重新提交审核');
                    },
                    child: Container(
                      width: 120,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF52C41A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '重新提交审核',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
