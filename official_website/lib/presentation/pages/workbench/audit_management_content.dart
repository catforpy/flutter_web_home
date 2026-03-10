import 'package:flutter/material.dart';
import 'components/audit_info_banner.dart';
import 'components/online_version_card.dart';
import 'components/audit_version_card.dart';
import 'components/experience_version_card.dart';
import 'components/code_update_card.dart';

/// 审核管理页面内容区
/// 只包含内容，不包含侧边栏和标题栏
class AuditManagementContent extends StatelessWidget {
  const AuditManagementContent({super.key});

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
            const AuditInfoBanner(),

            const SizedBox(height: 24),

            // 版本卡片网格
            Row(
              children: [
                Expanded(
                  child: OnlineVersionCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AuditVersionCard(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ExperienceVersionCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: CodeUpdateCard(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
