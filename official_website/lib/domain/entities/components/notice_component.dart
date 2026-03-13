import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 通知公告组件
class NoticeComponent extends PageComponent {
  final List<NoticeItem> items;
  final NoticeConfig config;
  final NoticeStyle style;

  const NoticeComponent({
    required super.id,
    required this.items,
    required this.config,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '通知公告',
          type: ComponentType.notice,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      padding: style.padding,
      margin: style.margin,
      decoration: BoxDecoration(
        color: style.backgroundColor ?? Colors.amber[50],
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: Row(
        children: [
          Icon(config.icon, size: config.iconSize, color: style.iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              items.isNotEmpty ? items.first.content : '暂无公告',
              style: TextStyle(fontSize: style.fontSize),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) {
    return const Center(child: Text('公告编辑器 - 待实现'));
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'items': items.map((e) => e.toJson()).toList(),
        'config': config.toJson(),
        'style': style.toJson(),
      };

  factory NoticeComponent.fromJson(Map<String, dynamic> json) {
    return NoticeComponent(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => NoticeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      config: json['config'] != null
          ? NoticeConfig.fromJson(json['config'] as Map<String, dynamic>)
          : NoticeConfig.defaultConfig,
      style: json['style'] != null
          ? NoticeStyle.fromJson(json['style'] as Map<String, dynamic>)
          : NoticeStyle.defaultStyle,
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
    List<NoticeItem>? items,
    NoticeConfig? config,
    NoticeStyle? style,
  }) {
    return NoticeComponent(
      id: id ?? this.id,
      items: items ?? this.items,
      config: config ?? this.config,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 公告项
class NoticeItem {
  final String content;
  final String? linkUrl;

  const NoticeItem({
    required this.content,
    this.linkUrl,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'linkUrl': linkUrl,
      };

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    return NoticeItem(
      content: json['content'] as String? ?? '',
      linkUrl: json['linkUrl'] as String?,
    );
  }
}

/// 公告配置
class NoticeConfig {
  final IconData icon;
  final double iconSize;
  final bool autoPlay;
  final Duration interval;

  const NoticeConfig({
    this.icon = Icons.notifications_active,
    this.iconSize = 20,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 3),
  });

  static const defaultConfig = NoticeConfig();

  Map<String, dynamic> toJson() => {
        'iconName': icon.codePoint.toString(),
        'iconSize': iconSize,
        'autoPlay': autoPlay,
        'interval': interval.inMilliseconds,
      };

  factory NoticeConfig.fromJson(Map<String, dynamic> json) {
    return NoticeConfig(
      iconSize: (json['iconSize'] as num?)?.toDouble() ?? 20,
      autoPlay: json['autoPlay'] as bool? ?? true,
      interval: Duration(
          milliseconds: json['interval'] as int? ?? 3000),
    );
  }
}

/// 公告样式
class NoticeStyle extends ComponentStyle {
  final double fontSize;
  final Color textColor;
  final Color iconColor;

  const NoticeStyle({
    this.fontSize = 14,
    this.textColor = const Color(0xFF1F2329),
    this.iconColor = const Color(0xFF1A9B8E),
    super.margin,
    super.padding,
    super.borderRadius,
    super.backgroundColor,
  });

  static const defaultStyle = NoticeStyle();

  @override
  Map<String, dynamic> toJson() => {
        'fontSize': fontSize,
        'textColor': ColorUtils.serializeColor(textColor),
        'iconColor': ColorUtils.serializeColor(iconColor),
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
        'borderRadius': borderRadius,
        'backgroundColor': ColorUtils.serializeColor(backgroundColor ?? const Color(0xFFFFFFFF)),
      };

  factory NoticeStyle.fromJson(Map<String, dynamic> json) {
    return NoticeStyle(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
      textColor: ColorUtils.parseColor(json['textColor'] as String?) ?? const Color(0xFF1F2329),
      iconColor: ColorUtils.parseColor(json['iconColor'] as String?) ?? const Color(0xFF1A9B8E),
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 0,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 0,
      ),
      padding: EdgeInsets.only(
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 12,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 12,
      ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0,
      backgroundColor: ColorUtils.parseColor(json['backgroundColor'] as String?),
    );
  }
}
