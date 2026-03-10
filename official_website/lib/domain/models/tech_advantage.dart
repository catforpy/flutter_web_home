import 'package:flutter/material.dart';

/// 技术优势模型
/// 用于展示技术优势或特点
class TechAdvantage {
  /// 优势主标题（如"加速应用开发"）
  final String title;

  /// 优势副标题（如"极致性体验"）
  final String? subtitle;

  /// 优势描述
  final String description;

  /// 优势图标
  final IconData icon;

  /// 优势图片URL（可选）
  final String? imageUrl;

  const TechAdvantage({
    required this.title,
    this.subtitle,
    required this.description,
    required this.icon,
    this.imageUrl,
  });

  /// 创建技术优势的便捷方法
  static TechAdvantage create({
    required String title,
    String? subtitle,
    required String description,
    required IconData icon,
    String? imageUrl,
  }) {
    return TechAdvantage(
      title: title,
      subtitle: subtitle,
      description: description,
      icon: icon,
      imageUrl: imageUrl,
    );
  }
}
