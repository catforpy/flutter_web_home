import 'package:flutter/material.dart';

/// 应用尺寸配置
/// 统一管理所有尺寸，方便后续修改
class AppSizes {
  // 间距
  static const double xs = 4.0;    // 极小间距
  static const double sm = 8.0;    // 小间距
  static const double md = 16.0;   // 中间距
  static const double lg = 24.0;   // 大间距
  static const double xl = 32.0;   // 超大间距
  static const double xxl = 48.0;  // 特大间距
  static const double xxxl = 64.0; // 巨大间距

  // 字体大小
  static const double fsSm = 12.0;   // 小字
  static const double fsMd = 14.0;   // 中等字
  static const double fsLg = 16.0;   // 大字
  static const double fsXl = 18.0;   // 超大字
  static const double fs2xl = 24.0;  // 标题小
  static const double fs3xl = 32.0;  // 标题中
  static const double fs4xl = 48.0;  // 标题大

  // 圆角
  static const double radiusSm = 4.0;   // 小圆角
  static const double radiusMd = 8.0;   // 中圆角
  static const double radiusLg = 16.0;  // 大圆角
  static const double radiusXl = 24.0;  // 超大圆角

  // 阴影
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  // 屏幕断点
  static const double breakpointMobile = 640.0;   // 手机
  static const double breakpointTablet = 768.0;   // 平板
  static const double breakpointDesktop = 1024.0; // 桌面

  // 卡片尺寸
  static const double cardMinHeight = 200.0;
  static const double cardMaxWidth = 400.0;

  // 按钮高度
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;

  // 图标大小
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // 禁用私有构造函数
  AppSizes._();
}
