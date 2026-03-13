import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

class ButtonComponent extends PageComponent {
  final String text;
  final String? linkType;
  final String? linkTarget;
  final ComponentButtonStyle style;

  const ButtonComponent({
    required super.id,
    required this.text,
    this.linkType,
    this.linkTarget,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '按钮',
          type: ComponentType.button,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      margin: style.margin,
      alignment: style.alignment,
      child: SizedBox(
        width: style.width,
        height: style.height,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: style.backgroundColor,
            foregroundColor: style.textColor,
            padding: style.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(style.borderRadius),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: style.fontSize),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('按钮编辑器 - 待实现'));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'text': text,
        'linkType': linkType,
        'linkTarget': linkTarget,
        'style': style.toJson(),
      };

  factory ButtonComponent.fromJson(Map<String, dynamic> json) {
    return ButtonComponent(
      id: json['id'] as String,
      text: json['text'] as String? ?? '按钮',
      linkType: json['linkType'] as String?,
      linkTarget: json['linkTarget'] as String?,
      style: json['style'] != null
          ? ComponentButtonStyle.fromJson(json['style'] as Map<String, dynamic>)
          : ComponentButtonStyle.defaultStyle,
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
    String? text,
    String? linkType,
    String? linkTarget,
    ComponentButtonStyle? style,
  }) {
    return ButtonComponent(
      id: id ?? this.id,
      text: text ?? this.text,
      linkType: linkType ?? this.linkType,
      linkTarget: linkTarget ?? this.linkTarget,
      style: style as ComponentButtonStyle? ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ComponentButtonStyle extends ComponentStyle {
  final double? width;
  final double? height;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final AlignmentGeometry alignment;

  const ComponentButtonStyle({
    this.width,
    this.height,
    this.fontSize = 16,
    this.backgroundColor = const Color(0xFF1A9B8E),
    this.textColor = Colors.white,
    this.alignment = Alignment.center,
    super.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    super.borderRadius = 8,
  });

  static const defaultStyle = ComponentButtonStyle();

  @override
  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'fontSize': fontSize,
        'backgroundColor': ColorUtils.serializeColor(backgroundColor ?? const Color(0xFFFFFFFF)),
        'textColor': ColorUtils.serializeColor(textColor),
        'alignment': alignment.toString(),
        'paddingTop': padding.top,
        'paddingBottom': padding.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
        'borderRadius': borderRadius,
      };

  factory ComponentButtonStyle.fromJson(Map<String, dynamic> json) {
    return ComponentButtonStyle(
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16,
      backgroundColor: ColorUtils.parseColor(json['backgroundColor'] as String?) ?? const Color(0xFF1A9B8E),
      textColor: ColorUtils.parseColor(json['textColor'] as String?) ?? Colors.white,
      alignment: _parseAlignment(json['alignment'] as String?),
      padding: EdgeInsets.only(
        top: (json['paddingTop'] as num?)?.toDouble() ?? 12,
        bottom: (json['paddingBottom'] as num?)?.toDouble() ?? 12,
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 24,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 24,
      ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 8,
    );
  }

  static AlignmentGeometry _parseAlignment(String? value) {
    switch (value) {
      case 'Alignment.center':
        return Alignment.center;
      case 'Alignment.centerLeft':
        return Alignment.centerLeft;
      case 'Alignment.centerRight':
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}
