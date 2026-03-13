import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 轮播组件
class CarouselComponent extends PageComponent {
  /// 轮播图片列表
  final List<CarouselImage> images;

  /// 轮播样式
  final CarouselStyle style;

  const CarouselComponent({
    required super.id,
    required this.images,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '轮播',
          type: ComponentType.carousel,
        );

  @override
  Widget buildPreview(BuildContext context) {
    // TODO: 实现预览组件
    return Container(
      height: style.height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: const Center(
        child: Icon(Icons.slideshow, size: 48),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) {
    // TODO: 实现编辑器
    return const Center(
      child: Text('轮播编辑器 - 待实现'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'images': images.map((e) => e.toJson()).toList(),
        'style': style.toJson(),
      };

  factory CarouselComponent.fromJson(Map<String, dynamic> json) {
    return CarouselComponent(
      id: json['id'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => CarouselImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      style: json['style'] != null
          ? CarouselStyle.fromJson(json['style'] as Map<String, dynamic>)
          : CarouselStyle.defaultStyle,
      enabled: json['enabled'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  @override
  PageComponent copyWith({
    String? id,
    String? name,
    ComponentType? type,
    bool? enabled,
    int? sortOrder,
    List<CarouselImage>? images,
    CarouselStyle? style,
  }) {
    return CarouselComponent(
      id: id ?? this.id,
      images: images ?? this.images,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 轮播图片
class CarouselImage {
  /// 图片 URL
  final String url;

  /// 链接类型
  final String linkType;

  /// 链接目标
  final String linkTarget;

  const CarouselImage({
    required this.url,
    required this.linkType,
    required this.linkTarget,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'linkType': linkType,
        'linkTarget': linkTarget,
      };

  factory CarouselImage.fromJson(Map<String, dynamic> json) {
    return CarouselImage(
      url: json['url'] as String? ?? '',
      linkType: json['linkType'] as String? ?? '无链接',
      linkTarget: json['linkTarget'] as String? ?? '',
    );
  }

  CarouselImage copyWith({
    String? url,
    String? linkType,
    String? linkTarget,
  }) {
    return CarouselImage(
      url: url ?? this.url,
      linkType: linkType ?? this.linkType,
      linkTarget: linkTarget ?? this.linkTarget,
    );
  }
}

/// 轮播样式
class CarouselStyle extends ComponentStyle {
  /// 是否自动播放
  final bool autoPlay;

  /// 动画持续时间
  final Duration duration;

  /// 播放间隔
  final Duration interval;

  /// 指示器颜色
  final Color indicatorColor;

  /// 当前指示器颜色
  final Color activeIndicatorColor;

  /// 轮播高度
  final double height;

  const CarouselStyle({
    this.autoPlay = true,
    this.duration = const Duration(milliseconds: 1000),
    this.interval = const Duration(milliseconds: 4000),
    this.indicatorColor = Colors.white,
    this.activeIndicatorColor = const Color(0xFF1A9B8E),
    this.height = 200.0,
    super.margin = EdgeInsets.zero,
    super.padding = EdgeInsets.zero,
    super.borderRadius = 0.0,
    super.backgroundColor,
  });

  /// 默认样式
  static const defaultStyle = CarouselStyle();

  @override
  Map<String, dynamic> toJson() => {
        'autoPlay': autoPlay,
        'duration': duration.inMilliseconds,
        'interval': interval.inMilliseconds,
        'indicatorColor': ColorUtils.serializeColor(indicatorColor),
        'activeIndicatorColor': ColorUtils.serializeColor(activeIndicatorColor),
        'height': height,
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
        'borderRadius': borderRadius,
        'backgroundColor': ColorUtils.serializeColor(backgroundColor ?? const Color(0xFFFFFFFF)),
      };

  factory CarouselStyle.fromJson(Map<String, dynamic> json) {
    return CarouselStyle(
      autoPlay: json['autoPlay'] as bool? ?? true,
      duration: Duration(milliseconds: json['duration'] as int? ?? 1000),
      interval: Duration(milliseconds: json['interval'] as int? ?? 4000),
      indicatorColor: ColorUtils.parseColor(json['indicatorColor'] as String?) ??
          Colors.white,
      activeIndicatorColor:
          ColorUtils.parseColor(json['activeIndicatorColor'] as String?) ??
              const Color(0xFF1A9B8E),
      height: (json['height'] as num?)?.toDouble() ?? 200.0,
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 0.0,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 0.0,
      ),
      padding: EdgeInsets.only(
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 0.0,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 0.0,
      ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0.0,
      backgroundColor: ColorUtils.parseColor(json['backgroundColor'] as String?),
    );
  }

  CarouselStyle copyWith({
    bool? autoPlay,
    Duration? duration,
    Duration? interval,
    Color? indicatorColor,
    Color? activeIndicatorColor,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? backgroundColor,
  }) {
    return CarouselStyle(
      autoPlay: autoPlay ?? this.autoPlay,
      duration: duration ?? this.duration,
      interval: interval ?? this.interval,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      height: height ?? this.height,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
