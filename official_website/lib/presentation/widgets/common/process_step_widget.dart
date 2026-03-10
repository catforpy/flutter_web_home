import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/process_step.dart';

/// 流程步骤组件
/// 用于展示服务流程或开发流程
class ProcessStepWidget extends StatelessWidget {
  /// 步骤列表
  final List<ProcessStep> steps;

  /// 排列方向
  final Axis direction;

  /// 是否显示步骤编号
  final bool showStepNumbers;

  /// 连接符（用于横向排列）
  final Widget? connector;

  const ProcessStepWidget({
    super.key,
    required this.steps,
    this.direction = Axis.horizontal,
    this.showStepNumbers = false,
    this.connector,
  });

  @override
  Widget build(BuildContext context) {
    // 根据屏幕宽度判断是否使用横向布局
    final screenWidth = MediaQuery.of(context).size.width;
    final isHorizontal = screenWidth > AppSizes.breakpointTablet &&
        direction == Axis.horizontal;

    if (!isHorizontal) {
      return _buildVerticalSteps();
    }

    // 横向布局：两行展示
    // 第一行：2个步骤（小程序开发、可视化云开发）
    // 第二行：3个步骤（小程序测试、小程序发布、应用运营）
    final firstRowSteps = steps.sublist(0, 2);
    final secondRowSteps = steps.sublist(2);

    return Column(
      children: [
        // 第一行
        _buildRow(firstRowSteps, 1),
        SizedBox(height: AppSizes.xl),
        // 第二行
        _buildRow(secondRowSteps, 3),
      ],
    );
  }

  /// 构建横向布局的单行
  Widget _buildRow(List<ProcessStep> rowSteps, int startNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildRowStepsList(rowSteps, startNumber),
    );
  }

  /// 构建单行的步骤列表
  List<Widget> _buildRowStepsList(List<ProcessStep> rowSteps, int startNumber) {
    List<Widget> widgets = [];

    for (int i = 0; i < rowSteps.length; i++) {
      final step = rowSteps[i];
      final stepNumber = startNumber + i;

      // 添加步骤
      widgets.add(_buildStepItem(step, stepNumber));

      // 如果不是最后一个步骤，添加连接符和间距
      if (i < rowSteps.length - 1) {
        widgets.add(
          connector ??
              Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
        );
        widgets.add(SizedBox(width: AppSizes.xl));
      }
    }

    return widgets;
  }

  /// 纵向布局
  Widget _buildVerticalSteps() {
    return Column(
      children: _buildStepsList(false),
    );
  }

  /// 构建步骤列表（纵向）
  List<Widget> _buildStepsList(bool isHorizontal) {
    List<Widget> widgets = [];

    for (int i = 0; i < steps.length; i++) {
      // 添加步骤
      widgets.add(_buildStepItem(steps[i], i + 1));

      // 如果不是最后一个步骤，添加间距
      if (i < steps.length - 1) {
        widgets.add(SizedBox(height: AppSizes.lg));
      }
    }

    return widgets;
  }

  /// 构建单个步骤
  Widget _buildStepItem(ProcessStep step, int stepNumber) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 步骤图标或编号
          if (showStepNumbers)
            Container(
              width: AppSizes.iconXl + AppSizes.md,
              height: AppSizes.iconXl + AppSizes.md,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: TextStyle(
                    fontSize: AppSizes.fsLg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.background,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Icon(
                step.icon,
                size: AppSizes.iconXl,
                color: AppColors.primary,
              ),
            ),

          SizedBox(height: AppSizes.md),

          // 步骤标题
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.fsMd,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          // 步骤描述（如果有）
          if (step.description != null && step.description!.isNotEmpty) ...[
            SizedBox(height: AppSizes.xs),
            Text(
              step.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.fsSm,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
