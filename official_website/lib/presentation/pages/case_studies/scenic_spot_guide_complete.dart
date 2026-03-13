import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:official_website/presentation/widgets/workbench/register_mini_program_dialog.dart';
import 'package:official_website/domain/models/mini_program_registration.dart';

/// 智慧景区导览 - 完整实现版本
///
/// 使用 CustomScrollView + Sliver 架构
/// 实现所有原始需求：导航栏滚动效果、sticky侧边栏、渐变背景等
class ScenicSpotGuideComplete extends StatefulWidget {
  const ScenicSpotGuideComplete({super.key});

  @override
  State<ScenicSpotGuideComplete> createState() => _ScenicSpotGuideCompleteState();
}

class _ScenicSpotGuideCompleteState extends State<ScenicSpotGuideComplete> with TickerProviderStateMixin {
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

  // 右侧卡片区域的粘滞动画状态
  double _rightSidebarOffset = 0.0;

  // GlobalKey用于获取实际的渲染位置
  final GlobalKey _mainContentKey = GlobalKey();
  final GlobalKey _rightCardKey = GlobalKey();

  // 阶段2锁定状态（避免动效抖动）
  bool _isStage2Locked = false;
  double _lockedSidebarOffset = 0.0;

  // 是否已初始化
  bool _isInitialized = false;

  // 滚动简介动画相关
  late AnimationController _scrollingBioController;
  late AnimationController _titleSlideController;
  late Animation<double> _titleSlideAnimation;

  // 轮播图相关
  int _currentCarouselIndex = 0;

  // 注册小程序弹窗控制
  bool _showRegisterDialog = false;

