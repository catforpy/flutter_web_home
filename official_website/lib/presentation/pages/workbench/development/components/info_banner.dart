import 'package:flutter/material.dart';

/// 绿色提示横幅组件
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        border: Border.all(
          color: const Color(0xFF52C41A),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Color(0xFF52C41A),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '提示：请妥善保管您的 AppID 和 AppSecret，不要泄露给第三方。如需修改服务器配置，请确保服务器已正确配置。',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
