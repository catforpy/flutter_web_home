import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 页面编辑器状态基类
abstract class PageEditorState extends Equatable {
  const PageEditorState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class PageEditorInitial extends PageEditorState {
  const PageEditorInitial();
}

/// 加载中状态
class PageEditorLoading extends PageEditorState {
  const PageEditorLoading();
}

/// 已加载状态
class PageEditorLoaded extends PageEditorState {
  final String? templateId;
  final String pageType;
  final List<PageComponent> components;
  final int? selectedComponentIndex;
  final bool isSaving;
  final bool isPreviewing;

  const PageEditorLoaded({
    this.templateId,
    this.pageType = '首页',
    this.components = const [],
    this.selectedComponentIndex,
    this.isSaving = false,
    this.isPreviewing = false,
  });

  /// 获取选中的组件
  PageComponent? get selectedComponent {
    if (selectedComponentIndex != null &&
        selectedComponentIndex! >= 0 &&
        selectedComponentIndex! < components.length) {
      return components[selectedComponentIndex!];
    }
    return null;
  }

  @override
  List<Object?> get props => [
        templateId,
        pageType,
        components,
        selectedComponentIndex,
        isSaving,
        isPreviewing,
      ];

  PageEditorLoaded copyWith({
    String? templateId,
    String? pageType,
    List<PageComponent>? components,
    int? selectedComponentIndex,
    bool? isSaving,
    bool? isPreviewing,
  }) {
    return PageEditorLoaded(
      templateId: templateId ?? this.templateId,
      pageType: pageType ?? this.pageType,
      components: components ?? this.components,
      selectedComponentIndex: selectedComponentIndex ?? this.selectedComponentIndex,
      isSaving: isSaving ?? this.isSaving,
      isPreviewing: isPreviewing ?? this.isPreviewing,
    );
  }
}

/// 错误状态
class PageEditorError extends PageEditorState {
  final String message;

  const PageEditorError(this.message);

  @override
  List<Object?> get props => [message];
}
