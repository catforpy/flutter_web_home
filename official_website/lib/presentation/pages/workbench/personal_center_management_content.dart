import 'package:flutter/material.dart';
import 'page_management/page_editor.dart';

/// 个人中心管理内容区
class PersonalCenterManagementContent extends StatefulWidget {
  const PersonalCenterManagementContent({super.key});

  @override
  State<PersonalCenterManagementContent> createState() => _PersonalCenterManagementContentState();
}

class _PersonalCenterManagementContentState extends State<PersonalCenterManagementContent> {
  @override
  Widget build(BuildContext context) {
    // 直接使用 PageEditor，并设置初始页面类型为"个人中心"
    return const PageEditor(
      initialPageType: '个人中心',
    );
  }
}
