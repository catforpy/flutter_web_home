import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

/// 服务流程展示组件 -> "我们能为您做的"
/// 左侧标题，右侧：3个服务卡片（横向长条形）
class ServiceProcessWidget extends StatelessWidget {
  const ServiceProcessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: screenWidth * 0.08,
        right: screenWidth * 0.08,
        top: 10,
        bottom: 60,
      ),
      child: Column(
        children: [
          // 标题和副标题组
          _buildLeftContent(),
          const SizedBox(height: 50),
          // 3个卡片组
          _buildRightCards(context),
        ],
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
          '我们能为您做的',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // 副标题组
        _buildSubTitle('提供一站式互联网解决方案'),
        const SizedBox(height: 12),
        _buildSubTitle('从需求分析到产品上线全程服务'),
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

  /// 右侧三卡片（横向长条形）
  Widget _buildRightCards(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 横向滚动
      child: Row(
        children: [
          _ServiceCard(
            iconName: 'chat', // 临时使用图标
            icon: Icons.chat_bubble,
            title: '微信小程序开发',
            subtitle: '共享微信9亿用户，用完即走，拥抱新生态',
            onTap: () {
              // 跳转到合作页面并选中"小程序购买"标签
              AppRouter.goToCooperationWithTab(context, 0);
            },
          ),
          const SizedBox(width: 30),
          const _ServiceCard(
            iconName: 'phone', // 临时使用图标
            icon: Icons.phone_android,
            title: 'APP定制开发',
            subtitle: '专注于手机应用软件开发与服务',
            onTap: null, // 暂时没有跳转
          ),
          const SizedBox(width: 30),
          _ServiceCard(
            iconName: 'platform', // 临时使用图标
            icon: Icons.apps,
            title: '租赁/合作平台',
            subtitle: '免开发零运维，低门槛租用共享，轻松参与销售变现',
            onTap: () {
              // 跳转到合作页面并选中"小程序租赁"标签
              AppRouter.goToCooperationWithTab(context, 1);
            },
          ),
        ],
      ),
    );
  }
}

/// 服务卡片组件（横向长条形 3:1）
class _ServiceCard extends StatefulWidget {
  final String iconName;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ServiceCard({
    required this.iconName,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFFAFAFA) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.0),
                blurRadius: _isHovered ? 24 : 0,
                offset: Offset(0, _isHovered ? 8 : 0),
              ),
            ],
          ),
          child: Container(
            width: 400,
            constraints: const BoxConstraints(
              minHeight: 130,  // 保持3:1宽高比（400x130 ≈ 3:1）
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            child: Row(
              children: [
                // 左侧图标区域
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF07C160), // 微信绿色
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 20),

                // 右侧内容区域（Column布局）
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 主标题
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 副标题
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                          height: 1.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // "了解更多"（使用透明度动画，始终占据空间）
                      // 只有当 onTap 不为 null 时才显示
                      if (widget.onTap != null)
                        AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _buildLearnMoreButton(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建"了解更多"按钮
  Widget _buildLearnMoreButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 按钮文字
        const Text(
          '了解更多',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFD93025),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        // 红色小圆点
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFD93025), // 微信红
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
