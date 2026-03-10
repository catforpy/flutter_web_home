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
      body: ListView(
        children: [
          // 轮播图 - 完全全屏，第一屏
          SizedBox(
            height: screenHeight,
            child: const HomeHeroCarousel(),
          ),

          // 导航栏 - 在轮播图下面，需要滚动才能看到
          const UnifiedNavigationBar(
            currentPath: '/',
          ),

          // 其他内容区域（后续添加）
          // const SizedBox(height: 100, child: Center(child: Text('更多内容...'))),

          // AppFooter - 在所有内容的最后
          const AppFooter(),
        ],
      ),
    );
  }
}
