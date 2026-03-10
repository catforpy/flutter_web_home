import 'package:flutter/material.dart';

/// 体验版本卡片
class ExperienceVersionCard extends StatelessWidget {
  const ExperienceVersionCard({super.key});

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
            '体验版本',
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(color: const Color(0xFF1890FF), width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        '体验版器',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1890FF),
                        ),
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
                    _buildInfoRow('最新版本', '当前代码库最新版本: 4.2.5'),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '体验说明',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '您的小程序代码包非最新版本,请点击右侧获取最新体验版,以更新到最新代码包。',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                            height: 1.6,
                          ),
                        ),
                      ],
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
                      debugPrint('重新获取最新体验版');
                    },
                    child: Container(
                      width: 140,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF52C41A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '重新获取最新体验版',
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
            ),
          ),
        ),
      ],
    );
  }
}
