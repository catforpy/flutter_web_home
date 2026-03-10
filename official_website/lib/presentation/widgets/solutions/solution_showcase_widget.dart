import 'package:flutter/material.dart';

/// 解决方案图文展示组件
/// 左侧：手机界面展示，右侧：标题+副标题+合作品牌
class SolutionShowcaseWidget extends StatelessWidget {
  const SolutionShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF8F9FA), // 极浅灰背景
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08, // 动态计算8%
        vertical: 0, // 上下间距为0
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 移动端：垂直布局
          if (constraints.maxWidth < 900) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhoneMockup(),
                const SizedBox(height: 60),
                _buildRightContent(),
              ],
            );
          }

          // 桌面端：左右布局，自适应
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 图片使用Flexible，在空间不足时可以缩小
              Flexible(
                child: _buildPhoneMockup(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05, // 动态5%间距
              ),
              // 右侧内容使用Flexible，防止溢出
              Flexible(
                child: _buildRightContent(),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建左侧图片展示
  Widget _buildPhoneMockup() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 1200,
        maxWidth: 800, // 限制最大宽度，防止溢出
      ),
      child: Image.asset(
        'assets/mobile-internet-customization.png',
        height: 1200, // 固定高度
        fit: BoxFit.cover, // 不保持比例，填满整个区域
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 1200,
            color: Colors.grey.withValues(alpha: 0.1),
            child: const Center(
              child: Text('图片加载中...'),
            ),
          );
        },
      ),
    );
  }

  /// 构建右侧内容区
  Widget _buildRightContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主标题
        const Text(
          '移动互联网定制专家',
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.3,
          ),
        ),

        const SizedBox(height: 24),

        // 副标题列表
        _buildBulletPoint('16年专注技术服务，您身边的软件定制专家'),
        const SizedBox(height: 16),
        _buildBulletPoint('系统定制，一站式行业解决方案'),

        const SizedBox(height: 40),

        // 标语
        const Text(
          '专业的服务，创造有影响力的产品',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF999999),
          ),
        ),

        const SizedBox(height: 32),

        // 合作品牌Logo区（占位）
        _buildPartnerLogos(),
      ],
    );
  }

  /// 构建列表项
  Widget _buildBulletPoint(String text) {
    return Text(
      '• $text',
      style: const TextStyle(
        fontSize: 20,
        color: Color(0xFF666666),
        height: 1.8,
      ),
    );
  }

  /// 构建合作品牌Logo区
  Widget _buildPartnerLogos() {
    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: [
        _PartnerLogo(
          name: '都达',
          imageUrl: 'images/duda-logo.png',
        ),

      ],
    );
  }
}

/// 合作品牌Logo组件
class _PartnerLogo extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _PartnerLogo({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // 判断是网络图片还是本地图片
    final isNetworkImage = imageUrl.startsWith('http');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: name,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isNetworkImage
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          '都',
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  )
                : Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          '都',
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(0xFF999999),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
