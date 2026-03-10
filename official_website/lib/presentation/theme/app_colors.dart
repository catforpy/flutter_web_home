import 'package:flutter/material.dart';

/// 应用颜色定义
/// 定义Light和Dark主题的颜色
class AppColors {
  // ==================== Light主题颜色 ====================

  /// 主色
  static const Color primary = Color(0xFF2196F3); // Blue
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// 次要色
  static const Color secondary = Color(0xFF03DAC6); // Teal
  static const Color onSecondary = Color(0xFF000000);

  /// 第三色
  static const Color tertiary = Color(0xFFFF9800); // Orange
  static const Color onTertiary = Color(0xFFFFFFFF);

  /// 背景色
  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF000000);

  /// 表面色
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF000000);

  /// 错误色
  static const Color error = Color(0xFFB00020);
  static const Color onError = Color(0xFFFFFFFF);

  /// 边框色
  static const Color outline = Color(0xFFE0E0E0);

  /// 灰度色
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== Dark主题颜色 ====================

  /// 暗色主题主色
  static const Color darkPrimary = Color(0xFF90CAF9); // Light Blue
  static const Color onDarkPrimary = Color(0xFF000000);

  /// 暗色主题次要色
  static const Color darkSecondary = Color(0xFF80CBC4); // Light Teal
  static const Color onDarkSecondary = Color(0xFF000000);

  /// 暗色主题第三色
  static const Color darkTertiary = Color(0xFFFFCC80); // Light Orange
  static const Color onDarkTertiary = Color(0xFF000000);

  /// 暗色主题背景色
  static const Color darkBackground = Color(0xFF121212);
  static const Color onDarkBackground = Color(0xFFFFFFFF);

  /// 暗色主题表面色
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color onDarkSurface = Color(0xFFFFFFFF);

  /// 暗色主题错误色
  static const Color darkError = Color(0xFFCF6679);
  static const Color onDarkError = Color(0xFF000000);

  /// 暗色主题边框色
  static const Color darkOutline = Color(0xFF3E3E3E);

  // ==================== 通用颜色 ====================

  /// 透明色
  static const Color transparent = Color(0x00000000);

  /// 遮罩色
  static const Color mask = Color(0x80000000);

  /// 分割线色
  static const Color divider = Color(0xFFE5E5E5);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // ==================== 功能色 ====================

  /// 成功色
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);

  /// 警告色
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);

  /// 信息色
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  /// 危险色
  static const Color danger = Color(0xFFF44336);
  static const Color dangerLight = Color(0xFFE57373);

  // ==================== 渐变色 ====================

  /// 主色渐变
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 次要色渐变
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF03DAC6), Color(0xFF018786)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 暗色渐变
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 彩虹渐变
  static const LinearGradient rainbowGradient = LinearGradient(
    colors: [
      Color(0xFFFF0000),
      Color(0xFFFF7F00),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
      Color(0xFF0000FF),
      Color(0xFF4B0082),
      Color(0xFF9400D3),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== 阴影色 ====================

  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x3D000000);

  // ==================== 品牌色 ====================
  // 根据您的品牌设计修改以下颜色

  /// 品牌主色
  static const Color brandPrimary = Color(0xFF2196F3);

  /// 品牌辅助色
  static const Color brandSecondary = Color(0xFF03DAC6);

  /// 品牌强调色
  static const Color brandAccent = Color(0xFFFF9800);
}

/// 颜色扩展方法
extension ColorExtension on Color {
  /// 返回带透明度的颜色
  Color withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return Color.fromARGB(
      (opacity * 255).round(),
      red,
      green,
      blue,
    );
  }

  /// 变亮颜色
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// 变暗颜色
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }
}
