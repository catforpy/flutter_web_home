import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/development_step.dart';

/// 开发流程卡片组件
/// 六边形图标 + 序号 + 标题 + 描述列表
class DevelopmentStepCard extends StatefulWidget {
  final DevelopmentStep step;
  final bool showConnector;

  const DevelopmentStepCard({
    super.key,
    required this.step,
    this.showConnector = true,
  });

  @override
  State<DevelopmentStepCard> createState() => _DevelopmentStepCardState();
}

class _DevelopmentStepCardState extends State<DevelopmentStepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // 禁用滚动指示器，但允许内容溢出时滚动
        child: Column(
          mainAxisSize: MainAxisSize.min, // 让Column尽可能小
          children: [
            // 六边形图标 + 序号
            _buildHexagonIcon(),

            const SizedBox(height: 10),

            // 序号
            Text(
              widget.step.stepNumber,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDisabled,
              ),
            ),

            const SizedBox(height: 10),

            // 主标题
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 17,
                fontWeight: _isHovered ? FontWeight.bold : FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              child: Text(
                widget.step.title,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 6),

            // 描述列表
            ...widget.step.descriptions.map((desc) => Padding(
                  padding: const EdgeInsets.only(bottom: 1.5),
                  child: Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),

            // 连接线（除最后一个）
            if (widget.showConnector) _buildConnector(),
          ],
        ),
      ),
    );
  }

  /// 构建六边形图标
  Widget _buildHexagonIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isHovered ? AppColors.secondary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 80,
        height: 80,
        child: CustomPaint(
          painter: _HexagonPainter(
            color: AppColors.secondary,
            iconType: widget.step.iconType,
            isHovered: _isHovered,
          ),
        ),
      ),
    );
  }

  /// 构建连接线
  Widget _buildConnector() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 左半段虚线
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.5),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          // 中间圆圈
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
          ),
          // 右半段虚线
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.5),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 六边形绘制器
class _HexagonPainter extends CustomPainter {
  final Color color;
  final DevelopmentStepIconType iconType;
  final bool isHovered;

