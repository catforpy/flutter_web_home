import 'package:flutter/material.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/app_footer.dart';
import '../../widgets/home/home_hero_carousel.dart';

/// 首页
///
/// 展示网站的主要内容区域
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // 导航栏 - 固定在顶部
          const UnifiedNavigationBar(
            currentPath: '/',
          ),

          // 内容区域（可滚动）
          Expanded(
            child: ListView(
              children: [
                // 轮播图 - 全屏显示
                SizedBox(
                  height: screenHeight,
                  child: const HomeHeroCarousel(),
                ),

                // 其他内容区域（后续添加）
                // const SizedBox(height: 100, child: Center(child: Text('更多内容...'))),

                // AppFooter - 在所有内容的最后
                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
