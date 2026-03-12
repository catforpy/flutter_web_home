import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:official_website/presentation/pages/case_studies/scenic_spot_guide_complete.dart';

/// 服务详情页 - 展示小程序模版的详细信息
///
/// 展示形式：
/// 1. 轮播图（支持视频和图片）
/// 2. 图文混排
/// 3. 长图列表
/// 4. 纯文字说明
/// 5. 案例展示（智慧景区导览）
class ServiceDetailPage extends StatefulWidget {
  final String serviceId;
  final String title;
  final String providerName;

  const ServiceDetailPage({
    super.key,
    required this.serviceId,
    required this.title,
    required this.providerName,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage>
    with SingleTickerProviderStateMixin {
  // 选中的展示类型标签
  String _selectedDisplayType = '轮播展示';

  // 展示类型列表
  final List<String> _displayTypes = ['轮播展示', '图文介绍', '长图列表', '文字说明', '案例展示'];

  // 是否已关注
  bool _isFollowed = false;

  // 轮播图控制器
  int _currentCarouselIndex = 0;

  // 模拟轮播数据（支持视频和图片）
  final List<MediaItem> _carouselItems = [
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/800/600?random=1',
      title: '首页效果展示',
    ),
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/800/600?random=2',
      title: '功能页面展示',
    ),
    MediaItem(
      type: MediaType.video,
      url: 'https://www.w3schools.com/html/mov_bbb.mp4',
      thumbnail: 'https://picsum.photos/800/600?random=3',
      title: '操作演示视频',
    ),
    MediaItem(
      type: MediaType.image,
      url: 'https://picsum.photos/800/600?random=4',
      title: '组件细节展示',
    ),
  ];

  // 图文介绍数据
  final List<TextImageItem> _textImageItems = [
    TextImageItem(
      title: '产品概述',
      description: '这是一款功能完整的小程序模版，包含首页、列表页、详情页、个人中心等核心页面。UI设计简洁美观，交互流畅，适合各类企业快速搭建自己的小程序。',
      image: 'https://picsum.photos/600/400?random=10',
      imagePosition: ImagePosition.right,
    ),
    TextImageItem(
      title: '核心功能',
      description: '• 商品展示：支持多种布局方式\n'
                  '• 购物车：完整的购物车流程\n'
                  '• 订单管理：订单状态实时更新\n'
                  '• 用户中心：个人信息管理\n'
                  '• 优惠活动：优惠券、满减活动',
      image: 'https://picsum.photos/600/400?random=11',
      imagePosition: ImagePosition.left,
    ),
    TextImageItem(
      title: '技术特点',
      description: '• 采用最新的小程序开发框架\n'
                  '• 代码结构清晰，易于维护\n'
                  '• 支持自定义主题色\n'
                  '• 响应式设计，适配各种屏幕\n'
                  '• 性能优化，加载速度快',
      image: 'https://picsum.photos/600/400?random=12',
      imagePosition: ImagePosition.right,
    ),
  ];

  // 长图列表数据
  final List<LongImageItem> _longImageItems = [
    LongImageItem(
      title: '完整功能流程',
      image: 'https://picsum.photos/800/2000?random=20',
      description: '从首页到下单的完整流程展示',
    ),
    LongImageItem(
      title: 'UI组件库',
      image: 'https://picsum.photos/800/1800?random=21',
      description: '所有可用的UI组件预览',
    ),
  ];

  // 文字说明数据
  final String _textDescription = '''
# 产品介绍

这是一款功能完善的小程序模版，适用于电商、餐饮、服务等多个行业。

## 模版特点

### 1. 界面设计
- 简洁现代的UI风格
- 支持自定义主题色
- 响应式布局设计
- 流畅的动画效果

### 2. 功能模块
- 首页：轮播图、分类导航、推荐商品
- 列表页：多种筛选方式、瀑布流布局
- 详情页：图片轮播、规格选择、加入购物车
- 购物车：商品管理、数量调整、优惠券
- 订单页：订单列表、订单详情、物流跟踪
- 个人中心：个人信息、收货地址、我的收藏

### 3. 技术优势
- 代码结构清晰，易于二次开发
- 组件化开发，复用性高
- 性能优化，加载速度快
- 兼容性好，支持各种机型

### 4. 适用场景
- 电商零售
- 餐饮外卖
- 服务平台
- 社区团购
- 其他行业

## 使用说明

购买后即可获得完整的源代码，包含详细的使用文档和视频教程。支持二次开发，可根据实际需求进行功能定制。
''';

  @override
  Widget build(BuildContext context) {
    // 案例展示模式：直接全屏显示，不显示顶部栏和标签
    if (_selectedDisplayType == '案例展示') {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildCaseStudyContent(),
      );
    }

    // 其他展示模式：显示顶部栏和标签
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // 顶部操作栏 - 包含返回、分享等
          _buildTopAppBar(),

          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 展示类型切换标签
                  _buildDisplayTypeTabs(),

                  // 内容区域
                  _buildContentArea(),
                ],
              ),
            ),
          ),
        ],
      ),

      // === 方案1: 侧边悬浮按钮 ===
      floatingActionButton: _buildSideButtons(),

      // === 方案2: 顶部按钮栏 (已注释，如需使用请取消注释并注释掉 floatingActionButton) ===
      // bottomNavigationBar: _buildBottomButtonBar(),
    );
  }

  /// 构建顶部应用栏
  Widget _buildTopAppBar() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // 返回按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 标题
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.providerName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 分享按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // TODO: 实现分享功能
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, size: 16, color: Color(0xFF666666)),
                    SizedBox(width: 6),
                    Text(
                      '分享',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
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

  /// 构建展示类型切换标签
  Widget _buildDisplayTypeTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
      child: Wrap(
        spacing: 12,
        children: _displayTypes.map((type) {
          final isSelected = _selectedDisplayType == type;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDisplayType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1890FF) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE0E0E0),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContentArea() {
    switch (_selectedDisplayType) {
      case '轮播展示':
        return _buildCarouselContent();
      case '图文介绍':
        return _buildTextImageContent();
      case '长图列表':
        return _buildLongImageContent();
      case '文字说明':
        return _buildTextContent();
      case '案例展示':
        return _buildCaseStudyContent();
      default:
        return const SizedBox.shrink();
    }
  }

  /// 1. 轮播图内容
  Widget _buildCarouselContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 32),
      child: Column(
        children: [
          // 轮播图
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
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // 内容
                          Positioned.fill(
                            child: item.type == MediaType.video
                                ? _buildVideoPlayer(item.url)
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

                          // 视频标识
                          if (item.type == MediaType.video)
                            const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 80,
                                color: Colors.white,
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
    );
  }

  /// 简单的视频播放器（占位）
  Widget _buildVideoPlayer(String url) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              '视频播放器',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// 2. 图文介绍内容
  Widget _buildTextImageContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 32),
      child: Column(
        children: _textImageItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.all(32),
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
            child: Row(
              children: [
                if (item.imagePosition == ImagePosition.left) ...[
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: Colors.grey.withValues(alpha: 0.2),
                            child: const Center(
                              child: Icon(Icons.image, size: 48, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.imagePosition == ImagePosition.right) ...[
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: Colors.grey.withValues(alpha: 0.2),
                            child: const Center(
                              child: Icon(Icons.image, size: 48, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 3. 长图列表内容
  Widget _buildLongImageContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 32),
      child: Column(
        children: _longImageItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 40),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),

                // 长图
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 800,
                        color: Colors.grey.withValues(alpha: 0.2),
                        child: const Center(
                          child: Icon(Icons.image, size: 64, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 4. 纯文字内容
  Widget _buildTextContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 32),
      child: Container(
        padding: const EdgeInsets.all(40),
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
        child: Text(
          _textDescription,
          style: const TextStyle(
            fontSize: 15,
            height: 2,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  /// 5. 案例展示内容（智慧景区导览页面）
  Widget _buildCaseStudyContent() {
    // 使用完整版本，包含所有特性
    return const ScenicSpotGuideComplete();
  }

  /// === 方案1: 侧边悬浮按钮 ===
  Widget _buildSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 关注按钮
          _buildSideActionButton(
            icon: _isFollowed ? Icons.favorite : Icons.favorite_border,
            label: _isFollowed ? '已关注' : '关注',
            color: _isFollowed ? const Color(0xFFFF4D4F) : const Color(0xFF1890FF),
            onTap: () {
              setState(() {
                _isFollowed = !_isFollowed;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFollowed ? '已关注' : '已取消关注'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 客服按钮
          _buildSideActionButton(
            icon: Icons.headset_mic_outlined,
            label: '客服',
            color: const Color(0xFF52C41A),
            onTap: () {
              // TODO: 打开客服聊天
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('正在连接客服...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // 入厅申请按钮
          _buildSideActionButton(
            icon: Icons.meeting_room_outlined,
            label: '入厅申请',
            color: const Color(0xFFFF5000),
            onTap: () {
              // TODO: 打开入厅申请弹窗
              _showJoinHallDialog();
            },
          ),
        ],
      ),
    );
  }

  /// 侧边操作按钮
  Widget _buildSideActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// === 方案2: 底部按钮栏（可选方案） ===
  Widget _buildBottomButtonBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 关注按钮
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFollowed = !_isFollowed;
                  });
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isFollowed ? const Color(0xFFFF4D4F) : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isFollowed ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: _isFollowed ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isFollowed ? '已关注' : '关注',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _isFollowed ? const Color(0xFFFF4D4F) : const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 客服按钮
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // TODO: 打开客服聊天
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF52C41A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headset_mic_outlined, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '客服',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 入厅申请按钮
          Expanded(
            flex: 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _showJoinHallDialog();
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.meeting_room_outlined, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '入厅申请',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
    );
  }

  /// 显示入厅申请弹窗
  void _showJoinHallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('入厅申请'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请选择申请类型：'),
            SizedBox(height: 16),
            Text('• 普通会员：查看基础内容'),
            Text('• VIP会员：查看全部内容+专属服务'),
            Text('• 企业会员：团队协作+API接入'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('申请已提交，请等待审核'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5000),
            ),
            child: const Text('提交申请'),
          ),
        ],
      ),
    );
  }
}

/// 媒体类型
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

/// 图文项
class TextImageItem {
  final String title;
  final String description;
  final String image;
  final ImagePosition imagePosition;

  TextImageItem({
    required this.title,
    required this.description,
    required this.image,
    required this.imagePosition,
  });
}

/// 图片位置
enum ImagePosition { left, right }

/// 长图项
class LongImageItem {
  final String title;
  final String image;
  final String description;

  LongImageItem({
    required this.title,
    required this.image,
    required this.description,
  });
}
