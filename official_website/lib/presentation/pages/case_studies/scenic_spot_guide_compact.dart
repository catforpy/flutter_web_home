import 'package:flutter/material.dart';

/// 智慧景区导览案例 - 紧凑嵌入版本（完整增强版）
///
/// 专门用于嵌入到服务详情页中
/// 使用 SingleChildScrollView + Column，避免 Sliver 嵌套问题
/// 包含完整的视觉效果和动画
class ScenicSpotGuideContent extends StatefulWidget {
  const ScenicSpotGuideContent({super.key});

  @override
  State<ScenicSpotGuideContent> createState() => _ScenicSpotGuideContentState();
}

class _ScenicSpotGuideContentState extends State<ScenicSpotGuideContent> {
  double _stat1Value = 0;
  double _stat2Value = 0;
  double _scrollOffset = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _stat1Value = 185;
          _stat2Value = 68.5;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // 监听主内容的滚动事件
        if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            _scrollOffset = _scrollController.offset;
          });
        }
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFAFA),
              Colors.white,
              Color(0xFFF5F7FA),
            ],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildTopBar(),
              // 主内容区域 + 右侧侧边栏
              _buildMainContentWithSidebar(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  /// 主内容区域 + 右侧粘性侧边栏（真正的 sticky 效果）
  Widget _buildMainContentWithSidebar() {
    // Sticky判断：当滚动超过 80px 时，侧边栏固定在视口顶部
    bool isSticky = _scrollOffset > 80;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧主要内容（可滚动）
          Expanded(
            child: Column(
              children: [
                _buildHeroSection(),
                _buildMainCaseSection(),
                _buildServicesSection(),
                _buildMoreCasesSection(),
                _buildAdvantagesSection(),
                _buildCTASection(),
                _buildFooter(),
              ],
            ),
          ),
          const SizedBox(width: 40),

          // 右侧粘性侧边栏
          // 使用 Stack + Positioned 实现 sticky 效果
          SizedBox(
            width: 280,
            height: isSticky ? MediaQuery.of(context).size.height - 100 : null,
            child: isSticky
                ? _buildFixedSidebar()  // 固定悬停模式
                : _buildScrollingSidebar(),  // 跟随滚动模式
          ),
        ],
      ),
    );
  }

  /// 跟随滚动模式的侧边栏
  Widget _buildScrollingSidebar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        _buildSidebarCard(
          title: '项目服务',
          child: _buildSidebarServiceList(),
        ),
        const SizedBox(height: 20),
        _buildSidebarCard(
          title: '探索更多',
          child: _buildSidebarButtons(),
        ),
        const SizedBox(height: 20),
        _buildSidebarCard(
          title: '更多案例',
          child: _buildSidebarCaseNav(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// 固定悬停模式的侧边栏
  Widget _buildFixedSidebar() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
          bottom: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部间距（模拟 top: 80px）
          const SizedBox(height: 20),

          // 可滚动的内容区
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildSidebarSection(
                    title: '项目服务',
                    child: _buildSidebarServiceList(),
                  ),
                  const SizedBox(height: 20),
                  _buildSidebarSection(
                    title: '探索更多',
                    child: _buildSidebarButtons(),
                  ),
                  const SizedBox(height: 20),
                  _buildSidebarSection(
                    title: '更多案例',
                    child: _buildSidebarCaseNav(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 侧边栏区块（用于固定模式）
  Widget _buildSidebarSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// 侧边栏卡片容器
  Widget _buildSidebarCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// 侧边栏服务列表
  Widget _buildSidebarServiceList() {
    final services = [
      '原创视觉设计',
      '页面UI排版',
      '访客交互体验',
      '项目安全运维',
      '便于二次升级',
      '商用正规系统',
      'SSL安全访问',
      '秒级售后跟进',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: services.map((service) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF52C41A).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Color(0xFF52C41A)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF595959),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 侧边栏按钮组
  Widget _buildSidebarButtons() {
    return Column(
      children: [
        _buildSidebarButton(
          text: '有类似需求',
          isPrimary: true,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildSidebarButton(
          text: '免费获取报价',
          isPrimary: false,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildSidebarButton(
          text: '了解定制流程',
          isPrimary: false,
          onTap: () {},
        ),
      ],
    );
  }

  /// 侧边栏按钮
  Widget _buildSidebarButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF1890FF) : Colors.transparent,
            border: Border.all(
              color: isPrimary ? const Color(0xFF1890FF) : const Color(0xFFD9D9D9),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isPrimary ? Colors.white : const Color(0xFF595959),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 侧边栏案例导航
  Widget _buildSidebarCaseNav() {
    return Column(
      children: [
        _buildCaseNavItem(
          label: '上一个',
          title: '蜻蜓志愿 2.0',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildCaseNavItem(
          label: '下一个',
          title: 'VIPKID趣味英语',
          onTap: () {},
        ),
      ],
    );
  }

  /// 案例导航项
  Widget _buildCaseNavItem({
    required String label,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8C8C8C),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF262626),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 140,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '智慧景区',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Color(0xFF1890FF)),
                  SizedBox(width: 6),
                  Text('400-607-8355', style: TextStyle(fontSize: 14, color: Color(0xFF595959), fontWeight: FontWeight.w500)),
                  SizedBox(width: 24),
                  Icon(Icons.message, size: 16, color: Color(0xFF1890FF)),
                  SizedBox(width: 6),
                  Text('150-1069-6167', style: TextStyle(fontSize: 14, color: Color(0xFF595959), fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1890FF),
            const Color(0xFF40A9FF).withValues(alpha: 0.9),
            const Color(0xFF69C0FF).withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1890FF).withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '智慧景区导览',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                ),
                child: const Text(
                  'CASE SHOW',
                  style: TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 6, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatCard(value: _stat1Value, label: '访客停留时长', unit: '秒', isDecimal: false, gradientColors: const [Color(0xFF1890FF), Color(0xFF40A9FF)]),
                  const SizedBox(width: 60),
                  Container(
                    width: 2,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.5), Colors.transparent],
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  _buildStatCard(value: _stat2Value, label: '有效转化率', unit: '%', isDecimal: true, gradientColors: const [Color(0xFF52C41A), Color(0xFF73D13D)]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required double value, required String label, required String unit, required bool isDecimal, required List<Color> gradientColors}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Text(isDecimal ? value.toStringAsFixed(1) : value.toInt().toString()),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(unit, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildMainCaseSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF1890FF), Color(0xFF40A9FF)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('项目介绍', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                    ),
                    const SizedBox(height: 32),
                    const Text('智慧景区导览系统', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF262626))),
                    const SizedBox(height: 16),
                    const Text('基于微信小程序和APP的景区智能化解决方案', style: TextStyle(fontSize: 16, color: Color(0xFF8C8C8C))),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF1890FF).withValues(alpha: 0.05), const Color(0xFF40A9FF).withValues(alpha: 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1890FF).withValues(alpha: 0.1), width: 2),
                ),
                child: const Text(
                  '智慧景区导览系统是一套基于微信小程序和APP的景区智能化解决方案。通过整合景区地图导航、语音讲解、景点介绍、线路推荐等功能，为游客提供便捷的一站式游览体验。系统采用最新的前端技术栈开发，支持离线地图加载、实时定位、AR导览等先进功能，大大提升了游客的游览体验和景区的管理效率。',
                  style: TextStyle(fontSize: 15, height: 2, color: Color(0xFF595959)),
                ),
              ),
              const SizedBox(height: 60),
              const Center(child: Text('核心功能', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF262626)))),
              const SizedBox(height: 32),
              _buildFeatureGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': '🗺️', 'title': '智能导航', 'desc': '基于GPS定位的实时导航系统', 'color': const Color(0xFF1890FF)},
      {'icon': '🎧', 'title': '语音讲解', 'desc': '多语言语音导览', 'color': const Color(0xFF722ED1)},
      {'icon': '📍', 'title': '景点推荐', 'desc': '智能推荐算法', 'color': const Color(0xFFF5222D)},
      {'icon': '📱', 'title': '互动体验', 'desc': 'AR实景导航', 'color': const Color(0xFFFAAD14)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 2.5),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [(feature['color'] as Color).withValues(alpha: 0.1), (feature['color'] as Color).withValues(alpha: 0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: (feature['color'] as Color).withValues(alpha: 0.2), width: 1.5),
            boxShadow: [
              BoxShadow(color: (feature['color'] as Color).withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (feature['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(feature['icon'] as String, style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(feature['title'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: feature['color'] as Color)),
                    const SizedBox(height: 6),
                    Text(feature['desc'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF8C8C8C))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServicesSection() {
    final services = ['原创视觉设计', '页面UI排版', '访客交互体验', '项目安全运维', '便于二次升级', '商用正规系统', 'SSL安全访问', '秒级售后跟进'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text('项目服务', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF262626))),
              const SizedBox(height: 40),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [const Color(0xFF1890FF).withValues(alpha: 0.08), const Color(0xFF40A9FF).withValues(alpha: 0.04)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1890FF).withValues(alpha: 0.15), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(color: const Color(0xFF52C41A).withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.check, size: 14, color: Color(0xFF52C41A)),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            services[index],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF595959)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreCasesSection() {
    final cases = [
      {'title': '智慧社区小程序', 'desc': '改版升级 / 页面重构 / 高效售后', 'tag': '小程序', 'color': const Color(0xFF1890FF)},
      {'title': '蜻蜓志愿 2.0', 'desc': '学习平台 / 志愿报考 / 体验升级', 'tag': 'APP', 'color': const Color(0xFF722ED1)},
      {'title': '电商平台', 'desc': '全新设计 / 功能开发 / 性能优化', 'tag': '网站', 'color': const Color(0xFF52C41A)},
    ];

    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text('探索更多', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF262626))),
              const SizedBox(height: 40),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1.3),
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  final caseItem = cases[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [caseItem['color'] as Color, (caseItem['color'] as Color).withValues(alpha: 0.8)],
                                  ),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                ),
                                child: Center(child: Icon(Icons.business_center, size: 48, color: Colors.white.withValues(alpha: 0.5))),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
                                  child: Text(caseItem['tag'] as String, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(caseItem['title'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: caseItem['color'] as Color)),
                                const SizedBox(height: 6),
                                Text(caseItem['desc'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)), maxLines: 2, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvantagesSection() {
    final advantages = [
      {'icon': Icons.search, 'title': '现状分析', 'desc': '充分了解项目情况', 'color': const Color(0xFF1890FF)},
      {'icon': Icons.lightbulb_outline, 'title': '专业建议', 'desc': '有效并可落地的建议', 'color': const Color(0xFFFAAD14)},
      {'icon': Icons.monetization_on_outlined, 'title': '透明报价', 'desc': '详细的报价说明', 'color': const Color(0xFF52C41A)},
      {'icon': Icons.support_agent_outlined, 'title': '永久服务', 'desc': '长期稳定的合作', 'color': const Color(0xFF722ED1)},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text('您将获得', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF262626))),
              const SizedBox(height: 40),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 0.85),
                itemCount: advantages.length,
                itemBuilder: (context, index) {
                  final advantage = advantages[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [(advantage['color'] as Color).withValues(alpha: 0.08), (advantage['color'] as Color).withValues(alpha: 0.04)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: (advantage['color'] as Color).withValues(alpha: 0.15), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: advantage['color'] as Color, borderRadius: BorderRadius.circular(10)),
                          child: Icon(advantage['icon'] as IconData, color: Colors.white, size: 22),
                        ),
                        const SizedBox(height: 16),
                        Text(advantage['title'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: advantage['color'] as Color)),
                        const SizedBox(height: 8),
                        Text(advantage['desc'] as String, style: const TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF8C8C8C))),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1890FF), const Color(0xFF40A9FF).withValues(alpha: 0.9), const Color(0xFF69C0FF).withValues(alpha: 0.8)],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1890FF).withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('免费获取报价方案', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))])),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: Text('立即咨询', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1890FF), letterSpacing: 1)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF262626), Color(0xFF1F1F1F)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _FooterItem(title: '免费咨询', content: '400-607-8355', desc: '7*24小时客服热线'),
                _FooterItem(title: '商务经理', content: '150-1069-6167', desc: '同微信'),
                _FooterItem(title: '联系邮箱', content: 'wangzhan360@qq.com'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Divider(color: Color(0xFF404040), thickness: 1),
          ),
          const SizedBox(height: 24),
          const Text('© 2025 智慧景区导览. All rights reserved.', style: TextStyle(fontSize: 13, color: Color(0xFF8C8C8C), letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final String title;
  final String content;
  final String desc;

  const _FooterItem({required this.title, required this.content, this.desc = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
        const SizedBox(height: 12),
        Text(content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1890FF), letterSpacing: 0.5)),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
        ],
      ],
    );
  }
}
