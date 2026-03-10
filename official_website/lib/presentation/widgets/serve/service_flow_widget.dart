import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/process_step.dart';
import '../common/section_title_widget.dart';
import 'process_flow_card.dart';

/// 服务流程组件
/// 移动互联网创业-企业数字化转型
/// 第一行2个大卡片，第二行3个小卡片
class ServiceFlowWidget extends StatelessWidget {
  /// 流程步骤列表（必须5个步骤）
  final List<ProcessStep> steps;

  /// 流程标题
  final String title;

  /// 流程副标题
  final String? subtitle;

  /// 背景色
  final Color? backgroundColor;

  const ServiceFlowWidget({
    super.key,
    required this.steps,
    this.title = '移动互联网创业-企业数字化转型',
    this.subtitle = '众多知名企业的放心之选，以专业的技术，成熟的行业经验，为企业提供高效可靠的移动化服务',
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 移动端：单列布局
    if (screenWidth < AppSizes.breakpointTablet) {
      return Container(
        color: backgroundColor ?? AppColors.background,
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.xxxl,
          horizontal: AppSizes.lg,
        ),
        child: Column(
          children: [
            SectionTitleWidget(
              title: title,
              subtitle: subtitle,
            ),
            SizedBox(height: AppSizes.xl),
            ...steps.map((step) => Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.md),
                  child: ProcessFlowCard(step: step),
                )),
          ],
        ),
      );
    }

    // 桌面端：2行布局（2+3）
    return Container(
      color: backgroundColor ?? AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.xxxl,
        horizontal: AppSizes.lg,
      ),
      child: Column(
        children: [
          // 标题
          SectionTitleWidget(
            title: title,
            subtitle: subtitle,
          ),

          SizedBox(height: AppSizes.xxxl),

          // 第一行：2个大卡片
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 560, // 大卡片固定宽度
                    child: ProcessFlowCard(step: steps[0]),
                  ),
                  SizedBox(width: AppSizes.lg),
                  SizedBox(
                    width: 560, // 大卡片固定宽度
                    child: ProcessFlowCard(step: steps[1]),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: AppSizes.lg),

          // 第二行：3个小卡片
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350, // 小卡片固定宽度
                    child: ProcessFlowCard(step: steps[2]),
                  ),
                  SizedBox(width: AppSizes.lg),
                  SizedBox(
                    width: 350, // 小卡片固定宽度
                    child: ProcessFlowCard(step: steps[3]),
                  ),
                  SizedBox(width: AppSizes.lg),
                  SizedBox(
                    width: 350, // 小卡片固定宽度
                    child: ProcessFlowCard(step: steps[4]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
