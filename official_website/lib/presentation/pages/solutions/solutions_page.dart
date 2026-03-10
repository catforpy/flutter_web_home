import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/serve/hero_banner_widget.dart';
import '../../widgets/solutions/solution_showcase_widget.dart';
import '../../widgets/serve/custom_solution_widget.dart';
import '../../widgets/solutions/solution_process_widget.dart';
import '../../widgets/solutions/service_process_widget.dart';
import '../../widgets/solutions/client_showcase_widget.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../routes/app_router.dart';

/// 解决方案页面
class SolutionsPage extends StatefulWidget {
  const SolutionsPage({super.key});

  @override
  State<SolutionsPage> createState() => _SolutionsPageState();
}

class _SolutionsPageState extends State<SolutionsPage> {
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
                title: '个性化软件开发定制专家',
                subtitle: '产品定位 | 产品设计 | 代码实现 | 产品上线',
                backgroundImageUrl: 'assets/solution-banner.png',
              ),

              // 导航栏（在 Hero 横幅下面）
              UnifiedNavigationBar(
                currentPath: AppRouter.solutions,
              ),

              // 图文展示区域
              const SolutionShowcaseWidget(),

              // 流程展示区域
              const SolutionProcessWidget(),

              // 定制化解决方案卡片
              const CustomSolutionWidget(),

              // 服务流程展示
              const ServiceProcessWidget(),

              // // 客户案例展示墙
              // const ClientShowcaseWidget(),

              // Footer 底部导航栏
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
