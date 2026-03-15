import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// 区块标题组件
/// 用于展示各个区块的标题和副标题
class SectionTitleWidget extends StatelessWidget {
  /// 主标题
  final String title;

  /// 副标题（可选）
  final String? subtitle;

  /// 对齐方式
  final TextAlign textAlign;

  /// 是否居中对齐
  final bool centered;

  /// 标题颜色
  final Color? titleColor;

  /// 副标题颜色
  final Color? subtitleColor;

  const SectionTitleWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.textAlign = TextAlign.center,
    this.centered = true,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 主标题
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: AppSizes.fs2xl,
            fontWeight: FontWeight.bold,
            color: titleColor ?? AppColors.textPrimary,
            height: 1.4,
          ),
        ),

        // 如果有副标题，显示副标题
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.sm),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: AppSizes.fsLg,
              color: subtitleColor ?? AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
