import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// CTA 按钮类型
enum CTAButtonType {
  primary,
  secondary,
  outline,
  text,
}

/// 行动号召按钮组件
/// 用于引导用户进行关键操作
class CTAButtonWidget extends StatefulWidget {
  /// 按钮文字
  final String text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮类型
  final CTAButtonType type;

  /// 按钮大小
  final CTAButtonSize size;

  /// 是否禁用
  final bool disabled;

  /// 自定义宽度
  final double? width;

  /// 图标（可选）
  final IconData? icon;

  const CTAButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CTAButtonType.primary,
    this.size = CTAButtonSize.medium,
    this.disabled = false,
    this.width,
    this.icon,
  });

  @override
  State<CTAButtonWidget> createState() => _CTAButtonWidgetState();
}

class _CTAButtonWidgetState extends State<CTAButtonWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: _getHeight(),
          decoration: BoxDecoration(
            gradient: _getGradient(),
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: widget.type == CTAButtonType.outline
                ? Border.all(color: AppColors.primary)
                : null,
            boxShadow: _isHovered && !widget.disabled
                ? AppSizes.shadowMd
                : AppSizes.shadowSm,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: 0,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                    SizedBox(width: AppSizes.sm),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient? _getGradient() {
    if (widget.disabled) return null;
    if (widget.type == CTAButtonType.primary) {
      return AppColors.primaryGradient;
    }
    return null;
  }

  Color? _getBackgroundColor() {
    if (widget.disabled) return AppColors.textDisabled;
    switch (widget.type) {
      case CTAButtonType.primary:
        return null; // 使用渐变
      case CTAButtonType.secondary:
        return AppColors.secondary;
      case CTAButtonType.outline:
        return _isHovered ? AppColors.primaryLight.withOpacity(0.1) : null;
      case CTAButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.disabled) return AppColors.textDisabled;
    switch (widget.type) {
      case CTAButtonType.primary:
      case CTAButtonType.secondary:
        return AppColors.background;
      case CTAButtonType.outline:
      case CTAButtonType.text:
        return AppColors.primary;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case CTAButtonSize.small:
        return AppSizes.buttonHeightSm;
      case CTAButtonSize.medium:
        return AppSizes.buttonHeightMd;
      case CTAButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case CTAButtonSize.small:
        return AppSizes.md;
      case CTAButtonSize.medium:
        return AppSizes.lg;
      case CTAButtonSize.large:
        return AppSizes.xl;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case CTAButtonSize.small:
        return AppSizes.fsSm;
      case CTAButtonSize.medium:
        return AppSizes.fsMd;
      case CTAButtonSize.large:
        return AppSizes.fsLg;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case CTAButtonSize.small:
        return AppSizes.iconSm;
      case CTAButtonSize.medium:
        return AppSizes.iconMd;
      case CTAButtonSize.large:
        return AppSizes.iconLg;
    }
  }
}

/// CTA 按钮大小
enum CTAButtonSize {
  small,
  medium,
  large,
}
