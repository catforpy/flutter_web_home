import 'package:flutter/material.dart';

/// 解决方案流程展示组件
/// 左侧：标题区，右侧：三阶段流程卡片
class SolutionProcessWidget extends StatelessWidget {
  const SolutionProcessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08, // 动态8%
        vertical: 80,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 移动端（宽度小于900）：垂直布局
          if (constraints.maxWidth < 900) {
            return Column(
              children: [
                _buildLeftContent(),
                const SizedBox(height: 60),
                _buildRightCards(),
              ],
            );
          }

          // 桌面端：左右布局，自适应
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧文案区（自适应宽度）
              Flexible(
                flex: 1,
                child: _buildLeftContent(),
              ),
              SizedBox(
                width: screenWidth * 0.08, // 动态8%间距
              ),
              // 右侧三卡片（自适应宽度）
              Flexible(
                flex: 2,
                child: _buildRightCards(),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 左侧文案区
  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主标题
        const Text(
          '互联网解决方案服务商',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // 副标题组
        _buildSubTitle('全流程服务保障项目交付'),
        const SizedBox(height: 12),
        _buildSubTitle('长期稳定迭代维护，终身技术咨询'),

        const SizedBox(height: 40),

        // 强调标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4D4F).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: const Color(0xFFFF4D4F).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Text(
            '标准化项目实施流程',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF4D4F),
            ),
          ),
        ),
      ],
    );
  }

  /// 副标题
  Widget _buildSubTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF666666),
      ),
    );
  }

  /// 右侧三卡片
  Widget _buildRightCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 横向滚动
      child: Row(
        children: [
          _ProcessCard(
            iconName: 'luchang1',
            title: '设计阶段',
            description: '资深项目经理，产品经理，UI设计师帮您梳理项目需求，制定项目开发方案。',
          ),
          const SizedBox(width: 40),
          _ProcessCard(
            iconName: 'luchang2',
            title: '开发阶段',
            description: '高级技术研发工程师以最新的主流流程，提供专业的代码编写，高质量、高保障。',
          ),
          const SizedBox(width: 40),
          _ProcessCard(
            iconName: 'luchang3',
            title: '测试阶段',
            description: '标准化测试流程，为项目最后上线工作提供保驾护航，让您的项目顺利落地。',
          ),
        ],
      ),
    );
  }
}

/// 流程卡片组件
class _ProcessCard extends StatefulWidget {
  final String iconName;
  final String title;
  final String description;

  const _ProcessCard({
    required this.iconName,
    required this.title,
    required this.description,
  });

  @override
  State<_ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<_ProcessCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: Container(
          width: 280,  // 固定宽度
          constraints: const BoxConstraints(
            minHeight: 400,  // 最小高度，确保是竖板卡片（400 > 280）
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 40),

              // 圆形图标
              _buildCircleIcon(_isHovered, 70),

              const SizedBox(height: 24),

              // 标题
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // 描述文本
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建圆形图标
  Widget _buildCircleIcon(bool isHovered, double iconSize) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.identity()..scale(isHovered ? 1.1 : 1.0),
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE0D0), // 浅肉色
              Color(0xFFFFD4C0),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4D4F).withValues(alpha: isHovered ? 0.3 : 0.2),
              blurRadius: isHovered ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(iconSize * 0.1875), // 15/80 = 0.1875
          child: Image.asset(
            'assets/${widget.iconName}.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFFFF4D4F),
              );
            },
          ),
        ),
      ),
    );
  }
}
