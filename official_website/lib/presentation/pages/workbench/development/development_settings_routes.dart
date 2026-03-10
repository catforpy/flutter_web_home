import 'package:flutter/material.dart';
import 'development_settings_page.dart';

/// 路由配置
class DevelopmentSettingsRoutes {
  static const String routeName = '/development-settings';

  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DevelopmentSettingsPage(),
      ),
    );
  }
}
