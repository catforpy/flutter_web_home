import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/components/carousel_component.dart';
import 'package:official_website/domain/entities/components/video_component.dart';
import 'package:official_website/domain/entities/components/notice_component.dart';
import 'package:official_website/domain/entities/components/search_component.dart';
import 'package:official_website/domain/entities/components/category_nav_component.dart';
import 'package:official_website/domain/entities/components/title_component.dart';
import 'package:official_website/domain/entities/components/image_component.dart';
import 'package:official_website/domain/entities/components/showcase_component.dart';
import 'package:official_website/domain/entities/components/button_component.dart';
import 'package:official_website/domain/entities/components/divider_component.dart';

/// 页面组件基类
///
/// 所有页面组件的抽象基类，定义了组件的基本属性和行为
abstract class PageComponent {
  /// 组件唯一标识
  final String id;

  /// 组件名称
  final String name;

  /// 组件类型
  final ComponentType type;

  /// 是否启用
  final bool enabled;

  /// 排序顺序
  final int sortOrder;

  const PageComponent({
    required this.id,
    required this.name,
    required this.type,
    this.enabled = true,
    this.sortOrder = 0,
  });

  /// 构建预览组件
  Widget buildPreview(BuildContext context);

  /// 构建编辑器
  Widget buildEditor(BuildContext context);

  /// 序列化为 JSON
  Map<String, dynamic> toJson();

  /// 从 JSON 创建组件
  static PageComponent fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String?;
    final type = ComponentType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => ComponentType.unknown,
    );

    switch (type) {
      case ComponentType.carousel:
        return CarouselComponent.fromJson(json);
      case ComponentType.video:
        return VideoComponent.fromJson(json);
      case ComponentType.notice:
        return NoticeComponent.fromJson(json);
      case ComponentType.search:
        return SearchComponent.fromJson(json);
      case ComponentType.categoryNav:
        return CategoryNavComponent.fromJson(json);
      case ComponentType.title:
        return TitleComponent.fromJson(json);
      case ComponentType.image:
        return ImageComponent.fromJson(json);
      case ComponentType.showcase:
        return ShowcaseComponent.fromJson(json);
      case ComponentType.button:
        return ButtonComponent.fromJson(json);
      case ComponentType.divider:
        return DividerComponent.fromJson(json);
      default:
        throw UnimplementedError('Component type $type is not implemented');
    }
  }

  /// 复制组件并修改部分属性
  PageComponent copyWith({
    String? id,
    String? name,
    ComponentType? type,
    bool? enabled,
    int? sortOrder,
  });
}

/// 组件类型枚举
enum ComponentType {
  /// 轮播图
  carousel('轮播', Icons.slideshow),

  /// 搜索框
  search('搜索', Icons.search),

  /// 分类导航
  categoryNav('分类导航', Icons.category),

  /// 视频
  video('视频', Icons.video_library),

  /// 通知公告
  notice('通知公告', Icons.notifications),

  /// 标题
  title('标题', Icons.title),

  /// 图片
  image('图片', Icons.image),

  /// 橱窗
  showcase('橱窗', Icons.store),

  /// 按钮
  button('按钮', Icons.smart_button),

  /// 分割线
  divider('分割线', Icons.horizontal_rule),

  /// 图文列表
  imageTextList('图文列表', Icons.view_list),

  /// 课程列表
  courseList('课程列表', Icons.school),

  /// 推荐列表
  recommendList('推荐列表', Icons.recommend),

  /// 讲师列表
  teacherList('讲师列表', Icons.people),

  /// 未知类型
  unknown('未知', Icons.help_outline);

  final String displayName;
  final IconData icon;

  const ComponentType(this.displayName, this.icon);
}

/// 组件样式基类
abstract class ComponentStyle {
  /// 外边距
  final EdgeInsets margin;

  /// 内边距
  final EdgeInsets padding;

  /// 圆角
  final double borderRadius;

  /// 背景颜色
  final Color? backgroundColor;

  const ComponentStyle({
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 0.0,
    this.backgroundColor,
  });

  /// 序列化为 JSON
  Map<String, dynamic> toJson();

  /// 从 JSON 创建样式
  static ComponentStyle? fromJsonDynamic(Map<String, dynamic>? json) {
    if (json == null) return null;
    // 子类实现
    return null;
  }

  /// 解析颜色
  static Color? parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  /// 序列化颜色
  static String? serializeColor(Color? color) {
    if (color == null) return null;
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
