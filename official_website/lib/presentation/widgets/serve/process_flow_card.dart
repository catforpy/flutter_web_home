import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/process_step.dart';

/// 流程卡片组件
/// 支持hover动效：遮罩变化 + Logo出现 + 元素放大弹出
class ProcessFlowCard extends StatefulWidget {
  final ProcessStep step;

  const ProcessFlowCard({
    super.key,
    required this.step,
  });

  @override
  State<ProcessFlowCard> createState() => _ProcessFlowCardState();
}

class _ProcessFlowCardState extends State<ProcessFlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: widget.step.isLarge ? 280 : 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              Image.network(
                widget.step.backgroundImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.8),
                          AppColors.primaryDark.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // 半透明遮罩 - hover时变深
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isHovered
                        ? [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.black.withValues(alpha: 0.8),
                          ]
                        : [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.4),
                          ],
                  ),
                ),
              ),

              // 内容
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo图片（只在hover时显示，带放大效果）
                    if (widget.step.logoImage != null)
                      AnimatedOpacity(
                        opacity: _isHovered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: AnimatedScale(
                          scale: _isHovered ? 1.15 : 0.8, // 从0.8放大到1.15，更明显的弹出效果
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut, // 弹性曲线
                          child: Image.network(
                            widget.step.logoImage!,
                            width: widget.step.isLarge ? 100 : 80,
                            height: widget.step.isLarge ? 100 : 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                widget.step.icon,
                                size: widget.step.isLarge ? 64 : 48,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),

                    SizedBox(height: AppSizes.sm),

                    // 标题（带放大效果）
                    AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0, // 文字放大10%
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: widget.step.isLarge ? AppSizes.fsXl : AppSizes.fsLg,
                          fontWeight: _isHovered ? FontWeight.bold : FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        child: Text(
                          widget.step.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSizes.sm),

                    // 短横线（带放大效果）
                    AnimatedScale(
                      scale: _isHovered ? 1.15 : 1.0, // 下划线放大15%
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: widget.step.isLarge ? 80 : 60,
                        height: 2,
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppColors.secondary
                              : Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
