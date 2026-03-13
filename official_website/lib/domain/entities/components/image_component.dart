import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/page_component.dart';

class ImageComponent extends PageComponent {
  final String imageUrl;
  final String? linkType;
  final String? linkTarget;
  final ImageStyle style;

  const ImageComponent({
    required super.id,
    required this.imageUrl,
    this.linkType,
    this.linkTarget,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '图片',
          type: ComponentType.image,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      margin: style.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(style.borderRadius),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: style.width,
                height: style.height,
                fit: style.boxFit,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: style.width,
      height: style.height ?? 200,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('图片编辑器 - 待实现'));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'imageUrl': imageUrl,
        'linkType': linkType,
        'linkTarget': linkTarget,
        'style': style.toJson(),
      };

  factory ImageComponent.fromJson(Map<String, dynamic> json) {
    return ImageComponent(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      linkType: json['linkType'] as String?,
      linkTarget: json['linkTarget'] as String?,
      style: json['style'] != null
          ? ImageStyle.fromJson(json['style'] as Map<String, dynamic>)
          : ImageStyle.defaultStyle,
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
    String? imageUrl,
    String? linkType,
    String? linkTarget,
    ImageStyle? style,
  }) {
    return ImageComponent(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      linkType: linkType ?? this.linkType,
      linkTarget: linkTarget ?? this.linkTarget,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ImageStyle extends ComponentStyle {
  final double? width;
  final double? height;
  final BoxFit boxFit;

  const ImageStyle({
    this.width,
    this.height,
    this.boxFit = BoxFit.cover,
    super.margin,
    super.borderRadius,
  });

  static const defaultStyle = ImageStyle();

  @override
  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'boxFit': boxFit.name,
        'marginTop': margin.top,
        'marginBottom': margin.bottom,
        'marginLeft': margin.left,
        'marginRight': margin.right,
        'borderRadius': borderRadius,
      };

  factory ImageStyle.fromJson(Map<String, dynamic> json) {
    return ImageStyle(
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      boxFit: _parseBoxFit(json['boxFit'] as String?),
      margin: EdgeInsets.only(
        top: (json['marginTop'] as num?)?.toDouble() ?? 0,
        bottom: (json['marginBottom'] as num?)?.toDouble() ?? 0,
        left: (json['marginLeft'] as num?)?.toDouble() ?? 0,
        right: (json['marginRight'] as num?)?.toDouble() ?? 0,
      ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 0,
    );
  }

  static BoxFit _parseBoxFit(String? value) {
    switch (value) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }
}
