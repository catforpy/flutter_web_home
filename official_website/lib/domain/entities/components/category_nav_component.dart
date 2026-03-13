import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 分类导航组件
class CategoryNavComponent extends PageComponent {
  final List<CategoryNavItem> items;
  final CategoryNavStyle style;

  const CategoryNavComponent({
    required super.id,
    required this.items,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '分类导航',
          type: ComponentType.categoryNav,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      padding: style.padding,
      child: Wrap(
        spacing: style.spacing,
        runSpacing: style.runSpacing,
        children: items.take(4).map((item) {
          return SizedBox(
            width: style.itemWidth,
            child: Column(
              children: [
                if (item.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(style.imageBorderRadius),
                    child: Image.network(
                      item.imageUrl,
                      width: style.imageSize,
                      height: style.imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: style.imageSize,
                        height: style.imageSize,
                        color: Colors.grey[300],
                      ),
                    ),
                  )
                else
                  Container(
                    width: style.imageSize,
                    height: style.imageSize,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(style.imageBorderRadius),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: TextStyle(fontSize: style.fontSize),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('分类导航编辑器 - 待实现'));

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'enabled': enabled,
        'sortOrder': sortOrder,
        'items': items.map((e) => e.toJson()).toList(),
        'style': style.toJson(),
      };

  factory CategoryNavComponent.fromJson(Map<String, dynamic> json) {
    return CategoryNavComponent(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CategoryNavItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      style: json['style'] != null
          ? CategoryNavStyle.fromJson(json['style'] as Map<String, dynamic>)
          : CategoryNavStyle.defaultStyle,
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
    List<CategoryNavItem>? items,
    CategoryNavStyle? style,
  }) {
    return CategoryNavComponent(
      id: id ?? this.id,
      items: items ?? this.items,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class CategoryNavItem {
  final String imageUrl;
  final String title;
  final String linkType;
  final String linkTarget;

  const CategoryNavItem({
    required this.imageUrl,
    required this.title,
    required this.linkType,
    required this.linkTarget,
  });

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'title': title,
        'linkType': linkType,
        'linkTarget': linkTarget,
      };

  factory CategoryNavItem.fromJson(Map<String, dynamic> json) {
    return CategoryNavItem(
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      linkType: json['linkType'] as String? ?? '无链接',
      linkTarget: json['linkTarget'] as String? ?? '',
    );
  }
}

class CategoryNavStyle extends ComponentStyle {
  final double itemWidth;
  final double imageSize;
  final double imageBorderRadius;
  final double fontSize;
  final double spacing;
  final double runSpacing;

  const CategoryNavStyle({
    this.itemWidth = 80,
    this.imageSize = 48,
    this.imageBorderRadius = 8,
    this.fontSize = 14,
    this.spacing = 16,
    this.runSpacing = 16,
    super.padding = const EdgeInsets.all(16),
  });

  static const defaultStyle = CategoryNavStyle();

  @override
  Map<String, dynamic> toJson() => {
        'itemWidth': itemWidth,
        'imageSize': imageSize,
        'imageBorderRadius': imageBorderRadius,
        'fontSize': fontSize,
        'spacing': spacing,
        'runSpacing': runSpacing,
        'paddingTop': padding.top,
        'paddingBottom': padding.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
      };

  factory CategoryNavStyle.fromJson(Map<String, dynamic> json) {
    return CategoryNavStyle(
      itemWidth: (json['itemWidth'] as num?)?.toDouble() ?? 80,
      imageSize: (json['imageSize'] as num?)?.toDouble() ?? 48,
      imageBorderRadius: (json['imageBorderRadius'] as num?)?.toDouble() ?? 8,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
      spacing: (json['spacing'] as num?)?.toDouble() ?? 16,
      runSpacing: (json['runSpacing'] as num?)?.toDouble() ?? 16,
      padding: EdgeInsets.only(
        top: (json['paddingTop'] as num?)?.toDouble() ?? 16,
        bottom: (json['paddingBottom'] as num?)?.toDouble() ?? 16,
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 16,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 16,
      ),
    );
  }
}
