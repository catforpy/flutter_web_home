import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

/// 首页Hero轮播组件
/// 支持视频和图片轮播，视频自动播放结束后切换到图片
/// 图片显示指定时间后切换回视频，视频从头开始播放
class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key});

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel>
    with TickerProviderStateMixin {
  // PageController用于控制页面切换
  late PageController _pageController;

  // 当前显示的页面索引
  int _currentPage = 0;

  // HTML5 video元素（用于Web平台自动播放）
  html.VideoElement? _htmlVideoElement;
  String? _videoViewId;

  // 图片显示定时器
  Timer? _imageTimer;

  // 轮播项列表
  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      type: CarouselItemType.video,
      videoUrl: 'https://fuyin15190311094.oss-cn-beijing.aliyuncs.com/home_hero_video.mp4',
    ),
    CarouselItem(
      type: CarouselItemType.image,
      imagePath: 'assets/联系.png',
    ),
  ];

  // 图片显示时长（秒）
  final int _imageDisplayDuration = 10;

  // 是否已经初始化
  bool _isInitialized = false;

  // Widget是否在树中（用于判断页面是否切换）
  bool _isWidgetInTree = true;

  // 是否静音（默认静音以支持自动播放）
  bool _isMuted = true;

  // 广告语动画控制器
  late AnimationController _sloganAnimationController;
  late Animation<Offset> _sloganSlideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 初始化广告语滑入动画
    _sloganAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _sloganSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // 从下方50%的位置开始
      end: Offset.zero, // 滑动到正常位置
    ).animate(CurvedAnimation(
      parent: _sloganAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _initializeHtml5Video();
    _isInitialized = true;

    // 延迟启动动画，等待视频加载
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _sloganAnimationController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听路由变化，判断页面是否切换
    _isWidgetInTree = true;
  }

  @override
  void deactivate() {
    // Widget从树中移除时（页面切换）
    _isWidgetInTree = false;
    _stopVideo();
    super.deactivate();
  }

  @override
  void activate() {
    // Widget重新激活时（页面切回）
    _isWidgetInTree = true;
    if (_currentPage == 0) {
      // 重新播放HTML5 video
      _htmlVideoElement?.play().catchError((e) {
        debugPrint('重新播放失败: $e');
      });
    }
    super.activate();
  }

  /// 初始化HTML5 video元素（支持自动播放）
  void _initializeHtml5Video() {
    _videoViewId = 'video-player-${DateTime.now().millisecondsSinceEpoch}';

    // 创建video元素
    _htmlVideoElement = html.VideoElement()
      ..id = _videoViewId!
      ..src = _carouselItems[0].videoUrl!
      ..autoplay = true  // 自动播放
      ..muted = true    // 静音（允许自动播放）
      ..setAttribute('playsinline', 'true')  // 在移动设备内联播放
      ..controls = false // 不显示控制条
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.position = 'absolute'
      ..style.top = '0'
      ..style.left = '0';

    // 监听视频结束事件
    _htmlVideoElement!.onEnded.listen((_) {
      debugPrint('HTML5视频播放结束');
      if (mounted && _currentPage == 0) {
        _nextPage();
      }
    });

    // 监听播放错误
    _htmlVideoElement!.onError.listen((_) {
      debugPrint('HTML5视频播放错误');
      if (mounted && _currentPage == 0) {
        Future.delayed(const Duration(seconds: 2), () {
          _jumpToImageIfTimeout();
        });
      }
    });

    // 监听播放开始
    _htmlVideoElement!.onPlay.listen((_) {
      debugPrint('HTML5视频开始播放');
    });

    // 注册到Flutter
    ui_web.platformViewRegistry.registerViewFactory(
      _videoViewId!,
      (viewId) => _htmlVideoElement!,
    );

    debugPrint('HTML5 video元素初始化完成');
  }

  /// 跳转到图片页
  void _jumpToImageIfTimeout() {
    if (mounted && _carouselItems.length > 1) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 视频播放监听器
  void _videoListener() {
    // 不需要了，HTML5 video使用事件监听
  }

  /// 切换到下一页
  void _nextPage() {
    if (!_isWidgetInTree) return;

    if (_currentPage < _carouselItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // 最后一页切换回第一页（视频）
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 开始图片显示计时器
  void _startImageTimer() {
    _imageTimer?.cancel();
    _imageTimer = Timer(Duration(seconds: _imageDisplayDuration), () {
      if (_currentPage == _carouselItems.length - 1 && _isWidgetInTree) {
        // 图片显示时间到，切换回视频
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// 停止图片计时器
  void _stopImageTimer() {
    _imageTimer?.cancel();
    _imageTimer = null;
  }

  /// 停止视频播放（不是暂停）
  void _stopVideo() {
    // 停止HTML5 video
    if (_htmlVideoElement != null) {
      _htmlVideoElement!.pause();
      _htmlVideoElement!.currentTime = 0;
    }
  }

  /// 切换静音状态
  void _toggleMute() {
    if (_htmlVideoElement == null) return;

    setState(() {
      _isMuted = !_isMuted;
      _htmlVideoElement!.muted = _isMuted;
    });

    debugPrint('静音状态: ${_isMuted ? "静音" : "有声"}');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stopImageTimer();
    _stopVideo();
    _sloganAnimationController.dispose();

    // 清理HTML5 video元素
    _htmlVideoElement?.remove();
    _htmlVideoElement = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  '视频加载中...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // 监听滚动事件，当轮播组件滑出屏幕时停止视频
        if (scrollNotification is ScrollUpdateNotification) {
          final metrics = scrollNotification.metrics;
          final screenHeight = MediaQuery.of(context).size.height;

          // 判断轮播组件是否在可见区域
          final isVisible = metrics.pixels < screenHeight;

          if (!isVisible && _currentPage == 0) {
            _stopVideo();
          } else if (isVisible && _currentPage == 0 && _htmlVideoElement != null) {
            // 如果视频没有在播放，则重新播放
            if (_htmlVideoElement!.paused) {
              _htmlVideoElement!.play().catchError((e) {
                debugPrint('重新播放失败: $e');
              });
            }
          }
        }
        return false;
      },
      child: Stack(
        children: [
          // 轮播图主体 - 完全满屏
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                if (!mounted) return;

                setState(() {
                  _currentPage = index;
                });

                if (index == 0) {
                  // 切换到视频页，停止图片计时器
                  _stopImageTimer();
                  // 重置并播放视频
                  if (_htmlVideoElement != null) {
                    _htmlVideoElement!.currentTime = 0;
                    _htmlVideoElement!.play().catchError((e) {
                      debugPrint('视频播放失败: $e');
                    });
                  }
                } else {
                  // 切换到图片页，停止视频，开始图片计时器
                  _stopVideo();
                  _startImageTimer();
                }
              },
              itemCount: _carouselItems.length,
              itemBuilder: (context, index) {
                return _buildCarouselItem(_carouselItems[index]);
              },
            ),
          ),

          // 底部指示器 - "..."小圆点
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: _buildIndicators(),
          ),
        ],
      ),
    );
  }

  /// 构建指示器 - 小圆点
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _carouselItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentPage == index ? 24 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建轮播项
  Widget _buildCarouselItem(CarouselItem item) {
    switch (item.type) {
      case CarouselItemType.video:
        final url = item.videoUrl ?? item.videoPath;
        if (url == null) {
          debugPrint('错误：视频URL为空');
          return const SizedBox.shrink();
        }
        return _buildVideoItem(url);
      case CarouselItemType.image:
        if (item.imagePath == null) {
          debugPrint('错误：图片路径为空');
          return const SizedBox.shrink();
        }
        return _buildImageItem(item.imagePath!);
    }
  }

  /// 构建视频项 - 使用HTML5 video元素（支持自动播放）
  Widget _buildVideoItem(String videoPath) {
    if (_htmlVideoElement == null || _videoViewId == null) {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  '视频加载中...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // HTML5 Video元素
          Positioned.fill(
            child: HtmlElementView(
              viewType: _videoViewId!,
            ),
          ),

          // 右上角音量控制按钮
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _toggleMute,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // 广告语悬浮层 - 从下向上滑入，垂直居中
          Positioned(
            left: 80,
            top: MediaQuery.of(context).size.height / 2 - 100, // 垂直居中
            child: SlideTransition(
              position: _sloganSlideAnimation,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 第一行 - 大标题（放大）
                    Text(
                      '以诚为本',
                      style: TextStyle(
                        fontSize: 96, // 从64增大到96
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 2, // 增加字间距
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.7),
                            blurRadius: 25,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 第二行 - 副标题（放大）
                    Text(
                      '匠心服务，笃定前行',
                      style: TextStyle(
                        fontSize: 42, // 从32增大到42
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 18,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 第三行 - 描述（放大）
                    Text(
                      '都达网，用心做好每一个小程序',
                      style: TextStyle(
                        fontSize: 32, // 从24增大到32
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.5,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 15,
                            offset: const Offset(1.5, 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图片项 - 完全满屏
  Widget _buildImageItem(String imagePath) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, size: 48, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}

/// 轮播项数据模型
class CarouselItem {
  final CarouselItemType type;
  final String? videoPath;        // 本地视频路径（已废弃）
  final String? videoUrl;         // 网络视频URL
  final String? imagePath;

  CarouselItem({
    required this.type,
    this.videoPath,
    this.videoUrl,
    this.imagePath,
  });
}

/// 轮播项类型枚举
enum CarouselItemType {
  video,
  image,
}
