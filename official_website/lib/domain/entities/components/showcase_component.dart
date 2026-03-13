import 'package:flutter/material.dart';
import 'package:official_website/domain/utils/color_utils.dart';
import 'package:official_website/domain/entities/page_component.dart';

class ShowcaseComponent extends PageComponent {
  final List<ShowcaseItem> items;
  final ShowcaseStyle style;

  const ShowcaseComponent({
    required super.id,
    required this.items,
    required this.style,
    super.enabled = true,
    super.sortOrder = 0,
  }) : super(
          name: '橱窗',
          type: ComponentType.showcase,
        );

  @override
  Widget buildPreview(BuildContext context) {
    return Container(
      padding: style.padding,
      margin: style.margin,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: style.columnCount,
          crossAxisSpacing: style.spacing,
          mainAxisSpacing: style.spacing,
          childAspectRatio: style.aspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(style.imageBorderRadius),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                style: TextStyle(fontSize: style.titleFontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.price != null)
                Text(
                  '¥${item.price}',
                  style: TextStyle(
                    fontSize: style.priceFontSize,
                    color: style.priceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget buildEditor(BuildContext context) => const Center(child: Text('橱窗编辑器 - 待实现'));

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

  factory ShowcaseComponent.fromJson(Map<String, dynamic> json) {
    return ShowcaseComponent(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShowcaseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      style: json['style'] != null
          ? ShowcaseStyle.fromJson(json['style'] as Map<String, dynamic>)
          : ShowcaseStyle.defaultStyle,
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
    List<ShowcaseItem>? items,
    ShowcaseStyle? style,
  }) {
    return ShowcaseComponent(
      id: id ?? this.id,
      items: items ?? this.items,
      style: style ?? this.style,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ShowcaseItem {
  final String imageUrl;
  final String title;
  final String? price;
  final String? linkType;
  final String? linkTarget;

  const ShowcaseItem({
    required this.imageUrl,
    required this.title,
    this.price,
    this.linkType,
    this.linkTarget,
  });

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'title': title,
        'price': price,
        'linkType': linkType,
        'linkTarget': linkTarget,
      };

  factory ShowcaseItem.fromJson(Map<String, dynamic> json) {
    return ShowcaseItem(
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: json['price'] as String?,
      linkType: json['linkType'] as String?,
      linkTarget: json['linkTarget'] as String?,
    );
  }
}

class ShowcaseStyle extends ComponentStyle {
  final int columnCount;
  final double spacing;
  final double aspectRatio;
  final double imageBorderRadius;
  final double titleFontSize;
  final double priceFontSize;
  final Color priceColor;

  const ShowcaseStyle({
    this.columnCount = 2,
    this.spacing = 8,
    this.aspectRatio = 1.0,
    this.imageBorderRadius = 4,
    this.titleFontSize = 14,
    this.priceFontSize = 16,
    this.priceColor = const Color(0xFFFF6B00),
    super.padding = const EdgeInsets.all(8),
  });

  static const defaultStyle = ShowcaseStyle();

  @override
  Map<String, dynamic> toJson() => {
        'columnCount': columnCount,
        'spacing': spacing,
        'aspectRatio': aspectRatio,
        'imageBorderRadius': imageBorderRadius,
        'titleFontSize': titleFontSize,
        'priceFontSize': priceFontSize,
        'priceColor': ColorUtils.serializeColor(priceColor),
        'paddingTop': padding.top,
        'paddingBottom': padding.bottom,
        'paddingLeft': padding.left,
        'paddingRight': padding.right,
      };

  factory ShowcaseStyle.fromJson(Map<String, dynamic> json) {
    return ShowcaseStyle(
      columnCount: json['columnCount'] as int? ?? 2,
      spacing: (json['spacing'] as num?)?.toDouble() ?? 8,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 1.0,
      imageBorderRadius: (json['imageBorderRadius'] as num?)?.toDouble() ?? 4,
      titleFontSize: (json['titleFontSize'] as num?)?.toDouble() ?? 14,
      priceFontSize: (json['priceFontSize'] as num?)?.toDouble() ?? 16,
      priceColor: ColorUtils.parseColor(json['priceColor'] as String?) ?? const Color(0xFFFF6B00),
      padding: EdgeInsets.only(
        top: (json['paddingTop'] as num?)?.toDouble() ?? 8,
        bottom: (json['paddingBottom'] as num?)?.toDouble() ?? 8,
        left: (json['paddingLeft'] as num?)?.toDouble() ?? 8,
        right: (json['paddingRight'] as num?)?.toDouble() ?? 8,
      ),
    );
  }
}
