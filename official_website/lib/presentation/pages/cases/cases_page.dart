import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/serve/hero_banner_widget.dart';
import '../../widgets/cases/case_category_widget.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../routes/app_router.dart';

/// 案例页面
class CasesPage extends StatefulWidget {
  const CasesPage({super.key});

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Hero 横幅
              const HeroBannerWidget(
                title: '服务客户 来自全国各地',
                subtitle: '',
                backgroundImageUrl: 'assets/case-banner.png',
              ),

              // 导航栏（在 Hero 横幅下面）
              UnifiedNavigationBar(
                currentPath: AppRouter.cases,
              ),

              // 案例分类标签栏
              const CaseCategoryWidget(),

              // Footer 底部导航栏
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
