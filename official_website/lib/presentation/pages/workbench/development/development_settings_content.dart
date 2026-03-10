import 'package:flutter/material.dart';
import 'components/info_banner.dart';
import 'components/development_info_table.dart';
import 'components/mini_program_info_table.dart';
import 'components/server_domain_table.dart';

/// 开发设置页面内容区
/// 只包含内容，不包含侧边栏和标题栏
class DevelopmentSettingsContent extends StatelessWidget {
  const DevelopmentSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部信息提示
            const InfoBanner(),

            const SizedBox(height: 24),

            // 开发者设置表格
            const DevelopmentInfoTable(),

            const SizedBox(height: 24),

            // 小程序信息表格
            const MiniProgramInfoTable(),

            const SizedBox(height: 24),

            // 服务器域名表格
            const ServerDomainTable(),
          ],
        ),
      ),
    );
  }
}
