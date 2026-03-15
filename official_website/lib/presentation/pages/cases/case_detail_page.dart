import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../widgets/cases/case_detail_hero_widget.dart';
import '../../widgets/cases/case_card_grid_widget.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../routes/app_router.dart';

/// 案例详情页
/// 通用组件，用于显示各个案例的详细信息
class CaseDetailPage extends StatefulWidget {
  /// 案例ID或标识
  final String? caseId;

  const CaseDetailPage({
    super.key,
    this.caseId,
  });

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // 可滚动内容区域
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: const Column(
                  children: [
                    // 案例详情Hero区域（模糊背景图，70%屏幕高度）
                    CaseDetailHeroWidget(
                      backgroundImageUrl: 'https://picsum.photos/1920/1080?random=100', // 临时占位图
                    ),

                    SizedBox(height: 60),

                    // 相关案例区域
                    _RelatedCasesSection(),

                    SizedBox(height: 80),

                    // Footer 底部导航栏
                    FooterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 相关案例区域组件
class _RelatedCasesSection extends StatelessWidget {
  const _RelatedCasesSection();

  @override
  Widget build(BuildContext context) {
    // 获取假数据
    final relatedCases = _getRelatedCases();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: [
          // 标题栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 左侧：相关案例标题
              const Text(
                '相关案例',
                style: TextStyle(
                  fontSize: 28, // 比CASE SHOW (24px) 稍大
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              // 右侧：更多案例按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    AppRouter.goToCases(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD93025),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '更多案例',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFD93025),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xFFD93025),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 3列卡片列表
          Row(
            children: List.generate(
              relatedCases.length > 3 ? 3 : relatedCases.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? 20 : 0, // 最后一个不需要右边距
                  ),
                  child: _RelatedCaseCard(caseItem: relatedCases[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取相关案例假数据
  List<CaseItem> _getRelatedCases() {
    return [
      const CaseItem(
        companyName: '云创信息',
        subtitle: '现代化品牌展示网站',
        location: '上海·浦东',
        backgroundImage: 'https://picsum.photos/800/600?random=11',
        logoUrl: 'https://via.placeholder.com/60',
        caseId: null,
      ),
      const CaseItem(
        companyName: '智汇网络',
        subtitle: '响应式企业门户系统',
        location: '深圳·南山',
        backgroundImage: 'https://picsum.photos/800/600?random=12',
        logoUrl: 'https://via.placeholder.com/60',
        caseId: null,
      ),
      const CaseItem(
        companyName: '星河科技',
        subtitle: '多语言官网开发',
        location: '广州·天河',
        backgroundImage: 'https://picsum.photos/800/600?random=13',
        logoUrl: 'https://via.placeholder.com/60',
        caseId: null,
      ),
    ];
  }
}

/// 相关案例卡片组件（使用精选案例的动画效果）
class _RelatedCaseCard extends StatefulWidget {
  final CaseItem caseItem;

  const _RelatedCaseCard({required this.caseItem});

  @override
  State<_RelatedCaseCard> createState() => _RelatedCaseCardState();
}

class _RelatedCaseCardState extends State<_RelatedCaseCard> {
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

              // 毛玻璃蒙层（悬停时显示）
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
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
                        duration: const Duration(milliseconds: 300),
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

                      // 底部：副标题 + 公司名称+地址
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 副标题（悬停时显示）
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
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
    );
  }
}
