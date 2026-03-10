import 'package:flutter/material.dart';

/// 流程步骤模型
/// 用于展示服务流程或开发流程的步骤
class ProcessStep {
  /// 步骤标题
  final String title;

  /// 步骤图标
  final IconData icon;

  /// 步骤描述（可选）
  final String? description;

  /// 步骤编号（可选）
  final int? stepNumber;

  /// 背景图片URL（可选）
  final String? backgroundImage;

  /// Logo图片URL（可选，显示在卡片上）
  final String? logoImage;

  /// Hover图标类型（可选）
  final ProcessStepHoverIcon? hoverIconType;

  /// 是否为大卡片（第一行的2个卡片）
  final bool isLarge;

  const ProcessStep({
    required this.title,
    required this.icon,
    this.description,
    this.stepNumber,
    this.backgroundImage,
    this.logoImage,
    this.hoverIconType,
    this.isLarge = false,
  });

  /// 创建流程步骤的便捷方法
  static ProcessStep create({
    required String title,
    required IconData icon,
    String? description,
    int? stepNumber,
    String? backgroundImage,
    String? logoImage,
    ProcessStepHoverIcon? hoverIconType,
    bool isLarge = false,
  }) {
    return ProcessStep(
      title: title,
      icon: icon,
      description: description,
      stepNumber: stepNumber,
      backgroundImage: backgroundImage,
      logoImage: logoImage,
      hoverIconType: hoverIconType,
      isLarge: isLarge,
    );
  }
}

/// Hover图标类型
enum ProcessStepHoverIcon {
  /// CPU芯片图标（C1 小程序开发）
  cpuChip,

  /// 滑块图标（C3 小程序测试）
  sliders,

  /// 无特殊图标
  none,
}
