import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../common/cta_button_widget.dart';

/// 联系咨询组件
/// 显示联系信息和咨询按钮
class ContactBarWidget extends StatelessWidget {
  /// 提示文字
  final String hintText;

  /// 客服热线
  final String phoneNumber;

  /// 按钮文字
  final String buttonText;

  /// 按钮点击回调
  final VoidCallback? onButtonPressed;

  /// 是否固定在底部
  final bool pinned;

  /// 背景色
  final Color? backgroundColor;

  const ContactBarWidget({
    super.key,
    this.hintText = '现在就与君和客服在线沟通',
    this.phoneNumber = '13961535392',
    this.buttonText = '免费咨询',
    this.onButtonPressed,
    this.pinned = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final widgetToRender = Container(
      color: backgroundColor ?? AppColors.primary,
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.lg,
        horizontal: AppSizes.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 提示文字
          if (MediaQuery.of(context).size.width > AppSizes.breakpointMobile)
            Text(
              hintText,
              style: TextStyle(
                fontSize: AppSizes.fsLg,
                color: AppColors.background,
                fontWeight: FontWeight.w500,
              ),
            ),

          if (MediaQuery.of(context).size.width > AppSizes.breakpointMobile)
            SizedBox(width: AppSizes.xl),

          // 客服热线
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppColors.background,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  '客服热线：$phoneNumber',
                  style: TextStyle(
                    fontSize: AppSizes.fsMd,
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSizes.lg),

          // 咨询按钮
          CTAButtonWidget(
            text: buttonText,
            type: CTAButtonType.secondary,
            size: CTAButtonSize.medium,
            onPressed: onButtonPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('感谢您的咨询！我们将尽快联系您。'),
                      backgroundColor: AppColors.secondary,
                    ),
                  );
                },
          ),
        ],
      ),
    );

    if (pinned) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: widgetToRender,
      );
    }

    return widgetToRender;
  }
}
