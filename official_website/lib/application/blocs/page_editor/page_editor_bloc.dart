import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_event.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_state.dart';
import 'package:official_website/data/datasources/page_component_mock_datasource.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 页面编辑器 BLoC
///
/// 负责管理页面编辑器的所有状态和业务逻辑
class PageEditorBloc extends Bloc<PageEditorEvent, PageEditorState> {
  PageEditorBloc() : super(const PageEditorInitial()) {
    on<PageEditorInitEvent>(_onInit);
    on<PageEditorAddComponentEvent>(_onAddComponent);
    on<PageEditorDeleteComponentEvent>(_onDeleteComponent);
    on<PageEditorSelectComponentEvent>(_onSelectComponent);
    on<PageEditorUpdateComponentEvent>(_onUpdateComponent);
    on<PageEditorReorderComponentsEvent>(_onReorderComponents);
    on<PageEditorSaveEvent>(_onSave);
    on<PageEditorPreviewEvent>(_onPreview);
  }

  /// 初始化页面编辑器
  Future<void> _onInit(
    PageEditorInitEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    emit(const PageEditorLoading());

    try {
      // 模拟异步加载
      await Future.delayed(const Duration(milliseconds: 300));

      // 从数据源获取组件（这里使用假数据）
      final components = PageComponentMockDatasource.getDefaultComponents();

      emit(PageEditorLoaded(
        templateId: event.templateId,
        pageType: event.pageType ?? '首页',
        components: components,
      ));
    } catch (e) {
      emit(PageEditorError(e.toString()));
    }
  }

  /// 添加组件
  Future<void> _onAddComponent(
    PageEditorAddComponentEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;
      final newComponents = List<PageComponent>.from(currentState.components)
        ..add(event.component);

      emit(currentState.copyWith(
        components: newComponents,
        selectedComponentIndex: newComponents.length - 1,
      ));
    }
  }

  /// 删除组件
  Future<void> _onDeleteComponent(
    PageEditorDeleteComponentEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      if (event.index >= 0 && event.index < currentState.components.length) {
        final newComponents = List<PageComponent>.from(currentState.components);
        newComponents.removeAt(event.index);

        emit(currentState.copyWith(
          components: newComponents,
          selectedComponentIndex: null,
        ));
      }
    }
  }

  /// 选中组件
  Future<void> _onSelectComponent(
    PageEditorSelectComponentEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      emit(currentState.copyWith(
        selectedComponentIndex: event.index,
      ));
    }
  }

  /// 更新组件
  Future<void> _onUpdateComponent(
    PageEditorUpdateComponentEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      if (event.index >= 0 && event.index < currentState.components.length) {
        final newComponents = List<PageComponent>.from(currentState.components);
        newComponents[event.index] = event.component;

        emit(currentState.copyWith(
          components: newComponents,
        ));
      }
    }
  }

  /// 重排组件
  Future<void> _onReorderComponents(
    PageEditorReorderComponentsEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      if (event.oldIndex >= 0 &&
          event.oldIndex < currentState.components.length &&
          event.newIndex >= 0 &&
          event.newIndex < currentState.components.length) {
        final newComponents = List<PageComponent>.from(currentState.components);

        if (event.oldIndex < event.newIndex) {
          // 向后移动
          final item = newComponents.removeAt(event.oldIndex);
          newComponents.insert(event.newIndex - 1, item);
        } else {
          // 向前移动
          final item = newComponents.removeAt(event.oldIndex);
          newComponents.insert(event.newIndex, item);
        }

        emit(currentState.copyWith(
          components: newComponents,
        ));
      }
    }
  }

  /// 保存页面
  Future<void> _onSave(
    PageEditorSaveEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      emit(currentState.copyWith(isSaving: true));

      try {
        // TODO: 实现保存逻辑
        await Future.delayed(const Duration(seconds: 1));

        emit(currentState.copyWith(isSaving: false));
      } catch (e) {
        emit(currentState.copyWith(isSaving: false));
        emit(PageEditorError(e.toString()));
      }
    }
  }

  /// 预览页面
  Future<void> _onPreview(
    PageEditorPreviewEvent event,
    Emitter<PageEditorState> emit,
  ) async {
    if (state is PageEditorLoaded) {
      final currentState = state as PageEditorLoaded;

      emit(currentState.copyWith(isPreviewing: true));

      // TODO: 实现预览逻辑

      emit(currentState.copyWith(isPreviewing: false));
    }
  }
}
