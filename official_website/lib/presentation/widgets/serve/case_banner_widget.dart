import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

/// 案例横幅组件
/// 深蓝色渐变背景 + 放射状几何网格线 + 发光按钮
class CaseBannerWidget extends StatelessWidget {
  final VoidCallback? onConsult;

  const CaseBannerWidget({
    super.key,
    this.onConsult,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        children: [
          // 深蓝色渐变背景 + 放射状网格线
          Positioned.fill(
            child: CustomPaint(
              painter: _RadialGridBackgroundPainter(),
            ),
          ),

          // 内容
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 主标题
                  const Text(
                    '更多小程序行业案例，快速构建企业级应用',
                    style: TextStyle(
                      fontSize: AppSizes.fs2xl,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),

                  // 副标题
                  Text(
                    '企业移动信息化转型，互联网创业快速落地',
                    style: TextStyle(
                      fontSize: AppSizes.fsMd,
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.xxxl),

                  // 发光按钮
                  _buildGlowingButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 带光晕效果的按钮
  Widget _buildGlowingButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击免费评估按钮');
          onConsult?.call();
        },
        child: _GlowingButton(
          text: '免费评估',
          onPressed: () {
            debugPrint('点击免费评估按钮');
            onConsult?.call();
          },
        ),
      ),
    );
  }
}

/// 放射状网格背景绘制器
class _RadialGridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. 绘制深蓝色渐变背景
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0A2E5C), // 顶部深蓝灰
        Color(0xFF001F3F), // 底部海军蓝
      ],
    );

    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final backgroundPaint = Paint()
      ..shader = gradient.createShader(backgroundRect);
    canvas.drawRect(backgroundRect, backgroundPaint);

    // 2. 绘制放射状几何线条
    _drawRadialLines(canvas, size);

    // 3. 绘制正交网格
    _drawOrthogonalGrid(canvas, size);
  }

  /// 绘制放射状线条
  void _drawRadialLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // 中心点（偏下位置）
    final centerX = size.width / 2;
    final centerY = size.height * 0.7;

    // 绘制15-20条放射线
    const lineCount = 18;
    for (int i = 0; i < lineCount; i++) {
      final angle = (i * 360 / lineCount) * 3.14159 / 180;

      // 每条线的长度不同，有些延伸到边缘，有些中途淡出
      final lineLength = size.width * 0.6;
      final startX = centerX;
      final startY = centerY;
      final endX = centerX + lineLength * cos(angle);
      final endY = centerY + lineLength * sin(angle);

      // 绘制线条（带渐变透明度）
      _drawLineWithGradient(
        canvas,
        Offset(startX, startY),
        Offset(endX, endY),
        linePaint,
      );
    }
  }

  /// 绘制带渐变透明度的线条
  void _drawLineWithGradient(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    final linePaint = Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..style = paint.style;

    // 创建沿线条的渐变
    final gradient = ui.Gradient.linear(
      start,
      end,
      [
        const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        const Color(0xFFFFFFFF).withValues(alpha: 0.0),
      ],
    );

    linePaint.shader = gradient;
    canvas.drawLine(start, end, linePaint);
  }

  /// 绘制正交网格
  void _drawOrthogonalGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 90.0;

    // 绘制垂直线
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // 绘制水平线
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RadialGridBackgroundPainter oldDelegate) => false;
}

/// 发光按钮组件
class _GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _GlowingButton({
    required this.text,
    required this.onPressed,
  });

  @override
  State<_GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<_GlowingButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
        decoration: BoxDecoration(
          // 内层柔光（4px，透明度10%）
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 4,
              spreadRadius: 4,
            ),
            // 外层扩散光晕（20px，透明度30%）
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
            // 悬停时的阴影
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Container(
          width: 160,
          height: 48,
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFFF0F0F0)
                : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: AppSizes.fsMd,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A2E5C),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
