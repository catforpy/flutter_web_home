import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 页面编辑器事件基类
abstract class PageEditorEvent extends Equatable {
  const PageEditorEvent();

  @override
  List<Object?> get props => [];
}

/// 初始化事件
class PageEditorInitEvent extends PageEditorEvent {
  final String? templateId;
  final String? pageType;

  const PageEditorInitEvent({
    this.templateId,
    this.pageType,
  });

  @override
  List<Object?> get props => [templateId, pageType];
}

/// 添加组件事件
class PageEditorAddComponentEvent extends PageEditorEvent {
  final PageComponent component;

  const PageEditorAddComponentEvent(this.component);

  @override
  List<Object?> get props => [component];
}

/// 删除组件事件
class PageEditorDeleteComponentEvent extends PageEditorEvent {
  final int index;

  const PageEditorDeleteComponentEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// 选中组件事件
class PageEditorSelectComponentEvent extends PageEditorEvent {
  final int? index;

  const PageEditorSelectComponentEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// 更新组件事件
class PageEditorUpdateComponentEvent extends PageEditorEvent {
  final int index;
  final PageComponent component;

  const PageEditorUpdateComponentEvent({
    required this.index,
    required this.component,
  });

  @override
  List<Object?> get props => [index, component];
}

/// 重排组件事件
class PageEditorReorderComponentsEvent extends PageEditorEvent {
  final int oldIndex;
  final int newIndex;

  const PageEditorReorderComponentsEvent({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

/// 保存页面事件
class PageEditorSaveEvent extends PageEditorEvent {
  const PageEditorSaveEvent();
}

/// 预览页面事件
class PageEditorPreviewEvent extends PageEditorEvent {
  const PageEditorPreviewEvent();
}