  final List<MediaItem> _carouselItems = [
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/1400/800?random=101',
      title: '智慧景区导览 - 首页效果',
    ),
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/1400/800?random=102',
      title: '地图导航功能展示',
    ),
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/1400/800?random=103',
      title: '语音讲解功能',
    ),
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/1400/800?random=104',
      title: 'AR导览体验',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 初始化滚动简介动画
    _scrollingBioController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // 初始化标题和数据卡片的向上移动动画（100rpx ≈ 33px）
    _titleSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _titleSlideAnimation = Tween<double>(
      begin: 0.0,
      end: -300.0, // 向上移动100px
    ).animate(CurvedAnimation(
      parent: _titleSlideController,
      curve: Curves.easeInOut,
    ));

    // 延迟初始化右侧卡片位置（等待widget完全build后）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRightSidebarPosition();
    });

    // 延迟启动数字动画和标题滑动动画
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animateNumbers();
        _titleSlideController.forward();
      }
    });
  }

  // 初始化右侧卡片位置 - 让它和主内容区域对齐
  void _initializeRightSidebarPosition() {
    final RenderBox? mainContentBox = _mainContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (mainContentBox != null && mounted) {
      final double mainContentScreenPosition = mainContentBox.localToGlobal(Offset.zero).dy;

      // 计算让右侧卡片和主内容区域对齐的offset
      // 右侧卡片top = 100 + _rightSidebarOffset
      // 主内容top + 60 = mainContentScreenPosition + 60
      // 要对齐：100 + _rightSidebarOffset = mainContentScreenPosition + 60
      // _rightSidebarOffset = mainContentScreenPosition - 40
      final double initialOffset = mainContentScreenPosition - 40.0;

      setState(() {
        _rightSidebarOffset = initialOffset;
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollingBioController.dispose();
    _titleSlideController.dispose();
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

      // 右侧卡片的粘滞动画逻辑（右侧卡片现在在外层Stack）
      const double navbarHeight = 100.0; // 导航栏高度
      const double screenHeight = 900.0; // 屏幕高度
      const double mainContentHeight = 7000.0; // 主内容高度

      // 获取主内容区域的实际渲染坐标（用于阶段判断）
      final RenderBox? mainContentBox = _mainContentKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? rightCardBox = _rightCardKey.currentContext?.findRenderObject() as RenderBox?;

      if (mainContentBox != null && rightCardBox != null) {
        final double mainContentScreenPosition = mainContentBox.localToGlobal(Offset.zero).dy;
        final double mainContentActualHeight = mainContentBox.size.height;
        final double rightCardHeight = rightCardBox.size.height;

        // 计算主内容区域底部的屏幕位置
        final double mainContentBottomFromScreenTop = mainContentScreenPosition + mainContentActualHeight;

        // 定义阶段判断条件
        final bool shouldStage1 = mainContentScreenPosition > navbarHeight;
        final bool shouldStage3 = mainContentBottomFromScreenTop < screenHeight;

        // 计算目标offset
        double targetOffset;
        if (shouldStage1) {
          // 阶段1: 计算目标offset
          targetOffset = mainContentScreenPosition - 40.0;
          _isStage2Locked = false;
        } else if (shouldStage3) {
          // 阶段3: 底部对齐
          targetOffset = mainContentBottomFromScreenTop - navbarHeight - rightCardHeight;
          _isStage2Locked = false;
        } else {
          // 阶段2: 吸顶固定
          targetOffset = 0.0;
          _isStage2Locked = true;
        }

        // 直接设置offset，不使用平滑动画
        _rightSidebarOffset = targetOffset;
      }

      _lastScrollOffset = offset;

      // 获取实际的渲染坐标
      if (offset.toInt() % 100 == 0 && offset > 0) {
        // 获取主内容区域的实际位置
        final RenderBox? mainContentBox = _mainContentKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? rightCardBox = _rightCardKey.currentContext?.findRenderObject() as RenderBox?;

        if (mainContentBox != null && rightCardBox != null) {
          // 获取相对于屏幕的实际位置
          final mainContentPosition = mainContentBox.localToGlobal(Offset.zero);
          final rightCardPosition = rightCardBox.localToGlobal(Offset.zero);

          // 计算Positioned的top值
          final double rightCardTopInStack = 60.0 + _rightSidebarOffset;
          final double mainContentScreenPosition = mainContentPosition.dy;
          final double mainContentBottomPosition = mainContentScreenPosition + mainContentHeight;

          // 判断阶段
          final String stage;
          if (mainContentScreenPosition > navbarHeight) {
            stage = "1(跟随)";
          } else if (mainContentBottomPosition < screenHeight) {
            stage = "3(底部对齐)";
          } else {
            stage = "2(吸顶-固定)";
          }
        }
      }
    });
  }

  void _animateNumbers() {
    setState(() {
      _visitorTimeValue = 185;
      _conversionRateValue = 68.5;
    });
  }

  // 判断是否应该显示右侧卡片
  bool _shouldShowRightSidebar() {
    // 初始状态不显示，只有滚动后才显示
    // 使用scroll offset判断，避免在build时查询RenderObject
    if (_scrollController.hasClients) {
      final double offset = _scrollController.offset;
      // 当滚动超过一定距离后才显示右侧卡片
      // 例如：滚动超过150px后显示
      return offset > 150.0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // === 底层：全屏背景图片 + 高斯模糊 + 底部白色渐变 ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // 背景图片
                  Positioned.fill(
                    child: Image.asset(
                      'assets/284a0007c2c9e73207ff885f70fa4c40.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
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
                        );
                      },
                    ),
                  ),

                  // 强高斯模糊层
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),

                  // 底部渐变到白色
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.7),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === 右侧卡片（独立于CustomScrollView，实现真正的fixed效果）===
          // 只有当主内容区域接近/进入屏幕时才显示
          if (_shouldShowRightSidebar())
            Positioned(
              key: _rightCardKey,
              right: 60, // 和主内容区域的padding一致
              top: 100 + _rightSidebarOffset, // 导航栏高度 + 动态offset
              child: _buildRightSidebarCard(context),
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
                        // 左侧标题 + 滚动简介
                        Expanded(
                          flex: 3,
                          child: AnimatedBuilder(
                            animation: _titleSlideAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _titleSlideAnimation.value),
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
                                    const SizedBox(height: 24),
                                    // 滚动简介区域
                                    _buildScrollingBio(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 40),

                        // 右侧统计卡片（也要向上移动）
                        AnimatedBuilder(
                          animation: _titleSlideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _titleSlideAnimation.value),
                              child: _buildStatisticsCard(),
                            );
                          },
                        ),
                  ],
                ),
                  ),
                ),
              ),

              // 4. 主内容区 + 右侧卡片区域（使用Stack分层）
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: SizedBox(
                      // 指定高度，让Stack有边界
                      height: 8000, // 预估高度，包含主内容区和侧边栏
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 层1: 主内容区域（右侧留空 470px = 450px卡片 + 20px gap）
                          Positioned(
                            left: 0,
                            right: 470, // 右侧留空
                            top: 0,
                            bottom: 0,
                            child: Container(
                              key: _mainContentKey,
                              margin: const EdgeInsets.only(top: 60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  _buildCaseImageSection(),
                                  _buildProjectIntroSection(),
                                  _buildCoreFeaturesSection(),
                                  _buildTechArchitectureSection(),
                                  _buildProjectResultsSection(),
                                  _buildUserReviewsSection(),
                                  _buildEffectShowcaseSection(),
                                  _buildMoreCasesSection(),
                                  _buildAdvantagesSection(),
                                  _buildCTASection(),
                                  _buildFooterSection(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 注册小程序弹窗
          if (_showRegisterDialog)
            RegisterMiniProgramDialog(
              onRegistrationComplete: (registration) {
                setState(() {
                  _showRegisterDialog = false;
                });
                // TODO: 处理注册完成后的逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('小程序注册成功！'),
                    backgroundColor: Color(0xFF52C41A),
                  ),
                );
              },
              onClose: () {
                setState(() {
                  _showRegisterDialog = false;
                });
              },
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
            fontSize: 32, // 和Case Show一样大
            fontWeight: FontWeight.w300,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
              style: const TextStyle(
                fontSize: 64, // 比智慧景区导览(72px)小一点
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
                  fontSize: 24, // 相应变大
                  fontWeight: FontWeight.w300,
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

  /// 构建右侧卡片（一个完整的白色卡片，包含所有内容）
  Widget _buildRightSidebarCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 450,
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
        padding: const EdgeInsets.all(20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 项目服务部分
          Text(
            '项目服务',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ...[
            '原创视觉设计',
            '交互体验优化',
            '响应式布局',
            '性能优化',
            '数据可视化',
            '智能推荐算法',
            '实时位置服务',
            '多端适配',
          ].map((item) => Padding(
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

          const SizedBox(height: 24),

          // 探索更多部分
          Text(
            '我想做',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildExploreButton('查看', Icons.article_outlined, onTap: () {
            print('点击了查看按钮');
            _showQRCodeDialog(context);
          }),
          const SizedBox(height: 12),
          _buildExploreButton('关注', Icons.code_outlined),
          const SizedBox(height: 12),
          _buildExploreButton('项目入厅', Icons.contact_phone_outlined),
          const SizedBox(height: 12),
          _buildExploreButton('我想购买', Icons.shopping_cart_outlined, onTap: () {
            print('点击了我想购买按钮');
            setState(() {
              _showRegisterDialog = true;
            });
          }),

          const SizedBox(height: 24),

          // 案例导航部分
          Container(
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
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildExploreButton(String label, IconData icon, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
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

  /// 显示二维码弹窗
  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 关闭按钮
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 二维码
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: QrImageView(
                    data: 'https://example.com/mini-program',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),

                const SizedBox(height: 20),

                // 提示文字
                const Text(
                  '扫描二维码查看小程序详情',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          // 轮播图展示
          Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 500,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                ),
                items: _carouselItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // 内容
                              Positioned.fill(
                                child: item.type == MediaType.video
                                    ? const Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Image.network(
                                        item.url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.withValues(alpha: 0.2),
                                            child: const Center(
                                              child: Icon(Icons.error, size: 48, color: Colors.grey),
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              // 标题标签
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 轮播指示器
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _carouselItems.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == entry.key
                          ? const Color(0xFF1890FF)
                          : const Color(0xFFE0E0E0),
                    ),
                  );
                }).toList(),
              ),
            ],
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

  /// 滚动简介组件（类似歌词滚动）
  Widget _buildScrollingBio() {
    // 简介文本内容
    const String bioText = '''本项目为某5A级景区打造的一站式智慧导览系统，通过AR技术、实时定位、智能推荐等创新功能，为游客提供沉浸式的游览体验。
系统采用先进的地理信息系统（GIS）和增强现实（AR）技术，结合大数据分析平台，实现了智能路径规划、实时语音讲解、AR场景重现、社交分享等核心功能。
智能路径规划：根据游客兴趣、时间、体力等因素，自动生成最优游览路线，避免拥堵，提升游览效率。
实时语音讲解：采用AI语音合成技术，为游客提供多语言、多风格的语音讲解服务，让文化历史更加生动。
AR场景重现：通过AR技术，将历史场景、文物故事以虚拟现实的方式呈现，让游客身临其境感受文化魅力。
社交分享功能：游客可以记录游览轨迹、分享精彩瞬间，与好友互动交流，增强游览的趣味性和传播力。
系统上线后，景区游客满意度提升45%，平均游览时长增加30分钟，有效转化率提升至68.5%，成为智慧旅游建设的标杆项目。
项目荣获"2022年度最佳智慧旅游解决方案"奖，被多家媒体报道，在全国范围内推广使用。
''';

    // 将文本分割成行
    final List<String> lines = bioText.split('\n');

    return ClipRect(
      child: SizedBox(
        height: 100, // 固定高度，显示2-3行
        child: AnimatedBuilder(
          animation: _scrollingBioController,
          builder: (context, child) {
            // 使用更平滑的动画曲线
            final double curvedValue = Curves.linear.transform(_scrollingBioController.value);
            final double scrollOffset = curvedValue * (lines.length * 42); // 总滚动距离

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Transform.translate(
                offset: Offset(0, -scrollOffset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 原始内容
                    ...lines.map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6), // 固定行间距
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    )),
                    // 重复一次内容实现无缝循环
                    ...lines.map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 自动换行：将长文本根据最大宽度分割成多行
  List<String> _wrapText(String text, {required double maxWidth}) {
    final TextStyle style = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w300,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    final List<String> lines = [];
    final List<String> words = text.split(''); // 按字符分割
    String currentLine = '';

    for (int i = 0; i < words.length; i++) {
      final String testLine = currentLine + words[i];
      textPainter.text = TextSpan(text: testLine, style: style);
      textPainter.layout();

      if (textPainter.width <= maxWidth) {
        currentLine = testLine;
      } else {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = words[i];
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
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

/// 媒体类型枚举
enum MediaType { image, video }

/// 媒体项
class MediaItem {
  final MediaType type;
  final String url;
  final String? thumbnail;
  final String title;

  MediaItem({
    required this.type,
    required this.url,
    this.thumbnail,
    required this.title,
  });
}
