import 'package:flutter/material.dart';

/// 问号帮助图标组件
class QuestionIcon extends StatelessWidget {
  final String? tooltip;

  const QuestionIcon({
    super.key,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: 显示帮助信息
          debugPrint('显示帮助：$tooltip');
        },
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFF999999),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
