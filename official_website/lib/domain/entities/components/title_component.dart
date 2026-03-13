import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

class TitleComponent extends PageComponent {
  final String text;
  final TitleStyle style;

  const TitleComponent({
    required super.id,
    required this.text,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '标题',
          type: ComponentType.title,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      padding: style.padding,
      margin: style.margin,
      child: Text(
        text,
        style: TextStyle(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          color: style.textColor,
          height: style.lineHeight,
        ),
        textAlign: style.textAlign,
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('标题编辑器 - 待实现'));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'text': text,
        'style': style.toJson(),
      };

  factory TitleComponent.fromJson(Map<String, dynamic> json) {
    return TitleComponent(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      style: json['style'] != null
          ? TitleStyle.fromJson(json['style'] as Map<String, dynamic>)
          : TitleStyle.defaultStyle,
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
    TitleStyle? style,
  }) {
    return TitleComponent(
      id: id ?? this.id,
      text: text ?? this.text,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class TitleStyle extends ComponentStyle {
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign textAlign;
  final double lineHeight;

  const TitleStyle({
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
    this.textColor = const Color(0xFF1F2329),
    this.textAlign = TextAlign.left,
    this.lineHeight = 1.4,
    super.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  static const defaultStyle = TitleStyle();

  @override
  Map<String, dynamic> toJson() => {
        'fontSize': fontSize,
        'fontWeight': fontWeight.toString(),
        'textColor': ColorUtils.serializeColor(textColor),
        'textAlign': textAlign.name,
        'lineHeight': lineHeight,
        'paddingTop': padding.top,
        'paddingBottom': padding.bottom,
      };

  factory TitleStyle.fromJson(Map<String, dynamic> json) {
    return TitleStyle(
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 18,
      fontWeight: _parseFontWeight(json['fontWeight'] as String?),
      textColor: ColorUtils.parseColor(json['textColor'] as String?) ?? const Color(0xFF1F2329),
      textAlign: _parseTextAlign(json['textAlign'] as String?),
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.4,
      padding: EdgeInsets.only(
        top: (json['paddingTop'] as num?)?.toDouble() ?? 8,
        bottom: (json['paddingBottom'] as num?)?.toDouble() ?? 8,
      ),
    );
  }

  static FontWeight _parseFontWeight(String? value) {
    switch (value) {
      case 'FontWeight.w100':
        return FontWeight.w100;
      case 'FontWeight.w200':
        return FontWeight.w200;
      case 'FontWeight.w300':
        return FontWeight.w300;
      case 'FontWeight.w400':
        return FontWeight.w400;
      case 'FontWeight.w500':
        return FontWeight.w500;
      case 'FontWeight.w600':
        return FontWeight.w600;
      case 'FontWeight.w700':
        return FontWeight.w700;
      case 'FontWeight.w800':
        return FontWeight.w800;
      case 'FontWeight.w900':
        return FontWeight.w900;
      default:
        return FontWeight.w600;
    }
  }

  static TextAlign _parseTextAlign(String? value) {
    switch (value) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}
