import 'package:flutter/material.dart';
import 'audit_management_page.dart';

/// 审核管理路由配置
class AuditManagementRoutes {
  static const String routeName = '/audit-management';

  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AuditManagementPage(),
      ),
    );
  }
}
