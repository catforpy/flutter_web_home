import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/models/service_item.dart';

/// 服务卡片组件
/// 用于展示服务项目，支持悬停动效
/// 布局：上图下文，图片占2/3，文本区占1/3
class ServiceCardWidget extends StatefulWidget {
  /// 服务项目数据
  final ServiceItem service;

  /// 点击回调
  final VoidCallback? onTap;

  const ServiceCardWidget({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片区 (占3/5高度，增加图片区域)
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Stack(
                  children: [
                    // 背景图片
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusLg),
                          topRight: Radius.circular(AppSizes.radiusLg),
                        ),
                        image: widget.service.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.service.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.service.imageUrl == null
                          ? Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: Center(
                                child: Icon(
                                  widget.service.icon,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),

                    // 深色蒙版
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusLg),
                          topRight: Radius.circular(AppSizes.radiusLg),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),

                    // 标题（白色，左上角，增大字体）
                    Positioned(
                      top: AppSizes.md,
                      left: AppSizes.md,
                      child: Text(
                        widget.service.title,
                        style: const TextStyle(
                          fontSize: 24, // 从 AppSizes.fsXl 改为固定 24
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 文本区 (占2/5高度，增加文本区域)
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.md), // 改回 md
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.radiusLg),
                      bottomRight: Radius.circular(AppSizes.radiusLg),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 改为 spaceBetween
                    children: [
                      // 上部：描述或特性
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 显示所有特性
                              ...widget.service.features.map((feature) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 16,
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      // 底部红色横线动画
                      SizedBox(
                        height: 3,
                        width: double.infinity,
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
