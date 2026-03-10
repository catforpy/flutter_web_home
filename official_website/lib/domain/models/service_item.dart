import 'package:flutter/material.dart';

/// 服务项目模型
/// 用于展示单个服务项目的信息
class ServiceItem {
  /// 服务标题
  final String title;

  /// 服务图标
  final IconData icon;

  /// 服务特性列表
  final List<String> features;

  /// 服务描述（可选）
  final String? description;

  /// 服务图片URL（可选）
  final String? imageUrl;

  const ServiceItem({
    required this.title,
    required this.icon,
    required this.features,
    this.description,
    this.imageUrl,
  });

  /// 创建服务项目的便捷方法
  static ServiceItem create({
    required String title,
    required IconData icon,
    required List<String> features,
    String? description,
    String? imageUrl,
  }) {
    return ServiceItem(
      title: title,
      icon: icon,
      features: features,
      description: description,
      imageUrl: imageUrl,
    );
  }
}
