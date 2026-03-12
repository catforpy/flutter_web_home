import 'package:flutter/material.dart';

/// 智慧景区导览案例内容（紧凑嵌入版本）
///
/// 专门用于嵌入到详情页中，使用基本的 SingleChildScrollView
/// 避免 Sliver 组件的嵌套问题
class ScenicSpotGuideContent extends StatefulWidget {
  const ScenicSpotGuideContent({super.key});

  @override
  State<ScenicSpotGuideContent> createState() => _ScenicSpotGuideContentState();
}

class _ScenicSpotGuideContentState extends State<ScenicSpotGuideContent> {
  // 统计数字动画值
  double _stat1Value = 0;
  double _stat2Value = 0;

  @override
  void initState() {
    super.initState();
    // 启动统计数字动画
    _animateStats();
  }

  /// 统计数字动画
  void _animateStats() {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero区域
          _buildHeroSection(),

          // 主案例展示区（简化版）
          _buildMainCaseSection(),

          // 项目服务区
          _buildServicesSection(),

          // 更多案例展示
          _buildMoreCasesSection(),

          // 服务优势区
          _buildAdvantagesSection(),

          // 底部CTA
          _buildCTASection(),

          // 页脚
          _buildFooter(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
///
/// 用于嵌入到其他页面中展示案例内容
/// 使用 SingleChildScrollView 而不是 CustomScrollView，以避免嵌套滚动视图的问题
class ScenicSpotGuideContent extends StatefulWidget {
  const ScenicSpotGuideContent({super.key});

  @override
  State<ScenicSpotGuideContent> createState() => _ScenicSpotGuideContentState();
}

class _ScenicSpotGuideContentState extends State<ScenicSpotGuideContent> {
  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 统计数字动画值
  double _stat1Value = 0;
  double _stat2Value = 0;

  // 是否显示返回顶部按钮
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // 启动统计数字动画
    _animateStats();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _showBackToTop = _scrollController.offset > 300;
    });
  }

