import 'package:flutter/material.dart';

/// 线上版本卡片
class OnlineVersionCard extends StatelessWidget {
  const OnlineVersionCard({super.key});

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
            '线上版本',
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
                      '4.2.2',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6FFED),
                        border: Border.all(color: const Color(0xFF52C41A), width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        '线上版本',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF52C41A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),

              // 右列：应用信息
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('应用名称', 'JJDXCX'),
                    const SizedBox(height: 16),
                    _buildInfoRow('到期时间', '2027-07-30 00:00:00'),
                    const SizedBox(height: 16),
                    _buildInfoRow('应用简介', 'junjundexiaochengxu'),
                  ],
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
            ),
          ),
        ),
      ],
    );
  }
}
