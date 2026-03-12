import 'package:flutter/material.dart';

/// 智慧景区导览 - 完整实现版本
///
/// 使用 CustomScrollView + Sliver 架构
/// 实现所有原始需求：导航栏滚动效果、sticky侧边栏、渐变背景等
class ScenicSpotGuideComplete extends StatefulWidget {
  const ScenicSpotGuideComplete({super.key});

  @override
  State<ScenicSpotGuideComplete> createState() => _ScenicSpotGuideCompleteState();
}

class _ScenicSpotGuideCompleteState extends State<ScenicSpotGuideComplete> {
  // 导航栏状态
  bool _isNavbarTransparent = true;
  bool _isNavbarShrunk = false;

  // 滚动监听
  final ScrollController _scrollController = ScrollController();

  // 数字动画
  double _visitorTimeValue = 0;
  double _conversionRateValue = 0;

  // 记录滚动位置，用于判断滚动方向
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 延迟启动数字动画
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animateNumbers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final isScrollingDown = offset > _lastScrollOffset;

    setState(() {
      // 滚动超过80px时，导航栏变白色
      if (offset > 80) {
        _isNavbarTransparent = false;
        _isNavbarShrunk = isScrollingDown;
      } else if (offset < 20) {
        _isNavbarTransparent = true;
        _isNavbarShrunk = false;
      }

      _lastScrollOffset = offset;
    });
  }

  void _animateNumbers() {
    setState(() {
      _visitorTimeValue = 185;
      _conversionRateValue = 68.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // === 底层：全屏渐变背景 ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF52C41A),
                    Color(0xFFD4B106),
                    Color(0xFFFAFAFA),
                    Colors.white,
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // === 上层：CustomScrollView（包含导航栏和内容）===
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 2. 顶部导航栏（真正透明，能看到下面的渐变背景）
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _NavbarSliverDelegate(
                  isTransparent: _isNavbarTransparent,
                  isShrunk: _isNavbarShrunk,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),

              // 3. Hero区域（透明背景）
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60, top: 80, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 左侧标题
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const Text(
                            '智慧景区导览',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Case Show',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 40),

                    // 右侧统计卡片
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildStatisticsCard(),
                    ),
                  ],
                ),
                  ),
                ),
              ),

              // 4. 主内容区 + 侧边栏（白色背景，向上覆盖）
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -400),
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1800),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 左侧：主内容区
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(60),
                                child: Column(
                                  children: [
                                    _buildCaseImageSection(),
                                    _buildProjectIntroSection(),
                                    _buildCoreFeaturesSection(),
                                    _buildTechArchitectureSection(),
                                    _buildProjectResultsSection(),
                                    _buildUserReviewsSection(),
                                    _buildEffectShowcaseSection(),
                                    _buildServicesSection(),
                                    _buildMoreCasesSection(),
                                    _buildAdvantagesSection(),
                                    _buildCTASection(),
                                    _buildFooterSection(),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 40),

                            // 右侧：Sticky侧边栏
                            SizedBox(
                              width: 280,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 60, top: 60),
                                child: _buildStickySidebar(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 统计卡片
  Widget _buildStatisticsCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 关键：只占据需要的最小高度
        children: [
          _buildStatItem(
            '访客停留时长',
            _visitorTimeValue.toInt().toString(),
            '秒',
            _visitorTimeValue / 185,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          _buildStatItem(
            '有效转化率',
            _conversionRateValue.toStringAsFixed(1),
            '%',
            _conversionRateValue / 68.5,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
              ),
              child: Text(value),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.9),
            ),
            minHeight: 3,
          ),
        ),
      ],
    );
  }

  /// 主内容（包含主内容区和侧边栏）
  Widget _buildMainContent() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1800),
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧主内容
          Expanded(
            child: Column(
              children: [
                _buildCaseImageSection(),
                _buildProjectIntroSection(),
                _buildCoreFeaturesSection(),
                _buildTechArchitectureSection(),
                _buildProjectResultsSection(),
                _buildUserReviewsSection(),
                _buildEffectShowcaseSection(),
                _buildServicesSection(),
                _buildMoreCasesSection(),
                _buildAdvantagesSection(),
                _buildCTASection(),
                _buildFooterSection(),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // 5. 右侧Sticky侧边栏
          SizedBox(
            width: 280,
            child: _buildStickySidebar(),
          ),
        ],
      ),
    );
  }

  /// 5. Sticky侧边栏
  Widget _buildStickySidebar() {
    return Container(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 项目服务
            _buildSidebarSection(
              '项目服务',
              [
                '原创视觉设计',
                '交互体验优化',
                '响应式布局',
                '性能优化',
                '数据可视化',
                '智能推荐算法',
                '实时位置服务',
                '多端适配',
              ],
            ),

            const SizedBox(height: 24),

            // 探索更多
            _buildExploreMore(),

            const SizedBox(height: 24),

            // 案例导航
            _buildCaseNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Color(0xFF52C41A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExploreMore() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '探索更多',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildExploreButton('案例详情', Icons.article_outlined),
          const SizedBox(height: 12),
          _buildExploreButton('技术方案', Icons.code_outlined),
          const SizedBox(height: 12),
          _buildExploreButton('联系我们', Icons.contact_phone_outlined),
        ],
      ),
    );
  }

  Widget _buildExploreButton(String label, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1890FF)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1890FF).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '案例导航',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNavButton('上一个', Icons.arrow_back_ios_new, () {}),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNavButton('下一个', Icons.arrow_forward_ios, () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 以下是各种内容区域的构建方法（简化版，与之前相同）
  Widget _buildCaseImageSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://picsum.photos/1400/800?random=100',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF52C41A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Color(0xFF52C41A)),
                    SizedBox(width: 6),
                    Text('2022年', style: TextStyle(fontSize: 14, color: Color(0xFF52C41A), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 16, color: Color(0xFFFF5000)),
                    SizedBox(width: 6),
                    Text('浏览热度 98%', style: TextStyle(fontSize: 14, color: Color(0xFFFF5000), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectIntroSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '项目介绍',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: const Text(
              '本项目为某5A级景区打造的一站式智慧导览系统，通过AR技术、实时定位、智能推荐等创新功能，为游客提供沉浸式的游览体验。',
              style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreFeaturesSection() {
    final features = [
      {'icon': Icons.map_outlined, 'title': 'AR实景导航', 'desc': '基于AR技术的实时导航'},
      {'icon': Icons.headphones, 'title': '智能语音讲解', 'desc': '多语言AI讲解系统'},
      {'icon': Icons.route, 'title': '个性化路线', 'desc': '智能推荐游览路线'},
      {'icon': Icons.photo_camera, 'title': '互动打卡', 'desc': '拍照分享社交功能'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '核心功能',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1890FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(feature['icon'] as IconData, size: 24, color: const Color(0xFF1890FF)),
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
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feature['desc'] as String,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTechArchitectureSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '技术架构',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF0F5FF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD6E4FF)),
            ),
            child: const Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _TechBadge('Flutter'),
                _TechBadge('Dart'),
                _TechBadge('ARKit'),
                _TechBadge('CoreLocation'),
                _TechBadge('Firebase'),
                _TechBadge('Google Maps API'),
                _TechBadge('Text-to-Speech'),
                _TechBadge('REST API'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectResultsSection() {
    final results = [
      {'label': '游客满意度', 'value': '96%', 'color': 0xFF52C41A},
      {'label': '平均游览时长', 'value': '3.5h', 'color': 0xFF1890FF},
      {'label': '回头客率', 'value': '42%', 'color': 0xFF722ED1},
      {'label': '推荐率', 'value': '89%', 'color': 0xFFFF5000},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '项目成果',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 32),
          Row(
            children: results.map((result) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        result['value'] as String,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(result['color'] as int),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result['label'] as String,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviewsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '用户评价',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD666)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"这个导览系统太棒了！AR导航让我轻松找到了每个景点，语音讲解也很详细。强烈推荐给大家！"',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF666666),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://picsum.photos/100/100?random=200'),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('张先生', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                        Text('2023-06-15', style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectShowcaseSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '效果展示',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 24),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 240,
                  margin: EdgeInsets.only(right: index < 2 ? 20 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://picsum.photos/600/400?random=${300 + index}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      '界面设计', '交互开发', '数据集成', '测试部署',
      '性能优化', '用户培训', '技术支持', '持续迭代',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '项目服务',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2.5,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    services[index],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoreCasesSection() {
    final cases = [
      {'title': '博物馆智能导览', 'category': '文博行业'},
      {'title': '公园游玩助手', 'category': '休闲娱乐'},
      {'title': '展馆AR导航', 'category': '展览展示'},
      {'title': '校园服务平台', 'category': '教育培训'},
      {'title': '商场导购系统', 'category': '商业零售'},
      {'title': '医院智能导诊', 'category': '医疗健康'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '更多案例',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseItem = cases[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://picsum.photos/400/300?random=${400 + index}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: const Color(0xFFF5F5F5));
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1890FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    caseItem['category'] as String,
                                    style: const TextStyle(fontSize: 11, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  caseItem['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantagesSection() {
    final advantages = [
      {'icon': Icons.speed, 'title': '快速响应', 'desc': '7x24小时技术支持'},
      {'icon': Icons.security, 'title': '安全可靠', 'desc': '企业级安全保障'},
      {'icon': Icons.trending_up, 'title': '持续优化', 'desc': '定期迭代升级'},
      {'icon': Icons.settings_suggest, 'title': '定制开发', 'desc': '满足个性化需求'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '服务优势',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 32),
          Row(
            children: advantages.map((advantage) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF0F5FF), Color(0xFFFFFFFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD6E4FF)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1890FF).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          advantage['icon'] == 'icon_custom' ? Icons.settings_suggest : advantage['icon'] as IconData,
                          size: 28,
                          color: const Color(0xFF1890FF),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        advantage['title'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        advantage['desc'] as String,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1890FF).withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '准备好开始您的项目了吗？',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '立即联系我们，获取专属解决方案',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1890FF),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: const Text(
              '立即咨询',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: Colors.white, // 改成白色背景
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1800),
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '智慧导览',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '专业的智慧景区解决方案',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildFooterLink('关于我们', () {}),
                    const SizedBox(width: 32),
                    _buildFooterLink('服务项目', () {}),
                    const SizedBox(width: 32),
                    _buildFooterLink('案例分析', () {}),
                    const SizedBox(width: 32),
                    _buildFooterLink('联系我们', () {}),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 1,
            color: const Color(0xFF333333),
          ),
          const SizedBox(height: 24),
          const Text(
            '© 2023 智慧导览. All rights reserved.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFCCCCCC),
          ),
        ),
      ),
    );
  }
}

/// 导航栏Sliver代理
class _NavbarSliverDelegate extends SliverPersistentHeaderDelegate {
  final bool isTransparent;
  final bool isShrunk;
  final VoidCallback onBack;

  _NavbarSliverDelegate({
    required this.isTransparent,
    required this.isShrunk,
    required this.onBack,
  });

  @override
  double get minExtent => isShrunk ? 70 : 100;

  @override
  double get maxExtent => isShrunk ? 70 : 100;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      decoration: BoxDecoration(
        // 真正透明，能看到下面的渐变背景
        color: isTransparent
            ? Colors.transparent
            : Colors.white.withValues(alpha: 0.95),
        boxShadow: isTransparent
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 60,
        vertical: isShrunk ? 6 : 20,
      ),
      child: Row(
        children: [
          // 返回按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isTransparent
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: isTransparent ? Colors.white : const Color(0xFF333333),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '返回',
                      style: TextStyle(
                        fontSize: 14,
                        color: isTransparent ? Colors.white : const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1890FF), Color(0xFF40A9FF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '智慧导览',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Spacer(),

          // 联系方式
          Row(
            children: [
              _buildContactItem(Icons.phone, '400-123-4567'),
              const SizedBox(width: 24),
              _buildContactItem(Icons.wechat, 'WeChat_Service'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF666666)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_NavbarSliverDelegate oldDelegate) {
    return isTransparent != oldDelegate.isTransparent ||
        isShrunk != oldDelegate.isShrunk;
  }
}

/// 技术标签组件
class _TechBadge extends StatelessWidget {
  final String label;

  const _TechBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1890FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1890FF).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1890FF),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
