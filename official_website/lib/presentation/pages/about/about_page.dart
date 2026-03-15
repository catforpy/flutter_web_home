import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';

/// 我们页面（原"关于"页面）
/// 三栏布局：左侧文案 + 中间导航树 + 右侧图片
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
            // 主内容区
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 左侧：主文案区（30%）
                        Expanded(
                          flex: 3,
                          child: _LeftContentSection(),
                        ),

                        SizedBox(width: 60),

                        // 中间：导航树区（40%）
                        Expanded(
                          flex: 4,
                          child: _NavTreeSection(),
                        ),

                        SizedBox(width: 60),

                        // 右侧：图片区（30%）
                        Expanded(
                          flex: 3,
                          child: _RightImageSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

/// 左侧内容区
class _LeftContentSection extends StatelessWidget {
  const _LeftContentSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        const Text(
          '我们',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.2,
          ),
        ),

        const SizedBox(height: 24),

        // 标语
        const Text(
          '专注软件开发服务\n为企业数字化转型赋能',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF666666),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 40),

        // 了解更多按钮
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // TODO: 跳转到联系页面
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD93025),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '了解更多',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 中间导航树区
class _NavTreeSection extends StatefulWidget {
  const _NavTreeSection();

  @override
  State<_NavTreeSection> createState() => _NavTreeSectionState();
}

class _NavTreeSectionState extends State<_NavTreeSection> {
  // 默认全部展开
  final Set<String> _expandedGroups = {'了解我们', '客户心声'};

  void _toggleGroup(String groupName) {
    setState(() {
      if (_expandedGroups.contains(groupName)) {
        _expandedGroups.remove(groupName);
      } else {
        _expandedGroups.add(groupName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组1：了解我们
        _NavGroup(
          title: '了解我们',
          isExpanded: _expandedGroups.contains('了解我们'),
          onToggle: () => _toggleGroup('了解我们'),
          items: const [
            _NavItem(title: '我们是谁？', hasTag: false),
            _NavItem(title: '优势亮点', hasTag: true, tagName: '亮点'),
            _NavItem(title: '资质荣誉', hasTag: false),
            _NavItem(title: '发展历程', hasTag: false),
          ],
        ),

        const SizedBox(height: 32),

        // 分组2：客户心声
        _NavGroup(
          title: '客户心声',
          isExpanded: _expandedGroups.contains('客户心声'),
          onToggle: () => _toggleGroup('客户心声'),
          items: const [
            _NavItem(title: '合作流程', hasTag: false),
            _NavItem(title: '客户评价', hasTag: true, tagName: '口碑'),
            _NavItem(title: '服务保障', hasTag: false),
          ],
        ),
      ],
    );
  }
}

/// 导航分组
class _NavGroup extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<_NavItem> items;

  const _NavGroup({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 20,
                    color: const Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 子项列表
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Column(
                    children: items,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// 导航项
class _NavItem extends StatelessWidget {
  final String title;
  final bool hasTag;
  final String? tagName;

  const _NavItem({
    required this.title,
    this.hasTag = false,
    this.tagName,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: 处理点击事件
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              if (hasTag && tagName != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tagName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 右侧图片区
class _RightImageSection extends StatelessWidget {
  const _RightImageSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/solution-banner.png', // 临时使用现有图片
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.business, size: 64, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
