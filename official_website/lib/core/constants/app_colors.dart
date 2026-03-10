import 'package:flutter/material.dart';

/// 应用颜色配置
/// 统一管理所有颜色，方便后续修改
class AppColors {
  // 主色系
  static const Color primary = Color(0xFF1890FF);        // 主蓝色
  static const Color primaryDark = Color(0xFF096DD9);    // 深蓝色
  static const Color primaryLight = Color(0xFF40A9FF);   // 浅蓝色

  // 辅助色
  static const Color secondary = Color(0xFFFF0000);      // 红色（网页CTA按钮）
  static const Color warning = Color(0xFFFAAD14);        // 橙色
  static const Color error = Color(0xFFF5222D);          // 红色
  static const Color info = Color(0xFF1890FF);           // 信息蓝

  // 中性色
  static const Color textPrimary = Color(0xFF262626);    // 主文字
  static const Color textSecondary = Color(0xFF8C8C8C);  // 次要文字
  static const Color textDisabled = Color(0xFFBFBFBF);   // 禁用文字
  static const Color border = Color(0xFFD9D9D9);         // 边框色
  static const Color divider = Color(0xFFE8E8E8);        // 分割线

  // 背景色
  static const Color background = Color(0xFFFFFFFF);     // 白色背景
  static const Color backgroundDark = Color(0xFFF5F5F5); // 浅灰背景
  static const Color backgroundLight = Color(0xFFFAFAFA);// 极浅灰背景

  // 阴影
  static const Color shadow = Color(0x1A000000);         // 10% 黑色
  static const Color shadowLight = Color(0x0D000000);    // 5% 黑色

  // 渐变色
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 禁用私有构造函数
  AppColors._();
}
