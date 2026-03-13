import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/account_settings.dart';

/// 基本信息区域
class BasicInfoSection extends StatelessWidget {
  final AccountSettings settings;
  final VoidCallback onEditTap;

  const BasicInfoSection({
    super.key,
    required this.settings,
    required this.onEditTap,
  });

  String _formatValue(String? value) {
    return value?.isNotEmpty == true ? value! : '暂未填写';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '个人信息',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '账户信息',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 信息列表
          _buildInfoRow('用户名', settings.username),
          _buildInfoRow('性别', settings.gender.displayName),
          _buildInfoRow('生日', _formatBirthdate(settings.birthdate)),
          _buildInfoRow('个人简介', _formatValue(settings.bio)),
          _buildInfoRow('所在地', _formatValue(settings.location)),
          _buildInfoRow('个人网站', _formatValue(settings.website)),

          const SizedBox(height: 24),

          // 修改信息按钮
          Align(
            alignment: Alignment.centerLeft,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '修改信息',
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isEmpty = value == '暂未填写';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isEmpty ? const Color(0xFF999999) : const Color(0xFF333333),
                fontWeight: isEmpty ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBirthdate(DateTime? date) {
    if (date == null) return '暂未填写';
    return '${date.year}年${date.month}月${date.day}日';
  }
}