  /// 统计数字动画
  void _animateStats() {
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
  Widget build(BuildContext context) {
    return SizedBox(
      // 给予一个明确的高度，避免无限高度问题
      height: 800,
      child: Stack(
        children: [
          // 主内容区 - 使用 SingleChildScrollView 替代 CustomScrollView
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hero区域
                _buildHeroSection(),

                // 主案例展示区
                _buildMainCaseSection(),

                // 项目服务区
                _buildServicesSection(),

                // 更多案例展示
                _buildMoreCasesSection(),

                // 服务优势区
                _buildAdvantagesSection(),

                // 底部CTA
                _buildCTASection(),

                // 页脚
                _buildFooter(),

                // 底部留白（给悬浮按钮留空间）
                SizedBox(height: _showBackToTop ? 80 : 20),
              ],
            ),
          ),

          // 固定悬浮按钮
          _buildFloatingButtons(),

          // 返回顶部按钮
          if (_showBackToTop) _buildBackToTopButton(),
        ],
      ),
    );
  }

  // ============================================
  // Hero区域
  // ============================================
  Widget _buildHeroSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1890FF),
            const Color(0xFF40A9FF).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 标题
              const Text(
                '智慧景区导览',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Case Show',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 60),

              // 统计数据
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem(
                    value: _stat1Value,
                    label: '访客停留时长',
                    unit: '秒',
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.white.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                  ),
                  _buildStatItem(
                    value: _stat2Value,
                    label: '有效转化率',
                    unit: '%',
                    isDecimal: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 统计项
  Widget _buildStatItem({
    required double value,
    required String label,
    required String unit,
    bool isDecimal = false,
  }) {
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          child: Text(
            isDecimal ? value.toStringAsFixed(1) : value.toInt().toString(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  // ============================================
  // 3. 主案例展示区
  // ============================================
  Widget _buildMainCaseSection() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              // 大屏幕：左右布局 + 粘性侧边栏
              return _buildWideStickyLayout();
            } else {
              // 小屏幕：单列布局
              return _buildNarrowLayout();
            }
          },
        ),
      ),
    );
  }

  /// 宽屏粘性布局
  Widget _buildWideStickyLayout() {
    return Column(
      children: [
        // 顶部留白（给粘性侧边栏留空间）
        const SizedBox(height: 60),

        // 主内容区（使用 IntrinsicHeight 确保左右等高）
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧主内容
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildMainContent(),
                ),
              ),
              const SizedBox(width: 40),

              // 右侧粘性侧边栏
              SizedBox(
                width: 300,
                child: _buildStickySidebar(),
              ),
            ],
          ),
        ),

        // 底部留白
        const SizedBox(height: 60),
      ],
    );
  }

  /// 窄屏布局（单列）
  Widget _buildNarrowLayout() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildMainContent(),
          const SizedBox(height: 40),
          _buildSidebar(),
        ],
      ),
    );
  }

  /// 左侧主内容
  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 案例大图
        _buildCaseImage(),
        const SizedBox(height: 40),

        // 项目介绍
        _buildSection(
          title: '项目介绍',
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '智慧景区导览系统是一套基于微信小程序和APP的景区智能化解决方案。通过整合景区地图导航、语音讲解、景点介绍、线路推荐等功能，为游客提供便捷的一站式游览体验。',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.8,
                  color: Color(0xFF595959),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '该系统采用最新的前端技术栈开发，支持离线地图加载、实时定位、AR导览等先进功能，大大提升了游客的游览体验和景区的管理效率。',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.8,
                  color: Color(0xFF595959),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // 核心功能
        _buildSection(
          title: '核心功能',
          child: _buildFeatureGrid(),
        ),
        const SizedBox(height: 40),

        // 技术架构
        _buildSection(
          title: '技术架构',
          child: _buildTechList(),
        ),
        const SizedBox(height: 40),

        // 项目成果
        _buildSection(
          title: '项目成果',
          child: _buildAchievementList(),
        ),
        const SizedBox(height: 40),

        // 效果展示
        _buildSection(
          title: '效果展示',
          child: _buildShowcaseGrid(),
        ),
        const SizedBox(height: 20),

        // 免责声明
        const Text(
          '上述图文素材所有权及解释权归客户所有，上述案例只做分享、展示和陈述，不作为商业推广目的。',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF8C8C8C),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  /// 案例大图
  Widget _buildCaseImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              '智慧景区导览案例展示',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip('2022年'),
                _buildInfoChip('浏览热度：386'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 通用区块
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF262626),
          ),
        ),
        const SizedBox(height: 24),
        child,
      ],
    );
  }

  /// 核心功能网格
  Widget _buildFeatureGrid() {
    final features = [
      {'icon': '🗺️', 'title': '智能导航', 'desc': '基于GPS定位的实时导航系统，支持多种路线规划'},
      {'icon': '🎧', 'title': '语音讲解', 'desc': '多语言语音导览，专业配音员录制'},
      {'icon': '📍', 'title': '景点推荐', 'desc': '智能推荐算法，个性化游览路线'},
      {'icon': '📱', 'title': '互动体验', 'desc': 'AR实景导航、虚拟拍照等互动功能'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Row(
            children: [
              Text(
                feature['icon'] as String,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF262626),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['desc'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8C8C8C),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 技术架构列表
  Widget _buildTechList() {
    final techs = [
      {'label': '前端框架', 'value': 'Vue 3 + Vant UI'},
      {'label': '地图服务', 'value': '高德地图 API'},
      {'label': '后端技术', 'value': 'Node.js + Express'},
      {'label': '数据库', 'value': 'MySQL + Redis'},
      {'label': '部署方案', 'value': 'Docker 容器化部署'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: techs.map((tech) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tech['label'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF595959),
                  ),
                ),
                Text(
                  tech['value'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1890FF),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 项目成果列表
  Widget _buildAchievementList() {
    final achievements = [
      {'number': '50000+', 'label': '月活跃用户'},
      {'number': '98%', 'label': '用户满意度'},
      {'number': '50+', 'label': '合作景区'},
      {'number': '200+', 'label': '覆盖景点'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                achievement['number'] as String,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement['label'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 效果展示网格
  Widget _buildShowcaseGrid() {
    final showcases = [
      {'title': '首页界面', 'color': const Color(0xFF1890FF)},
      {'title': '地图导航', 'color': const Color(0xFF40A9FF)},
      {'title': '语音讲解', 'color': const Color(0xFF52C41A)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: showcases.length,
      itemBuilder: (context, index) {
        final showcase = showcases[index];
        return Container(
          decoration: BoxDecoration(
            color: showcase['color'] as Color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_iphone,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                showcase['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 右侧Sticky侧边栏
  Widget _buildSidebar() {
    return Column(
      children: [
        _buildSidebarSection(
          title: '项目服务',
          child: _buildServiceList(),
        ),
        const SizedBox(height: 24),
        _buildSidebarSection(
          title: '探索更多',
          child: _buildSidebarButtons(),
        ),
        const SizedBox(height: 24),
        _buildSidebarSection(
          title: '更多案例',
          child: _buildCaseNavigation(),
        ),
      ],
    );
  }

  /// 右侧粘性侧边栏（使用 CustomScrollView + SliverPersistentHeader）
  Widget _buildStickySidebar() {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: CustomScrollView(
        slivers: [
          // 项目服务区块（粘性）
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickySidebarHeaderDelegate(
              minHeight: 200,
              maxHeight: 200,
              child: _buildSidebarSection(
                title: '项目服务',
                child: _buildServiceList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 探索更多区块（粘性）
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickySidebarHeaderDelegate(
              minHeight: 180,
              maxHeight: 180,
              child: _buildSidebarSection(
                title: '探索更多',
                child: _buildSidebarButtons(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 更多案例区块（粘性）
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickySidebarHeaderDelegate(
              minHeight: 160,
              maxHeight: 160,
              child: _buildSidebarSection(
                title: '更多案例',
                child: _buildCaseNavigation(),
              ),
            ),
          ),

          // 底部留空
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildSidebarSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
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

  Widget _buildServiceList() {
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
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Color(0xFF52C41A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF595959),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

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
          text: '了解项目定制流程',
          isPrimary: false,
          onTap: () {},
        ),
      ],
    );
  }

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
            ),
            borderRadius: BorderRadius.circular(6),
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

  Widget _buildCaseNavigation() {
    return Column(
      children: [
        _buildCaseNavItem(label: '上一个', title: '蜻蜓志愿 2.0'),
        const SizedBox(height: 12),
        _buildCaseNavItem(label: '下一个', title: 'VIPKID趣味英语'),
      ],
    );
  }

  Widget _buildCaseNavItem({required String label, required String title}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8C8C8C),
            ),
          ),
          const SizedBox(height: 4),
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
    );
  }

  // ============================================
  // 4. 项目服务区
  // ============================================
  Widget _buildServicesSection() {
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

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Text(
              '项目服务',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: services.map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Color(0xFF52C41A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          service,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF595959),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // 5. 更多案例展示
  // ============================================
  Widget _buildMoreCasesSection() {
    final cases = [
      {'title': '智慧社区小程序', 'desc': '改版升级 / 页面重构 / 高效售后', 'tag': '小程序', 'color': const Color(0xFF1890FF)},
      {'title': '蜻蜓志愿 2.0', 'desc': '学习平台 / 志愿报考 / 体验升级', 'tag': 'APP', 'color': const Color(0xFF40A9FF)},
      {'title': '电商平台', 'desc': '全新设计 / 功能开发 / 性能优化', 'tag': '网站', 'color': const Color(0xFF52C41A)},
      {'title': '企业管理系统', 'desc': '定制开发 / 数据管理 / 权限控制', 'tag': '系统', 'color': const Color(0xFFFAAD14)},
      {'title': '在线教育平台', 'desc': '直播课堂 / 在线作业 / 学习追踪', 'tag': '平台', 'color': const Color(0xFFF5222D)},
      {'title': '医疗健康APP', 'desc': '在线问诊 / 健康管理 / 预约挂号', 'tag': 'APP', 'color': const Color(0xFF722ED1)},
    ];

    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Text(
              '探索更多',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.6,
                ),
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  final caseItem = cases[index];
                  return _buildCaseCard(
                    title: caseItem['title'] as String,
                    desc: caseItem['desc'] as String,
                    tag: caseItem['tag'] as String,
                    color: caseItem['color'] as Color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCard({
    required String title,
    required String desc,
    required String tag,
    required Color color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('查看案例: $title'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片区域
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.business_center,
                          size: 48,
                          color: Colors.white30,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 内容区域
              Padding(
                padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8C8C8C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // 6. 服务优势区
  // ============================================
  Widget _buildAdvantagesSection() {
    final advantages = [
      {
        'icon': Icons.search,
        'title': '现状分析',
        'desc': '对企业/行业/产品/场景/需求/人群等进行调研分析，充分了解项目情况。输出项目分析报告与、执行计划。',
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': '专业且落地的建议',
        'desc': '我们具有各个行业丰富地实操经验，针对您的产品，我们可以提供很多有效并且可落地的建议。',
      },
      {
        'icon': Icons.monetization_on_outlined,
        'title': '透明干净的报价方式',
        'desc': '在线营销顾问会非常详细的向您讲解价格计算方式，在这个过程中您会得知所做服务中的所有细节。',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': '永久顾问服务',
        'desc': '我们与众多客户都保持长期稳定的合作关系，只要是互联网相关问题，我们都会力所能及帮助您。',
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Text(
              '您将获得',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF262626),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemCount: advantages.length,
                itemBuilder: (context, index) {
                  final advantage = advantages[index];
                  return _buildAdvantageCard(
                    icon: advantage['icon'] as IconData,
                    title: advantage['title'] as String,
                    desc: advantage['desc'] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1890FF),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF8C8C8C),
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ============================================
  // 7. 底部CTA
  // ============================================
  Widget _buildCTASection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1890FF),
              const Color(0xFF40A9FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '免费获取报价方案',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '立即咨询',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1890FF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // 8. 页脚
  // ============================================
  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF262626),
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _FooterItem(
                        title: '免费咨询',
                        content: '400-607-8355',
                        desc: '7*24小时客服热线',
                      ),
                      _FooterItem(
                        title: '商务经理',
                        content: '150-1069-6167',
                        desc: '同微信',
                      ),
                      _FooterItem(
                        title: '联系邮箱',
                        content: 'wangzhan360@qq.com',
                        desc: '',
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Divider(color: Color(0xFF404040)),
                  SizedBox(height: 20),
                  Text(
                    '© 2025 智慧景区导览. All rights reserved.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // 固定悬浮按钮
  // ============================================
  Widget _buildFloatingButtons() {
    return Positioned(
      right: 24,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatButton(
            icon: Icons.wechat,
            tooltip: '微信交谈',
            color: const Color(0xFF07C160),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildFloatButton(
            icon: Icons.phone,
            tooltip: '联系方式',
            color: const Color(0xFF1890FF),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildFloatButton(
            icon: Icons.description_outlined,
            tooltip: '获取方案',
            color: const Color(0xFF52C41A),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildFloatButton(
            icon: Icons.video_call_outlined,
            tooltip: '线上会议',
            color: const Color(0xFFFAAD14),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFloatButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  /// 返回顶部按钮
  Widget _buildBackToTopButton() {
    return Positioned(
      right: 24,
      bottom: 240,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_upward, size: 20),
          ),
        ),
      ),
    );
  }
}

// ============================================
// Header Sliver Persistent Delegate
// ============================================
// ============================================
// Footer Item Widget
// ============================================
class _FooterItem extends StatelessWidget {
  final String title;
  final String content;
  final String desc;

  const _FooterItem({
    required this.title,
    required this.content,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1890FF),
          ),
        ),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8C8C8C),
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================
// Sticky Sidebar Header Delegate
// ============================================
class _StickySidebarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickySidebarHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickySidebarHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// ============================================
// 完整页面版本（带 Scaffold）- 可独立使用
// ============================================
/// 智慧景区导览案例页面（完整版本）
///
/// 包含顶部导航栏，可以独立使用
/// 如果要嵌入到其他页面，请使用 ScenicSpotGuideContent
class ScenicSpotGuidePage extends StatelessWidget {
  const ScenicSpotGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: const ScenicSpotGuideContent(),
    );
  }
}

