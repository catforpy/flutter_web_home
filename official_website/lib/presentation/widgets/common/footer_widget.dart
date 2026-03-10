import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_sizes.dart';

/// Footer 底部导航栏组件
/// 包含五列导航 + 版权行
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // 深灰背景
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.xxxl,
        ),
        child: Column(
          children: [
            // 五列导航
            _buildNavigationColumns(context),

            SizedBox(height: AppSizes.xl),

            // 分隔线
            _buildSeparatorLine(),

            SizedBox(height: AppSizes.lg),

            // 版权行
            _buildCopyrightRow(),
          ],
        ),
      ),
    );
  }

  /// 构建五列导航
  Widget _buildNavigationColumns(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 移动端（宽度小于768）：垂直堆叠
        if (constraints.maxWidth < 768) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSingleColumn('服务', _getServiceItems(context), isFirst: true),
              SizedBox(height: AppSizes.lg),
              _buildSingleColumn('解决方案', _getSolutionItems()),
              SizedBox(height: AppSizes.lg),
              _buildSingleColumn('关于我们', _getAboutItems()),
              SizedBox(height: AppSizes.lg),
              _buildSingleColumn('联系我们', _getContactItems()),
            ],
          );
        }

        // 桌面端：四列横向排列
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSingleColumn('服务', _getServiceItems(context), isFirst: true)),
            Expanded(child: _buildSingleColumn('解决方案', _getSolutionItems())),
            Expanded(child: _buildSingleColumn('关于我们', _getAboutItems())),
            Expanded(child: _buildSingleColumn('联系我们', _getContactItems())),
          ],
        );
      },
    );
  }

  /// 构建单列导航
  Widget _buildSingleColumn(String title, List<FooterLinkItem> items, {bool isFirst = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 列标题
        Text(
          title,
          style: TextStyle(
            fontSize: AppSizes.fsLg,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppSizes.md),
        // 列表项
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _buildLinkItem(item),
            )),
      ],
    );
  }

  /// 构建链接项
  Widget _buildLinkItem(FooterLinkItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: Text(
          item.text,
          style: TextStyle(
            fontSize: AppSizes.fsSm,
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  /// 构建分隔线
  Widget _buildSeparatorLine() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
      ),
    );
  }

  /// 构建版权行
  Widget _buildCopyrightRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 移动端：垂直排列
        if (constraints.maxWidth < 768) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Copyright@ 2010-2026 无锡都达网络科技有限公司 All Rights Reserved.',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              _buildICPLink(),
            ],
          );
        }

        // 桌面端：左右对齐
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Copyright@ 2010-2026 无锡都达网络科技有限公司 All Rights Reserved.',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
              ),
            ),
            _buildICPLink(),
          ],
        );
      },
    );
  }

  /// 构建ICP备案链接
  Widget _buildICPLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse('https://beian.miit.gov.cn/#/Integrated/index');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          '苏ICP备2025161808号',
          style: TextStyle(
            fontSize: AppSizes.fsSm,
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  // ==================== 数据提供方法 ====================

  /// 服务列的链接项（跳转到当前页面）
  List<FooterLinkItem> _getServiceItems(BuildContext context) {
    return [
      FooterLinkItem(
        text: '网站建设',
        onTap: () {
          // 跳转到当前页面（服务页）
          debugPrint('点击了网站建设 - 跳转到服务页');
          // TODO: 路由系统建立后启用
          // Navigator.pushNamed(context, AppRouter.serve);
        },
      ),
      FooterLinkItem(
        text: '软件开发',
        onTap: () {
          debugPrint('点击了软件开发 - 跳转到服务页');
        },
      ),
      FooterLinkItem(
        text: '小程序开发',
        onTap: () {
          debugPrint('点击了小程序开发 - 跳转到服务页');
        },
      ),
      FooterLinkItem(
        text: 'APP开发',
        onTap: () {
          debugPrint('点击了APP开发 - 跳转到服务页');
        },
      ),
    ];
  }

  /// 解决方案列的链接项（预留，页面未写）
  List<FooterLinkItem> _getSolutionItems() {
    return [
      FooterLinkItem(
        text: '移动电商类',
        onTap: () {
          debugPrint('点击了移动电商类');
        },
      ),
      FooterLinkItem(
        text: '社区类',
        onTap: () {
          debugPrint('点击了社区类');
        },
      ),
      FooterLinkItem(
        text: '教育类',
        onTap: () {
          debugPrint('点击了教育类');
        },
      ),
      FooterLinkItem(
        text: '金融类',
        onTap: () {
          debugPrint('点击了金融类');
        },
      ),
    ];
  }

  /// 关于我们列的链接项（预留，页面未写）
  List<FooterLinkItem> _getAboutItems() {
    return [
      FooterLinkItem(
        text: '服务案例',
        onTap: () {
          debugPrint('点击了服务案例');
        },
      ),
      FooterLinkItem(
        text: '公司简介',
        onTap: () {
          debugPrint('点击了公司简介');
        },
      ),
      FooterLinkItem(
        text: '发展历程',
        onTap: () {
          debugPrint('点击了发展历程');
        },
      ),
      FooterLinkItem(
        text: '企业文化',
        onTap: () {
          debugPrint('点击了企业文化');
        },
      ),
    ];
  }

  /// 联系我们列的链接项
  List<FooterLinkItem> _getContactItems() {
    return [
      FooterLinkItem(
        text: '电话：13961535392',
        onTap: () async {
          final uri = Uri.parse('tel:13961535392');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
      ),
      FooterLinkItem(
        text: '邮箱：contact@junhe.com',
        onTap: () async {
          final uri = Uri.parse('mailto:contact@junhe.com');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
      ),
      FooterLinkItem(
        text: '地址：珠海市香洲区',
        onTap: () {
          debugPrint('点击了地址');
        },
      ),
    ];
  }
}

/// Footer链接项数据模型
class FooterLinkItem {
  final String text;
  final VoidCallback onTap;

  FooterLinkItem({
    required this.text,
    required this.onTap,
  });
}
