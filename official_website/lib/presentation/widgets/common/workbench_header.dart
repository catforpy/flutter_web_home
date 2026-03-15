import 'package:flutter/material.dart';

/// 工作台顶部标题栏组件
class WorkbenchHeader extends StatelessWidget {
  final String title;
  final List<HeaderButton> buttons;
  final VoidCallback? onManagementCenterTap;

  const WorkbenchHeader({
    super.key,
    required this.title,
    required this.buttons,
    this.onManagementCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0xFF1A9B8E),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo + 系统名称
          _buildLogoSection(),

          const Spacer(),

          // 右侧功能按钮组
          ...buttons.map((button) => _buildButton(button)),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Row(
      children: [
        // Logo（圆形图标）
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'W',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A9B8E),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(HeaderButton button) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: button.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: button.isActive ? const Color(0xFF148A7D) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (button.text.isNotEmpty)
                  Text(
                    button.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                if (button.isMoreButton)
                  const Icon(
                    Icons.more_horiz,
                    size: 16,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 顶部按钮数据模型
class HeaderButton {
  final String text;
  final bool isActive;
  final bool isMoreButton;
  final VoidCallback? onTap;

  HeaderButton({
    required this.text,
    this.isActive = false,
    this.isMoreButton = false,
    this.onTap,
  });

  factory HeaderButton.more({VoidCallback? onTap}) {
    return HeaderButton(
      text: '',
      isMoreButton: true,
      onTap: onTap,
    );
  }
}
