import 'package:flutter/material.dart';

/// 颜色工具类
class ColorUtils {
  /// 将颜色序列化为十六进制字符串
  static String serializeColor(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  /// 从十六进制字符串解析颜色
  static Color parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return const Color(0xFF000000);
    }

    String hex = colorString.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }
}
