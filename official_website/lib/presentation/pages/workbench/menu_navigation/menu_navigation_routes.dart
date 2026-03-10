import 'package:flutter/material.dart';
import 'menu_navigation_page.dart';

/// 菜单导航路由配置
class MenuNavigationRoutes {
  static const String routeName = '/menu-navigation';

  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuNavigationPage(),
      ),
    );
  }
}
