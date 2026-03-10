import 'package:flutter/material.dart';

/// 客户案例展示墙组件
/// 展示合作品牌/企业的Logo卡片
class ClientShowcaseWidget extends StatelessWidget {
  const ClientShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 标题区
              _buildTitle(),

              const SizedBox(height: 50),

              // Logo 卡片网格
              _buildLogoGrid(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建标题区
  Widget _buildTitle() {
    return Column(
      children: [
        // 主标题
        const Text(
          '我们服务的客户',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // 副标题
        Text(
          '超1000+客户服务案例，致力于互联网极致产品',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建Logo网格（6列布局）
  Widget _buildLogoGrid() {
    // 模拟数据 - 实际使用时从后端API获取
    final clients = [
      {'id': 1, 'name': '万科', 'logo': 'assets/images/logos/vanke.png'},
      {'id': 2, 'name': '中建七局', 'logo': 'assets/images/logos/cscec.png'},
      {'id': 3, 'name': '国家电网', 'logo': 'assets/images/logos/state-grid.png'},
      {'id': 4, 'name': '腾讯', 'logo': 'assets/images/logos/tencent.png'},
      {'id': 5, 'name': '阿里巴巴', 'logo': 'assets/images/logos/alibaba.png'},
      {'id': 6, 'name': '字节跳动', 'logo': 'assets/images/logos/bytedance.png'},
      {'id': 7, 'name': '美团', 'logo': 'assets/images/logos/meituan.png'},
      {'id': 8, 'name': '京东', 'logo': 'assets/images/logos/jd.png'},
      {'id': 9, 'name': '华为', 'logo': 'assets/images/logos/huawei.png'},
      {'id': 10, 'name': '小米', 'logo': 'assets/images/logos/xiaomi.png'},
      {'id': 11, 'name': '滴滴', 'logo': 'assets/images/logos/didi.png'},
      {'id': 12, 'name': '网易', 'logo': 'assets/images/logos/netease.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.0,
      ),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        return _HoverClientCard(
          name: client['name'] as String,
          logoPath: client['logo'] as String,
        );
      },
    );
  }
}

/// 带悬停动效的客户卡片
class _HoverClientCard extends StatefulWidget {
  final String name;
  final String logoPath;

  const _HoverClientCard({
    required this.name,
    required this.logoPath,
  });

  @override
  State<_HoverClientCard> createState() => _HoverClientCardState();
}

class _HoverClientCardState extends State<_HoverClientCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        height: 100,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: () {
            // TODO: 点击跳转逻辑，后续设置
            print('点击了客户: ${widget.name}');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.logoPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // 图片加载失败时显示占位符
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: Text(
                      widget.name[0], // 显示首字作为占位符
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
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
