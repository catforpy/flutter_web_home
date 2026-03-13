import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

class DividerComponent extends PageComponent {
  final DividerStyle style;

  const DividerComponent({
    required super.id,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '分割线',
          type: ComponentType.divider,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      margin: style.margin,
      child: style.style == DividerStyleType.dashed
          ? _buildDashedDivider()
          : style.style == DividerStyleType.dotted
              ? _buildDottedDivider()
              : Divider(
                  color: style.color,
                  thickness: style.thickness,
                  height: style.height,
                ),
    );
  }

  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = style.dashWidth;
        final dashSpace = style.dashSpace;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Flex(
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: style.thickness,
              color: style.color,
            );
          }).expand((element) => [element, SizedBox(width: dashSpace)]).toList()
            ..removeLast(),
        );
      },
    );
  }

  Widget _buildDottedDivider() {
    return Flex(
      direction: Axis.horizontal,
      children: List.generate(
        100,
        (_) => Container(
          width: style.dashWidth,
          height: style.thickness,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: style.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('分割线编辑器 - 待实现'));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'style': style.toJson(),
      };

  factory DividerComponent.fromJson(Map<String, dynamic> json) {
    return DividerComponent(
      id: json['id'] as String,
      style: json['style'] != null
          ? DividerStyle.fromJson(json['style'] as Map<String, dynamic>)
          : DividerStyle.defaultStyle,
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
    DividerStyle? style,
  }) {
    return DividerComponent(
      id: id ?? this.id,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

enum DividerStyleType { solid, dashed, dotted }

class DividerStyle extends ComponentStyle {
  final double thickness;
  final double height;
  final Color color;
  final DividerStyleType style;
  final double dashWidth;
  final double dashSpace;

  const DividerStyle({
    this.thickness = 1,
    this.height = 32,
    this.color = const Color(0xFFE5E5E5),
    this.style = DividerStyleType.solid,
    this.dashWidth = 6,
    this.dashSpace = 4,
    super.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  static const defaultStyle = DividerStyle();

  @override
  Map<String, dynamic> toJson() => {
        'thickness': thickness,
        'height': height,
        'color': ColorUtils.serializeColor(color),
        'style': style.name,
        'dashWidth': dashWidth,
        'dashSpace': dashSpace,
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
      };

  factory DividerStyle.fromJson(Map<String, dynamic> json) {
    return DividerStyle(
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1,
      height: (json['height'] as num?)?.toDouble() ?? 32,
      color: ColorUtils.parseColor(json['color'] as String?) ?? const Color(0xFFE5E5E5),
      style: _parseDividerStyleType(json['style'] as String?),
      dashWidth: (json['dashWidth'] as num?)?.toDouble() ?? 6,
      dashSpace: (json['dashSpace'] as num?)?.toDouble() ?? 4,
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 8,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 8,
      ),
    );
  }

  static DividerStyleType _parseDividerStyleType(String? value) {
    switch (value) {
      case 'solid':
        return DividerStyleType.solid;
      case 'dashed':
        return DividerStyleType.dashed;
      case 'dotted':
        return DividerStyleType.dotted;
      default:
        return DividerStyleType.solid;
    }
  }
}
