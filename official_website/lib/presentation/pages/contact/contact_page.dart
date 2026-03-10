import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import '../../routes/app_router.dart';

/// 联系页面
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 1. 导航栏 + 联系标题区
                  _buildHeroSection(),

                  // 2. 导航栏（在 Hero 横幅下面）
                  UnifiedNavigationBar(
                    currentPath: AppRouter.contact,
                  ),

                  // 3. 公司信息区
                  _buildCompanyInfoSection(),

                  // 3. 联系方式区
                  _buildContactInfoSection(),

                  // 4. Footer 底部导航栏
                  const FooterWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部区域（导航栏 + 联系标题）
  Widget _buildHeroSection() {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          // 背景图
          Positioned.fill(
            child: Image.asset(
              'assets/contact-banner.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('ContactBanner: 图片加载失败 - $error');
                // 图片加载失败时显示渐变背景
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A2332),
                        Color(0xFF0D1B2A),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 黑色半透明蒙版
          Container(
            color: Colors.black.withValues(alpha: 0.65),
          ),

          // 左侧文案区（距左40px，距顶180px）
          Positioned(
            top: 180,
            left: 40,
            child: _buildLeftContent(),
          ),
        ],
      ),
    );
  }

  /// 构建左侧内容
  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主标题
        Text(
          '下一个品牌故事，我们一起讲述...',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),

        // 副标题（空白）
        const SizedBox.shrink(),
      ],
    );
  }

  /// 构建公司信息区
  Widget _buildCompanyInfoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Center(
        child: SizedBox(
          width: 900,
          child: Column(
            children: [
              // 主标题
              Text(
                '我们是，都达网络',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '专注中小企业与个体工商户的数字化建站服务商',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xFF999999),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // 公司介绍正文
              Text(
                '都达网络科技有限公司，是一家新兴的互联网技术服务团队，致力于成为中小企业及个体工商户最值得信赖的数字化合作伙伴。\n\n我们摒弃传统大型服务商的繁琐流程与高昂溢价，专注于为小微经济体提供高性价比的品牌网站建设、小程序开发及运营维护服务。虽然我们是行业的新锐力量，但我们拥有严谨的技术态度与敏锐的市场洞察。\n\n我们深知创业维艰，因此坚持以"让每一家小店都拥有自己的品牌官网"为愿景，用专业的技术和贴心的服务，助力您在互联网浪潮中轻松起步，快速获客，实现业务增长。',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF666666),
                  height: 1.8,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建联系方式区
  Widget _buildContactInfoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧Column
          Expanded(
            child: _buildLeftContactInfo(),
          ),

          const SizedBox(width: 120),

          // 右侧Column
          Expanded(
            child: _buildRightContactInfo(),
          ),
        ],
      ),
    );
  }

  /// 左侧联系方式
  Widget _buildLeftContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Text(
          '全国免费合作电话',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 24),

        // 电话号码（红色大字）
        Text(
          '139-6153-5392',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD93025),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 48),

        // 项目咨询
        _ContactItem(
          icon: Icons.phone,
          label: '项目咨询：',
          value: '139-6153-5392',
        ),
        const SizedBox(height: 24),

        // 售后服务
        _ContactItem(
          icon: Icons.mobile_screen_share,
          label: '售后服务：',
          value: '',
        ),
        const SizedBox(height: 24),

        // 作息时间
        _ContactItem(
          icon: Icons.access_time,
          label: '作息时间：',
          value: '早9:00 ~ 晚21:00（周一到周日）',
        ),
      ],
    );
  }

  /// 右侧联系方式（二维码）
  Widget _buildRightContactInfo() {
    return Row(
      children: [
        // 二维码
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF5F5F5),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_2,
                  size: 80,
                  color: const Color(0xFF999999),
                ),
                const SizedBox(height: 8),
                Text(
                  '微信二维码',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 40),

        // 文字说明
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '微信咨询',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '扫码加好友',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '商务经理快速报价',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 联系方式条目组件
class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF333333),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (value.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ],
    );
  }
}
