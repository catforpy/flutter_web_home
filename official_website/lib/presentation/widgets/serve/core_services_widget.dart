import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/service_item.dart';
import '../common/service_card_widget.dart';
import '../common/section_title_widget.dart';

/// 核心服务组件
/// 展示4个核心服务项目
class CoreServicesWidget extends StatelessWidget {
  /// 服务项目列表
  final List<ServiceItem> services;

  /// 背景色
  final Color? backgroundColor;

  const CoreServicesWidget({
    super.key,
    required this.services,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: backgroundColor ?? AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.xxl,
        horizontal: AppSizes.lg,
      ),
      child: Column(
        children: [
          // 标题
          const SectionTitleWidget(
            title: '高品质行业服务',
            subtitle: '为企业提供一站式技术服务，以高品质铸造商业价值',
          ),

          SizedBox(height: AppSizes.xl),

          // 服务卡片网格
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 根据屏幕宽度决定列数
                  int crossAxisCount;
                  double childAspectRatio;

                  if (screenWidth < AppSizes.breakpointMobile) {
                    crossAxisCount = 1;
                    childAspectRatio = 0.8;
                  } else if (screenWidth < AppSizes.breakpointDesktop) {
                    crossAxisCount = 2;
                    childAspectRatio = 0.75;
                  } else {
                    crossAxisCount = 4;
                    childAspectRatio = 0.7;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: AppSizes.md,
                      mainAxisSpacing: AppSizes.md,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return ServiceCardWidget(
                        service: services[index],
                        onTap: () {
                          // TODO: 处理卡片点击事件
                          debugPrint('点击服务: ${services[index].title}');
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