  _HexagonPainter({
    required this.color,
    required this.iconType,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 绘制六边形
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // 绘制六边形边框
    canvas.drawPath(path, paint);

    // 绘制图标
    _drawIcon(canvas, center, size);
  }

  void _drawIcon(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final iconSize = size.width * 0.35;
    const strokeWidth = 2.0;

    switch (iconType) {
      case DevelopmentStepIconType.personnel:
        // Y型分支图标
        final path = Path();
        // 中心垂直线
        path.moveTo(center.dx, center.dy - iconSize * 0.4);
        path.lineTo(center.dx, center.dy + iconSize * 0.4);
        // 左分支
        path.moveTo(center.dx, center.dy);
        path.lineTo(center.dx - iconSize * 0.3, center.dy - iconSize * 0.2);
        // 右分支1
        path.moveTo(center.dx, center.dy - iconSize * 0.1);
        path.lineTo(center.dx + iconSize * 0.3, center.dy - iconSize * 0.3);
        // 右分支2
        path.moveTo(center.dx, center.dy + iconSize * 0.1);
        path.lineTo(center.dx + iconSize * 0.3, center.dy + iconSize * 0.3);
        canvas.drawPath(path, paint..strokeWidth = strokeWidth);
        break;

      case DevelopmentStepIconType.weeklyReport:
        // 笔记本+等号图标
        // 笔记本矩形
        final rect = Rect.fromCenter(
          center: center,
          width: iconSize * 0.6,
          height: iconSize * 0.5,
        );
        canvas.drawRect(rect, paint..strokeWidth = strokeWidth);
        // 等号
        canvas.drawLine(
          Offset(center.dx - iconSize * 0.2, center.dy),
          Offset(center.dx + iconSize * 0.2, center.dy),
          paint..strokeWidth = strokeWidth,
        );
        canvas.drawLine(
          Offset(center.dx - iconSize * 0.2, center.dy + iconSize * 0.1),
          Offset(center.dx + iconSize * 0.2, center.dy + iconSize * 0.1),
          paint..strokeWidth = strokeWidth,
        );
        break;

      case DevelopmentStepIconType.testing:
        // 代码标签+日历格子
        final codeSize = iconSize * 0.4;
        final codeRect = Rect.fromCenter(
          center: center.translate(0, -iconSize * 0.15),
          width: codeSize,
          height: codeSize * 0.5,
        );
        canvas.drawRect(codeRect, paint..strokeWidth = strokeWidth);
        // < 符号
        canvas.drawLine(
          codeRect.bottomLeft,
          codeRect.topRight,
          paint..strokeWidth = strokeWidth,
        );
        // 日历格子（3x2）
        final calendarSize = iconSize * 0.4;
        final calendarRect = Rect.fromCenter(
          center: center.translate(0, iconSize * 0.15),
          width: calendarSize,
          height: calendarSize * 0.5,
        );
        canvas.drawRect(calendarRect, paint..strokeWidth = strokeWidth);
        canvas.drawLine(
          Offset(calendarRect.left, center.dy),
          Offset(calendarRect.right, center.dy),
          paint..strokeWidth = strokeWidth,
        );
        break;

      case DevelopmentStepIconType.deliverables:
        // 文件夹+文档列表
        final folderSize = iconSize * 0.5;
        final folderRect = Rect.fromCenter(
          center: center,
          width: folderSize,
          height: folderSize * 0.6,
        );
        // 绘制文件夹（双层矩形）
        final outerRRect = RRect.fromRectAndRadius(folderRect, const Radius.circular(4));
        final innerRRect = RRect.fromRectAndRadius(
          folderRect.deflate(2),
          const Radius.circular(2),
        );
        canvas.drawDRRect(
          outerRRect,
          innerRRect,
          paint..strokeWidth = strokeWidth,
        );
        // 文档线条
        final folderHeight = folderSize * 0.6;
        for (int i = 0; i < 3; i++) {
          final lineY = folderRect.top + (i + 1) * folderHeight * 0.25;
          canvas.drawLine(
            Offset(folderRect.left + 8, lineY),
            Offset(folderRect.right - 8, lineY),
            paint..strokeWidth = 1.5,
          );
        }

      case DevelopmentStepIconType.maintenance:
        // 显示器+IT文字
        final monitorSize = iconSize * 0.5;
        final monitorRect = Rect.fromCenter(
          center: center,
          width: monitorSize,
          height: monitorSize * 0.6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(monitorRect, const Radius.circular(2)),
          paint..strokeWidth = strokeWidth,
        );
        // 底座
        canvas.drawLine(
          Offset(monitorRect.left - 6, monitorRect.bottom),
          Offset(monitorRect.right + 6, monitorRect.bottom),
          paint..strokeWidth = strokeWidth,
        );
        // IT文字（简化为IT）
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'IT',
            style: TextStyle(
              fontSize: 7,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2,
          ),
        );
        break;

      case DevelopmentStepIconType.training:
        // 文档+手形点击 - 简化版本，只绘制文档
        final docSize = iconSize * 0.5;
        final docRect = Rect.fromCenter(
          center: center,
          width: docSize,
          height: docSize * 0.6,
        );
        canvas.drawRect(docRect, paint..strokeWidth = strokeWidth);
        // 文档内的线条
        for (int i = 0; i < 3; i++) {
          final lineY = docRect.top + (i + 1) * (docSize * 0.6) * 0.25;
          canvas.drawLine(
            Offset(docRect.left + 4, lineY),
            Offset(docRect.right - 4, lineY),
            paint..strokeWidth = 1.0,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(_HexagonPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.iconType != iconType ||
      oldDelegate.isHovered != isHovered;
}
