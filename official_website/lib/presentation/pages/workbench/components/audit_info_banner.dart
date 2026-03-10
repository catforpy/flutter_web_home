import 'package:flutter/material.dart';

/// 审核管理页面顶部信息横幅
class AuditInfoBanner extends StatelessWidget {
  const AuditInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        border: const Border(
          left: BorderSide(color: Color(0xFF52C41A), width: 4),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        '线上版本：表示小程序已上线，可在微信通过小程序名称进行搜索；\n'
        '审核版本：表示小程序已提交微信进行审核，审核周期为3-4天；\n'
        '体验版本：也称"预览"，小程序内容配置后可扫码预览；\n'
        '代码更新：小程序功能根据市场需求在不断迭代更新，一些新功能需要更新版本上线后可使用；',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF52C41A),
          height: 1.8,
        ),
      ),
    );
  }
}
