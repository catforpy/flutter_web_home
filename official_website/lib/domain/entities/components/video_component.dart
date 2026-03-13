import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 视频组件
class VideoComponent extends PageComponent {
  final String videoUrl;
  final String? coverUrl;
  final bool autoPlay;
  final bool showControls;
  final VideoStyle style;

  const VideoComponent({
    required super.id,
    required this.videoUrl,
    this.coverUrl,
    this.autoPlay = false,
    this.showControls = true,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '视频',
          type: ComponentType.video,
        );

  @override
  Widget buildPreview(BuildContext context) {
    // TODO: 实现预览
    return Container(
      height: style.height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 64),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) {
    return const Center(child: Text('视频编辑器 - 待实现'));
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'videoUrl': videoUrl,
        'coverUrl': coverUrl,
        'autoPlay': autoPlay,
        'showControls': showControls,
        'style': style.toJson(),
      };

  factory VideoComponent.fromJson(Map<String, dynamic> json) {
    return VideoComponent(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String? ?? '',
      coverUrl: json['coverUrl'] as String?,
      autoPlay: json['autoPlay'] as bool? ?? false,
      showControls: json['showControls'] as bool? ?? true,
      style: json['style'] != null
          ? VideoStyle.fromJson(json['style'] as Map<String, dynamic>)
          : VideoStyle.defaultStyle,
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
    String? videoUrl,
    String? coverUrl,
    bool? autoPlay,
    bool? showControls,
    VideoStyle? style,
  }) {
    return VideoComponent(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      autoPlay: autoPlay ?? this.autoPlay,
      showControls: showControls ?? this.showControls,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 视频样式
class VideoStyle extends ComponentStyle {
  final double height;

  const VideoStyle({
    this.height = 200,
    super.margin,
    super.padding,
    super.borderRadius,
    super.backgroundColor,
  });

  static const defaultStyle = VideoStyle();

  @override
  Map<String, dynamic> toJson() => {
        'height': height,
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
        'borderRadius': borderRadius,
        'backgroundColor': ColorUtils.serializeColor(backgroundColor ?? const Color(0xFFFFFFFF)),
      };

  factory VideoStyle.fromJson(Map<String, dynamic> json) {
    return VideoStyle(
      height: (json['height'] as num?)?.toDouble() ?? 200,
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 0,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 0,
      ),
      padding: EdgeInsets.only(
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 0,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 0,
      ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0,
      backgroundColor: ColorUtils.parseColor(json['backgroundColor'] as String?),
    );
  }
}
