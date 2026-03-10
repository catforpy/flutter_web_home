import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/development_step.dart';
import 'development_step_card.dart';

/// 开发流程组件
/// 6个横向排列的开发步骤，带虚线连接
class DevelopmentFlowWidget extends StatelessWidget {
  final List<DevelopmentStep> steps;
  final Color backgroundColor;

  const DevelopmentFlowWidget({
    super.key,
    required this.steps,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Column(
        children: [
          // 标题区域
          Padding(
            padding: EdgeInsets.only(
              top: AppSizes.xxxl,
              bottom: AppSizes.xl,
            ),
            child: Column(
              children: [
                Text(
                  '开发流程',
                  style: TextStyle(
                    fontSize: AppSizes.fs3xl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                Text(
                  '高规格流程把控，保障优质产品输出',
                  style: TextStyle(
                    fontSize: AppSizes.fsMd,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // 6个步骤（横向排列）
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 判断是否为移动端（宽度小于768）
                final isMobile = constraints.maxWidth < 768;

                if (isMobile) {
                  // 移动端：垂直排列
                  return Column(
                    children: steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.xl),
                        child: DevelopmentStepCard(
                          step: step,
                          showConnector: index < steps.length - 1,
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  // 桌面端：水平排列
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return Expanded(
                          child: DevelopmentStepCard(
                            step: step,
                            showConnector: index < steps.length - 1,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),

          // 底部间距
          SizedBox(height: AppSizes.xxxl),
        ],
      ),
    );
  }
}
