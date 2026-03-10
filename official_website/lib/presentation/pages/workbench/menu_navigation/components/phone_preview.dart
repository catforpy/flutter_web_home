import 'package:flutter/material.dart';

/// 手机预览组件
/// 模拟iPhone外框，实时显示配置效果
class PhonePreview extends StatelessWidget {
  final Map<String, dynamic> config;
  final int selectedTabIndex;
  final Function(int) onTabTap;

  const PhonePreview({
    super.key,
    required this.config,
    required this.selectedTabIndex,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = config['items'] as List<Map<String, dynamic>>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          width: 350,
          height: 700,
          child: Column(
            children: [
              // 状态栏
              _buildStatusBar(),

              // 导航栏
              _buildNavigationBar(),

              // 内容区
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F5F5),
                  child: const Center(
                    child: Text(
                      '页面内容区域',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ),
              ),

              // 底部TabBar
              _buildTabBar(items),

              // 底部Home条
              _buildHomeIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建状态栏
  Widget _buildStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '中国移动',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const Text(
            '9:41 AM',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Text(
            '🔋 100%',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  /// 构建导航栏
  Widget _buildNavigationBar() {
    final textColor = config['navigationBarTextStyle'] == 'white' ? Colors.white : Colors.black;

    return Container(
      height: 44,
      color: config['navigationBarBgColor'] as Color,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Center(
              child: Text(
                '小程序标题',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
          Text(
            '•••',
            style: TextStyle(fontSize: 18, color: textColor, letterSpacing: 2),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.circle_outlined,
            size: 16,
            color: textColor,
          ),
        ],
      ),
    );
  }

  /// 构建底部TabBar
  Widget _buildTabBar(List<Map<String, dynamic>> items) {
    final textColor = config['tabBarTextColor'] as Color;
    final selectedColor = config['tabBarSelectedColor'] as Color;
    final backgroundColor = config['tabBarBackgroundColor'] as Color;
    final borderStyle = config['tabBarBorderStyle'] as String;
    final borderColor = borderStyle == 'black' ? const Color(0xFF000000) : Colors.white;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedTabIndex == index;

          return Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onTabTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconData(item['iconPath'] as String),
                      size: 24,
                      color: isSelected ? selectedColor : textColor,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['name'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? selectedColor : const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 构建底部Home条
  Widget _buildHomeIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
      case 'home_active':
        return Icons.home;
      case 'school':
      case 'school_active':
        return Icons.school;
      case 'subscriptions':
      case 'subscriptions_active':
        return Icons.subscriptions;
      case 'person':
      case 'person_active':
        return Icons.person;
      case 'shopping_cart':
      case 'shopping_cart_active':
        return Icons.shopping_cart;
      case 'search':
      case 'search_active':
        return Icons.search;
      case 'favorite':
      case 'favorite_active':
        return Icons.favorite;
      case 'settings':
      case 'settings_active':
        return Icons.settings;
      case 'course':
      case 'course_active':
        return Icons.school;
      case 'subscription':
      case 'subscription_active':
        return Icons.subscriptions;
      case 'profile':
      case 'profile_active':
        return Icons.person;
      case 'help':
      case 'help_active':
        return Icons.help_outline;
      default:
        return Icons.help_outline;
    }
  }
}
