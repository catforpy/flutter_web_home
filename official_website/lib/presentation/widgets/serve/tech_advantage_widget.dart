import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/tech_advantage.dart';
import '../common/section_title_widget.dart';

/// 技术优势组件
/// 三栏卡片式布局，展示技术优势和特点
class TechAdvantageWidget extends StatelessWidget {
  /// 技术优势列表
  final List<TechAdvantage> advantages;

  /// 背景色
  final Color? backgroundColor;

  const TechAdvantageWidget({
    super.key,
    required this.advantages,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: backgroundColor ?? AppColors.backgroundLight,
      padding: EdgeInsets.only(
        top: AppSizes.xxxl,
        left: AppSizes.lg,
        right: AppSizes.lg,
        bottom: AppSizes.xxxl + 80, // 底部额外留出80px空间给卡片下滑动画
      ),
      child: Column(
        children: [
          // 标题区
          const SectionTitleWidget(
            title: '安全可靠，全程技术支持',
            subtitle: '为全行业提供高效便捷的小程序开发服务',
          ),

          SizedBox(height: AppSizes.xxxl),

          // 三栏卡片布局
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: screenWidth < AppSizes.breakpointTablet
                  ? Column(
                      children: advantages
                          .map((advantage) => Padding(
                                padding: EdgeInsets.only(bottom: AppSizes.lg),
                                child: _AdvantageCard(advantage: advantage),
                              ))
                          .toList(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: advantages
                          .map((advantage) => Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.md,
                                ),
                                child: SizedBox(
                                  width: 350, // 固定宽度
                                  child: _AdvantageCard(advantage: advantage),
                                ),
                              ))
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 单个优势卡片
class _AdvantageCard extends StatefulWidget {
  final TechAdvantage advantage;

  const _AdvantageCard({required this.advantage});

  @override
  State<_AdvantageCard> createState() => _AdvantageCardState();
}

class _AdvantageCardState extends State<_AdvantageCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 固定值：先上浮10px，然后向下滑80px
    _slideAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -10.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 80.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              padding: EdgeInsets.all(AppSizes.xl),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 红色渐变圆形图标
                      AnimatedScale(
                        scale: _isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.secondary, Color(0xFFFF6B6B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.advantage.icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSizes.lg),

                      // 两行标题
                      Text(
                        widget.advantage.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSizes.fsXl,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),

                      if (widget.advantage.subtitle != null) ...[
                        SizedBox(height: AppSizes.xs),
                        Text(
                          widget.advantage.subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSizes.fsMd,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ],

                      SizedBox(height: AppSizes.md),

                      // 分隔线（细灰线）
                      Container(
                        width: 60,
                        height: 1,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(0.5),
                        ),
                      ),

                      SizedBox(height: AppSizes.md),

                      // 正文段落
                      Text(
                        widget.advantage.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: AppSizes.fsMd,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
}
