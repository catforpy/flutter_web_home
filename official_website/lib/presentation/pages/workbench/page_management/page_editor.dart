import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:official_website/presentation/widgets/image_upload_dialog.dart';

/// 组件数据模型
class ComponentData {
  final String id;
  final String name;
  final IconData icon;
  final String type; // 'basic' 或 'marketing'

  ComponentData({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
}

/// 组件预览内容Widget
class ComponentPreviewContent extends StatelessWidget {
  final ComponentData component;
  final int index;
  final bool isSelected;
  final VoidCallback? onDelete;
  final List<Map<String, dynamic>>? carouselImages;
  final Map<String, dynamic>? searchStyle;
  final List<Map<String, dynamic>>? categoryNavItems;
  final Map<String, dynamic>? categoryNavStyle;
  final Map<String, dynamic>? videoData;
  final Map<String, dynamic>? videoStyle;
  final List<Map<String, dynamic>>? noticeItems;
  final Map<String, dynamic>? noticeConfig;
  final Map<String, dynamic>? noticeStyle;
  final Map<String, dynamic>? titleConfig;
  final Map<String, dynamic>? titleStyle;
  final Map<String, dynamic>? imageConfig;
  final Map<String, dynamic>? imageStyle;
  final List<Map<String, dynamic>>? showcaseItems;
  final Map<String, dynamic>? showcaseStyle;
  final Map<String, dynamic>? buttonConfig;
  final Map<String, dynamic>? buttonStyle;
  final Map<String, dynamic>? dividerConfig;
  final Map<String, dynamic>? dividerStyle;
  final List<Map<String, dynamic>>? imageTextListItems;
  final Map<String, dynamic>? imageTextListStyle;
  final Map<String, dynamic>? courseListConfig;
  final Map<String, dynamic>? courseListStyle;
  final List<Map<String, dynamic>>? recommendListItems;
  final Map<String, dynamic>? recommendListConfig;
  final Map<String, dynamic>? recommendListStyle;
  final Map<String, dynamic>? teacherListConfig;
  final Map<String, dynamic>? teacherListStyle;

  const ComponentPreviewContent({
    super.key,
    required this.component,
    required this.index,
    required this.isSelected,
    this.onDelete,
    this.carouselImages,
    this.searchStyle,
    this.categoryNavItems,
    this.categoryNavStyle,
    this.videoData,
    this.videoStyle,
    this.noticeItems,
    this.noticeConfig,
    this.noticeStyle,
    this.titleConfig,
    this.titleStyle,
    this.imageConfig,
    this.imageStyle,
    this.showcaseItems,
    this.showcaseStyle,
    this.buttonConfig,
    this.buttonStyle,
    this.dividerConfig,
    this.dividerStyle,
    this.imageTextListItems,
    this.imageTextListStyle,
    this.courseListConfig,
    this.courseListStyle,
    this.recommendListItems,
    this.recommendListConfig,
    this.recommendListStyle,
    this.teacherListConfig,
    this.teacherListStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 组件头部
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(component.icon, size: 20, color: const Color(0xFF1A9B8E)),
              const SizedBox(width: 8),
              Text(
                component.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
              const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 组件预览内容
        Padding(
          padding: const EdgeInsets.all(12),
          child: _buildComponentPreview(component),
        ),
      ],
    );
  }

  Widget _buildComponentPreview(ComponentData component) {
    switch (component.name) {
      case '轮播':
        return _buildCarouselPreview();
      case '搜索':
        return _buildSearchPreview();
      case '分类导航':
        return _buildCategoryNavPreview();
      case '视频':
        return _buildVideoPreview();
      case '通知公告':
        return _buildNoticePreview();
      case '标题':
        return _buildTitlePreview();
      case '图片':
        return _buildImagePreview();
      case '橱窗':
        return _buildShowcasePreview();
      case '按钮':
        return _buildButtonPreview();
      case '分割线':
        return _buildDividerPreview();
      case '图文列表':
        return _buildImageTextListPreview();
      case '课程列表':
        return _buildCourseListPreview();
      case '推荐列表':
        return _buildRecommendListPreview();
      case '讲师列表':
        return _buildTeacherListPreview();
      default:
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text('组件预览', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
          ),
        );
    }
  }

  Widget _buildCarouselPreview() {
    final images = carouselImages ?? [];

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          if (images.isEmpty)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.slideshow, size: 32, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 6),
                  Text('轮播图预览', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                ],
              ),
            )
          else
            Center(
              child: _buildCarouselImage(images[0]),
            ),

          // 指示器
          if (images.isNotEmpty)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    margin: EdgeInsets.only(left: index > 0 ? 6 : 0),
                    width: 12,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == 0 ? const Color(0xFF1A9B8E) : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(Map<String, dynamic> imageData) {
    final imageUrl = imageData['image'] as String?;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 6),
                  Text('加载失败', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                ],
              ),
            );
          },
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFFCCCCCC)),
          SizedBox(height: 6),
          Text('请上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
        ],
      ),
    );
  }

  Widget _buildSearchPreview() {
    final style = searchStyle;
    final placeholder = style?['placeholder'] as String? ?? '请输入搜索内容';
    final areaBgColor = style?['areaBgColor'] as String? ?? '#F5F6F7';
    final boxBgColor = style?['boxBgColor'] as String? ?? '#FFFFFF';
    final textColor = style?['textColor'] as String? ?? '#1F2329';
    final iconColor = style?['iconColor'] as String? ?? '黑';
    final height = (style?['height'] as int?) ?? 40;
    final borderRadius = (style?['borderRadius'] as int?) ?? 45;

    return Container(
      height: height.toDouble(),
      decoration: BoxDecoration(
        color: _parseColor(areaBgColor),
        borderRadius: BorderRadius.circular(45),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: height.toDouble(),
        decoration: BoxDecoration(
          color: _parseColor(boxBgColor),
          borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 18,
              color: iconColor == '白' ? Colors.white : const Color(0xFF999999),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                placeholder,
                style: TextStyle(
                  fontSize: 14,
                  color: _parseColor(textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerPreview() {
    final style = dividerStyle ?? {};
    final lineStyle = style['lineStyle'] as String? ?? '实线';
    final linePosition = style['linePosition'] as String? ?? '居左';
    final lineColor = style['lineColor'] as String? ?? '#E5E5E5';
    final lineWidth = (style['lineWidth'] as int?) ?? 375;
    final lineHeight = (style['lineHeight'] as int?) ?? 2;
    final paddingLeft = (style['paddingLeft'] as int?) ?? 0;
    final marginTop = (style['marginTop'] as int?) ?? 0;

    // 对齐方式
    MainAxisAlignment alignment;
    if (linePosition == '居中') {
      alignment = MainAxisAlignment.center;
    } else if (linePosition == '居右') {
      alignment = MainAxisAlignment.end;
    } else {
      alignment = MainAxisAlignment.start;
    }

    // 根据线条样式创建线条
    Widget buildLine() {
      Color color = _parseColor(lineColor);
      double width = lineWidth.toDouble();
      double height = lineHeight.toDouble();

      switch (lineStyle) {
        case '实线':
          return Container(
            width: width,
            height: height,
            color: color,
          );
        case '虚线':
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: color,
                  width: height,
                ),
              ),
            ),
            child: CustomPaint(
              size: Size(width, height),
              painter: _DashedLinePainter(
                color: color,
                dashWidth: 8.0,
                dashSpace: 4.0,
                strokeWidth: height,
              ),
            ),
          );
        case '点线':
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: color,
                  width: height,
                ),
              ),
            ),
            child: CustomPaint(
              size: Size(width, height),
              painter: _DottedLinePainter(
                color: color,
                dotRadius: height / 2,
                dotSpace: 4.0,
              ),
            ),
          );
        default:
          return Container(
            width: width,
            height: height,
            color: color,
          );
      }
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble()),
      padding: EdgeInsets.only(left: paddingLeft.toDouble()),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          buildLine(),
        ],
      ),
    );
  }

  Widget _buildImageTextListPreview() {
    final items = imageTextListItems ?? [];
    final style = imageTextListStyle ?? {};
    final listStyle = style['listStyle'] as String? ?? '单行滑动';
    final titleStyle = style['titleStyle'] as String? ?? '正常标题';
    final textPosition = style['textPosition'] as String? ?? '居左';
    final itemsPerRow = (style['itemsPerRow'] as int?) ?? 2;
    final titleColor = style['titleColor'] as String? ?? '#1F2329';
    final titleFontSize = (style['titleFontSize'] as int?) ?? 14;
    final titleLineHeight = (style['titleLineHeight'] as int?) ?? 20;
    final imageHeight = (style['imageHeight'] as int?) ?? 100;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    // 对齐方式
    CrossAxisAlignment alignment;
    if (textPosition == '居中') {
      alignment = CrossAxisAlignment.center;
    } else if (textPosition == '居右') {
      alignment = CrossAxisAlignment.end;
    } else {
      alignment = CrossAxisAlignment.start;
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      child: listStyle == '单行滑动'
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items.map((item) {
                  final image = item['image'] as String? ?? '';
                  final title = item['title'] as String? ?? '';
                  return Container(
                    width: 480 / itemsPerRow,
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildImageTextItem(
                      image,
                      title,
                      titleStyle,
                      alignment,
                      titleColor,
                      titleFontSize,
                      titleLineHeight,
                      imageHeight,
                    ),
                  );
                }).toList(),
              ),
            )
          : Column(
              children: [
                for (int i = 0; i < items.length; i += itemsPerRow)
                  Row(
                    children: List.generate(itemsPerRow, (j) {
                      final index = i + j;
                      if (index >= items.length) {
                        return Expanded(
                          child: Container(
                            height: imageHeight.toDouble(),
                            margin: const EdgeInsets.only(right: 12),
                          ),
                        );
                      }
                      final item = items[index];
                      final image = item['image'] as String? ?? '';
                      final title = item['title'] as String? ?? '';
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: j < itemsPerRow - 1 ? 12 : 0,
                            bottom: 12,
                          ),
                          child: _buildImageTextItem(
                            image,
                            title,
                            titleStyle,
                            alignment,
                            titleColor,
                            titleFontSize,
                            titleLineHeight,
                            imageHeight,
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
    );
  }

  Widget _buildImageTextItem(
    String image,
    String title,
    String titleStyle,
    CrossAxisAlignment alignment,
    String titleColor,
    int titleFontSize,
    int titleLineHeight,
    int imageHeight,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // 图片
        Container(
          width: double.infinity,
          height: imageHeight.toDouble(),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 32, color: Color(0xFF999999)),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Icon(Icons.image, size: 32, color: Color(0xFFCCCCCC)),
                ),
        ),
        // 标题
        if (titleStyle != '无标题')
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize.toDouble(),
                color: _parseColor(titleColor),
                height: titleLineHeight / titleFontSize,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : alignment == CrossAxisAlignment.end
                      ? TextAlign.right
                      : TextAlign.left,
            ),
          ),
      ],
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Colors.black;
    } catch (e) {
      return Colors.black;
    }
  }

  Widget _buildCourseListPreview() {
    final config = courseListConfig ?? {};
    final style = courseListStyle ?? {};
    final title = config['title'] as String? ?? '课程列表';
    final showSales = config['showSales'] as bool? ?? false;
    final showMore = config['showMore'] as bool? ?? false;
    final showSections = config['showSections'] as bool? ?? false;
    final showType = config['showType'] as bool? ?? false;
    final showRefresh = config['showRefresh'] as bool? ?? false;
    final itemCount = (config['itemCount'] as int?) ?? 4;
    final listStyle = style['listStyle'] as String? ?? '小图';
    final titleColor = style['titleColor'] as String? ?? '#1F2329';
    final titleFontSize = (style['titleFontSize'] as int?) ?? 15;
    final priceColor = style['priceColor'] as String? ?? '#FF4D4F';
    final priceFontSize = (style['priceFontSize'] as int?) ?? 15;
    final priceBold = style['priceBold'] as bool? ?? false;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize.toDouble(),
                      color: _parseColor(titleColor),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showMore)
                    const Text(
                      '更多 >',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                ],
              ),
            ),

          // 课程列表
          if (listStyle == '横向滑动')
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: _buildCourseListItem(
                      listStyle,
                      showSales,
                      showSections,
                      showType,
                      titleColor,
                      titleFontSize,
                      priceColor,
                      priceFontSize,
                      priceBold,
                      index,
                    ),
                  );
                },
              ),
            )
          else if (listStyle == '小图')
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return _buildCourseListItem(
                    listStyle,
                    showSales,
                    showSections,
                    showType,
                    titleColor,
                    titleFontSize,
                    priceColor,
                    priceFontSize,
                    priceBold,
                    index,
                  );
                },
              ),
            )
          else
            Column(
              children: List.generate(itemCount, (index) {
                return Container(
                  margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: _buildCourseListItem(
                    listStyle,
                    showSales,
                    showSections,
                    showType,
                    titleColor,
                    titleFontSize,
                    priceColor,
                    priceFontSize,
                    priceBold,
                    index,
                  ),
                );
              }),
            ),

          // 换一换按钮
          if (showRefresh)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 16, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text('换一换', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseListItem(
    String listStyle,
    bool showSales,
    bool showSections,
    bool showType,
    String titleColor,
    int titleFontSize,
    String priceColor,
    int priceFontSize,
    bool priceBold,
    int index,
  ) {
    switch (listStyle) {
      case '小图':
        // 两列布局 - 图片在上，标题和价格在下
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 28, color: Color(0xFFCCCCCC)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // 标题
            Text(
              '课程标题$index',
              style: TextStyle(
                fontSize: titleFontSize.toDouble(),
                color: _parseColor(titleColor),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // 价格
            Text(
              '¥199',
              style: TextStyle(
                fontSize: priceFontSize.toDouble(),
                color: _parseColor(priceColor),
                fontWeight: priceBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );

      case '详细列表':
        // 行布局 - 图片在左，详情在右
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Container(
              width: 100,
              height: 75,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)),
              ),
            ),
            const SizedBox(width: 12),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '课程标题 $index',
                    style: TextStyle(
                      fontSize: titleFontSize.toDouble(),
                      color: _parseColor(titleColor),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (showSections)
                    Text(
                      '共10节',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '¥199',
                        style: TextStyle(
                          fontSize: priceFontSize.toDouble(),
                          color: _parseColor(priceColor),
                          fontWeight: priceBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (showSales)
                        Text(
                          '已售100',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case '大图':
        // 单列布局 - 大图在上，内容在下
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Color(0xFFCCCCCC)),
              ),
            ),
            const SizedBox(height: 12),
            // 内容
            Text(
              '课程标题 $index - 这是一段很长的课程标题用来测试多行显示效果',
              style: TextStyle(
                fontSize: titleFontSize.toDouble(),
                color: _parseColor(titleColor),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '¥199',
                  style: TextStyle(
                    fontSize: priceFontSize.toDouble(),
                    color: _parseColor(priceColor),
                    fontWeight: priceBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                if (showSales)
                  Text(
                    '已售100',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ],
        );

      case '横向滑动':
        // 横向滑动卡片 - 竖向卡片
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)),
              ),
            ),
            const SizedBox(height: 6),
            // 标题
            Text(
              '课程标题$index',
              style: TextStyle(
                fontSize: titleFontSize.toDouble(),
                color: _parseColor(titleColor),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // 价格
            Text(
              '¥199',
              style: TextStyle(
                fontSize: priceFontSize.toDouble(),
                color: _parseColor(priceColor),
                fontWeight: priceBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );

      case '音频列表':
        return Row(
          children: [
            // 播放图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A9B8E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.play_arrow, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '课程标题 $index',
                    style: TextStyle(
                      fontSize: titleFontSize.toDouble(),
                      color: _parseColor(titleColor),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '¥199',
                        style: TextStyle(
                          fontSize: priceFontSize.toDouble(),
                          color: _parseColor(priceColor),
                          fontWeight: priceBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (showSections)
                        Text(
                          '共10节',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRecommendListPreview() {
    final items = recommendListItems ?? [];
    final config = recommendListConfig ?? {};
    final style = recommendListStyle ?? {};
    final showMore = config['showMore'] as bool? ?? false;
    final itemCount = (config['itemCount'] as int?) ?? 4;
    final listStyle = style['listStyle'] as String? ?? '单行滑动';
    final titleStyle = style['titleStyle'] as String? ?? '正常标题';
    final textPosition = style['textPosition'] as String? ?? '居左';
    final itemsPerRow = (style['itemsPerRow'] as int?) ?? 2;
    final titleColor = style['titleColor'] as String? ?? '#1F2329';
    final titleFontSize = (style['titleFontSize'] as int?) ?? 14;
    final titleLineHeight = (style['titleLineHeight'] as int?) ?? 20;
    final imageHeight = (style['imageHeight'] as int?) ?? 100;
    final showSummary = style['showSummary'] as bool? ?? false;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    // 对齐方式
    CrossAxisAlignment alignment;
    if (textPosition == '居中') {
      alignment = CrossAxisAlignment.center;
    } else if (textPosition == '居右') {
      alignment = CrossAxisAlignment.end;
    } else {
      alignment = CrossAxisAlignment.start;
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏和更多按钮
          if (showMore)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '推荐列表',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                  ),
                  const Text(
                    '更多 >',
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),

          // 推荐列表
          if (listStyle == '单行滑动')
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items.take(itemCount).map((item) {
                  final image = item['image'] as String? ?? '';
                  final title = item['title'] as String? ?? '';
                  final summary = item['summary'] as String? ?? '';
                  return Container(
                    width: 480 / itemsPerRow,
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildRecommendListItem(
                      image,
                      title,
                      summary,
                      titleStyle,
                      alignment,
                      titleColor,
                      titleFontSize,
                      titleLineHeight,
                      imageHeight,
                      showSummary,
                    ),
                  );
                }).toList(),
              ),
            )
          else
            Column(
              children: [
                for (int i = 0; i < itemCount && i < items.length; i += itemsPerRow)
                  Row(
                    children: List.generate(itemsPerRow, (j) {
                      final index = i + j;
                      if (index >= items.length || index >= itemCount) {
                        return Expanded(
                          child: Container(
                            height: imageHeight.toDouble(),
                            margin: const EdgeInsets.only(right: 12),
                          ),
                        );
                      }
                      final item = items[index];
                      final image = item['image'] as String? ?? '';
                      final title = item['title'] as String? ?? '';
                      final summary = item['summary'] as String? ?? '';
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: j < itemsPerRow - 1 ? 12 : 0,
                            bottom: 12,
                          ),
                          child: _buildRecommendListItem(
                            image,
                            title,
                            summary,
                            titleStyle,
                            alignment,
                            titleColor,
                            titleFontSize,
                            titleLineHeight,
                            imageHeight,
                            showSummary,
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendListItem(
    String image,
    String title,
    String summary,
    String titleStyle,
    CrossAxisAlignment alignment,
    String titleColor,
    int titleFontSize,
    int titleLineHeight,
    int imageHeight,
    bool showSummary,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // 图片
        Container(
          width: double.infinity,
          height: imageHeight.toDouble(),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 32, color: Color(0xFF999999)),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Icon(Icons.image, size: 32, color: Color(0xFFCCCCCC)),
                ),
        ),
        // 标题
        if (titleStyle != '无标题')
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize.toDouble(),
                color: _parseColor(titleColor),
                height: titleLineHeight / titleFontSize,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : alignment == CrossAxisAlignment.end
                      ? TextAlign.right
                      : TextAlign.left,
            ),
          ),
        // 简介
        if (showSummary && summary.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              summary,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : alignment == CrossAxisAlignment.end
                      ? TextAlign.right
                      : TextAlign.left,
            ),
          ),
      ],
    );
  }

  Widget _buildTeacherListPreview() {
    final config = teacherListConfig ?? {};
    final style = teacherListStyle ?? {};
    final title = config['title'] as String? ?? '讲师列表';
    final showSubscribe = config['showSubscribe'] as bool? ?? false;
    final showMore = config['showMore'] as bool? ?? false;
    final showRefresh = config['showRefresh'] as bool? ?? false;
    final teacherCount = (config['teacherCount'] as int?) ?? 3;
    final titleColor = style['titleColor'] as String? ?? '#1F2329';
    final titleFontSize = (style['titleFontSize'] as int?) ?? 15;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize.toDouble(),
                      color: _parseColor(titleColor),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showMore)
                    const Text(
                      '更多 >',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                ],
              ),
            ),

          // 讲师列表
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: teacherCount,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 头像
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 30, color: Color(0xFFCCCCCC)),
                    ),
                    const SizedBox(height: 8),
                    // 讲师名称
                    Text(
                      '讲师 ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 订阅按钮
                    if (showSubscribe)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A9B8E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '订阅',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          // 换一换按钮
          if (showRefresh)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 16, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text('换一换', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryNavPreview() {
    final items = categoryNavItems ?? [];
    final style = categoryNavStyle ?? {};
    final itemsPerRow = style['itemsPerRow'] as int? ?? 3;
    final navBgColor = style['navBgColor'] as String? ?? '#000000';
    final iconBorderRadius = (style['iconBorderRadius'] as int?) ?? 10;
    final titleFontSize = (style['titleFontSize'] as int?) ?? 13;
    final titleColor = style['titleColor'] as String? ?? '#999999';

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.category, size: 32, color: Color(0xFFCCCCCC)),
              SizedBox(height: 8),
              Text('暂无分类', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          return SizedBox(
            width: 300 / itemsPerRow - 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _parseColor(navBgColor),
                    borderRadius: BorderRadius.circular(iconBorderRadius.toDouble()),
                  ),
                  child: item['image'] != null && item['image'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(iconBorderRadius.toDouble()),
                          child: Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC));
                            },
                          ),
                        )
                      : const Icon(Icons.image, size: 24, color: Color(0xFFCCCCCC)),
                ),
                const SizedBox(height: 4),
                // 标题
                Text(
                  item['title'] ?? '未命名',
                  style: TextStyle(
                    fontSize: titleFontSize.toDouble(),
                    color: _parseColor(titleColor),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVideoPreview() {
    final data = videoData ?? {};
    final style = videoStyle ?? {};
    final coverImage = data['coverImage'] as String? ?? '';
    final height = (style['height'] as int?) ?? 200;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;
    final paddingLeft = (style['paddingLeft'] as int?) ?? 0;
    final paddingRight = (style['paddingRight'] as int?) ?? 0;

    return Container(
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      padding: EdgeInsets.only(left: paddingLeft.toDouble(), right: paddingRight.toDouble()),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(4),
            ),
            child: coverImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      coverImage,
                      width: double.infinity,
                      height: height.toDouble(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam, size: 48, color: Color(0xFF666666)),
                              SizedBox(height: 8),
                              Text('视频封面加载失败', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, size: 48, color: Color(0xFF666666)),
                        SizedBox(height: 8),
                        Text('请上传视频封面', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticePreview() {
    final items = noticeItems ?? [];
    final style = noticeStyle ?? {};
    final config = noticeConfig ?? {};
    final bgColor = style['bgColor'] as String? ?? '#FFF8E1';
    final titleColor = style['titleColor'] as String? ?? '#1F2329';
    final textColor = style['textColor'] as String? ?? '#666666';
    final fontSize = (style['fontSize'] as int?) ?? 14;
    final titleBold = (style['titleBold'] as bool?) ?? false;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;
    final noticeTitle = config['noticeTitle'] as String? ?? '最新头条';

    if (items.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.notifications, size: 32, color: Color(0xFFCCCCCC)),
              SizedBox(height: 8),
              Text('暂无通知', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      decoration: BoxDecoration(
        color: _parseColor(bgColor),
      ),
      child: Column(
        children: [
          // 通知标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.notifications, size: 16, color: Color(0xFF1A9B8E)),
                const SizedBox(width: 6),
                Text(
                  noticeTitle,
                  style: TextStyle(
                    fontSize: fontSize.toDouble(),
                    color: _parseColor(titleColor),
                    fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          // 通知列表
          ...items.map((item) {
            final title = item['title'] as String? ?? '';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: (fontSize - 1).toDouble(),
                        color: _parseColor(textColor),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Color(0xFF999999)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTitlePreview() {
    final config = titleConfig ?? {};
    final style = titleStyle ?? {};
    final titleText = config['titleText'] as String? ?? '标题文本';
    final titleStyleValue = style['titleStyle'] as String? ?? '纯标题';
    final titlePosition = style['titlePosition'] as String? ?? '居左';
    final titleBold = style['titleBold'] as bool? ?? false;
    final bgColor = style['bgColor'] as String? ?? '#FFFFFF';
    final textColor = style['textColor'] as String? ?? '#1F2329';
    final accentColor = style['accentColor'] as String? ?? '#1A9B8E';
    final fontSize = (style['fontSize'] as int?) ?? 15;
    final paddingTop = (style['paddingTop'] as int?) ?? 13;
    final paddingBottom = (style['paddingBottom'] as int?) ?? 13;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;
    final bgImage = style['bgImage'] as String? ?? '';

    // 对齐方式
    CrossAxisAlignment alignment;
    if (titlePosition == '居中') {
      alignment = CrossAxisAlignment.center;
    } else if (titlePosition == '居右') {
      alignment = CrossAxisAlignment.end;
    } else {
      alignment = CrossAxisAlignment.start;
    }

    return Container(
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      color: _parseColor(bgColor),
      child: Stack(
        children: [
          // 背景图（如果有）
          if (titleStyleValue == '背景图样式' && bgImage.isNotEmpty)
            Positioned.fill(
              child: Opacity(
                opacity: 1.0,
                child: Image.network(
                  bgImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

          // 内容
          Container(
            padding: EdgeInsets.only(
              top: paddingTop.toDouble(),
              bottom: paddingBottom.toDouble(),
              left: 12,
              right: 12,
            ),
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                // 根据不同样式构建标题
                if (titleStyleValue == '纯标题')
                  Text(
                    titleText,
                    style: TextStyle(
                      fontSize: fontSize.toDouble(),
                      color: _parseColor(textColor),
                      fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                else if (titleStyleValue == '左圆点')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _parseColor(accentColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: fontSize.toDouble(),
                          color: _parseColor(textColor),
                          fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  )
                else if (titleStyleValue == '左线条')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: fontSize.toDouble() + 4,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _parseColor(accentColor),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: fontSize.toDouble(),
                          color: _parseColor(textColor),
                          fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  )
                else if (titleStyleValue == '下横线')
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: fontSize.toDouble(),
                          color: _parseColor(textColor),
                          fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _parseColor(accentColor),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ],
                  )
                else if (titleStyleValue == '背景图样式')
                  Text(
                    titleText,
                    style: TextStyle(
                      fontSize: fontSize.toDouble(),
                      color: bgImage.isNotEmpty ? Colors.white : _parseColor(textColor),
                      fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
                      shadows: bgImage.isNotEmpty
                          ? [
                              const Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black45,
                              ),
                            ]
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    final config = imageConfig ?? {};
    final style = imageStyle ?? {};
    final imageUrl = config['imageUrl'] as String? ?? '';
    final imagePosition = style['imagePosition'] as String? ?? '居左';
    final imageWidth = (style['imageWidth'] as int?) ?? 375;
    final imageHeight = (style['imageHeight'] as int?) ?? 100;
    final borderRadius = (style['borderRadius'] as int?) ?? 0;
    final bgColor = style['bgColor'] as String? ?? '#FFFFFF';
    final paddingTop = (style['paddingTop'] as int?) ?? 0;
    final paddingBottom = (style['paddingBottom'] as int?) ?? 0;
    final paddingLeft = (style['paddingLeft'] as int?) ?? 0;
    final paddingRight = (style['paddingRight'] as int?) ?? 0;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    // 对齐方式
    MainAxisAlignment alignment;
    if (imagePosition == '居中') {
      alignment = MainAxisAlignment.center;
    } else if (imagePosition == '居右') {
      alignment = MainAxisAlignment.end;
    } else {
      alignment = MainAxisAlignment.start;
    }

    return Container(
      width: double.infinity,
      color: _parseColor(bgColor),
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      padding: EdgeInsets.only(
        top: paddingTop.toDouble(),
        bottom: paddingBottom.toDouble(),
        left: paddingLeft.toDouble(),
        right: paddingRight.toDouble(),
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius.toDouble()),
              child: Image.network(
                imageUrl,
                width: imageWidth.toDouble(),
                height: imageHeight.toDouble(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageWidth.toDouble(),
                    height: imageHeight.toDouble(),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
                    ),
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 32, color: Color(0xFF999999)),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: imageWidth.toDouble(),
              height: imageHeight.toDouble(),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(borderRadius.toDouble()),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 32, color: Colors.grey.shade400),
                    const SizedBox(height: 4),
                    Text(
                      '暂无图片',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShowcasePreview() {
    final items = showcaseItems ?? [];
    final style = showcaseStyle ?? {};
    final layoutStyle = style['showcaseStyle'] as String? ?? '两列';
    final showcaseHeight = (style['showcaseHeight'] as int?) ?? 150;
    final imageSpacing = (style['imageSpacing'] as int?) ?? 3;
    final borderRadius = (style['borderRadius'] as int?) ?? 0;
    final bgColor = style['bgColor'] as String? ?? '#FFFFFF';
    final paddingTop = (style['paddingTop'] as int?) ?? 0;
    final paddingBottom = (style['paddingBottom'] as int?) ?? 0;
    final paddingLeft = (style['paddingLeft'] as int?) ?? 0;
    final paddingRight = (style['paddingRight'] as int?) ?? 0;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    // 根据橱窗样式构建布局
    Widget buildLayout() {
      if (items.isEmpty) {
        return Container(
          height: showcaseHeight.toDouble(),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(borderRadius.toDouble()),
          ),
          child: const Center(
            child: Text('暂无图片', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
          ),
        );
      }

      switch (layoutStyle) {
        case '两列':
          return SizedBox(
            height: showcaseHeight.toDouble(),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final image = item['image'] as String? ?? '';
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < items.length - 1 ? imageSpacing.toDouble() : 0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
                    ),
                    child: image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius.toDouble()),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, size: 32, color: Color(0xFF999999)),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.image, size: 32, color: Color(0xFFCCCCCC)),
                          ),
                  ),
                );
              }),
            ),
          );

        case '左一右二':
          return SizedBox(
            height: showcaseHeight.toDouble(),
            child: Row(
              children: [
                // 左边一个图片（占一半宽度）
                Expanded(
                  child: _buildShowcaseImageItem(items[0], borderRadius, imageSpacing.toDouble(), false),
                ),
                SizedBox(width: imageSpacing.toDouble()),
                // 右边两个图片（占一半宽度，垂直排列）
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: items.length > 1
                            ? _buildShowcaseImageItem(items[1], borderRadius, 0, false)
                            : _buildShowcasePlaceholder(borderRadius),
                      ),
                      SizedBox(height: imageSpacing.toDouble()),
                      Expanded(
                        child: items.length > 2
                            ? _buildShowcaseImageItem(items[2], borderRadius, 0, false)
                            : _buildShowcasePlaceholder(borderRadius),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        case '左二右一':
          return SizedBox(
            height: showcaseHeight.toDouble(),
            child: Row(
              children: [
                // 左边两个图片（占一半宽度，垂直排列）
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildShowcaseImageItem(items[0], borderRadius, 0, false),
                      ),
                      SizedBox(height: imageSpacing.toDouble()),
                      Expanded(
                        child: items.length > 1
                            ? _buildShowcaseImageItem(items[1], borderRadius, 0, false)
                            : _buildShowcasePlaceholder(borderRadius),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: imageSpacing.toDouble()),
                // 右边一个图片（占一半宽度）
                Expanded(
                  child: items.length > 2
                      ? _buildShowcaseImageItem(items[2], borderRadius, imageSpacing.toDouble(), false)
                      : _buildShowcasePlaceholder(borderRadius),
                ),
              ],
            ),
          );

        case '一行三个':
          return SizedBox(
            height: showcaseHeight.toDouble(),
            child: Row(
              children: List.generate(3, (index) {
                final item = index < items.length ? items[index] : null;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < 2 ? imageSpacing.toDouble() : 0,
                    ),
                    child: item != null
                        ? _buildShowcaseImageItem(item, borderRadius, 0, true)
                        : _buildShowcasePlaceholder(borderRadius),
                  ),
                );
              }),
            ),
          );

        case '一行四个':
          return SizedBox(
            height: showcaseHeight.toDouble(),
            child: Row(
              children: List.generate(4, (index) {
                final item = index < items.length ? items[index] : null;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < 3 ? imageSpacing.toDouble() : 0,
                    ),
                    child: item != null
                        ? _buildShowcaseImageItem(item, borderRadius, 0, true)
                        : _buildShowcasePlaceholder(borderRadius),
                  ),
                );
              }),
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    }

    return Container(
      width: double.infinity,
      color: _parseColor(bgColor),
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      padding: EdgeInsets.only(
        top: paddingTop.toDouble(),
        bottom: paddingBottom.toDouble(),
        left: paddingLeft.toDouble(),
        right: paddingRight.toDouble(),
      ),
      child: buildLayout(),
    );
  }

  Widget _buildShowcaseImageItem(
    Map<String, dynamic> item,
    int borderRadius,
    double marginRight,
    bool expand,
  ) {
    final image = item['image'] as String? ?? '';
    return Container(
      margin: EdgeInsets.only(right: marginRight),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      ),
      child: image.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius.toDouble()),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 32, color: Color(0xFF999999)),
                  );
                },
              ),
            )
          : const Center(
              child: Icon(Icons.image, size: 32, color: Color(0xFFCCCCCC)),
            ),
    );
  }

  Widget _buildShowcasePlaceholder(int borderRadius) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 32, color: Color(0xFFCCCCCC)),
      ),
    );
  }

  Widget _buildButtonPreview() {
    final config = buttonConfig ?? {};
    final style = buttonStyle ?? {};
    final buttonText = config['buttonText'] as String? ?? '按钮';
    final buttonPosition = style['buttonPosition'] as String? ?? '居左';
    final bgColor = style['bgColor'] as String? ?? '#1A9B8E';
    final borderColor = style['borderColor'] as String? ?? '#1A9B8E';
    final textColor = style['textColor'] as String? ?? '#FFFFFF';
    final fontSize = (style['fontSize'] as int?) ?? 15;
    final buttonWidth = (style['buttonWidth'] as int?) ?? 100;
    final buttonHeight = (style['buttonHeight'] as int?) ?? 45;
    final borderRadius = (style['borderRadius'] as int?) ?? 8;
    final paddingTop = (style['paddingTop'] as int?) ?? 10;
    final paddingBottom = (style['paddingBottom'] as int?) ?? 10;
    final marginTop = (style['marginTop'] as int?) ?? 0;
    final marginBottom = (style['marginBottom'] as int?) ?? 0;

    // 对齐方式
    MainAxisAlignment alignment;
    if (buttonPosition == '居中') {
      alignment = MainAxisAlignment.center;
    } else if (buttonPosition == '居右') {
      alignment = MainAxisAlignment.end;
    } else {
      alignment = MainAxisAlignment.start;
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: marginTop.toDouble(), bottom: marginBottom.toDouble()),
      padding: EdgeInsets.only(
        top: paddingTop.toDouble(),
        bottom: paddingBottom.toDouble(),
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Container(
            width: buttonWidth.toDouble(),
            height: buttonHeight.toDouble(),
            decoration: BoxDecoration(
              color: _parseColor(bgColor),
              border: Border.all(
                color: _parseColor(borderColor),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(borderRadius.toDouble()),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize.toDouble(),
                  color: _parseColor(textColor),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 虚线绘制器
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 点线绘制器
class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double dotSpace;

  _DottedLinePainter({
    required this.color,
    required this.dotRadius,
    required this.dotSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startX = dotRadius;
    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX, size.height / 2),
        dotRadius,
        paint,
      );
      startX += dotRadius * 2 + dotSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 页面编辑器 - 全屏独立页面
class PageEditor extends StatefulWidget {
  final String? templateId;
  final String? templateName;
  final String? initialPageType;

  const PageEditor({
    super.key,
    this.templateId,
    this.templateName,
    this.initialPageType,
  });

  @override
  State<PageEditor> createState() => _PageEditorState();
}

class _PageEditorState extends State<PageEditor> {
  // 选中的页面类型
  late String _selectedPageType;

  // 页面类型列表
  final List<String> _pageTypes = [
    '首页',
    '课程',
    '商城',
    '视频',
    '消息',
    '直播',
    '个人中心',
  ];

  // 右侧标签页索引
  int _selectedTabIndex = 0;

  // 页面上的组件列表
  final List<ComponentData> _pageComponents = [];

  // 当前选中的组件索引
  int? _selectedComponentIndex;

  // 拖拽中的组件索引
  int? _draggingIndex;

  @override
  void initState() {
    super.initState();
    // 初始化页面类型，如果有传入初始值则使用，否则默认为首页
    _selectedPageType = widget.initialPageType ?? '首页';
  }

  // 轮播图图片数据（模拟）
  final List<Map<String, dynamic>> _carouselImages = [
    {'image': '', 'linkType': '无链接', 'linkTarget': ''},
  ];

  // 轮播图样式配置
  final Map<String, dynamic> _carouselStyle = {
    'autoPlay': true,
    'duration': 1000,
    'interval': 4000,
    'indicatorColor': '#FFFFFF',
    'activeIndicatorColor': '#1A9B8E',
    'height': 200,
    'marginTop': 0,
    'marginBottom': 0,
    'paddingLeft': 0,
    'paddingRight': 0,
    'borderRadius': 0,
  };

  // 搜索组件样式配置
  final Map<String, dynamic> _searchStyle = {
    'placeholder': '请输入搜索内容',
    'areaBgColor': '#F5F6F7',
    'boxBgColor': '#FFFFFF',
    'textColor': '#1F2329',
    'borderColor': '#D9D9D9',
    'iconColor': '黑',
    'fontSize': 14,
    'height': 40,
    'width': 90,
    'borderRadius': 45,
    'paddingTop': 10,
    'paddingBottom': 10,
    'marginTop': 0,
    'marginBottom': 0,
  };

  // 分类导航数据
  final List<Map<String, dynamic>> _categoryNavItems = [
    {
      'image': '',
      'title': '分类1',
      'linkType': '无链接',
      'linkTarget': '',
    },
  ];

  // 分类导航样式配置
  final Map<String, dynamic> _categoryNavStyle = {
    'itemsPerRow': 3, // 单行个数：3、4、5
    'navStyle': '单行滑动', // 导航样式：单行滑动、两行清屏、简介导航、换行
    'navWidth': 100, // 导航宽度%
    'navBorderRadius': 0, // 导航圆角
    'navBgColor': '#000000', // 导航背景色
    'iconBorderRadius': 10, // 图标圆角
    'titleFontSize': 13, // 标题字大小
    'titleColor': '#999999', // 标题字颜色
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 视频组件数据
  final Map<String, dynamic> _videoData = {
    'coverImage': '', // 视频封面图
    'videoLink': '', // 视频链接
  };

  // 视频组件样式配置
  final Map<String, dynamic> _videoStyle = {
    'autoPlay': false, // 是否自动播放
    'height': 200, // 视频高度
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
    'paddingLeft': 0, // 左内边距
    'paddingRight': 0, // 右内边距
  };

  // 通知公告组件数据
  final List<Map<String, dynamic>> _noticeItems = [
    {
      'title': '最新头条',
      'linkTarget': '',
    },
  ];

  // 通知公告组件配置
  final Map<String, dynamic> _noticeConfig = {
    'noticeTitle': '最新头条', // 公告标题
  };

  // 通知公告组件样式配置
  final Map<String, dynamic> _noticeStyle = {
    'titleBold': false, // 标题是否加粗
    'bgColor': '#FFF8E1', // 通知背景颜色
    'titleColor': '#1F2329', // 通知标题颜色
    'textColor': '#666666', // 通知文字颜色
    'fontSize': 14, // 通知文字大小
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 标题组件配置
  final Map<String, dynamic> _titleConfig = {
    'titleText': '标题文本', // 标题文本
  };

  // 标题组件样式配置
  final Map<String, dynamic> _titleStyle = {
    'titleStyle': '纯标题', // 标题样式：纯标题、左圆点、左线条、下横线、背景图样式
    'titlePosition': '居左', // 标题位置：居左、居中、居右
    'titleBold': false, // 标题是否加粗
    'bgColor': '#FFFFFF', // 标题背景色
    'textColor': '#1F2329', // 文字颜色
    'accentColor': '#1A9B8E', // 装饰颜色（圆点、线条、横线的颜色）
    'fontSize': 15, // 标题大小
    'paddingTop': 13, // 上内边距
    'paddingBottom': 13, // 下内边距
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
    'bgImage': '', // 背景图（仅当titleStyle为背景图样式时使用）
  };

  // 图片组件配置
  final Map<String, dynamic> _imageConfig = {
    'imageUrl': '', // 图片URL
    'linkType': '无链接', // 连接类型
    'linkTarget': '', // 链接目标
  };

  // 图片组件样式配置
  final Map<String, dynamic> _imageStyle = {
    'imagePosition': '居左', // 图片位置：居左、居中、居右
    'imageWidth': 375, // 图片宽度
    'imageHeight': 100, // 图片高度
    'borderRadius': 0, // 图片圆角
    'bgColor': '#FFFFFF', // 背景颜色
    'paddingTop': 0, // 上内边距
    'paddingBottom': 0, // 下内边距
    'paddingLeft': 0, // 左内边距
    'paddingRight': 0, // 右内边距
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 橱窗组件数据
  final List<Map<String, dynamic>> _showcaseItems = [
    {
      'image': '', // 图片URL
      'linkType': '无链接', // 连接类型
      'linkTarget': '', // 链接目标
    },
    {
      'image': '', // 图片URL
      'linkType': '无链接', // 连接类型
      'linkTarget': '', // 链接目标
    },
  ];

  // 橱窗组件样式配置
  final Map<String, dynamic> _showcaseStyle = {
    'showcaseStyle': '两列', // 橱窗样式：两列、左一右二、左二右一、一行三个、一行四个
    'showcaseHeight': 150, // 橱窗高度
    'imageSpacing': 3, // 图片间距
    'borderRadius': 0, // 图片圆角
    'bgColor': '#FFFFFF', // 背景颜色
    'paddingTop': 0, // 上内边距
    'paddingBottom': 0, // 下内边距
    'paddingLeft': 0, // 左内边距
    'paddingRight': 0, // 右内边距
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 按钮组件配置
  final Map<String, dynamic> _buttonConfig = {
    'buttonText': '按钮', // 按钮文字
    'linkType': '无链接', // 连接类型
    'linkTarget': '', // 链接目标
  };

  // 按钮组件样式配置
  final Map<String, dynamic> _buttonStyle = {
    'buttonPosition': '居左', // 按钮位置：居左、居中、居右
    'bgColor': '#1A9B8E', // 按钮背景色
    'borderColor': '#1A9B8E', // 按钮边框颜色
    'textColor': '#FFFFFF', // 文字颜色
    'fontSize': 15, // 文字大小
    'buttonWidth': 100, // 按钮宽度
    'buttonHeight': 45, // 按钮高度
    'lineHeight': 45, // 按钮行高
    'borderRadius': 8, // 按钮圆角
    'paddingTop': 10, // 上内边距
    'paddingBottom': 10, // 下内边距
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 分割线组件配置
  final Map<String, dynamic> _dividerConfig = {
    'remark': '', // 备注
  };

  // 分割线组件样式配置
  final Map<String, dynamic> _dividerStyle = {
    'lineStyle': '实线', // 线条样式：实线、虚线、点线
    'linePosition': '居左', // 线条位置：居左、居中、居右
    'lineColor': '#E5E5E5', // 线条颜色
    'lineWidth': 375, // 线条宽度
    'lineHeight': 2, // 线条高度
    'paddingLeft': 0, // 左内边距
    'marginTop': 0, // 上外边距
  };

  // 图文列表组件数据
  final List<Map<String, dynamic>> _imageTextListItems = [
    {
      'image': '', // 图片URL
      'title': '标题1', // 标题名称
      'linkType': '无链接', // 连接类型
      'linkTarget': '', // 链接目标
    },
  ];

  // 图文列表组件样式配置
  final Map<String, dynamic> _imageTextListStyle = {
    'showSummary': false, // 显示简介开关
    'listStyle': '单行滑动', // 列表样式：单行滑动、列表平铺
    'titleStyle': '正常标题', // 标题样式：悬浮标题、正常标题、无标题
    'textPosition': '居左', // 文字位置：居左、居中、居右
    'itemsPerRow': 2, // 单行个数：1、2、3、4
    'titleColor': '#1F2329', // 标题颜色
    'titleFontSize': 14, // 标题字号
    'titleLineHeight': 20, // 标题行高
    'imageHeight': 100, // 图片高度
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 课程列表组件配置
  final Map<String, dynamic> _courseListConfig = {
    'title': '课程列表', // 标题
    'showSales': false, // 是否显示销量
    'showMore': false, // 是否显示更多
    'showSections': false, // 是否显示节数
    'showType': false, // 是否显示类型
    'showRefresh': false, // 是否显示换一换
    'itemCount': 4, // 显示商品数量：4、6、8、10
    'category': '全部分类', // 课程分类
    'categoryDetail': '全部', // 分类详情
  };

  // 课程列表组件样式配置
  final Map<String, dynamic> _courseListStyle = {
    'listStyle': '小图', // 列表样式：小图、详细列表、大图、横向滑动、音频列表
    'titleColor': '#1F2329', // 标题颜色
    'titleFontSize': 15, // 标题字大小
    'priceColor': '#FF4D4F', // 价格颜色
    'priceFontSize': 15, // 价格字大小
    'priceBold': false, // 价格是否加粗
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 推荐列表组件数据
  final List<Map<String, dynamic>> _recommendListItems = [
    {
      'image': '', // 图片URL
      'title': '推荐1', // 标题名称
      'summary': '这是推荐简介', // 简介
    },
  ];

  // 推荐列表组件配置
  final Map<String, dynamic> _recommendListConfig = {
    'showMore': false, // 是否显示更多
    'itemCount': 4, // 显示商品数量：4、6、8、10
    'type': '文章', // 类型：文章、课程
  };

  // 推荐列表组件样式配置
  final Map<String, dynamic> _recommendListStyle = {
    'showSummary': false, // 是否显示简介
    'listStyle': '单行滑动', // 列表样式：单行滑动、列表平铺
    'titleStyle': '正常标题', // 标题样式：悬浮标题、正常标题、无标题
    'textPosition': '居左', // 文字位置：居左、居中、居右
    'itemsPerRow': 2, // 单行个数：1、2、3、4
    'titleColor': '#1F2329', // 标题颜色
    'titleFontSize': 14, // 标题字号
    'titleLineHeight': 20, // 标题行高
    'imageHeight': 100, // 图片高度
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 讲师列表组件配置
  final Map<String, dynamic> _teacherListConfig = {
    'title': '讲师列表', // 标题
    'showSubscribe': false, // 是否显示订阅
    'showMore': false, // 是否显示更多
    'showRefresh': false, // 是否显示换一换
    'teacherCount': 3, // 显示讲师数量：3、6、9
    'fetchMode': '自动获取', // 添加方式：自动获取、手动获取
    'category': '全部分类', // 讲师分类
  };

  // 讲师列表组件样式配置
  final Map<String, dynamic> _teacherListStyle = {
    'titleColor': '#1F2329', // 标题颜色
    'titleFontSize': 15, // 标题字大小
    'marginTop': 0, // 上外边距
    'marginBottom': 0, // 下外边距
  };

  // 个人中心会员信息
  final Map<String, dynamic> _memberInfo = {
    'avatar': '', // 头像
    'nickname': '会员昵称', // 会员昵称
    'level': 'VIP会员', // 会员等级
  };

  // 个人中心功能组件（10个）
  final List<Map<String, dynamic>> _personalCenterItems = [
    {
      'id': '1',
      'icon': Icons.card_membership,
      'iconImage': '', // 自定义图标图片
      'name': '会员中心',
      'enabled': true,
      'linkTarget': '', // 跳转路径
    },
    {
      'id': '2',
      'icon': Icons.qr_code,
      'iconImage': '',
      'name': '邀请码',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '3',
      'icon': Icons.storefront,
      'iconImage': '',
      'name': '积分商城',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '4',
      'icon': Icons.shopping_bag,
      'iconImage': '',
      'name': '我的租赁',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '5',
      'icon': Icons.handshake,
      'iconImage': '',
      'name': '我的合作',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '6',
      'icon': Icons.subscriptions,
      'iconImage': '',
      'name': '我的订阅',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '7',
      'icon': Icons.edit,
      'iconImage': '',
      'name': '我的发帖',
      'enabled': true,
      'linkTarget': '',
    },
    {
      'id': '8',
      'icon': Icons.comment,
      'iconImage': '',
      'name': '我的评论',
      'enabled': true,
      'linkTarget': '',
    },
    // 讲师申请（特殊项）
    {
      'id': '9',
      'icon': Icons.school,
      'iconImage': '',
      'name': '讲师申请',
      'nameBefore': '入驻',
      'nameAfter': '管理中心',
      'enabled': true,
      'isSpecial': true,
      'linkTarget': '',
    },
  ];

  // 个人中心命令标签
  final List<Map<String, dynamic>> _personalCenterMenus = [
    {
      'id': 'm1',
      'icon': Icons.dataset,
      'iconImage': '',
      'name': '数据管理',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm2',
      'icon': Icons.shopping_cart,
      'iconImage': '',
      'name': '我的商城订单',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm3',
      'icon': Icons.favorite,
      'iconImage': '',
      'name': '我的收藏',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm4',
      'icon': Icons.play_circle,
      'iconImage': '',
      'name': '我的学习情况',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm5',
      'icon': Icons.pattern,
      'iconImage': '',
      'name': '平图案',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm6',
      'icon': Icons.flash_on,
      'iconImage': '',
      'name': '秒杀',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm7',
      'icon': Icons.content_cut,
      'iconImage': '',
      'name': '砍价',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm8',
      'icon': Icons.support_agent,
      'iconImage': '',
      'name': '客服',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm9',
      'icon': Icons.card_giftcard,
      'iconImage': '',
      'name': '抽奖',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm10',
      'icon': Icons.list_alt,
      'iconImage': '',
      'name': '商品分用列表',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm11',
      'icon': Icons.trending_up,
      'iconImage': '',
      'name': '租赁收益',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm12',
      'icon': Icons.handshake,
      'iconImage': '',
      'name': '合作收益',
      'enabled': false,
      'linkTarget': '',
    },
    {
      'id': 'm13',
      'icon': Icons.rate_review,
      'iconImage': '',
      'name': '我的评测',
      'enabled': false,
      'linkTarget': '',
    },
  ];

  // 基础组件列表
  final List<ComponentData> _basicComponents = [
    ComponentData(id: '1', name: '轮播', icon: Icons.slideshow, type: 'basic'),
    ComponentData(id: '2', name: '视频', icon: Icons.videocam, type: 'basic'),
    ComponentData(id: '3', name: '分类导航', icon: Icons.category, type: 'basic'),
    ComponentData(id: '4', name: '搜索', icon: Icons.search, type: 'basic'),
    ComponentData(id: '5', name: '地址', icon: Icons.location_on, type: 'basic'),
    ComponentData(id: '6', name: '通知公告', icon: Icons.notifications, type: 'basic'),
    ComponentData(id: '7', name: '标题', icon: Icons.title, type: 'basic'),
    ComponentData(id: '8', name: '图片', icon: Icons.image, type: 'basic'),
    ComponentData(id: '9', name: '橱窗', icon: Icons.store, type: 'basic'),
    ComponentData(id: '10', name: '按钮', icon: Icons.check_circle, type: 'basic'),
    ComponentData(id: '11', name: '分割线', icon: Icons.horizontal_rule, type: 'basic'),
    ComponentData(id: '12', name: '图文列表', icon: Icons.view_list, type: 'basic'),
    ComponentData(id: '13', name: '广告位', icon: Icons.campaign, type: 'basic'),
    ComponentData(id: '14', name: '课程列表', icon: Icons.school, type: 'basic'),
    ComponentData(id: '15', name: '经典语录', icon: Icons.format_quote, type: 'basic'),
    ComponentData(id: '16', name: '推荐列表', icon: Icons.thumb_up, type: 'basic'),
    ComponentData(id: '17', name: '讲师列表', icon: Icons.people, type: 'basic'),
    ComponentData(id: '18', name: '商品列表', icon: Icons.shopping_cart, type: 'basic'),
    ComponentData(id: '19', name: '直播', icon: Icons.live_tv, type: 'basic'),
  ];

  // 营销组件列表
  final List<ComponentData> _marketingComponents = [
    ComponentData(id: 'm1', name: '优惠券', icon: Icons.confirmation_number, type: 'marketing'),
    ComponentData(id: 'm2', name: '拼团', icon: Icons.group_add, type: 'marketing'),
    ComponentData(id: 'm3', name: '秒杀', icon: Icons.flash_on, type: 'marketing'),
    ComponentData(id: 'm4', name: '砍价', icon: Icons.content_cut, type: 'marketing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Column(
        children: [
          // 顶部导航栏
          _buildTopBar(),

          // 主体内容区（三栏布局）
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 最左侧：组件库
                _buildComponentLibrary(),

                // 中间：页面展示区
                Expanded(
                  child: _buildPagePreview(),
                ),

                // 右侧：属性配置面板
                _buildPropertyPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      ),
      child: Row(
        children: [
          // 左侧：返回按钮 + 页面类型下拉框
          Row(
            children: [
              // 返回按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, size: 20, color: Color(0xFF1F2329)),
                        SizedBox(width: 4),
                        Text('返回', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // 页面类型下拉框
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('页面类型：', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedPageType,
                      icon: const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF666666)),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
                      underline: SizedBox(),
                      items: _pageTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPageType = newValue;
                          });
                          debugPrint('✅ 已切换页面类型为: $newValue');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // 右侧：按钮组
          Row(
            children: [
              _buildTopButton('保存', const Color(0xFF1890FF), () => _handleSave()),
              const SizedBox(width: 12),
              _buildTopButton('保存并预览', const Color(0xFF52C41A), () => _handleSaveAndPreview()),
              const SizedBox(width: 12),
              _buildTopButton('发布', const Color(0xFFFA8C16), () => _handlePublish()),
              const SizedBox(width: 12),
              _buildTopButton('存储为模板', const Color(0xFF722ED1), () => _handleSaveAsTemplate()),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部按钮
  Widget _buildTopButton(String text, Color color, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// 构建组件库（最左侧）
  Widget _buildComponentLibrary() {
    // 个人中心页面不需要组件库
    if (_selectedPageType == '个人中心') {
      return Container(
        width: 280,
        height: double.infinity,
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 64,
                color: Color(0xFFCCCCCC),
              ),
              SizedBox(height: 16),
              Text(
                '个人中心页面',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF999999),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '请在右侧配置管理',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCCCCCC),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 280,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
            ),
            child: const Text(
              '组件库',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
            ),
          ),

          // 组件列表
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComponentCategory('基础组件', _basicComponents),
                  const SizedBox(height: 24),
                  _buildComponentCategory('营销组件', _marketingComponents),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建组件分类
  Widget _buildComponentCategory(String title, List<ComponentData> components) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: components.length,
          itemBuilder: (context, index) {
            return _buildDraggableComponent(components[index]);
          },
        ),
      ],
    );
  }

  /// 构建可拖拽的组件
  Widget _buildDraggableComponent(ComponentData component) {
    return Draggable<ComponentData>(
      data: component,
      onDragStarted: () {
        debugPrint('🔵 开始拖拽组件: ${component.name}');
      },
      onDragEnd: (details) {
        debugPrint('🔵 拖拽结束: ${component.name}');
      },
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF1A9B8E),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(component.icon, size: 24, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                component.name,
                style: const TextStyle(fontSize: 11, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      child: DragTarget<ComponentData>(
        onWillAcceptWithDetails: (details) => false,
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F7),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(component.icon, size: 24, color: const Color(0xFF1A9B8E)),
                const SizedBox(height: 4),
                Text(
                  component.name,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF1F2329)),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建页面展示区（中间）
  Widget _buildPagePreview() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          width: 480,
          constraints: const BoxConstraints(minHeight: 800),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // 手机顶部状态栏模拟
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('9:41', style: TextStyle(fontSize: 13, color: Colors.white, height: 1.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.signal_cellular_alt, size: 15, color: Colors.white),
                        SizedBox(width: 5),
                        Icon(Icons.wifi, size: 15, color: Colors.white),
                        SizedBox(width: 5),
                        Icon(Icons.battery_full, size: 15, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),

              // 页面内容区
              Expanded(
                child: _selectedPageType == '个人中心'
                    ? _buildPersonalCenterPreview()
                    : DragTarget<ComponentData>(
                        onWillAcceptWithDetails: (details) {
                          debugPrint('🟢 DragTarget onWillAccept: ${details.data.name}');
                          return true;
                        },
                        onAcceptWithDetails: (details) {
                          final component = details.data;
                          debugPrint('✅ DragTarget onAccept: ${component.name}');
                          setState(() {
                            _pageComponents.add(component);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('已添加组件：${component.name}')),
                          );
                        },
                        onLeave: (data) {
                          debugPrint('🔴 DragTarget onLeave: ${data?.name ?? "null"}');
                        },
                        builder: (context, candidateData, rejectedData) {
                          debugPrint('📦 DragTarget builder: 候选数=${candidateData.length}, 拒绝数=${rejectedData.length}');
                          return Container(
                            color: _pageComponents.isEmpty
                                ? const Color(0xFFF5F6F7)
                                : Colors.white,
                            child: _pageComponents.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_circle_outline, size: 80, color: Color(0xFFCCCCCC)),
                                        SizedBox(height: 20),
                                        Text(
                                          '从左侧拖拽组件到此处',
                                          style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _pageComponents.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: _buildPageComponent(_pageComponents[index], index),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建个人中心页面预览
  Widget _buildPersonalCenterPreview() {
    final avatar = _memberInfo['avatar'] as String? ?? '';
    final nickname = _memberInfo['nickname'] as String? ?? '会员昵称';
    final level = _memberInfo['level'] as String? ?? 'VIP会员';

    // 过滤出启用的功能组件
    final enabledItems = _personalCenterItems.where((item) => item['enabled'] == true).toList();

    // 过滤出启用的命令标签
    final enabledMenus = _personalCenterMenus.where((menu) => menu['enabled'] == true).toList();

    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 会员信息卡片
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // 头像
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: avatar.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              avatar,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.person, size: 30, color: Color(0xFF999999)),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.person, size: 30, color: Color(0xFF999999)),
                          ),
                  ),

                  const SizedBox(width: 16),

                  // 昵称和等级
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          level,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 功能组件区域
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // 第一排（5个）
                  if (enabledItems.length > 0)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: enabledItems.length > 5 ? 5 : enabledItems.length,
                      itemBuilder: (context, index) {
                        final item = enabledItems[index];
                        return _buildPersonalCenterItem(item);
                      },
                    ),

                  const SizedBox(height: 12),

                  // 第二排（5个）
                  if (enabledItems.length > 5)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: enabledItems.length > 10 ? 5 : (enabledItems.length - 5),
                      itemBuilder: (context, index) {
                        final item = enabledItems[index + 5];
                        return _buildPersonalCenterItem(item);
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 命令标签区域
            if (enabledMenus.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    for (var menu in enabledMenus)
                      Column(
                        children: [
                          _buildPersonalCenterMenu(menu),
                          if (menu != enabledMenus.last)
                            const Divider(height: 1, color: Color(0xFFE5E5E5)),
                        ],
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 构建个人中心功能组件项
  Widget _buildPersonalCenterItem(Map<String, dynamic> item) {
    final iconImage = item['iconImage'] as String? ?? '';
    final name = item['name'] as String? ?? '';
    final isSpecial = item['isSpecial'] == true;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 图标
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: iconImage.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    iconImage,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        item['icon'] as IconData? ?? Icons.widgets,
                        size: 20,
                        color: const Color(0xFF999999),
                      );
                    },
                  ),
                )
              : Icon(
                  item['icon'] as IconData? ?? Icons.widgets,
                  size: 20,
                  color: const Color(0xFF999999),
                ),
        ),

        const SizedBox(height: 6),

        // 名字
        Text(
          isSpecial ? (item['nameBefore'] as String? ?? '入驻') : name,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1F2329),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 构建个人中心命令标签项
  Widget _buildPersonalCenterMenu(Map<String, dynamic> menu) {
    final iconImage = menu['iconImage'] as String? ?? '';
    final name = menu['name'] as String? ?? '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 可以添加点击事件
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // 图标
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: iconImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          iconImage,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              menu['icon'] as IconData? ?? Icons.widgets,
                              size: 14,
                              color: const Color(0xFF999999),
                            );
                          },
                        ),
                      )
                    : Icon(
                        menu['icon'] as IconData? ?? Icons.widgets,
                        size: 14,
                        color: const Color(0xFF999999),
                      ),
              ),

              const SizedBox(width: 12),

              // 名称
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2329),
                  ),
                ),
              ),

              // 右箭头
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建页面上的组件
  Widget _buildPageComponent(ComponentData component, int index) {
    final isSelected = _selectedComponentIndex == index;
    final isDragging = _draggingIndex == index;

    return Draggable<ComponentData>(
      data: component,
      onDragStarted: () {
        debugPrint('🔵 开始拖拽组件: ${component.name}, 索引: $index');
        setState(() {
          _draggingIndex = index;
        });
      },
      onDragEnd: (details) {
        debugPrint('🔵 拖拽结束: ${component.name}, 索引: $index');
        setState(() {
          _draggingIndex = null;
        });
      },
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 448,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF1890FF),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ComponentPreviewContent(
            component: component,
            index: index,
            isSelected: isSelected,
            carouselImages: component.name == '轮播' ? _carouselImages : null,
            searchStyle: component.name == '搜索' ? _searchStyle : null,
            categoryNavItems: component.name == '分类导航' ? _categoryNavItems : null,
            categoryNavStyle: component.name == '分类导航' ? _categoryNavStyle : null,
            videoData: component.name == '视频' ? _videoData : null,
            videoStyle: component.name == '视频' ? _videoStyle : null,
            noticeItems: component.name == '通知公告' ? _noticeItems : null,
            noticeConfig: component.name == '通知公告' ? _noticeConfig : null,
            noticeStyle: component.name == '通知公告' ? _noticeStyle : null,
            titleConfig: component.name == '标题' ? _titleConfig : null,
            titleStyle: component.name == '标题' ? _titleStyle : null,
          ),
        ),
      ),
      child: DragTarget<ComponentData>(
        onWillAcceptWithDetails: (details) {
          // 只接受来自列表内部的组件（不是自己）
          final isFromList = _pageComponents.any((c) => c.id == details.data.id);
          final isNotSelf = details.data.id != component.id;
          final result = isFromList && isNotSelf;
          debugPrint('🟢 DragTarget onWillAccept: 组件${component.name}(索引$index) 接收 ${details.data.name}? = $result');
          return result;
        },
        onAcceptWithDetails: (details) {
          debugPrint('✅ DragTarget onAccept: 组件${component.name}(索引$index) 接收 ${details.data.name}');
          final draggedId = details.data.id;
          final fromIndex = _pageComponents.indexWhere((c) => c.id == draggedId);
          debugPrint('📝 拖拽源索引: $fromIndex, 目标索引: $index');

          if (fromIndex != index && fromIndex != -1) {
            setState(() {
              // 移动组件
              final movedComponent = _pageComponents.removeAt(fromIndex);
              _pageComponents.insert(index, movedComponent);
              debugPrint('🔄 已移动组件: ${movedComponent.name} 从 $fromIndex 到 $index');

              // 更新选中索引
              if (_selectedComponentIndex == fromIndex) {
                _selectedComponentIndex = index;
              } else if (_selectedComponentIndex != null && fromIndex < _selectedComponentIndex! && index <= _selectedComponentIndex!) {
                _selectedComponentIndex = _selectedComponentIndex! + 1;
              } else if (_selectedComponentIndex != null && fromIndex > _selectedComponentIndex! && index >= _selectedComponentIndex!) {
                _selectedComponentIndex = _selectedComponentIndex! - 1;
              }
            });
          }
        },
        builder: (context, candidateData, rejectedData) {
          final willAccept = candidateData.isNotEmpty &&
              candidateData.any((data) => data?.id != component.id);

          return Container(
            margin: EdgeInsets.only(bottom: willAccept ? 4 : 12),
            child: Column(
              children: [
                // 拖拽插入指示线
                if (willAccept)
                  Container(
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                // 组件卡片
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('👆 点击组件: ${component.name}, 索引: $index');
                      setState(() {
                        _selectedComponentIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDragging
                            ? Colors.transparent
                            : (isSelected ? const Color(0xFFE6F7FF) : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE5E5E5),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isDragging
                          ? const SizedBox(height: 100)
                          : ComponentPreviewContent(
                              component: component,
                              index: index,
                              isSelected: isSelected,
                              carouselImages: component.name == '轮播' ? _carouselImages : null,
                              searchStyle: component.name == '搜索' ? _searchStyle : null,
                              categoryNavItems: component.name == '分类导航' ? _categoryNavItems : null,
                              categoryNavStyle: component.name == '分类导航' ? _categoryNavStyle : null,
                              videoData: component.name == '视频' ? _videoData : null,
                              videoStyle: component.name == '视频' ? _videoStyle : null,
                              noticeItems: component.name == '通知公告' ? _noticeItems : null,
                              noticeConfig: component.name == '通知公告' ? _noticeConfig : null,
                              noticeStyle: component.name == '通知公告' ? _noticeStyle : null,
                              titleConfig: component.name == '标题' ? _titleConfig : null,
                              titleStyle: component.name == '标题' ? _titleStyle : null,
                              imageConfig: component.name == '图片' ? _imageConfig : null,
                              imageStyle: component.name == '图片' ? _imageStyle : null,
                              showcaseItems: component.name == '橱窗' ? _showcaseItems : null,
                              showcaseStyle: component.name == '橱窗' ? _showcaseStyle : null,
                              buttonConfig: component.name == '按钮' ? _buttonConfig : null,
                              buttonStyle: component.name == '按钮' ? _buttonStyle : null,
                              dividerConfig: component.name == '分割线' ? _dividerConfig : null,
                              dividerStyle: component.name == '分割线' ? _dividerStyle : null,
                              imageTextListItems: component.name == '图文列表' ? _imageTextListItems : null,
                              imageTextListStyle: component.name == '图文列表' ? _imageTextListStyle : null,
                              courseListConfig: component.name == '课程列表' ? _courseListConfig : null,
                              courseListStyle: component.name == '课程列表' ? _courseListStyle : null,
                              recommendListItems: component.name == '推荐列表' ? _recommendListItems : null,
                              recommendListConfig: component.name == '推荐列表' ? _recommendListConfig : null,
                              recommendListStyle: component.name == '推荐列表' ? _recommendListStyle : null,
                              teacherListConfig: component.name == '讲师列表' ? _teacherListConfig : null,
                              teacherListStyle: component.name == '讲师列表' ? _teacherListStyle : null,
                              onDelete: () {
                                setState(() {
                                  _pageComponents.removeAt(index);
                                  if (_selectedComponentIndex == index) {
                                    _selectedComponentIndex = null;
                                  } else if (_selectedComponentIndex != null && _selectedComponentIndex! > index) {
                                    _selectedComponentIndex = _selectedComponentIndex! - 1;
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已删除组件')),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建属性配置面板（右侧）
  Widget _buildPropertyPanel() {
    // 个人中心页面特殊处理
    if (_selectedPageType == '个人中心') {
      return Container(
        width: 320,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
              ),
              child: const Text(
                '个人中心管理',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
            ),

            // 内容区
            Expanded(
              child: _buildPersonalCenterConfig(),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 320,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标签页
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
            ),
            child: Row(
              children: [
                _buildTabItem('组件配置', 0),
                _buildTabItem('组件样式', 1),
                _buildTabItem('模板', 2),
              ],
            ),
          ),

          // 标签内容区
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  /// 构建标签项
  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedTabIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标签内容
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildComponentConfigContent();
      case 1:
        return _buildComponentStyleContent();
      case 2:
        return _buildTemplateContent();
      default:
        return _buildComponentConfigContent();
    }
  }

  /// 组件配置内容
  Widget _buildComponentConfigContent() {
    if (_selectedComponentIndex == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 48, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text(
              '请先从中间选择一个组件',
              style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
          ],
        ),
      );
    }

    final selectedComponent = _pageComponents[_selectedComponentIndex!];

    // 根据不同的组件类型显示不同的配置界面
    switch (selectedComponent.name) {
      case '轮播':
        return _buildCarouselConfig();
      case '视频':
        return _buildVideoConfig();
      case '分类导航':
        return _buildCategoryNavConfig();
      case '通知公告':
        return _buildNoticeConfig();
      case '标题':
        return _buildTitleConfig();
      case '图片':
        return _buildImageConfig();
      case '橱窗':
        return _buildShowcaseConfig();
      case '按钮':
        return _buildButtonConfig();
      case '分割线':
        return _buildDividerConfig();
      case '图文列表':
        return _buildImageTextListConfig();
      case '课程列表':
        return _buildCourseListConfig();
      case '推荐列表':
        return _buildRecommendListConfig();
      case '讲师列表':
        return _buildTeacherListConfig();
      default:
        return _buildDefaultConfig(selectedComponent);
    }
  }

  /// 轮播图配置
  Widget _buildCarouselConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '轮播图配置',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
              Text(
                '${_carouselImages.length} 张',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 轮播图图片列表
          ...List.generate(_carouselImages.length, (index) {
            return _buildCarouselImageItem(index);
          }),

          const SizedBox(height: 12),

          // 添加按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _carouselImages.add({
                    'image': '',
                    'linkType': '无链接',
                    'linkTarget': '',
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1A9B8E), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: Color(0xFF1A9B8E)),
                    SizedBox(width: 6),
                    Text('轮播图', style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建轮播图图片项
  Widget _buildCarouselImageItem(int index) {
    final imageData = _carouselImages[index];
    final selectedImage = imageData['image'] as String;
    final linkType = imageData['linkType'] as String;
    final linkTarget = imageData['linkTarget'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 右上角删除按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _carouselImages.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 图片上传区（独占一行）
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _uploadCarouselImage(index),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: selectedImage.isNotEmpty ? null : const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: selectedImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          selectedImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF999999)),
                            SizedBox(height: 6),
                            Text('点击上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 连接类型
          Row(
            children: [
              const Text('连接类型', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: linkType,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      iconSize: 18,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(value: '无链接', child: Text('无链接')),
                        DropdownMenuItem(value: '文章分类', child: Text('文章分类')),
                        DropdownMenuItem(value: '文章详情列表', child: Text('文章详情列表')),
                        DropdownMenuItem(value: '小程序', child: Text('小程序')),
                        DropdownMenuItem(value: 'VR全景链接', child: Text('VR全景链接')),
                        DropdownMenuItem(value: '课程详情', child: Text('课程详情')),
                        DropdownMenuItem(value: '分类列表', child: Text('分类列表')),
                        DropdownMenuItem(value: '付费预约详情', child: Text('付费预约详情')),
                        DropdownMenuItem(value: '商城商品分类列表（一级分类）', child: Text('商城商品分类列表（一级分类）')),
                        DropdownMenuItem(value: '商城商品分类列表（二级分类）', child: Text('商城商品分类列表（二级分类）')),
                        DropdownMenuItem(value: '商城商品详情', child: Text('商城商品详情')),
                        DropdownMenuItem(value: '余额充值', child: Text('余额充值')),
                        DropdownMenuItem(value: '秒杀商品详情', child: Text('秒杀商品详情')),
                        DropdownMenuItem(value: '砍价商品详情', child: Text('砍价商品详情')),
                        DropdownMenuItem(value: '拼团商品详情', child: Text('拼团商品详情')),
                        DropdownMenuItem(value: '客服', child: Text('客服')),
                        DropdownMenuItem(value: '电话', child: Text('电话')),
                        DropdownMenuItem(value: '分享', child: Text('分享')),
                        DropdownMenuItem(value: '菜单', child: Text('菜单')),
                        DropdownMenuItem(value: '签到', child: Text('签到')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _carouselImages[index]['linkType'] = value;
                            _carouselImages[index]['linkTarget'] = '';
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 链接目标 - 根据不同类型显示不同的输入方式
          if (linkType == '小程序')
            Row(
              children: [
                const Text('小程序', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: linkTarget),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                      ),
                      hintText: '请输入小程序路径',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    onChanged: (value) {
                      setState(() {
                        _carouselImages[index]['linkTarget'] = value;
                      });
                    },
                  ),
                ),
              ],
            )
          else if (linkType == 'VR全景链接')
            Row(
              children: [
                const Text('外链', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: linkTarget),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                      ),
                      hintText: '请输入外链地址',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    onChanged: (value) {
                      setState(() {
                        _carouselImages[index]['linkTarget'] = value;
                      });
                    },
                  ),
                ),
              ],
            )
          else if (linkType == '课程详情' || linkType == '付费预约详情')
            Row(
              children: [
                Text(linkType == '课程详情' ? '课程详情' : '付费预约', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: linkTarget.isNotEmpty ? linkTarget : null,
                        isExpanded: true,
                        hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        dropdownColor: Colors.white,
                        items: _getLinkTargets(linkType),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _carouselImages[index]['linkTarget'] = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (linkType == '分类列表')
            Column(
              children: [
                Row(
                  children: [
                    const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: linkTarget.isNotEmpty ? linkTarget : null,
                            isExpanded: true,
                            hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                            icon: const Icon(Icons.arrow_drop_down, size: 18),
                            iconSize: 18,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                            dropdownColor: Colors.white,
                            items: const [
                              DropdownMenuItem(value: '图文分类', child: Text('图文分类')),
                              DropdownMenuItem(value: '音频分类', child: Text('音频分类')),
                              DropdownMenuItem(value: '视频分类', child: Text('视频分类')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _carouselImages[index]['linkTarget'] = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 第二个分类详情
                Row(
                  children: [
                    const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: imageData['categoryDetail'] as String? ?? '无',
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 18),
                            iconSize: 18,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                            dropdownColor: Colors.white,
                            items: const [
                              DropdownMenuItem(value: '无', child: Text('无')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _carouselImages[index]['categoryDetail'] = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else if (linkType == '商城商品分类列表（一级分类）' || linkType == '商城商品分类列表（二级分类）')
            Row(
              children: [
                const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: linkTarget.isNotEmpty ? linkTarget : null,
                        isExpanded: true,
                        hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        dropdownColor: Colors.white,
                        items: _getLinkTargets(linkType),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _carouselImages[index]['linkTarget'] = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (linkType == '商城商品详情')
            Row(
              children: [
                const Text('商品详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showProductSelectDialog(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                linkTarget.isNotEmpty ? linkTarget : '点击选择商品',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: linkTarget.isNotEmpty ? const Color(0xFF1F2329) : const Color(0xFF999999),
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF999999)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (linkType != '无链接' &&
              linkType != '余额充值' &&
              linkType != '秒杀商品详情' &&
              linkType != '砍价商品详情' &&
              linkType != '拼团商品详情' &&
              linkType != '客服' &&
              linkType != '电话' &&
              linkType != '分享' &&
              linkType != '签到')
            Row(
              children: [
                Text('链接目标', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: linkTarget.isNotEmpty ? linkTarget : null,
                        isExpanded: true,
                        hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        dropdownColor: Colors.white,
                        items: _getLinkTargets(linkType),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _carouselImages[index]['linkTarget'] = value;
                            });
                          }
                        },
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

  /// 获取链接目标列表
  List<DropdownMenuItem<String>> _getLinkTargets(String linkType) {
    switch (linkType) {
      case '文章分类':
        // TODO: 从后端获取文章分类列表
        return const [
          DropdownMenuItem(value: 'category_1', child: Text('技术分享')),
          DropdownMenuItem(value: 'category_2', child: Text('产品更新')),
          DropdownMenuItem(value: 'category_3', child: Text('行业动态')),
        ];

      case '文章详情列表':
        // TODO: 从后端获取所有文章列表
        return const [
          DropdownMenuItem(value: 'article_1', child: Text('论抖音视频对生活的影响')),
          DropdownMenuItem(value: 'article_2', child: Text('如何高效学习编程')),
          DropdownMenuItem(value: 'article_3', child: Text('Flutter 开发实战指南')),
        ];

      case '小程序':
        return const [
          DropdownMenuItem(value: 'miniapp_home', child: Text('首页')),
          DropdownMenuItem(value: 'miniapp_user', child: Text('个人中心')),
        ];

      case 'VR全景链接':
        return const [
          DropdownMenuItem(value: 'vr_1', child: Text('VR场景1')),
          DropdownMenuItem(value: 'vr_2', child: Text('VR场景2')),
        ];

      case '课程详情':
        // TODO: 从后端获取课程列表
        return const [
          DropdownMenuItem(value: 'course_1', child: Text('Python 基础入门')),
          DropdownMenuItem(value: 'course_2', child: Text('Java 高级编程')),
          DropdownMenuItem(value: 'course_3', child: Text('Flutter 实战教程')),
        ];

      case '分类列表':
        return const [
          DropdownMenuItem(value: 'category_list_1', child: Text('分类列表1')),
          DropdownMenuItem(value: 'category_list_2', child: Text('分类列表2')),
        ];

      case '付费预约详情':
        return const [
          DropdownMenuItem(value: 'booking_1', child: Text('预约项目1')),
          DropdownMenuItem(value: 'booking_2', child: Text('预约项目2')),
        ];

      case '商城商品分类列表（一级分类）':
        // TODO: 从后端获取一级商品分类
        return const [
          DropdownMenuItem(value: 'product_category_1_1', child: Text('电子数码')),
          DropdownMenuItem(value: 'product_category_1_2', child: Text('图书音像')),
        ];

      case '商城商品分类列表（二级分类）':
        // TODO: 从后端获取二级商品分类
        return const [
          DropdownMenuItem(value: 'product_category_2_1', child: Text('手机配件')),
          DropdownMenuItem(value: 'product_category_2_2', child: Text('电脑配件')),
        ];

      case '商城商品详情':
        // TODO: 从后端获取商品列表
        return const [
          DropdownMenuItem(value: 'product_1', child: Text('编程入门视频课程')),
          DropdownMenuItem(value: 'product_2', child: Text('开发工具套装')),
        ];

      case '秒杀商品详情':
        return const [
          DropdownMenuItem(value: 'seckill_1', child: Text('秒杀商品1')),
          DropdownMenuItem(value: 'seckill_2', child: Text('秒杀商品2')),
        ];

      case '砍价商品详情':
        return const [
          DropdownMenuItem(value: 'bargain_1', child: Text('砍价商品1')),
          DropdownMenuItem(value: 'bargain_2', child: Text('砍价商品2')),
        ];

      case '拼团商品详情':
        return const [
          DropdownMenuItem(value: 'group_1', child: Text('拼团商品1')),
          DropdownMenuItem(value: 'group_2', child: Text('拼团商品2')),
        ];

      case '客服':
        return const [
          DropdownMenuItem(value: 'customer_service', child: Text('在线客服')),
        ];

      case '电话':
        return const [
          DropdownMenuItem(value: 'phone_400', child: Text('400-123-4567')),
        ];

      case '分享':
        return const [
          DropdownMenuItem(value: 'share_wechat', child: Text('分享到微信')),
          DropdownMenuItem(value: 'share_friends', child: Text('分享到朋友圈')),
        ];

      case '菜单':
        return const [
          DropdownMenuItem(value: 'menu_1', child: Text('菜单1')),
          DropdownMenuItem(value: 'menu_2', child: Text('菜单2')),
        ];

      case '签到':
        return const [
          DropdownMenuItem(value: 'check_in', child: Text('每日签到')),
        ];

      default:
        return [];
    }
  }

  /// 构建链接类型配置区域（可复用）
  List<Widget> _buildLinkTypeSection(
    String linkType,
    String linkTarget,
    void Function(String newLinkType, String newLinkTarget) onChanged,
  ) {
    return [
      // 连接类型
      Row(
        children: [
          const Text('连接类型', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: linkType,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  iconSize: 18,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(value: '无链接', child: Text('无链接')),
                    DropdownMenuItem(value: '文章分类', child: Text('文章分类')),
                    DropdownMenuItem(value: '文章详情列表', child: Text('文章详情列表')),
                    DropdownMenuItem(value: '小程序', child: Text('小程序')),
                    DropdownMenuItem(value: 'VR全景链接', child: Text('VR全景链接')),
                    DropdownMenuItem(value: '课程详情', child: Text('课程详情')),
                    DropdownMenuItem(value: '分类列表', child: Text('分类列表')),
                    DropdownMenuItem(value: '付费预约详情', child: Text('付费预约详情')),
                    DropdownMenuItem(value: '商城商品分类列表（一级分类）', child: Text('商城商品分类列表（一级分类）')),
                    DropdownMenuItem(value: '商城商品分类列表（二级分类）', child: Text('商城商品分类列表（二级分类）')),
                    DropdownMenuItem(value: '商城商品详情', child: Text('商城商品详情')),
                    DropdownMenuItem(value: '余额充值', child: Text('余额充值')),
                    DropdownMenuItem(value: '秒杀商品详情', child: Text('秒杀商品详情')),
                    DropdownMenuItem(value: '砍价商品详情', child: Text('砍价商品详情')),
                    DropdownMenuItem(value: '拼团商品详情', child: Text('拼团商品详情')),
                    DropdownMenuItem(value: '客服', child: Text('客服')),
                    DropdownMenuItem(value: '电话', child: Text('电话')),
                    DropdownMenuItem(value: '分享', child: Text('分享')),
                    DropdownMenuItem(value: '菜单', child: Text('菜单')),
                    DropdownMenuItem(value: '签到', child: Text('签到')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onChanged(value, '');
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      // 链接目标 - 根据不同类型显示不同的输入方式
      if (linkType == '小程序')
        Row(
          children: [
            const Text('小程序', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: linkTarget),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                  ),
                  hintText: '请输入小程序路径',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                onChanged: (value) {
                  onChanged(linkType, value);
                },
              ),
            ),
          ],
        )
      else if (linkType == 'VR全景链接')
        Row(
          children: [
            const Text('外链', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: linkTarget),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF1A9B8E)),
                  ),
                  hintText: '请输入外链地址',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                onChanged: (value) {
                  onChanged(linkType, value);
                },
              ),
            ),
          ],
        )
      else if (linkType == '课程详情' || linkType == '付费预约详情')
        Row(
          children: [
            Text(linkType == '课程详情' ? '课程详情' : '付费预约', style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      else if (linkType == '商城商品详情')
        Row(
          children: [
            const Text('商品详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      else if (linkType == '分类列表')
        Column(
          children: [
            Row(
              children: [
                const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: linkTarget.isNotEmpty ? linkTarget : null,
                        isExpanded: true,
                        hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(value: '图文分类', child: Text('图文分类')),
                          DropdownMenuItem(value: '音频分类', child: Text('音频分类')),
                          DropdownMenuItem(value: '视频分类', child: Text('视频分类')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            onChanged(linkType, value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      else if (linkType == '商城商品分类列表（一级分类）' || linkType == '商城商品分类列表（二级分类）')
        Row(
          children: [
            const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      else if (linkType == '文章分类' || linkType == '文章详情列表')
        Row(
          children: [
            Text(linkType == '文章分类' ? '文章分类' : '文章详情', style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      else if (linkType == '秒杀商品详情' || linkType == '砍价商品详情' || linkType == '拼团商品详情')
        Row(
          children: [
            Text(linkType == '秒杀商品详情' ? '秒杀' : linkType == '砍价商品详情' ? '砍价' : '拼团', style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      else if (linkType == '客服' || linkType == '电话' || linkType == '分享' || linkType == '菜单' || linkType == '签到')
        Row(
          children: [
            Text(linkType, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: linkTarget.isNotEmpty ? linkTarget : null,
                    isExpanded: true,
                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                    iconSize: 18,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    dropdownColor: Colors.white,
                    items: _getLinkTargets(linkType),
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(linkType, value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
    ];
  }

  /// 通知公告配置
  Widget _buildNoticeConfig() {
    final noticeTitle = _noticeConfig['noticeTitle'] as String? ?? '最新头条';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 通知公告管理（红色提示）
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F0),
              border: Border.all(color: const Color(0xFFFF4D4F)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFFFF4D4F)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '手机端公告自动滚动，PC端不做展示',
                    style: TextStyle(fontSize: 12, color: Color(0xFFFF4D4F)),
                  ),
                ),
              ],
            ),
          ),

          // 公告标题
          const Text('公告标题', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: noticeTitle)..selection = TextSelection.fromPosition(TextPosition(offset: noticeTitle.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '最新头条',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _noticeConfig['noticeTitle'] = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // 通知列表
          ..._noticeItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final title = item['title'] as String? ?? '';
            final linkTarget = item['linkTarget'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏（带删除按钮）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('通知内容', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2329))),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _noticeItems.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 标题文字
                  const Text('标题文字', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: title)..selection = TextSelection.fromPosition(TextPosition(offset: title.length)),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: '公告标题',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _noticeItems[index]['title'] = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 链接地址
                  const Text('链接地址', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: linkTarget.isNotEmpty ? linkTarget : null,
                        isExpanded: true,
                        hint: const Text('请选择文章', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        iconSize: 18,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(value: 'article_1', child: Text('论抖音视频对生活的影响')),
                          DropdownMenuItem(value: 'article_2', child: Text('如何高效学习编程')),
                          DropdownMenuItem(value: 'article_3', child: Text('Flutter 开发实战指南')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _noticeItems[index]['linkTarget'] = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          // 添加通知按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _noticeItems.add({
                    'title': '公告标题${_noticeItems.length + 1}',
                    'linkTarget': '',
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1A9B8E), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: Color(0xFF1A9B8E)),
                    SizedBox(width: 6),
                    Text('添加通知', style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 标题配置
  Widget _buildTitleConfig() {
    final titleText = _titleConfig['titleText'] as String? ?? '标题文本';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '标题配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题文本
          const Text('标题文本', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: titleText)..selection = TextSelection.fromPosition(TextPosition(offset: titleText.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '标题文本',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _titleConfig['titleText'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 图片配置
  Widget _buildImageConfig() {
    final imageUrl = _imageConfig['imageUrl'] as String? ?? '';
    final linkType = _imageConfig['linkType'] as String? ?? '无链接';
    final linkTarget = _imageConfig['linkTarget'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '图片配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 图片上传
          const Text('图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showImageUploadDialog(),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48, color: Color(0xFF1A9B8E)),
                            SizedBox(height: 12),
                            Text('点击上传图片', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 连接类型（复用轮播图的链接类型）
          ..._buildLinkTypeSection(linkType, linkTarget, (newLinkType, newLinkTarget) {
            setState(() {
              _imageConfig['linkType'] = newLinkType;
              _imageConfig['linkTarget'] = newLinkTarget;
            });
          }),
        ],
      ),
    );
  }

  /// 橱窗配置
  Widget _buildShowcaseConfig() {
    final showcaseStyle = _showcaseStyle['showcaseStyle'] as String? ?? '两列';

    // 根据橱窗样式确定需要的图片数量
    int requiredImageCount;
    switch (showcaseStyle) {
      case '两列':
        requiredImageCount = 2;
        break;
      case '左一右二':
      case '左二右一':
      case '一行三个':
        requiredImageCount = 3;
        break;
      case '一行四个':
        requiredImageCount = 4;
        break;
      default:
        requiredImageCount = 2;
    }

    // 调整_showcaseItems列表大小
    while (_showcaseItems.length < requiredImageCount) {
      _showcaseItems.add({
        'image': '',
        'linkType': '无链接',
        'linkTarget': '',
      });
    }
    while (_showcaseItems.length > requiredImageCount) {
      _showcaseItems.removeLast();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 提示信息
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FF),
              border: Border.all(color: const Color(0xFF1890FF)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Color(0xFF1890FF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '当前样式需要 $requiredImageCount 张图片',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1890FF)),
                  ),
                ),
              ],
            ),
          ),

          const Text(
            '橱窗图片配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 图片列表
          ..._showcaseItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final image = item['image'] as String? ?? '';
            final linkType = item['linkType'] as String? ?? '无链接';
            final linkTarget = item['linkTarget'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '图片 ${index + 1}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 图片上传
                  const Text('图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showShowcaseImageDialog(index),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF1A9B8E)),
                                    SizedBox(height: 8),
                                    Text('点击上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 连接类型（复用轮播图的链接类型）
                  ..._buildLinkTypeSection(linkType, linkTarget, (newLinkType, newLinkTarget) {
                    setState(() {
                      _showcaseItems[index]['linkType'] = newLinkType;
                      _showcaseItems[index]['linkTarget'] = newLinkTarget;
                    });
                  }),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 按钮配置
  Widget _buildButtonConfig() {
    final buttonText = _buttonConfig['buttonText'] as String? ?? '按钮';
    final linkType = _buttonConfig['linkType'] as String? ?? '无链接';
    final linkTarget = _buttonConfig['linkTarget'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '按钮配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 按钮文字
          const Text('按钮文字', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: buttonText)..selection = TextSelection.fromPosition(TextPosition(offset: buttonText.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '按钮',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _buttonConfig['buttonText'] = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // 连接类型（复用轮播图的链接类型）
          ..._buildLinkTypeSection(linkType, linkTarget, (newLinkType, newLinkTarget) {
            setState(() {
              _buttonConfig['linkType'] = newLinkType;
              _buttonConfig['linkTarget'] = newLinkTarget;
            });
          }),
        ],
      ),
    );
  }

  /// 分割线配置
  Widget _buildDividerConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '分割线配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 提示信息
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F0),
              border: Border.all(color: const Color(0xFFFF4D4F)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFFFF4D4F)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '暂无此配置',
                    style: TextStyle(fontSize: 12, color: Color(0xFFFF4D4F)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 图文列表配置
  Widget _buildImageTextListConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '图文列表管理',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 图文列表
          ..._imageTextListItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final image = item['image'] as String? ?? '';
            final title = item['title'] as String? ?? '';
            final linkType = item['linkType'] as String? ?? '无链接';
            final linkTarget = item['linkTarget'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '图文 ${index + 1}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageTextListItems.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 图片上传
                  const Text('图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showImageTextListImageDialog(index),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF1A9B8E)),
                                    SizedBox(height: 8),
                                    Text('点击上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 标题名称
                  const Text('标题名称', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: title)..selection = TextSelection.fromPosition(TextPosition(offset: title.length)),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: '请输入标题',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _imageTextListItems[index]['title'] = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 连接类型（复用轮播图的链接类型）
                  ..._buildLinkTypeSection(linkType, linkTarget, (newLinkType, newLinkTarget) {
                    setState(() {
                      _imageTextListItems[index]['linkType'] = newLinkType;
                      _imageTextListItems[index]['linkTarget'] = newLinkTarget;
                    });
                  }),
                ],
              ),
            );
          }).toList(),

          // 添加图文按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _imageTextListItems.add({
                    'image': '',
                    'title': '标题${_imageTextListItems.length + 1}',
                    'linkType': '无链接',
                    'linkTarget': '',
                  });
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF1A9B8E)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('添加图文', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 课程列表配置
  Widget _buildCourseListConfig() {
    final title = _courseListConfig['title'] as String? ?? '课程列表';
    final showSales = _courseListConfig['showSales'] as bool? ?? false;
    final showMore = _courseListConfig['showMore'] as bool? ?? false;
    final showSections = _courseListConfig['showSections'] as bool? ?? false;
    final showType = _courseListConfig['showType'] as bool? ?? false;
    final showRefresh = _courseListConfig['showRefresh'] as bool? ?? false;
    final itemCount = _courseListConfig['itemCount'] as int? ?? 4;
    final category = _courseListConfig['category'] as String? ?? '全部分类';
    final categoryDetail = _courseListConfig['categoryDetail'] as String? ?? '全部';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '课程列表配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题
          const Text('标题', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: title)..selection = TextSelection.fromPosition(TextPosition(offset: title.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '课程列表',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _courseListConfig['title'] = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // 开关选项
          _buildSwitchConfig('是否显示销量', showSales, (value) {
            setState(() {
              _courseListConfig['showSales'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示更多', showMore, (value) {
            setState(() {
              _courseListConfig['showMore'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示节数', showSections, (value) {
            setState(() {
              _courseListConfig['showSections'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示类型', showType, (value) {
            setState(() {
              _courseListConfig['showType'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示换一换', showRefresh, (value) {
            setState(() {
              _courseListConfig['showRefresh'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 显示商品数量
          const Text('显示商品数量', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: itemCount,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 4, child: Text('4个')),
                  DropdownMenuItem(value: 6, child: Text('6个')),
                  DropdownMenuItem(value: 8, child: Text('8个')),
                  DropdownMenuItem(value: 10, child: Text('10个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _courseListConfig['itemCount'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 课程分类
          const Text('课程分类', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: category,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '全部分类', child: Text('全部分类')),
                  DropdownMenuItem(value: '编程开发', child: Text('编程开发')),
                  DropdownMenuItem(value: '产品设计', child: Text('产品设计')),
                  DropdownMenuItem(value: '市场营销', child: Text('市场营销')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _courseListConfig['category'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 分类详情
          const Text('分类详情', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: categoryDetail,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '全部', child: Text('全部')),
                  DropdownMenuItem(value: '最新', child: Text('最新')),
                  DropdownMenuItem(value: '最热', child: Text('最热')),
                  DropdownMenuItem(value: '推荐', child: Text('推荐')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _courseListConfig['categoryDetail'] = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 推荐列表配置
  Widget _buildRecommendListConfig() {
    final showMore = _recommendListConfig['showMore'] as bool? ?? false;
    final itemCount = _recommendListConfig['itemCount'] as int? ?? 4;
    final type = _recommendListConfig['type'] as String? ?? '文章';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '推荐列表配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 是否显示更多
          _buildSwitchConfig('是否显示更多', showMore, (value) {
            setState(() {
              _recommendListConfig['showMore'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 显示商品数量
          const Text('显示商品数量', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: itemCount,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 4, child: Text('4个')),
                  DropdownMenuItem(value: 6, child: Text('6个')),
                  DropdownMenuItem(value: 8, child: Text('8个')),
                  DropdownMenuItem(value: 10, child: Text('10个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListConfig['itemCount'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 类型
          const Text('类型', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: type,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '文章', child: Text('文章')),
                  DropdownMenuItem(value: '课程', child: Text('课程')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListConfig['type'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 推荐列表
          ..._recommendListItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final image = item['image'] as String? ?? '';
            final title = item['title'] as String? ?? '';
            final summary = item['summary'] as String? ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '推荐 ${index + 1}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _recommendListItems.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 图片上传
                  const Text('图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showRecommendListImageDialog(index),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF1A9B8E)),
                                    SizedBox(height: 8),
                                    Text('点击上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 标题名称
                  const Text('标题名称', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: title)..selection = TextSelection.fromPosition(TextPosition(offset: title.length)),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: '请输入标题',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _recommendListItems[index]['title'] = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 简介
                  const Text('简介', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: summary)..selection = TextSelection.fromPosition(TextPosition(offset: summary.length)),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: '请输入简介',
                        hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _recommendListItems[index]['summary'] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // 添加推荐按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _recommendListItems.add({
                    'image': '',
                    'title': '推荐${_recommendListItems.length + 1}',
                    'summary': '这是推荐简介',
                  });
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9B8E),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF1A9B8E)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('添加推荐', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 讲师列表配置
  Widget _buildTeacherListConfig() {
    final title = _teacherListConfig['title'] as String? ?? '讲师列表';
    final showSubscribe = _teacherListConfig['showSubscribe'] as bool? ?? false;
    final showMore = _teacherListConfig['showMore'] as bool? ?? false;
    final showRefresh = _teacherListConfig['showRefresh'] as bool? ?? false;
    final teacherCount = _teacherListConfig['teacherCount'] as int? ?? 3;
    final fetchMode = _teacherListConfig['fetchMode'] as String? ?? '自动获取';
    final category = _teacherListConfig['category'] as String? ?? '全部分类';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '讲师列表配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题
          const Text('标题', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: title)..selection = TextSelection.fromPosition(TextPosition(offset: title.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '讲师列表',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _teacherListConfig['title'] = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // 开关选项
          _buildSwitchConfig('是否显示订阅', showSubscribe, (value) {
            setState(() {
              _teacherListConfig['showSubscribe'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示更多', showMore, (value) {
            setState(() {
              _teacherListConfig['showMore'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildSwitchConfig('是否显示换一换', showRefresh, (value) {
            setState(() {
              _teacherListConfig['showRefresh'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 显示讲师数量
          const Text('显示讲师数量', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: teacherCount,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3个')),
                  DropdownMenuItem(value: 6, child: Text('6个')),
                  DropdownMenuItem(value: 9, child: Text('9个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _teacherListConfig['teacherCount'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 添加方式
          const Text('添加方式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: fetchMode,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '自动获取', child: Text('自动获取')),
                  DropdownMenuItem(value: '手动获取', child: Text('手动获取')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _teacherListConfig['fetchMode'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 讲师分类
          const Text('讲师分类', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: category,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '全部分类', child: Text('全部分类')),
                  DropdownMenuItem(value: '金牌讲师', child: Text('金牌讲师')),
                  DropdownMenuItem(value: '银牌讲师', child: Text('银牌讲师')),
                  DropdownMenuItem(value: '铜牌讲师', child: Text('铜牌讲师')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _teacherListConfig['category'] = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 视频配置
  Widget _buildVideoConfig() {
    final coverImage = _videoData['coverImage'] as String? ?? '';
    final videoLink = _videoData['videoLink'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '视频配置',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 视频封面图
          const Text('视频封面图', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showVideoCoverImageDialog(),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: coverImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF1A9B8E)),
                            SizedBox(height: 8),
                            Text('点击选择图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 视频链接
          const Text('视频链接', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: videoLink)..selection = TextSelection.fromPosition(TextPosition(offset: videoLink.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.white,
                filled: true,
                hintText: '请输入视频链接',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              onChanged: (value) {
                setState(() {
                  _videoData['videoLink'] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 分类导航配置（占位）
  Widget _buildCategoryNavConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类列表
          ...List.generate(_categoryNavItems.length, (index) {
            return _buildCategoryNavItem(index);
          }),

          const SizedBox(height: 12),

          // 添加分类按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _categoryNavItems.add({
                    'image': '',
                    'title': '分类${_categoryNavItems.length + 1}',
                    'linkType': '无链接',
                    'linkTarget': '',
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1A9B8E), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: Color(0xFF1A9B8E)),
                    SizedBox(width: 6),
                    Text('添加分类', style: TextStyle(fontSize: 14, color: Color(0xFF1A9B8E), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建单个分类导航项
  Widget _buildCategoryNavItem(int index) {
    final item = _categoryNavItems[index];
    final linkType = item['linkType'] as String? ?? '无链接';
    final linkTarget = item['linkTarget'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 右上角删除按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _categoryNavItems.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 图片上传 + 标题、连接类型
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片上传
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _uploadCategoryImage(index),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: item['image'] != null && item['image'].isNotEmpty ? null : const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD9D9D9)),
                    ),
                    child: item['image'] != null && item['image'].isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, size: 24, color: Color(0xFFCCCCCC)),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 20, color: Color(0xFF999999)),
                                SizedBox(height: 2),
                                Text('上传', style: TextStyle(fontSize: 10, color: Color(0xFF999999))),
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 右侧：标题、连接类型
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题输入
                    const Text('标题', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: TextEditingController(text: item['title'])..selection = TextSelection.fromPosition(TextPosition(offset: item['title'].length)),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _categoryNavItems[index]['title'] = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 连接类型
                    const Text('连接类型', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: linkType,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, size: 18),
                          iconSize: 18,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(value: '无链接', child: Text('无链接')),
                            DropdownMenuItem(value: '文章分类', child: Text('文章分类')),
                            DropdownMenuItem(value: '文章详情列表', child: Text('文章详情列表')),
                            DropdownMenuItem(value: '小程序', child: Text('小程序')),
                            DropdownMenuItem(value: 'VR全景链接', child: Text('VR全景链接')),
                            DropdownMenuItem(value: '课程详情', child: Text('课程详情')),
                            DropdownMenuItem(value: '分类列表', child: Text('分类列表')),
                            DropdownMenuItem(value: '付费预约详情', child: Text('付费预约详情')),
                            DropdownMenuItem(value: '商城商品分类列表（一级分类）', child: Text('商城商品分类列表（一级分类）')),
                            DropdownMenuItem(value: '商城商品分类列表（二级分类）', child: Text('商城商品分类列表（二级分类）')),
                            DropdownMenuItem(value: '商城商品详情', child: Text('商城商品详情')),
                            DropdownMenuItem(value: '余额充值', child: Text('余额充值')),
                            DropdownMenuItem(value: '秒杀商品详情', child: Text('秒杀商品详情')),
                            DropdownMenuItem(value: '砍价商品详情', child: Text('砍价商品详情')),
                            DropdownMenuItem(value: '拼团商品详情', child: Text('拼团商品详情')),
                            DropdownMenuItem(value: '客服', child: Text('客服')),
                            DropdownMenuItem(value: '电话', child: Text('电话')),
                            DropdownMenuItem(value: '分享', child: Text('分享')),
                            DropdownMenuItem(value: '菜单', child: Text('菜单')),
                            DropdownMenuItem(value: '签到', child: Text('签到')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _categoryNavItems[index]['linkType'] = value;
                                _categoryNavItems[index]['linkTarget'] = '';
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    // 链接目标（根据连接类型显示）
                    if (linkType != '无链接' &&
                        linkType != '余额充值' &&
                        linkType != '秒杀商品详情' &&
                        linkType != '砍价商品详情' &&
                        linkType != '拼团商品详情' &&
                        linkType != '客服' &&
                        linkType != '电话' &&
                        linkType != '分享' &&
                        linkType != '签到')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              linkType == '小程序' ? '小程序' :
                              linkType == 'VR全景链接' ? '外链' :
                              linkType == '课程详情' ? '课程详情' :
                              linkType == '分类列表' ? '分类详情' :
                              linkType == '付费预约详情' ? '付费预约' :
                              linkType == '商城商品分类列表（一级分类）' ? '分类详情' :
                              linkType == '商城商品分类列表（二级分类）' ? '分类详情' :
                              linkType == '商城商品详情' ? '商品详情' : '链接目标',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                            const SizedBox(height: 4),
                            if (linkType == '商城商品详情')
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _showProductSelectDialog(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: const Color(0xFFD9D9D9)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            linkTarget.isNotEmpty ? linkTarget : '点击选择商品',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: linkTarget.isNotEmpty ? const Color(0xFF1F2329) : const Color(0xFF999999),
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF999999)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: linkTarget.isNotEmpty ? linkTarget : null,
                                    isExpanded: true,
                                    hint: const Text('请选择', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                                    icon: const Icon(Icons.arrow_drop_down, size: 18),
                                    iconSize: 18,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                                    dropdownColor: Colors.white,
                                    items: _getLinkTargets(linkType),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _categoryNavItems[index]['linkTarget'] = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 默认配置
  Widget _buildDefaultConfig(ComponentData component) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${component.name}配置',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          _buildConfigItem('组件ID', component.id),
          _buildConfigItem('组件名称', component.name),
          _buildConfigItem('可见性', '是'),
          _buildConfigItem('锁定', '否'),
        ],
      ),
    );
  }

  /// 组件样式内容
  Widget _buildComponentStyleContent() {
    if (_selectedComponentIndex == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 48, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text(
              '请先从中间选择一个组件',
              style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
          ],
        ),
      );
    }

    final selectedComponent = _pageComponents[_selectedComponentIndex!];

    // 根据不同的组件类型显示不同的样式配置
    switch (selectedComponent.name) {
      case '轮播':
        return _buildCarouselStyleConfig();
      case '搜索':
        return _buildSearchStyleConfig();
      case '分类导航':
        return _buildCategoryNavStyleConfig();
      case '视频':
        return _buildVideoStyleConfig();
      case '通知公告':
        return _buildNoticeStyleConfig();
      case '标题':
        return _buildTitleStyleConfig();
      case '图片':
        return _buildImageStyleConfig();
      case '橱窗':
        return _buildShowcaseStyleConfig();
      case '按钮':
        return _buildButtonStyleConfig();
      case '分割线':
        return _buildDividerStyleConfig();
      case '图文列表':
        return _buildImageTextListStyleConfig();
      case '课程列表':
        return _buildCourseListStyleConfig();
      case '推荐列表':
        return _buildRecommendListStyleConfig();
      case '讲师列表':
        return _buildTeacherListStyleConfig();
      default:
        return _buildDefaultStyleConfig(selectedComponent);
    }
  }

  /// 模板内容
  Widget _buildTemplateContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '模板设置',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          _buildConfigItem('模板名称', '默认模板'),
          _buildConfigItem('创建时间', '2026-03-08 14:30'),
          _buildConfigItem('最后修改', '2026-03-08 14:30'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FF),
              border: Border.all(color: const Color(0xFF91D5FF)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF1890FF)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '可以在此页面调整组件布局和样式',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1890FF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建配置项
  Widget _buildConfigItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 处理保存
  /// 处理保存
  void _handleSave() {
    // 生成JSON配置
    final jsonData = _generatePageConfigJson();

    // 打印到控制台
    debugPrint('════════════════════════════════════════');
    debugPrint('生成的页面配置JSON：');
    debugPrint(jsonEncode(jsonData));
    debugPrint('════════════════════════════════════════');

    // 显示JSON对话框
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('页面配置JSON'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                JsonEncoder.withIndent('  ').convert(jsonData),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonEncode(jsonData))).then((_) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('已复制到剪贴板')),
                    );
                  }
                });
              },
              child: const Text('复制'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('关闭'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: 调用后端API保存
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('JSON已生成，后端API接口待实现')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9B8E),
              ),
              child: const Text('确定', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// 处理保存并预览
  void _handleSaveAndPreview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功，正在预览...')),
    );
  }

  /// 处理发布
  void _handlePublish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('发布成功')),
    );
  }

  /// 生成页面配置JSON
  Map<String, dynamic> _generatePageConfigJson() {
    // 个人中心页面使用特殊的JSON结构
    if (_selectedPageType == '个人中心') {
      return _generatePersonalCenterJson();
    }

    // 生成组件列表
    final List<Map<String, dynamic>> componentsJson = [];

    for (int i = 0; i < _pageComponents.length; i++) {
      final component = _pageComponents[i];
      final Map<String, dynamic> componentJson = {
        'componentId': 'comp_${DateTime.now().millisecondsSinceEpoch}_$i',
        'componentOrder': i,
        'componentName': component.name,
        'componentType': component.type,
        'config': _getComponentConfig(component.name),
        'style': _getComponentStyle(component.name),
      };
      componentsJson.add(componentJson);
    }

    // 生成完整的页面配置
    return {
      'pageId': 'page_${_selectedPageType}_${DateTime.now().millisecondsSinceEpoch}',
      'pageName': _selectedPageType,
      'pageType': _selectedPageType,
      'version': '1.0.0',
      'lastModified': DateTime.now().toIso8601String(),
      'components': componentsJson,
    };
  }

  /// 生成个人中心页面的JSON
  Map<String, dynamic> _generatePersonalCenterJson() {
    // 生成功能组件列表
    final List<Map<String, dynamic>> functionItemsJson = [];
    for (var item in _personalCenterItems) {
      if (item['enabled'] == true) {
        functionItemsJson.add({
          'id': item['id'],
          'name': item['name'],
          'icon': item['iconImage']?.isNotEmpty == true ? item['iconImage'] : _getIconName(item['icon']),
          'linkTarget': item['linkTarget'] ?? '',
          'isSpecial': item['isSpecial'] == true,
          'nameBefore': item['nameBefore'] ?? '',
          'nameAfter': item['nameAfter'] ?? '',
        });
      }
    }

    // 生成命令标签列表
    final List<Map<String, dynamic>> menuItemsJson = [];
    for (var menu in _personalCenterMenus) {
      if (menu['enabled'] == true) {
        menuItemsJson.add({
          'id': menu['id'],
          'name': menu['name'],
          'icon': menu['iconImage']?.isNotEmpty == true ? menu['iconImage'] : _getIconName(menu['icon']),
          'linkTarget': menu['linkTarget'] ?? '',
        });
      }
    }

    return {
      'pageId': 'page_${_selectedPageType}_${DateTime.now().millisecondsSinceEpoch}',
      'pageName': _selectedPageType,
      'pageType': _selectedPageType,
      'version': '1.0.0',
      'lastModified': DateTime.now().toIso8601String(),
      'memberInfo': {
        'avatar': _memberInfo['avatar'],
        'nickname': _memberInfo['nickname'],
        'level': _memberInfo['level'],
      },
      'functionItems': functionItemsJson,
      'menuItems': menuItemsJson,
    };
  }

  /// 获取图标名称（用于没有自定义图片时）
  String _getIconName(IconData icon) {
    // 返回图标的默认名称，实际使用时可以根据icon映射到字符串
    return 'default_icon';
  }

  /// 获取组件配置数据
  Map<String, dynamic> _getComponentConfig(String componentName) {
    switch (componentName) {
      case '轮播':
        return {
          'images': _carouselImages,
        };
      case '搜索':
        return {
          'placeholder': _searchStyle['placeholder'],
        };
      case '分类导航':
        return {
          'items': _categoryNavItems,
        };
      case '视频':
        return {
          'coverImage': _videoData['coverImage'],
          'videoLink': _videoData['videoLink'],
        };
      case '通知公告':
        return {
          'noticeTitle': _noticeConfig['noticeTitle'],
          'items': _noticeItems,
        };
      case '标题':
        return {
          'titleText': _titleConfig['titleText'],
        };
      case '图片':
        return {
          'imageUrl': _imageConfig['imageUrl'],
          'linkType': _imageConfig['linkType'],
          'linkTarget': _imageConfig['linkTarget'],
        };
      case '橱窗':
        return {
          'items': _showcaseItems,
        };
      case '按钮':
        return {
          'buttonText': _buttonConfig['buttonText'],
          'linkType': _buttonConfig['linkType'],
          'linkTarget': _buttonConfig['linkTarget'],
        };
      case '分割线':
        return {
          'remark': _dividerConfig['remark'],
        };
      case '图文列表':
        return {
          'items': _imageTextListItems,
        };
      case '课程列表':
        return {
          'title': _courseListConfig['title'],
          'showSales': _courseListConfig['showSales'],
          'showMore': _courseListConfig['showMore'],
          'showSections': _courseListConfig['showSections'],
          'showType': _courseListConfig['showType'],
          'showRefresh': _courseListConfig['showRefresh'],
          'itemCount': _courseListConfig['itemCount'],
          'category': _courseListConfig['category'],
          'categoryDetail': _courseListConfig['categoryDetail'],
        };
      case '推荐列表':
        return {
          'showMore': _recommendListConfig['showMore'],
          'itemCount': _recommendListConfig['itemCount'],
          'type': _recommendListConfig['type'],
          'items': _recommendListItems,
        };
      case '讲师列表':
        return {
          'title': _teacherListConfig['title'],
          'showSubscribe': _teacherListConfig['showSubscribe'],
          'showMore': _teacherListConfig['showMore'],
          'showRefresh': _teacherListConfig['showRefresh'],
          'teacherCount': _teacherListConfig['teacherCount'],
          'fetchMode': _teacherListConfig['fetchMode'],
          'category': _teacherListConfig['category'],
        };
      default:
        return {};
    }
  }

  /// 获取组件样式数据
  Map<String, dynamic> _getComponentStyle(String componentName) {
    switch (componentName) {
      case '轮播':
        return _carouselStyle;
      case '搜索':
        return _searchStyle;
      case '分类导航':
        return _categoryNavStyle;
      case '视频':
        return _videoStyle;
      case '通知公告':
        return _noticeStyle;
      case '标题':
        return _titleStyle;
      case '图片':
        return _imageStyle;
      case '橱窗':
        return _showcaseStyle;
      case '按钮':
        return _buttonStyle;
      case '分割线':
        return _dividerStyle;
      case '图文列表':
        return _imageTextListStyle;
      case '课程列表':
        return _courseListStyle;
      case '推荐列表':
        return _recommendListStyle;
      case '讲师列表':
        return _teacherListStyle;
      default:
        return {};
    }
  }

  /// 处理存储为模板
  void _handleSaveAsTemplate() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('存储为模板'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: '模板名称',
                  hintText: '请输入模板名称',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('模板保存成功')),
                );
              },
              child: const Text('确定', style: TextStyle(color: Color(0xFF1A9B8E))),
            ),
          ],
        );
      },
    );
  }

  /// 轮播图样式配置
  Widget _buildCarouselStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '轮播图样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 自动轮播
          _buildSwitchConfig('自动轮播', _carouselStyle['autoPlay'] as bool, (value) {
            setState(() {
              _carouselStyle['autoPlay'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 切换动画时长
          _buildInputConfig('切换动画(ms)', '${_carouselStyle['duration']}', (value) {
            setState(() {
              _carouselStyle['duration'] = int.tryParse(value) ?? 1000;
            });
          }),

          const SizedBox(height: 12),

          // 滑动间隔
          _buildInputConfig('滑动间隔(ms)', '${_carouselStyle['interval']}', (value) {
            setState(() {
              _carouselStyle['interval'] = int.tryParse(value) ?? 4000;
            });
          }),

          const SizedBox(height: 12),

          // 轮播指示点颜色
          _buildColorConfig('轮播指示点', _carouselStyle['indicatorColor'], (value) {
            setState(() {
              _carouselStyle['indicatorColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 选中指示点颜色
          _buildColorConfig('选中指示点', _carouselStyle['activeIndicatorColor'], (value) {
            setState(() {
              _carouselStyle['activeIndicatorColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 轮播高度
          _buildInputConfig('轮播高度(px)', '${_carouselStyle['height']}', (value) {
            setState(() {
              _carouselStyle['height'] = int.tryParse(value) ?? 200;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_carouselStyle['marginTop']}', (value) {
            setState(() {
              _carouselStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_carouselStyle['marginBottom']}', (value) {
            setState(() {
              _carouselStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 左内边距
          _buildInputConfig('左内边距', '${_carouselStyle['paddingLeft']}', (value) {
            setState(() {
              _carouselStyle['paddingLeft'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 右内边距
          _buildInputConfig('右内边距', '${_carouselStyle['paddingRight']}', (value) {
            setState(() {
              _carouselStyle['paddingRight'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 圆角
          _buildInputConfig('圆角', '${_carouselStyle['borderRadius']}', (value) {
            setState(() {
              _carouselStyle['borderRadius'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 搜索样式配置
  Widget _buildSearchStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 组件配置 - 提示词
          const Text(
            '组件配置',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 8),
          _buildInputConfig('提示词', _searchStyle['placeholder'], (value) {
            setState(() {
              _searchStyle['placeholder'] = value;
            });
          }),

          const SizedBox(height: 20),

          // 组件样式
          const Text(
            '组件样式',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 8),

          _buildColorConfig('搜索区背景色', _searchStyle['areaBgColor'], (value) {
            setState(() {
              _searchStyle['areaBgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildColorConfig('搜索框背景色', _searchStyle['boxBgColor'], (value) {
            setState(() {
              _searchStyle['boxBgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildColorConfig('替换文本颜色', _searchStyle['textColor'], (value) {
            setState(() {
              _searchStyle['textColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          _buildColorConfig('边框颜色', _searchStyle['borderColor'], (value) {
            setState(() {
              _searchStyle['borderColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 搜索图标颜色
          Row(
            children: [
              const Text('搜索图标颜色', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _searchStyle['iconColor'],
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, size: 18),
                      iconSize: 18,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                      dropdownColor: Colors.white,
                      items: const [
                        DropdownMenuItem(value: '黑', child: Text('黑')),
                        DropdownMenuItem(value: '白', child: Text('白')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _searchStyle['iconColor'] = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildInputConfig('字体大小', '${_searchStyle['fontSize']}', (value) {
            setState(() {
              _searchStyle['fontSize'] = int.tryParse(value) ?? 14;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('搜索框高度', '${_searchStyle['height']}', (value) {
            setState(() {
              _searchStyle['height'] = int.tryParse(value) ?? 40;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('搜索框宽度(%)', '${_searchStyle['width']}', (value) {
            setState(() {
              _searchStyle['width'] = int.tryParse(value) ?? 90;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('搜索框圆角', '${_searchStyle['borderRadius']}', (value) {
            setState(() {
              _searchStyle['borderRadius'] = int.tryParse(value) ?? 45;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('上内边距', '${_searchStyle['paddingTop']}', (value) {
            setState(() {
              _searchStyle['paddingTop'] = int.tryParse(value) ?? 10;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('下内边距', '${_searchStyle['paddingBottom']}', (value) {
            setState(() {
              _searchStyle['paddingBottom'] = int.tryParse(value) ?? 10;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('上外边距', '${_searchStyle['marginTop']}', (value) {
            setState(() {
              _searchStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('下外边距', '${_searchStyle['marginBottom']}', (value) {
            setState(() {
              _searchStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 分类导航样式配置
  Widget _buildCategoryNavStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '分类导航样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 单行个数（第一行）
          const Text('单行个数', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _categoryNavStyle['itemsPerRow'] as int,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3个')),
                  DropdownMenuItem(value: 4, child: Text('4个')),
                  DropdownMenuItem(value: 5, child: Text('5个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoryNavStyle['itemsPerRow'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 导航样式（第二行）
          const Text('导航样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _categoryNavStyle['navStyle'] as String?,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '单行滑动', child: Text('单行滑动')),
                  DropdownMenuItem(value: '两行清屏', child: Text('两行清屏')),
                  DropdownMenuItem(value: '简介导航', child: Text('简介导航')),
                  DropdownMenuItem(value: '换行', child: Text('换行')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoryNavStyle['navStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 第二行：导航宽度、导航圆角、导航背景色
          _buildInputConfig('导航宽度(%)', '${_categoryNavStyle['navWidth']}', (value) {
            setState(() {
              _categoryNavStyle['navWidth'] = int.tryParse(value) ?? 100;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('导航圆角', '${_categoryNavStyle['navBorderRadius']}', (value) {
            setState(() {
              _categoryNavStyle['navBorderRadius'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          _buildColorConfig('导航背景色', _categoryNavStyle['navBgColor'], (value) {
            setState(() {
              _categoryNavStyle['navBgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 第三行：图标圆角、标题字大小、标题字颜色
          _buildInputConfig('图标圆角', '${_categoryNavStyle['iconBorderRadius']}', (value) {
            setState(() {
              _categoryNavStyle['iconBorderRadius'] = int.tryParse(value) ?? 10;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('标题字大小', '${_categoryNavStyle['titleFontSize']}', (value) {
            setState(() {
              _categoryNavStyle['titleFontSize'] = int.tryParse(value) ?? 13;
            });
          }),

          const SizedBox(height: 12),

          _buildColorConfig('标题字颜色', _categoryNavStyle['titleColor'], (value) {
            setState(() {
              _categoryNavStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 第四行：上外边距、下外边距
          _buildInputConfig('上外边距', '${_categoryNavStyle['marginTop']}', (value) {
            setState(() {
              _categoryNavStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          _buildInputConfig('下外边距', '${_categoryNavStyle['marginBottom']}', (value) {
            setState(() {
              _categoryNavStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 视频样式配置
  Widget _buildVideoStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '视频样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 第一行：是否自动播放
          _buildSwitchConfig('是否自动播放', _videoStyle['autoPlay'] as bool? ?? false, (value) {
            setState(() {
              _videoStyle['autoPlay'] = value;
            });
          }),

          const SizedBox(height: 16),

          // 视频高度
          _buildInputConfig('视频高度', '${_videoStyle['height']}', (value) {
            setState(() {
              _videoStyle['height'] = int.tryParse(value) ?? 200;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_videoStyle['marginTop']}', (value) {
            setState(() {
              _videoStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_videoStyle['marginBottom']}', (value) {
            setState(() {
              _videoStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 左内边距
          _buildInputConfig('左内边距', '${_videoStyle['paddingLeft']}', (value) {
            setState(() {
              _videoStyle['paddingLeft'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 右内边距
          _buildInputConfig('右内边距', '${_videoStyle['paddingRight']}', (value) {
            setState(() {
              _videoStyle['paddingRight'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 通知公告样式配置
  Widget _buildNoticeStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '通知公告样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题是否加粗
          _buildSwitchConfig('标题是否加粗', _noticeStyle['titleBold'] as bool? ?? false, (value) {
            setState(() {
              _noticeStyle['titleBold'] = value;
            });
          }),

          const SizedBox(height: 16),

          // 通知背景颜色
          _buildColorConfig('通知背景颜色', _noticeStyle['bgColor'], (value) {
            setState(() {
              _noticeStyle['bgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 通知标题颜色
          _buildColorConfig('通知标题颜色', _noticeStyle['titleColor'], (value) {
            setState(() {
              _noticeStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 通知文字颜色
          _buildColorConfig('通知文字颜色', _noticeStyle['textColor'], (value) {
            setState(() {
              _noticeStyle['textColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 通知文字大小
          _buildInputConfig('通知文字大小', '${_noticeStyle['fontSize']}', (value) {
            setState(() {
              _noticeStyle['fontSize'] = int.tryParse(value) ?? 14;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_noticeStyle['marginTop']}', (value) {
            setState(() {
              _noticeStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_noticeStyle['marginBottom']}', (value) {
            setState(() {
              _noticeStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 标题样式配置
  Widget _buildTitleStyleConfig() {
    final titleStyleValue = _titleStyle['titleStyle'] as String? ?? '纯标题';
    final bgImage = _titleStyle['bgImage'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '标题样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题样式
          const Text('标题样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: titleStyleValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '纯标题', child: Text('纯标题')),
                  DropdownMenuItem(value: '左圆点', child: Text('左圆点')),
                  DropdownMenuItem(value: '左线条', child: Text('左线条')),
                  DropdownMenuItem(value: '下横线', child: Text('下横线')),
                  DropdownMenuItem(value: '背景图样式', child: Text('背景图样式')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _titleStyle['titleStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题位置
          const Text('标题位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _titleStyle['titlePosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _titleStyle['titlePosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 标题是否加粗
          _buildSwitchConfig('标题是否加粗', _titleStyle['titleBold'] as bool? ?? false, (value) {
            setState(() {
              _titleStyle['titleBold'] = value;
            });
          }),

          // 条件显示：背景图（仅当选择了背景图样式时）
          if (titleStyleValue == '背景图样式') ...[
            const SizedBox(height: 16),
            const Text('标题背景图', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
            const SizedBox(height: 8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showTitleBgImageDialog(),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: bgImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            bgImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 32, color: Color(0xFFCCCCCC)),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF1A9B8E)),
                              SizedBox(height: 8),
                              Text('点击选择图片', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 标题背景色
          _buildColorConfig('标题背景色', _titleStyle['bgColor'], (value) {
            setState(() {
              _titleStyle['bgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 文字颜色
          _buildColorConfig('文字颜色', _titleStyle['textColor'], (value) {
            setState(() {
              _titleStyle['textColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 装饰颜色
          _buildColorConfig('装饰颜色', _titleStyle['accentColor'], (value) {
            setState(() {
              _titleStyle['accentColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 标题大小
          _buildInputConfig('标题大小', '${_titleStyle['fontSize']}', (value) {
            setState(() {
              _titleStyle['fontSize'] = int.tryParse(value) ?? 15;
            });
          }),

          const SizedBox(height: 12),

          // 上内边距
          _buildInputConfig('上内边距', '${_titleStyle['paddingTop']}', (value) {
            setState(() {
              _titleStyle['paddingTop'] = int.tryParse(value) ?? 13;
            });
          }),

          const SizedBox(height: 12),

          // 下内边距
          _buildInputConfig('下内边距', '${_titleStyle['paddingBottom']}', (value) {
            setState(() {
              _titleStyle['paddingBottom'] = int.tryParse(value) ?? 13;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_titleStyle['marginTop']}', (value) {
            setState(() {
              _titleStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_titleStyle['marginBottom']}', (value) {
            setState(() {
              _titleStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 图片样式配置
  Widget _buildImageStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '图片样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 图片位置
          const Text('图片位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _imageStyle['imagePosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _imageStyle['imagePosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 图片宽度
          _buildInputConfig('图片宽度', '${_imageStyle['imageWidth']}', (value) {
            setState(() {
              _imageStyle['imageWidth'] = int.tryParse(value) ?? 375;
            });
          }),

          const SizedBox(height: 12),

          // 图片高度
          _buildInputConfig('图片高度', '${_imageStyle['imageHeight']}', (value) {
            setState(() {
              _imageStyle['imageHeight'] = int.tryParse(value) ?? 100;
            });
          }),

          const SizedBox(height: 12),

          // 图片圆角
          _buildInputConfig('图片圆角', '${_imageStyle['borderRadius']}', (value) {
            setState(() {
              _imageStyle['borderRadius'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 背景颜色
          _buildColorConfig('背景颜色', _imageStyle['bgColor'], (value) {
            setState(() {
              _imageStyle['bgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 上内边距
          _buildInputConfig('上内边距', '${_imageStyle['paddingTop']}', (value) {
            setState(() {
              _imageStyle['paddingTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下内边距
          _buildInputConfig('下内边距', '${_imageStyle['paddingBottom']}', (value) {
            setState(() {
              _imageStyle['paddingBottom'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 左内边距
          _buildInputConfig('左内边距', '${_imageStyle['paddingLeft']}', (value) {
            setState(() {
              _imageStyle['paddingLeft'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 右内边距
          _buildInputConfig('右内边距', '${_imageStyle['paddingRight']}', (value) {
            setState(() {
              _imageStyle['paddingRight'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_imageStyle['marginTop']}', (value) {
            setState(() {
              _imageStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_imageStyle['marginBottom']}', (value) {
            setState(() {
              _imageStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 橱窗样式配置
  Widget _buildShowcaseStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '橱窗样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 橱窗样式
          const Text('橱窗样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _showcaseStyle['showcaseStyle'] as String? ?? '两列',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '两列', child: Text('两列')),
                  DropdownMenuItem(value: '左一右二', child: Text('左一右二')),
                  DropdownMenuItem(value: '左二右一', child: Text('左二右一')),
                  DropdownMenuItem(value: '一行三个', child: Text('一行三个')),
                  DropdownMenuItem(value: '一行四个', child: Text('一行四个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _showcaseStyle['showcaseStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 橱窗高度
          _buildInputConfig('橱窗高度', '${_showcaseStyle['showcaseHeight']}', (value) {
            setState(() {
              _showcaseStyle['showcaseHeight'] = int.tryParse(value) ?? 150;
            });
          }),

          const SizedBox(height: 12),

          // 图片间距
          _buildInputConfig('图片间距', '${_showcaseStyle['imageSpacing']}', (value) {
            setState(() {
              _showcaseStyle['imageSpacing'] = int.tryParse(value) ?? 3;
            });
          }),

          const SizedBox(height: 12),

          // 图片圆角
          _buildInputConfig('图片圆角', '${_showcaseStyle['borderRadius']}', (value) {
            setState(() {
              _showcaseStyle['borderRadius'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 背景颜色
          _buildColorConfig('背景颜色', _showcaseStyle['bgColor'], (value) {
            setState(() {
              _showcaseStyle['bgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 上内边距
          _buildInputConfig('上内边距', '${_showcaseStyle['paddingTop']}', (value) {
            setState(() {
              _showcaseStyle['paddingTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下内边距
          _buildInputConfig('下内边距', '${_showcaseStyle['paddingBottom']}', (value) {
            setState(() {
              _showcaseStyle['paddingBottom'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 左内边距
          _buildInputConfig('左内边距', '${_showcaseStyle['paddingLeft']}', (value) {
            setState(() {
              _showcaseStyle['paddingLeft'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 右内边距
          _buildInputConfig('右内边距', '${_showcaseStyle['paddingRight']}', (value) {
            setState(() {
              _showcaseStyle['paddingRight'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_showcaseStyle['marginTop']}', (value) {
            setState(() {
              _showcaseStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_showcaseStyle['marginBottom']}', (value) {
            setState(() {
              _showcaseStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 按钮样式配置
  Widget _buildButtonStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '按钮样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 按钮位置
          const Text('按钮位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _buttonStyle['buttonPosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _buttonStyle['buttonPosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 按钮背景色
          _buildColorConfig('按钮背景色', _buttonStyle['bgColor'], (value) {
            setState(() {
              _buttonStyle['bgColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 按钮边框颜色
          _buildColorConfig('按钮边框颜色', _buttonStyle['borderColor'], (value) {
            setState(() {
              _buttonStyle['borderColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 文字颜色
          _buildColorConfig('文字颜色', _buttonStyle['textColor'], (value) {
            setState(() {
              _buttonStyle['textColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 文字大小
          _buildInputConfig('文字大小', '${_buttonStyle['fontSize']}', (value) {
            setState(() {
              _buttonStyle['fontSize'] = int.tryParse(value) ?? 15;
            });
          }),

          const SizedBox(height: 12),

          // 按钮宽度
          _buildInputConfig('按钮宽度', '${_buttonStyle['buttonWidth']}', (value) {
            setState(() {
              _buttonStyle['buttonWidth'] = int.tryParse(value) ?? 100;
            });
          }),

          const SizedBox(height: 12),

          // 按钮高度
          _buildInputConfig('按钮高度', '${_buttonStyle['buttonHeight']}', (value) {
            setState(() {
              _buttonStyle['buttonHeight'] = int.tryParse(value) ?? 45;
            });
          }),

          const SizedBox(height: 12),

          // 按钮行高
          _buildInputConfig('按钮行高', '${_buttonStyle['lineHeight']}', (value) {
            setState(() {
              _buttonStyle['lineHeight'] = int.tryParse(value) ?? 45;
            });
          }),

          const SizedBox(height: 12),

          // 按钮圆角
          _buildInputConfig('按钮圆角', '${_buttonStyle['borderRadius']}', (value) {
            setState(() {
              _buttonStyle['borderRadius'] = int.tryParse(value) ?? 8;
            });
          }),

          const SizedBox(height: 12),

          // 上内边距
          _buildInputConfig('上内边距', '${_buttonStyle['paddingTop']}', (value) {
            setState(() {
              _buttonStyle['paddingTop'] = int.tryParse(value) ?? 10;
            });
          }),

          const SizedBox(height: 12),

          // 下内边距
          _buildInputConfig('下内边距', '${_buttonStyle['paddingBottom']}', (value) {
            setState(() {
              _buttonStyle['paddingBottom'] = int.tryParse(value) ?? 10;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_buttonStyle['marginTop']}', (value) {
            setState(() {
              _buttonStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_buttonStyle['marginBottom']}', (value) {
            setState(() {
              _buttonStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 分割线样式配置
  Widget _buildDividerStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '分割线样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 线条样式
          const Text('线条样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dividerStyle['lineStyle'] as String? ?? '实线',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '实线', child: Text('实线')),
                  DropdownMenuItem(value: '虚线', child: Text('虚线')),
                  DropdownMenuItem(value: '点线', child: Text('点线')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _dividerStyle['lineStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 线条位置
          const Text('线条位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dividerStyle['linePosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _dividerStyle['linePosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 线条颜色
          _buildColorConfig('线条颜色', _dividerStyle['lineColor'], (value) {
            setState(() {
              _dividerStyle['lineColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 线条宽度
          _buildInputConfig('线条宽度', '${_dividerStyle['lineWidth']}', (value) {
            setState(() {
              _dividerStyle['lineWidth'] = int.tryParse(value) ?? 375;
            });
          }),

          const SizedBox(height: 12),

          // 线条高度
          _buildInputConfig('线条高度', '${_dividerStyle['lineHeight']}', (value) {
            setState(() {
              _dividerStyle['lineHeight'] = int.tryParse(value) ?? 2;
            });
          }),

          const SizedBox(height: 12),

          // 左内边距
          _buildInputConfig('左内边距', '${_dividerStyle['paddingLeft']}', (value) {
            setState(() {
              _dividerStyle['paddingLeft'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_dividerStyle['marginTop']}', (value) {
            setState(() {
              _dividerStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 图文列表样式配置
  Widget _buildImageTextListStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '图文列表样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 显示简介开关
          _buildSwitchConfig('显示简介', _imageTextListStyle['showSummary'], (value) {
            setState(() {
              _imageTextListStyle['showSummary'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 列表样式
          const Text('列表样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _imageTextListStyle['listStyle'] as String? ?? '单行滑动',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '单行滑动', child: Text('单行滑动')),
                  DropdownMenuItem(value: '列表平铺', child: Text('列表平铺')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _imageTextListStyle['listStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题样式
          const Text('标题样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _imageTextListStyle['titleStyle'] as String? ?? '正常标题',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '悬浮标题', child: Text('悬浮标题')),
                  DropdownMenuItem(value: '正常标题', child: Text('正常标题')),
                  DropdownMenuItem(value: '无标题', child: Text('无标题')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _imageTextListStyle['titleStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 文字位置
          const Text('文字位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _imageTextListStyle['textPosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _imageTextListStyle['textPosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 单行个数
          const Text('单行个数', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _imageTextListStyle['itemsPerRow'] as int? ?? 2,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1个')),
                  DropdownMenuItem(value: 2, child: Text('2个')),
                  DropdownMenuItem(value: 3, child: Text('3个')),
                  DropdownMenuItem(value: 4, child: Text('4个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _imageTextListStyle['itemsPerRow'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题颜色
          _buildColorConfig('标题颜色', _imageTextListStyle['titleColor'], (value) {
            setState(() {
              _imageTextListStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 标题字号
          _buildInputConfig('标题字号', '${_imageTextListStyle['titleFontSize']}', (value) {
            setState(() {
              _imageTextListStyle['titleFontSize'] = int.tryParse(value) ?? 14;
            });
          }),

          const SizedBox(height: 12),

          // 标题行高
          _buildInputConfig('标题行高', '${_imageTextListStyle['titleLineHeight']}', (value) {
            setState(() {
              _imageTextListStyle['titleLineHeight'] = int.tryParse(value) ?? 20;
            });
          }),

          const SizedBox(height: 12),

          // 图片高度
          _buildInputConfig('图片高度', '${_imageTextListStyle['imageHeight']}', (value) {
            setState(() {
              _imageTextListStyle['imageHeight'] = int.tryParse(value) ?? 100;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_imageTextListStyle['marginTop']}', (value) {
            setState(() {
              _imageTextListStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_imageTextListStyle['marginBottom']}', (value) {
            setState(() {
              _imageTextListStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 课程列表样式配置
  Widget _buildCourseListStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '课程列表样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 列表样式
          const Text('列表样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _courseListStyle['listStyle'] as String? ?? '小图',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '小图', child: Text('小图')),
                  DropdownMenuItem(value: '详细列表', child: Text('详细列表')),
                  DropdownMenuItem(value: '大图', child: Text('大图')),
                  DropdownMenuItem(value: '横向滑动', child: Text('横向滑动')),
                  DropdownMenuItem(value: '音频列表', child: Text('音频列表')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _courseListStyle['listStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题颜色
          _buildColorConfig('标题颜色', _courseListStyle['titleColor'], (value) {
            setState(() {
              _courseListStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 标题字大小
          _buildInputConfig('标题字大小', '${_courseListStyle['titleFontSize']}', (value) {
            setState(() {
              _courseListStyle['titleFontSize'] = int.tryParse(value) ?? 15;
            });
          }),

          const SizedBox(height: 12),

          // 价格颜色
          _buildColorConfig('价格颜色', _courseListStyle['priceColor'], (value) {
            setState(() {
              _courseListStyle['priceColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 价格字大小
          _buildInputConfig('价格字大小', '${_courseListStyle['priceFontSize']}', (value) {
            setState(() {
              _courseListStyle['priceFontSize'] = int.tryParse(value) ?? 15;
            });
          }),

          const SizedBox(height: 12),

          // 价格是否加粗
          _buildSwitchConfig('价格是否加粗', _courseListStyle['priceBold'], (value) {
            setState(() {
              _courseListStyle['priceBold'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_courseListStyle['marginTop']}', (value) {
            setState(() {
              _courseListStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_courseListStyle['marginBottom']}', (value) {
            setState(() {
              _courseListStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 推荐列表样式配置
  Widget _buildRecommendListStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '推荐列表样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 是否显示简介开关
          _buildSwitchConfig('是否显示简介', _recommendListStyle['showSummary'], (value) {
            setState(() {
              _recommendListStyle['showSummary'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 列表样式
          const Text('列表样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _recommendListStyle['listStyle'] as String? ?? '单行滑动',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '单行滑动', child: Text('单行滑动')),
                  DropdownMenuItem(value: '列表平铺', child: Text('列表平铺')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListStyle['listStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题样式
          const Text('标题样式', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _recommendListStyle['titleStyle'] as String? ?? '正常标题',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '悬浮标题', child: Text('悬浮标题')),
                  DropdownMenuItem(value: '正常标题', child: Text('正常标题')),
                  DropdownMenuItem(value: '无标题', child: Text('无标题')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListStyle['titleStyle'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 文字位置
          const Text('文字位置', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _recommendListStyle['textPosition'] as String? ?? '居左',
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: '居左', child: Text('居左')),
                  DropdownMenuItem(value: '居中', child: Text('居中')),
                  DropdownMenuItem(value: '居右', child: Text('居右')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListStyle['textPosition'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 单行个数
          const Text('单行个数', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _recommendListStyle['itemsPerRow'] as int? ?? 2,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                iconSize: 18,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1个')),
                  DropdownMenuItem(value: 2, child: Text('2个')),
                  DropdownMenuItem(value: 3, child: Text('3个')),
                  DropdownMenuItem(value: 4, child: Text('4个')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recommendListStyle['itemsPerRow'] = value;
                    });
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 标题颜色
          _buildColorConfig('标题颜色', _recommendListStyle['titleColor'], (value) {
            setState(() {
              _recommendListStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 标题字号
          _buildInputConfig('标题字号', '${_recommendListStyle['titleFontSize']}', (value) {
            setState(() {
              _recommendListStyle['titleFontSize'] = int.tryParse(value) ?? 14;
            });
          }),

          const SizedBox(height: 12),

          // 标题行高
          _buildInputConfig('标题行高', '${_recommendListStyle['titleLineHeight']}', (value) {
            setState(() {
              _recommendListStyle['titleLineHeight'] = int.tryParse(value) ?? 20;
            });
          }),

          const SizedBox(height: 12),

          // 图片高度
          _buildInputConfig('图片高度', '${_recommendListStyle['imageHeight']}', (value) {
            setState(() {
              _recommendListStyle['imageHeight'] = int.tryParse(value) ?? 100;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_recommendListStyle['marginTop']}', (value) {
            setState(() {
              _recommendListStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_recommendListStyle['marginBottom']}', (value) {
            setState(() {
              _recommendListStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 讲师列表样式配置
  Widget _buildTeacherListStyleConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '讲师列表样式',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 标题颜色
          _buildColorConfig('标题颜色', _teacherListStyle['titleColor'], (value) {
            setState(() {
              _teacherListStyle['titleColor'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 标题字大小
          _buildInputConfig('标题字大小', '${_teacherListStyle['titleFontSize']}', (value) {
            setState(() {
              _teacherListStyle['titleFontSize'] = int.tryParse(value) ?? 15;
            });
          }),

          const SizedBox(height: 12),

          // 上外边距
          _buildInputConfig('上外边距', '${_teacherListStyle['marginTop']}', (value) {
            setState(() {
              _teacherListStyle['marginTop'] = int.tryParse(value) ?? 0;
            });
          }),

          const SizedBox(height: 12),

          // 下外边距
          _buildInputConfig('下外边距', '${_teacherListStyle['marginBottom']}', (value) {
            setState(() {
              _teacherListStyle['marginBottom'] = int.tryParse(value) ?? 0;
            });
          }),
        ],
      ),
    );
  }

  /// 个人中心管理配置
  Widget _buildPersonalCenterConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '个人中心管理',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 会员信息
          const Text(
            '会员信息',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 12),

          // 头像
          _buildImageSelector('头像', _memberInfo['avatar'], (value) {
            setState(() {
              _memberInfo['avatar'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 昵称
          _buildInputConfig('会员昵称', _memberInfo['nickname'], (value) {
            setState(() {
              _memberInfo['nickname'] = value;
            });
          }),

          const SizedBox(height: 12),

          // 等级
          _buildInputConfig('会员等级', _memberInfo['level'], (value) {
            setState(() {
              _memberInfo['level'] = value;
            });
          }),

          const SizedBox(height: 24),

          // 功能组件
          const Text(
            '功能组件',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 12),

          // 第一排（5个）
          for (int i = 0; i < 5 && i < _personalCenterItems.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPersonalCenterItemConfig(_personalCenterItems[i]),
            ),

          const SizedBox(height: 12),

          // 第二排（5个）
          for (int i = 5; i < 10 && i < _personalCenterItems.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPersonalCenterItemConfig(_personalCenterItems[i]),
            ),

          const SizedBox(height: 24),

          // 命令标签
          const Text(
            '命令标签',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 12),

          // 命令标签列表
          for (var menu in _personalCenterMenus)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPersonalCenterMenuConfig(menu),
            ),
        ],
      ),
    );
  }

  /// 个人中心功能组件配置项
  Widget _buildPersonalCenterItemConfig(Map<String, dynamic> item) {
    final isSpecial = item['isSpecial'] == true;
    final iconImage = item['iconImage'] as String? ?? '';
    final enabled = item['enabled'] as bool? ?? false;
    final name = item['name'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标选择 + 名称 + 开关
          Row(
            children: [
              // 图标选择
              GestureDetector(
                onTap: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => const ImageUploadDialog(),
                  );
                  if (result != null) {
                    setState(() {
                      item['iconImage'] = result;
                    });
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: iconImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            iconImage,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                item['icon'] as IconData? ?? Icons.widgets,
                                size: 24,
                                color: const Color(0xFF999999),
                              );
                            },
                          ),
                        )
                      : Icon(
                          item['icon'] as IconData? ?? Icons.widgets,
                          size: 24,
                          color: const Color(0xFF999999),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // 名称输入框
              Expanded(
                child: isSpecial
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 讲师申请前（入驻）
                          Row(
                            children: [
                              const Text('前：', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(text: item['nameBefore'] as String? ?? '入驻')
                                      ..selection = TextSelection.fromPosition(TextPosition(offset: (item['nameBefore'] as String? ?? '入驻').length)),
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        item['nameBefore'] = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // 讲师申请后（管理中心）
                          Row(
                            children: [
                              const Text('后：', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(text: item['nameAfter'] as String? ?? '管理中心')
                                      ..selection = TextSelection.fromPosition(TextPosition(offset: (item['nameAfter'] as String? ?? '管理中心').length)),
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        item['nameAfter'] = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: name)
                            ..selection = TextSelection.fromPosition(TextPosition(offset: name.length)),
                          style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                          onChanged: (value) {
                            setState(() {
                              item['name'] = value;
                            });
                          },
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              // 开关
              Switch(
                value: enabled,
                onChanged: (value) {
                  setState(() {
                    item['enabled'] = value;
                  });
                },
                activeColor: const Color(0xFF1A9B8E),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 跳转路径
          Row(
            children: [
              const Text('跳转路径：', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: TextEditingController(text: item['linkTarget'] as String? ?? '')
                      ..selection = TextSelection.fromPosition(TextPosition(offset: (item['linkTarget'] as String? ?? '').length)),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      hintText: '请输入跳转路径',
                      hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        item['linkTarget'] = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 个人中心命令标签配置项
  Widget _buildPersonalCenterMenuConfig(Map<String, dynamic> menu) {
    final iconImage = menu['iconImage'] as String? ?? '';
    final enabled = menu['enabled'] as bool? ?? false;
    final name = menu['name'] as String? ?? '';

    return Column(
      children: [
        Row(
          children: [
            // 图标选择
            GestureDetector(
              onTap: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => const ImageUploadDialog(),
                );
                if (result != null) {
                  setState(() {
                    menu['iconImage'] = result;
                  });
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: iconImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          iconImage,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              menu['icon'] as IconData? ?? Icons.widgets,
                              size: 20,
                              color: const Color(0xFF999999),
                            );
                          },
                        ),
                      )
                    : Icon(
                        menu['icon'] as IconData? ?? Icons.widgets,
                        size: 20,
                        color: const Color(0xFF999999),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // 显示开关
            Row(
              children: [
                const Text('显示', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                const SizedBox(width: 8),
                Checkbox(
                  value: enabled,
                  onChanged: (value) {
                    setState(() {
                      menu['enabled'] = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF1A9B8E),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // 名称输入框
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: TextEditingController(text: name)
                    ..selection = TextSelection.fromPosition(TextPosition(offset: name.length)),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                  onChanged: (value) {
                    setState(() {
                      menu['name'] = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 跳转路径
        Row(
          children: [
            const SizedBox(width: 60),
            const Text('跳转路径：', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: TextEditingController(text: menu['linkTarget'] as String? ?? '')
                    ..selection = TextSelection.fromPosition(TextPosition(offset: (menu['linkTarget'] as String? ?? '').length)),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    hintText: '请输入跳转路径',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      menu['linkTarget'] = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 图片选择器
  Widget _buildImageSelector(String label, String imageUrl, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (context) => const ImageUploadDialog(),
            );
            if (result != null) {
              onChanged(result);
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.add_photo_alternate, size: 24, color: Color(0xFF999999)),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(Icons.add_photo_alternate, size: 24, color: Color(0xFF999999)),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        const Text('点击上传图片', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
      ],
    );
  }

  /// 默认样式配置
  Widget _buildDefaultStyleConfig(ComponentData component) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${component.name}样式',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),
          _buildConfigItem('宽度', '100%'),
          _buildConfigItem('高度', '自适应'),
          _buildConfigItem('背景色', '#FFFFFF'),
          _buildConfigItem('边框', '无'),
        ],
      ),
    );
  }

  /// 构建开关配置
  Widget _buildSwitchConfig(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1A9B8E),
        ),
      ],
    );
  }

  /// 构建输入框配置
  Widget _buildInputConfig(String label, String value, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2329)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              ),
              onSubmitted: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建颜色选择配置
  Widget _buildColorConfig(String label, String value, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showColorPickerDialog(label, value, onChanged),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _parseColor(value),
                        border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1F2329)),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF999999)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 显示颜色选择器对话框
  void _showColorPickerDialog(String label, String currentColor, Function(String) onColorSelected) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '选择$label',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF999999)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 常用颜色色卡
                const Text('常用颜色', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF666666))),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorCard('#1A9B8E', onColorSelected, dialogContext),
                    _buildColorCard('#1890FF', onColorSelected, dialogContext),
                    _buildColorCard('#52C41A', onColorSelected, dialogContext),
                    _buildColorCard('#FA8C16', onColorSelected, dialogContext),
                    _buildColorCard('#F5222D', onColorSelected, dialogContext),
                    _buildColorCard('#FA541C', onColorSelected, dialogContext),
                    _buildColorCard('#722ED1', onColorSelected, dialogContext),
                    _buildColorCard('#EB2F96', onColorSelected, dialogContext),
                  ],
                ),

                const SizedBox(height: 16),

                // 中性色
                const Text('中性色', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF666666))),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorCard('#000000', onColorSelected, dialogContext),
                    _buildColorCard('#333333', onColorSelected, dialogContext),
                    _buildColorCard('#666666', onColorSelected, dialogContext),
                    _buildColorCard('#999999', onColorSelected, dialogContext),
                    _buildColorCard('#CCCCCC', onColorSelected, dialogContext),
                    _buildColorCard('#DDDDDD', onColorSelected, dialogContext),
                    _buildColorCard('#EEEEEE', onColorSelected, dialogContext),
                    _buildColorCard('#FFFFFF', onColorSelected, dialogContext),
                    _buildColorCard('#F5F6F7', onColorSelected, dialogContext),
                    _buildColorCard('#FAFAFA', onColorSelected, dialogContext),
                    _buildColorCard('#E5E5E5', onColorSelected, dialogContext),
                    _buildColorCard('#D9D9D9', onColorSelected, dialogContext),
                  ],
                ),

                const SizedBox(height: 20),

                // 自定义输入
                Row(
                  children: [
                    const Text('自定义：', style: TextStyle(fontSize: 13, color: Color(0xFF1F2329))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                            hintText: '#FFFFFF',
                            hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                          ),
                          onSubmitted: (value) {
                            if (value.startsWith('#') && value.length == 7) {
                              onColorSelected(value);
                              Navigator.of(dialogContext).pop();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建颜色卡片
  Widget _buildColorCard(String colorHex, Function(String) onColorSelected, BuildContext dialogContext) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onColorSelected(colorHex);
          Navigator.of(dialogContext).pop();
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _parseColor(colorHex),
            border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示商品选择弹窗
  void _showProductSelectDialog(int imageIndex) {
    // 模拟商品数据
    final List<Map<String, dynamic>> products = List.generate(20, (index) {
      return {
        'id': 'product_${index + 1}',
        'name': '商品名称 ${index + 1}',
        'price': (index + 1) * 100.0,
        'image': 'https://via.placeholder.com/80x80',
      };
    });

    String? selectedProductId;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Container(
                width: 700,
                height: 600,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    const Text(
                      '商品',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
                    ),

                    const SizedBox(height: 20),

                    // 搜索框 + 查询按钮
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFD9D9D9)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '商品名称',
                                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                // 执行查询操作
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A9B8E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '查询',
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 商品列表
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final isSelected = selectedProductId == product['id'];

                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    selectedProductId = product['id'];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFE6F7FF) : Colors.white,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE5E5E5),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      // 商品图片
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F6F7),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.image, size: 30, color: Color(0xFFCCCCCC)),
                                      ),
                                      const SizedBox(width: 12),
                                      // 商品信息
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'],
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1F2329)),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '¥${product['price']}',
                                              style: const TextStyle(fontSize: 14, color: Color(0xFFFA541C)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 选中图标
                                      if (isSelected)
                                        const Icon(Icons.check_circle, size: 20, color: Color(0xFF1890FF)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 底部提示文字
                    Text(
                      '共${products.length}条，每页18条',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),

                    const SizedBox(height: 16),

                    // 确定按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => Navigator.of(dialogContext).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFD9D9D9)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '取消',
                                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (selectedProductId != null) {
                                setState(() {
                                  final product = products.firstWhere((p) => p['id'] == selectedProductId);
                                  _carouselImages[imageIndex]['linkTarget'] = product['name'];
                                });
                                Navigator.of(dialogContext).pop();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedProductId != null ? const Color(0xFF1A9B8E) : const Color(0xFFCCCCCC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '确定',
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 上传图片（分类导航）
  Future<void> _uploadCategoryImage(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _categoryNavItems[index]['image'] = result;
      });
    }
  }

  /// 上传图片（轮播图）
  Future<void> _uploadCarouselImage(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _carouselImages[index]['image'] = result;
      });
    }
  }

  /// 选择视频封面图
  Future<void> _showVideoCoverImageDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _videoData['coverImage'] = result;
      });
    }
  }

  /// 选择标题背景图
  Future<void> _showTitleBgImageDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _titleStyle['bgImage'] = result;
      });
    }
  }

  /// 选择图片
  Future<void> _showImageUploadDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _imageConfig['imageUrl'] = result;
      });
    }
  }

  /// 选择橱窗图片
  Future<void> _showShowcaseImageDialog(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _showcaseItems[index]['image'] = result;
      });
    }
  }

  /// 选择图文列表图片
  Future<void> _showImageTextListImageDialog(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _imageTextListItems[index]['image'] = result;
      });
    }
  }

  /// 选择推荐列表图片
  Future<void> _showRecommendListImageDialog(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const ImageUploadDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _recommendListItems[index]['image'] = result;
      });
    }
  }

  /// 解析颜色
  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Colors.black;
    } catch (e) {
      return Colors.black;
    }
  }
}
