import 'package:flutter/material.dart';

/// 开发流程步骤模型
/// 六边形图标 + 序号 + 标题 + 描述列表
class DevelopmentStep {
  /// 步骤标题
  final String title;

  /// 步骤描述列表（3-4条）
  final List<String> descriptions;

  /// 序号（01-06）
  final String stepNumber;

  /// 图标类型
  final DevelopmentStepIconType iconType;

  const DevelopmentStep({
    required this.title,
    required this.descriptions,
    required this.stepNumber,
    required this.iconType,
  });

  /// 创建开发流程步骤的便捷方法
  static DevelopmentStep create({
    required String title,
    required List<String> descriptions,
    required String stepNumber,
    required DevelopmentStepIconType iconType,
  }) {
    return DevelopmentStep(
      title: title,
      descriptions: descriptions,
      stepNumber: stepNumber,
      iconType: iconType,
    );
  }
}

/// 开发流程图标类型
enum DevelopmentStepIconType {
  /// 人员角色/项目（Y型分支图标）
  personnel,

  /// 每周汇报（笔记本+等号）
  weeklyReport,

  /// 4项测试（代码标签+日历）
  testing,

  /// 12项交付内容（文件夹+文档列表）
  deliverables,

  /// 维护模式（显示器+IT文字）
  maintenance,

  /// 客户培训（文档+手形点击图标）
  training,
}
