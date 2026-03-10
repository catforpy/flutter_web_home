import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../routes/app_router.dart';

/// 企业成功案例组件
/// 左侧：标题+说明+链接，右侧：三张手机截图
class SuccessCasesWidget extends StatelessWidget {
  final Color backgroundColor;

  const SuccessCasesWidget({
    super.key,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Stack(
        children: [
          // 背景几何线条装饰
          _buildGeometricBackground(),

          // 主要内容
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: AppSizes.xxxl,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 移动端（宽度小于768）：垂直排列
                if (constraints.maxWidth < 768) {
                  return Column(
                    children: [
                      // 左侧内容（移动端在上方）
                      _buildLeftContent(context),
                      SizedBox(height: AppSizes.xl),
                      // 右侧手机截图
                      _buildRightContent(constraints.maxWidth),
                    ],
                  );
                }

                // 桌面端：水平排列
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 左侧内容（45%，与上方图标对齐）
                    Expanded(
                      flex: 45,
                      child: _buildLeftContent(context),
                    ),
                    SizedBox(width: AppSizes.xxxl),
                    // 右侧手机截图
                    Expanded(
                      flex: 55,
                      child: _buildRightContent(constraints.maxWidth * 0.55),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 左侧内容区域
  Widget _buildLeftContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主标题
        Text(
          '企业成功案例',
          style: TextStyle(
            fontSize: AppSizes.fs3xl,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.lg),

        // 说明段落
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            '君和数字创意帮助用户在移动场景中快速落地，涵盖电商、新能源、教育、社交、金融、资讯、医疗等众多领域',
            style: TextStyle(
              fontSize: AppSizes.fsMd,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        SizedBox(height: AppSizes.xl),

        // "更多行业案例"链接
        _buildHoverLink(context),
      ],
    );
  }

  /// 悬停链接
  Widget _buildHoverLink(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 跳转到案例页面
          AppRouter.goToCases(context);
        },
        child: _HoverLinkWidget(
          text: '更多行业案例 >',
        ),
      ),
    );
  }

  /// 右侧手机截图区域
  Widget _buildRightContent(double width) {
    // 三张手机截图数据
    final caseItems = [
      {
        'imageUrl': 'assets/cloud-travel-new.png',
        'title': '云游世界',
        'category': '旅游/出行',
      },
      {
        'imageUrl': 'assets/minimalist-coffee-new.png',
        'title': '极简咖啡',
        'category': '餐饮/咖啡',
      },
      {
        'imageUrl': 'assets/energetic-breakfast-new.png',
        'title': '元气早餐',
        'category': '餐饮/早餐',
      },
    ];

    // 统一使用 Row 横向排列
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: caseItems.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: _buildPhoneMockup(
              item['imageUrl']!,
              item['title']!,
              item['category']!,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 单个手机模型
  Widget _buildPhoneMockup(
    String imageUrl,
    String title,
    String category,
  ) {
    // 统一手机尺寸
    const phoneWidth = 200.0;
    const phoneHeight = 400.0;

    return Column(
      children: [
        // 直接显示图片，无外框
        Image.asset(
          imageUrl,
          width: phoneWidth,
          height: phoneHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: phoneWidth,
              height: phoneHeight,
              color: AppColors.background,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 32,
                  color: AppColors.textDisabled,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // 案例标题和分类
        Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.fsSm,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          category,
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  /// 背景几何线条装饰
  Widget _buildGeometricBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GeometricBackgroundPainter(),
      ),
    );
  }
}

/// 带悬停效果的链接组件
class _HoverLinkWidget extends StatefulWidget {
  final String text;

  const _HoverLinkWidget({required this.text});

  @override
  State<_HoverLinkWidget> createState() => _HoverLinkWidgetState();
}

class _HoverLinkWidgetState extends State<_HoverLinkWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: AppSizes.fsSm,
                fontWeight: FontWeight.w500,
                color: _isHovered
                    ? const Color(0xFF0051D5) // 深蓝色
                    : const Color(0xFF007AFF), // 蓝色
                decoration: _isHovered
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              child: Text(widget.text),
            ),
            AnimatedSlide(
              offset: Offset(_isHovered ? 4.0 : 0.0, 0), // 向右移动4px
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xFF007AFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 几何背景绘制器
class _GeometricBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F5F7)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // 绘制几何线条（右上角）
    final centerX = size.width * 0.8;
    final centerY = size.height * 0.3;

    // 绘制几条斜线
    for (int i = 0; i < 5; i++) {
      final startX = centerX + i * 40.0;
      final startY = centerY - 100.0;
      final endX = startX + 60.0;
      final endY = startY + 120.0;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }

    // 绘制圆圈（右下角）
    final circlePaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..style = PaintingStyle.fill;

    final circleStrokePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final circleX = size.width * 0.9;
      final circleY = size.height * 0.8 + i * 40.0;
      final radius = 20.0 + i * 10.0;

      canvas.drawCircle(
        Offset(circleX, circleY),
        radius,
        circlePaint,
      );
      canvas.drawCircle(
        Offset(circleX, circleY),
        radius,
        circleStrokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GeometricBackgroundPainter oldDelegate) => false;
}
