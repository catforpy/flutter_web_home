import 'package:flutter/material.dart';

/// 审核版本卡片
class AuditVersionCard extends StatelessWidget {
  const AuditVersionCard({super.key});

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
            '审核版本',
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

              // 中列：审核信息
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('审核状态', '审核未通过', const Color(0xFFFF4D4F)),
                    const SizedBox(height: 16),
                    _buildInfoRow('审核时间', '2026-01-17 21:32:21', null),
                    const SizedBox(height: 16),
                    const Text(
                      '原因描述',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1:小程序可用性和完整性不符合规则:\n'
                      '(1):你好，你的小程序实际展示为测试商品/内容，请上架正式运营商品/内容后再提交代码审核。\n'
                      '(2):你好，小程序【商城】页面无具体运营内容，请上架正式内容或商品（非测试）后重新提交审核。',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF333333),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),

              // 右列：状态标签
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '审核失败',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF4D4F),
                        fontWeight: FontWeight.w500,
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

  Widget _buildInfoRow(String label, String value, Color? valueColor) {
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
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
