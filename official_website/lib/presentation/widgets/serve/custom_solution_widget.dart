import 'package:flutter/material.dart';

/// 定制化解决方案卡片组件
/// 背景图 + 4张嵌入式卡片（1/3嵌入背景，2/3浮于白色区域）
class CustomSolutionWidget extends StatelessWidget {
  const CustomSolutionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.45; // 背景图占据45%视口高度

    return Column(
      children: [
        // 背景图层
        _buildHeroSection(heroHeight),

        // 卡片层（使用负边距向上嵌入背景）
        Transform.translate(
          offset: Offset(0, -heroHeight * 0.55), // 向上移动背景高度的55%，让1/3嵌入
          child: _buildCardsSection(),
        ),

        // 白色底部填充（卡片下方）
        Container(
          color: const Color(0xFFF5F7FA),
          height: 0,
        ),
      ],
    );
  }

  /// 背景图区域
  Widget _buildHeroSection(double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        'assets/custom-solution-banner.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: const Color(0xFF0A0F1C),
            child: const Center(
              child: Text(
                '背景图加载中...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 卡片区域
  Widget _buildCardsSection() {
    return Container(
      // 移除背景色，避免遮挡背景图
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,  // 横向滚动
        clipBehavior: Clip.none,  // 不裁剪阴影
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,  // 改为start避免高度约束冲突
          children: [
            _buildCard(
              title: '个性化产品',
              description: '根据客户自定义需求，结合用户画像定向开发。提供可行性分析报告，制定最佳架构，助力功能完美落地。',
              iconPath: 'assets/luchang1.png',
            ),
            const SizedBox(width: 30),
            _buildCard(
              title: '互联网解决方案',
              description: '通过物联网技术满足多样化需求，涵盖智慧城市、智能家居等场景，显著提升工作效率与管理成本。',
              iconPath: 'assets/luchang2.png',
            ),
            const SizedBox(width: 30),
            _buildCard(
              title: '丰富的开发经验',
              description: '打造符合市场的即时通讯系统，支持群聊、视频通话、红包互动及阅后即焚等高级功能，安全稳定。',
              iconPath: 'assets/luchang3.png',
            ),
            const SizedBox(width: 30),
            _buildCard(
              title: '全行业解决方案',
              description: '完善的制度与算法，支持主播认证、多种礼物类型、盲盒配置及红包收益体系，覆盖全行业场景。',
              iconPath: 'assets/luchang1.png',
            ),
          ],
        ),
      ),
    );
  }

  /// 单张卡片
  Widget _buildCard({
    required String title,
    required String description,
    required String iconPath,
  }) {
    return SizedBox(
      width: 300,  // 固定宽度，保持竖版比例
      child: _SolutionCard(
        title: title,
        description: description,
        iconPath: iconPath,
      ),
    );
  }
}

/// 单张卡片组件（带悬停动画）
class _SolutionCard extends StatefulWidget {
  final String title;
  final String description;
  final String iconPath;

  const _SolutionCard({
    required this.title,
    required this.description,
    required this.iconPath,
  });

  @override
  State<_SolutionCard> createState() => _SolutionCardState();
}

class _SolutionCardState extends State<_SolutionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -10.0 : 0.0)
          ..scale(_isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
              blurRadius: _isHovered ? 40 : 24,
              offset: Offset(0, _isHovered ? 20 : 8),
            ),
          ],
        ),
        constraints: const BoxConstraints(
          minHeight: 450,  // 最小高度，确保是竖板卡片（高 > 宽）
        ),
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // 图标容器（红色渐变圆形）
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              transform: Matrix4.identity()
                ..translate(0.0, -10.0)
                ..scale(_isHovered ? 1.1 : 1.0),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF4D4F),
                      Color(0xFFCF1322),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCF1322).withValues(
                        alpha: _isHovered ? 0.5 : 0.3,
                      ),
                      blurRadius: _isHovered ? 20 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    widget.iconPath,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error_outline,
                        size: 32,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 标题
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1F1F),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // 描述文字
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                height: 1.8,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
