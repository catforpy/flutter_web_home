import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 搜索组件
class SearchComponent extends PageComponent {
  final SearchConfig config;
  final SearchStyle style;

  const SearchComponent({
    required super.id,
    required this.config,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '搜索',
          type: ComponentType.search,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      height: style.height,
      margin: style.margin,
      decoration: BoxDecoration(
        color: style.areaBackgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: style.boxHeight,
          decoration: BoxDecoration(
            color: style.boxBackgroundColor,
            borderRadius: BorderRadius.circular(style.boxBorderRadius),
            border: Border.all(color: style.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: style.iconColor,
                size: style.iconSize,
              ),
              const SizedBox(width: 8),
              Text(
                config.placeholder,
                style: TextStyle(
                  color: style.textColor,
                  fontSize: style.fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) {
    return const Center(child: Text('搜索编辑器 - 待实现'));
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'config': config.toJson(),
        'style': style.toJson(),
      };

  factory SearchComponent.fromJson(Map<String, dynamic> json) {
    return SearchComponent(
      id: json['id'] as String,
      config: json['config'] != null
          ? SearchConfig.fromJson(json['config'] as Map<String, dynamic>)
          : SearchConfig.defaultConfig,
      style: json['style'] != null
          ? SearchStyle.fromJson(json['style'] as Map<String, dynamic>)
          : SearchStyle.defaultStyle,
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
    SearchConfig? config,
    SearchStyle? style,
  }) {
    return SearchComponent(
      id: id ?? this.id,
      config: config ?? this.config,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 搜索配置
class SearchConfig {
  final String placeholder;

  const SearchConfig({
    this.placeholder = '请输入搜索内容',
  });

  static const defaultConfig = SearchConfig();

  Map<String, dynamic> toJson() => {
        'placeholder': placeholder,
      };

  factory SearchConfig.fromJson(Map<String, dynamic> json) {
    return SearchConfig(
      placeholder: json['placeholder'] as String? ?? '请输入搜索内容',
    );
  }
}

/// 搜索样式
class SearchStyle extends ComponentStyle {
  final double height;
  final double boxHeight;
  final double boxBorderRadius;
  final Color areaBackgroundColor;
  final Color boxBackgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final double iconSize;
  final double fontSize;

  const SearchStyle({
    this.height = 60,
    this.boxHeight = 40,
    this.boxBorderRadius = 45,
    this.areaBackgroundColor = const Color(0xFFF5F6F7),
    this.boxBackgroundColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF1F2329),
    this.borderColor = const Color(0xFFD9D9D9),
    this.iconColor = const Color(0xFF999999),
    this.iconSize = 20,
    this.fontSize = 14,
    super.margin,
  });

  static const defaultStyle = SearchStyle();

  @override
  Map<String, dynamic> toJson() => {
        'height': height,
        'boxHeight': boxHeight,
        'boxBorderRadius': boxBorderRadius,
        'areaBackgroundColor': ColorUtils.serializeColor(areaBackgroundColor),
        'boxBackgroundColor': ColorUtils.serializeColor(boxBackgroundColor),
        'textColor': ColorUtils.serializeColor(textColor),
        'borderColor': ColorUtils.serializeColor(borderColor),
        'iconColor': ColorUtils.serializeColor(iconColor),
        'iconSize': iconSize,
        'fontSize': fontSize,
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
      };

  factory SearchStyle.fromJson(Map<String, dynamic> json) {
    return SearchStyle(
      height: (json['height'] as num?)?.toDouble() ?? 60,
      boxHeight: (json['boxHeight'] as num?)?.toDouble() ?? 40,
      boxBorderRadius: (json['boxBorderRadius'] as num?)?.toDouble() ?? 45,
      areaBackgroundColor: ColorUtils.parseColor(json['areaBackgroundColor'] as String?) ??
          const Color(0xFFF5F6F7),
      boxBackgroundColor: ColorUtils.parseColor(json['boxBackgroundColor'] as String?) ??
          const Color(0xFFFFFFFF),
      textColor: ColorUtils.parseColor(json['textColor'] as String?) ?? const Color(0xFF1F2329),
      borderColor: ColorUtils.parseColor(json['borderColor'] as String?) ?? const Color(0xFFD9D9D9),
      iconColor: ColorUtils.parseColor(json['iconColor'] as String?) ?? const Color(0xFF999999),
      iconSize: (json['iconSize'] as num?)?.toDouble() ?? 20,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 0,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 0,
      ),
    );
  }

  SearchStyle copyWith({
    double? height,
    double? boxHeight,
    double? boxBorderRadius,
    Color? areaBackgroundColor,
    Color? boxBackgroundColor,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    double? iconSize,
    double? fontSize,
    EdgeInsets? margin,
  }) {
    return SearchStyle(
      height: height ?? this.height,
      boxHeight: boxHeight ?? this.boxHeight,
      boxBorderRadius: boxBorderRadius ?? this.boxBorderRadius,
      areaBackgroundColor: areaBackgroundColor ?? this.areaBackgroundColor,
      boxBackgroundColor: boxBackgroundColor ?? this.boxBackgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      margin: margin ?? this.margin,
    );
  }
}
