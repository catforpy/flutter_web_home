import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_bloc.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_event.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_state.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 编辑画布 - 中间组件预览和编辑区域
class EditorCanvas extends StatelessWidget {
  final List<PageComponent> components;
  final int? selectedComponentIndex;

  const EditorCanvas({
    super.key,
    required this.components,
    this.selectedComponentIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.widgets_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '从左侧拖拽组件到此处',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: components.length,
        itemBuilder: (context, index) {
          final component = components[index];
          final isSelected = selectedComponentIndex == index;

          return _ComponentListItem(
            component: component,
            isSelected: isSelected,
            onTap: () => _selectComponent(context, index),
            onDelete: () => _deleteComponent(context, index),
          );
        },
      ),
    );
  }

  void _selectComponent(BuildContext context, int index) {
    context.read<PageEditorBloc>().add(
          PageEditorSelectComponentEvent(index),
        );
  }

  void _deleteComponent(BuildContext context, int index) {
    context.read<PageEditorBloc>().add(
          PageEditorDeleteComponentEvent(index),
        );
  }
}

class _ComponentListItem extends StatelessWidget {
  final PageComponent component;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ComponentListItem({
    required this.component,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF1A9B8E) : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 组件头部
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A9B8E).withOpacity(0.1) : null,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(
                    component.type.icon,
                    size: 18,
                    color: const Color(0xFF1A9B8E),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      component.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: onDelete,
                    tooltip: '删除',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // 组件预览
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: component.buildPreview(context as BuildContext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
