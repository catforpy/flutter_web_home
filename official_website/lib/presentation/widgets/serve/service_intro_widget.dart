import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// 全行业小程序开发服务介绍组件
/// 左侧：3D等距插画，右侧：标题+描述+CTA按钮
class ServiceIntroWidget extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onConsult;

  const ServiceIntroWidget({
    super.key,
    this.backgroundColor = AppColors.background,
    this.onConsult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.xxxl,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 移动端（宽度小于768）：垂直排列
            if (constraints.maxWidth < 768) {
              return Column(
                children: [
                  // 左侧插画（移动端在上方）
                  _buildIllustration(constraints.maxWidth),
                  const SizedBox(height: AppSizes.xl),
                  // 右侧内容
                  _buildContent(constraints.maxWidth),
                ],
              );
            }

            // 桌面端：水平排列
            return Row(
              children: [
                // 左侧插画（45%）
                Expanded(
                  flex: 45,
                  child: _buildIllustration(constraints.maxWidth * 0.45),
                ),
                const SizedBox(width: AppSizes.xxl),
                // 右侧内容（55%）
                Expanded(
                  flex: 55,
                  child: _buildContent(constraints.maxWidth * 0.55),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 左侧插画
  Widget _buildIllustration(double width) {
    return Image.asset(
      'images/advantage-logo.png',
      width: double.infinity,
      height: width * 0.75,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // 如果图片加载失败，显示占位符
        return Container(
          height: width * 0.75,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 64,
              color: AppColors.textDisabled,
            ),
          ),
        );
      },
    );
  }

  /// 右侧内容
  Widget _buildContent(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 主标题
        const Text(
          '全行业小程序开发服务',
          style: TextStyle(
            fontSize: AppSizes.fs3xl,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // 三段式说明文字
        _buildBulletPoint(
          '众多知名企业的放心之选，以专业的技术、成熟的行业经验为企业提供高效可靠的移动化服务',
        ),
        const SizedBox(height: AppSizes.md),
        _buildBulletPoint(
          '16 年移动开发经验，自有平台技术支持 App/小程序同时开发，升级成本低',
          highlightText: '16 年',
        ),
        const SizedBox(height: AppSizes.md),
        _buildBulletPoint(
          '支持移动应用定制、小程序开发、业务系统开发、行业解决方案等，推动企业的创新发展与数智化升级',
        ),

        const SizedBox(height: AppSizes.xl),

        // CTA 按钮
        _buildCTAButton(),
      ],
    );
  }

  /// 圆点列表项
  Widget _buildBulletPoint(String text, {String? highlightText}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: AppSizes.fsMd,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: '· '),
          // 如果有高亮文本，需要分割处理
          if (highlightText != null && text.contains(highlightText)) ...[
            TextSpan(text: text.substring(0, text.indexOf(highlightText))),
            TextSpan(
              text: highlightText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(text: text.substring(text.indexOf(highlightText) + highlightText.length)),
          ] else
            TextSpan(text: text.substring(2)), // 跳过 "· "
        ],
      ),
    );
  }

  /// CTA 按钮
  Widget _buildCTAButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击免费评估按钮');
          onConsult?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 180,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '免费小程序开发评估',
              style: TextStyle(
                fontSize: AppSizes.fsMd,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
