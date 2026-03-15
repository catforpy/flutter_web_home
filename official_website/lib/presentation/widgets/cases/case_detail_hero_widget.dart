import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import '../../routes/app_router.dart';

/// 案例详情页顶部Hero组件
/// 专用于各种案例详情页
/// 包含：导航栏 + 模糊背景图区域（70%屏幕高度）+ 标题 + 动态开关按钮 + 数据展示
class CaseDetailHeroWidget extends StatelessWidget {
  /// 背景图URL
  final String backgroundImageUrl;

  const CaseDetailHeroWidget({
    super.key,
    required this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.7; // 70%屏幕高度

    return Column(
      children: [
        // 上半部分：固定高度的背景图区域（Stack布局）
        SizedBox(
          height: heroHeight + 30, // 背景图高度 + 过渡区域可见高度
          child: Stack(
            children: [
              // 背景图区域（高斯模糊）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Image.network(
                    backgroundImageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 1920,
                    cacheHeight: 800,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        ),
                      );
                    },
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
              ),

              // 导航栏（包含Logo + 导航菜单）
              const Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: _NavigationBar(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Image.network(
                    backgroundImageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 1920,
                    cacheHeight: 800,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        ),
                      );
                    },
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
              ),

              // 标题和按钮（靠左，左右布局）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: const Padding(
                  padding: EdgeInsets.only(left: 80),
                  child: Row(
                    children: [
                      // 左侧：标题Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 主标题
                          Text(
                            '都达网络科技',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),

                          SizedBox(height: 16),

                          // 副标题 + 动态开关按钮
                          Row(
                            children: [
                              // 副标题
                              Text(
                                'CASE SHOW',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),

                              SizedBox(width: 20),

                              // 动态开关按钮
                              _StartButton(size: 40),
                            ],
                          ),
                        ],
                      ),

                      Spacer(),

                      // 右侧：数据展示
                      Padding(
                        padding: EdgeInsets.only(right: 80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 访客停留时长
                            Row(
                              children: [
                                Text(
                                  '访客停留时长',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '375',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 12),

                            // 有效转化率
                            Row(
                              children: [
                                Text(
                                  '有效转化率',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '556',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 过渡区域（向上叠加到背景图底部）
              Positioned(
                top: heroHeight - 50, // 位置 = 背景图高度 - 50px（向上叠加）
                left: 0,
                right: 0,
                height: 80, // 过渡区域高度
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent, // 顶部透明
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.6),
                        Colors.white, // 底部背景色
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 下半部分：白色背景框（高度自适应内容）
        Container(
          margin: const EdgeInsets.only(left: 80, right: 80),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 项目标题区
                const _ProjectHeader(
                  year: '2020年',
                  city: '无锡',
                  viewCount: 4353,
                ),

                const SizedBox(height: 32),

                // 项目简介
                const _ProjectIntro(),

                const SizedBox(height: 32),

                // 图片列表（动态数据）
                _ImageList(images: _getSampleImages()),

                const SizedBox(height: 24),

                // 版权声明
                const Text(
                  '上述图文素材所有权及解释权归客户所有，上述案例制作分享、展示和陈述，不做为商业推广目的。',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 动态开关按钮组件
class _StartButton extends StatefulWidget {
  final double size; // 按钮大小

  const _StartButton({this.size = 80});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: 点击按钮后的操作
          debugPrint('点击了开始按钮');
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD93025), // 红色背景
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD93025).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 绘制的三角形（底层）
              CustomPaint(
                size: Size(widget.size * 0.5, widget.size * 0.5),
                painter: _TrianglePainter(),
              ),

              // 白色渐变圆环（顶层，旋转）
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.5),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        ),
                      ),
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
}

/// 绘制三角形的 Painter
class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // 绘制等边三角形
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final triangleSize = size.width * 0.5;

    // 三角形顶点（朝右）
    final p1 = Offset(centerX + triangleSize * 0.6, centerY); // 右顶点
    final p2 = Offset(centerX - triangleSize * 0.5, centerY - triangleSize * 0.5); // 左上
    final p3 = Offset(centerX - triangleSize * 0.5, centerY + triangleSize * 0.5); // 左下

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 项目标题区组件
class _ProjectHeader extends StatelessWidget {
  final String year;
  final String city;
  final int viewCount;

  const _ProjectHeader({
    required this.year,
    required this.city,
    required this.viewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧：图标 + 年份城市
        Row(
          children: [
            // 6个小圆点组成的网格图标
            _buildGridIcon(),

            const SizedBox(width: 12),

            // 年份和城市
            Text(
              '$year - $city',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),

        // 右侧：浏览热度
        Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 16,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              '浏览热度：$viewCount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建6个小圆点组成的网格图标
  Widget _buildGridIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 第一行3个点
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFD93025),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // 第二行3个点
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFD93025),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 项目简介组件
class _ProjectIntro extends StatelessWidget {
  const _ProjectIntro();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Text(
          '项目简介',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),

        SizedBox(height: 16),

        // 内容
        Text(
          '销售难？开口难？成交更难？唐极课得专为解决销售一线难题而生！\n'
          '作为一个专业的销售视频课程销售平台，唐极课得不卖空洞理论，只交付能拿结果的实战视频。这里汇集了全网最优质的销售教学视频：从如何破冰开场，到如何处理价格异议，再到如何搞定关键决策人，每一个视频都是一个具体的解决方案。\n'
          '为什么选择唐极课得？\n'
          '真场景：所有课程基于真实业务场景拍摄，还原最真实的销售现场。\n'
          '超高效：碎片化视频学习，利用通勤、休息时间即可掌握一项核心技能。\n'
          '高性价比：相比线下昂贵的内训，在唐极课得只需极低成本即可获取全套销售秘籍。\n'
          '加入唐极课得，让您的销售团队拥有随时随地的"私人教练"，用视频驱动业绩翻倍！',
          style: TextStyle(
            fontSize: 16,
            height: 1.8,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

/// 图片列表组件（动态数据）
class _ImageList extends StatelessWidget {
  final List<String> images;

  const _ImageList({required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: images.map((imagePath) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 获取示例图片数据（后续从后端API获取）
List<String> _getSampleImages() {
  return [
    'assets/data-science.png',
    // 后续可以添加更多图片
    // 'assets/image2.png',
    // 'assets/image3.png',
  ];
}

/// 导航栏组件（管理悬停状态）
class _NavigationBar extends StatefulWidget {
  const _NavigationBar();

  @override
  State<_NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<_NavigationBar> {
  bool _isDropdownHovered = false;
  Timer? _closeTimer;

  /// 取消关闭定时器
  void _cancelCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  /// 启动关闭定时器
  void _startCloseTimer() {
    _cancelCloseTimer();
    _closeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isDropdownHovered = false);
      }
    });
  }

  /// 构建Logo
  Widget _buildLogo(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => AppRouter.goToHome(context),
        child: Image.network(
          'https://fuyin15190311094.oss-cn-beijing.aliyuncs.com/%E9%83%BD%E8%BE%BE_108_108.png',
          height: 48,
          width: 48,
          fit: BoxFit.contain,
          cacheWidth: 200,
          cacheHeight: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '都达',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF3B30),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 导航栏区域 + 下拉菜单（统一管理鼠标事件）
        MouseRegion(
          onExit: (_) => _startCloseTimer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                decoration: BoxDecoration(
                  color: _isDropdownHovered ? Colors.white : Colors.transparent,
                ),
                child: Row(
                  children: [
                    // Logo（左侧）
                    _buildLogo(context),

                    const Spacer(),

                    // 导航菜单（居中）
                    Wrap(
                      spacing: 24,
                      children: [
                        _NavLink(
                          label: '定制服务',
                          isDarkMode: !_isDropdownHovered,
                          onTap: () => AppRouter.goToServe(context),
                        ),
                        _NavSeparator(isDarkMode: !_isDropdownHovered),
                        _NavLink(
                          label: '解决方案',
                          isDarkMode: !_isDropdownHovered,
                          onTap: () => AppRouter.goToSolutions(context),
                        ),
                        _NavSeparator(isDarkMode: !_isDropdownHovered),
                        _NavLink(
                          label: '案例',
                          isDarkMode: !_isDropdownHovered,
                          onTap: () => AppRouter.goToCases(context),
                        ),
                        _NavSeparator(isDarkMode: !_isDropdownHovered),
                        _AboutDropdownTrigger(
                          isHovered: _isDropdownHovered,
                          isDarkMode: !_isDropdownHovered,
                          onEnter: (_) => setState(() => _isDropdownHovered = true),
                        ),
                        _NavSeparator(isDarkMode: !_isDropdownHovered),
                        _NavLink(
                          label: '联系',
                          isDarkMode: !_isDropdownHovered,
                          onTap: () => AppRouter.goToContact(context),
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),

              // 下拉菜单区域（全宽白色背景）
              if (_isDropdownHovered)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 第1列：我们 + 副标题 + 了解更多
                      Expanded(
                        child: _AboutSection(
                          onLearnMore: () => AppRouter.goToAbout(context),
                        ),
                      ),

                      // 第2列：了解我们分组
                      Expanded(
                        child: _MenuGroup(
                          title: '了解我们',
                          items: [
                            _MenuItem(
                              title: '我们是谁？',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                            _MenuItem(
                              title: '优势亮点',
                              tag: '亮点',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                            _MenuItem(
                              title: '资质荣誉',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                            _MenuItem(
                              title: '发展历程',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                          ],
                        ),
                      ),

                      // 第3列：客户心声分组
                      Expanded(
                        child: _MenuGroup(
                          title: '客户心声',
                          items: [
                            _MenuItem(
                              title: '合作流程',
                              onTap: () => AppRouter.goToCooperation(context),
                            ),
                            _MenuItem(
                              title: '客户评价',
                              tag: '口碑',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                            _MenuItem(
                              title: '服务保障',
                              onTap: () => AppRouter.goToContact(context),
                            ),
                          ],
                        ),
                      ),

                      // 第4列：图片
                      const Expanded(
                        child: _MenuImage(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 导航链接组件
class _NavLink extends StatelessWidget {
  final String label;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// 导航分隔符（竖线）
class _NavSeparator extends StatelessWidget {
  final bool isDarkMode;

  const _NavSeparator({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      '|',
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

/// "我们"下拉菜单触发器
class _AboutDropdownTrigger extends StatelessWidget {
  final bool isHovered;
  final bool isDarkMode;
  final Function(PointerEnterEvent) onEnter;

  const _AboutDropdownTrigger({
    required this.isHovered,
    required this.isDarkMode,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      cursor: SystemMouseCursors.click,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '我们',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isHovered ? Icons.expand_more : Icons.keyboard_arrow_down,
            size: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}

/// 下拉菜单项
class _DropdownMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DropdownMenuItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}

/// 第1列：我们区域
class _AboutSection extends StatelessWidget {
  final VoidCallback onLearnMore;

  const _AboutSection({
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 大标题"我们"
        const Text(
          '我们',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),

        const SizedBox(height: 8),

        // 副标题（空）
        const SizedBox(height: 20),

        const SizedBox(height: 24),

        // 了解更多（红色）
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onLearnMore,
            child: const Row(
              children: [
                Text(
                  '了解更多',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD93025),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '→',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD93025),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 菜单分组
class _MenuGroup extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuGroup({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 分组标题
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),

        const SizedBox(height: 16),

        // 子项列表
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      ],
    );
  }
}

/// 菜单项
class _MenuItem extends StatelessWidget {
  final String title;
  final String? tag;
  final VoidCallback onTap;

  const _MenuItem({
    required this.title,
    this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            if (tag != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  tag!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 菜单图片
class _MenuImage extends StatelessWidget {
  const _MenuImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        'https://picsum.photos/400/300?random=201',
        width: double.infinity,
        fit: BoxFit.cover,
        cacheWidth: 600,
        cacheHeight: 400,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.business, size: 48, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

