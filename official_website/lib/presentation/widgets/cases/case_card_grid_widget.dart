import 'package:flutter/material.dart';
import 'dart:ui';
import '../../routes/app_router.dart';

/// 案例卡片网格组件
/// 2+3布局：第一行2个卡片，第二行3个卡片，可重复多组
class CaseCardGridWidget extends StatelessWidget {
  /// 案例分类（'website' 或 'app'）
  final String category;
  /// 行业分类（如：'tech_training', 'logistics'等）
  final String? industry;

  const CaseCardGridWidget({
    super.key,
    required this.category,
    this.industry,
  });

  @override
  Widget build(BuildContext context) {
    // 根据分类和行业获取案例数据
    final cases = _getCasesByCategoryAndIndustry(category, industry);

    // 如果没有案例数据，显示空状态
    if (cases.isEmpty) {
      return Container(
        color: const Color(0xFFF5F7FA),
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
        child: const Center(
          child: Text(
            '暂无案例',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF999999),
            ),
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFFF5F7FA),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Column(
        children: [
          // 第一组：2个卡片 + 3个卡片
          _buildCardGroup(cases.sublist(0, cases.length >= 5 ? 5 : cases.length)),
        ],
      ),
    );
  }

  /// 构建一组卡片（2+3布局）
  Widget _buildCardGroup(List<CaseItem> items) {
    return Column(
      children: [
        // 第一行：2个卡片
        Row(
          children: [
            Expanded(
              child: items.isNotEmpty ? _CaseCard(caseItem: items[0]) : const SizedBox(),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: items.length > 1 ? _CaseCard(caseItem: items[1]) : const SizedBox(),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // 第二行：3个卡片
        Row(
          children: [
            Expanded(
              child: items.length > 2 ? _CaseCard(caseItem: items[2]) : const SizedBox(),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: items.length > 3 ? _CaseCard(caseItem: items[3]) : const SizedBox(),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: items.length > 4 ? _CaseCard(caseItem: items[4]) : const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  /// 根据分类和行业获取案例数据
  List<CaseItem> _getCasesByCategoryAndIndustry(String category, String? industry) {
    // 先获取分类下的所有案例
    List<CaseItem> categoryCases;
    if (category == 'website') {
      categoryCases = _websiteCases;
    } else {
      categoryCases = _appCases;
    }

    // 如果指定了行业，过滤出该行业的案例
    if (industry != null && industry.isNotEmpty) {
      return categoryCases.where((item) => item.industry == industry).toList();
    }

    return categoryCases;
  }

  // 企业官网定制案例数据
  static const List<CaseItem> _websiteCases = [
    // 暂时没有数据，留空
  ];

  // 小程序app开发案例数据
  static const List<CaseItem> _appCases = [
    // 科技培训行业
    CaseItem(
      companyName: '唐极课得',
      subtitle: '成年人技术培训教育',
      location: '江苏·无锡',
      backgroundImage: 'https://picsum.photos/800/600?random=6',
      logoUrl: 'https://via.placeholder.com/60',
      caseId: 'tangjike_de',
      industry: 'tech_training', // 科技培训
    ),
    // 其他行业暂时没有数据，后续可添加
  ];
}

/// 案例卡片组件
class _CaseCard extends StatefulWidget {
  final CaseItem caseItem;

  const _CaseCard({required this.caseItem});

  @override
  State<_CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<_CaseCard> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.caseItem.caseId != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (event) {
        // 获取相对于卡片的本地坐标（优化：只在悬停时更新）
        if (_isHovered) {
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final localPosition = box.globalToLocal(event.position);
            // 节流：只有位置变化超过10px才更新
            if ((localPosition - _mousePosition).distance > 10) {
              setState(() {
                _mousePosition = localPosition;
              });
            }
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          // 只有当 caseId 不为 null 时才跳转
          if (widget.caseItem.caseId != null) {
            AppRouter.goToCaseDetail(context, widget.caseItem.caseId!);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180), // 缩短到180ms
          curve: Curves.easeOut, // 使用更快的曲线
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 20 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 背景图片
              Positioned.fill(
                child: Image.network(
                  widget.caseItem.backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.withValues(alpha: 0.2),
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              // 半透明蒙层（悬停时显示）- 移除BackdropFilter提升性能
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                color: _isHovered
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),

              // 鼠标跟随的红色光圈（悬停时显示）
              if (_isHovered)
                _GlowingCircle(
                  position: _mousePosition,
                ),

              // 内容层
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(_isHovered ? 20 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 左上角：Logo
                      AnimatedScale(
                        scale: _isHovered ? 0.75 : 1.0,
                        duration: const Duration(milliseconds: 180), // 缩短到180ms
                        curve: Curves.easeOut,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              widget.caseItem.logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  child: const Center(
                                    child: Icon(Icons.business, size: 32),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // 底部：副标题 + 公司名称+地址Row
                      // 使用AnimatedContainer改变padding，与Logo同步
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 副标题（悬停时显示）
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180), // 缩短到180ms
                            curve: Curves.easeOut,
                            child: _isHovered
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      widget.caseItem.subtitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // 公司名称（左）+ Spacer + 地址（右）
                          Row(
                            children: [
                              Text(
                                widget.caseItem.companyName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.caseItem.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

/// 鼠标跟随的红色光圈组件
class _GlowingCircle extends StatefulWidget {
  final Offset position;

  const _GlowingCircle({
    required this.position,
  });

  @override
  State<_GlowingCircle> createState() => _GlowingCircleState();
}

class _GlowingCircleState extends State<_GlowingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 30, // 圆心对齐鼠标（半径30）
      top: widget.position.dy - 40,   // 稍微向上偏移
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFF6B6B), // 中心亮红色
                      Color(0xFFD93025), // 边缘深红色
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD93025).withValues(alpha: 0.6),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '鉴赏',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 案例数据模型
class CaseItem {
  final String companyName;
  final String subtitle;
  final String location;
  final String backgroundImage;
  final String logoUrl;
  final String? caseId; // 案例ID，用于详情页跳转
  final String? industry; // 行业分类（如：'tech_training', 'logistics'等）

  const CaseItem({
    required this.companyName,
    required this.subtitle,
    required this.location,
    required this.backgroundImage,
    required this.logoUrl,
    this.caseId,
    this.industry,
  });
}
