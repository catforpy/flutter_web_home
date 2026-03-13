import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_bloc.dart';
import 'package:official_website/application/blocs/page_editor/page_editor_event.dart';
import 'package:official_website/data/datasources/page_component_mock_datasource.dart';
import 'package:official_website/domain/entities/page_component.dart';
import 'package:official_website/domain/entities/components/carousel_component.dart';
import 'package:official_website/domain/entities/components/video_component.dart';
import 'package:official_website/domain/entities/components/notice_component.dart';
import 'package:official_website/domain/entities/components/search_component.dart';
import 'package:official_website/domain/entities/components/category_nav_component.dart';
import 'package:official_website/domain/entities/components/title_component.dart';
import 'package:official_website/domain/entities/components/image_component.dart';
import 'package:official_website/domain/entities/components/showcase_component.dart';
import 'package:official_website/domain/entities/components/button_component.dart';
import 'package:official_website/domain/entities/components/divider_component.dart';

/// 组件面板 - 左侧拖拽组件列表
class ComponentPalette extends StatelessWidget {
  final String pageType;

  const ComponentPalette({
    super.key,
    required this.pageType,
  });

  @override
  Widget build(BuildContext context) {
    final availableComponents = PageComponentMockDatasource.getAvailableComponents();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '组件库',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const Divider(height: 1),

          // 组件列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: availableComponents.length,
              itemBuilder: (context, index) {
                final componentType = availableComponents[index];
                return _ComponentListItem(
                  componentType: componentType,
                  onTap: () => _addComponent(context, componentType),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addComponent(BuildContext context, ComponentType type) {
    final component = _createComponent(type);

    if (component != null) {
      context.read<PageEditorBloc>().add(PageEditorAddComponentEvent(component));
    }
  }

  PageComponent? _createComponent(ComponentType type) {
    switch (type) {
      case ComponentType.carousel:
        return CarouselComponent(
          id: _generateId(),
          images: const [],
          style: CarouselStyle.defaultStyle,
        );
      case ComponentType.search:
        return SearchComponent(
          id: _generateId(),
          config: SearchConfig.defaultConfig,
          style: SearchStyle.defaultStyle,
        );
      case ComponentType.categoryNav:
        return CategoryNavComponent(
          id: _generateId(),
          items: const [],
          style: CategoryNavStyle.defaultStyle,
        );
      case ComponentType.video:
        return VideoComponent(
          id: _generateId(),
          videoUrl: '',
          style: VideoStyle.defaultStyle,
        );
      case ComponentType.notice:
        return NoticeComponent(
          id: _generateId(),
          items: const [],
          config: NoticeConfig.defaultConfig,
          style: NoticeStyle.defaultStyle,
        );
      case ComponentType.title:
        return TitleComponent(
          id: _generateId(),
          text: '标题文本',
          style: TitleStyle.defaultStyle,
        );
      case ComponentType.image:
        return ImageComponent(
          id: _generateId(),
          imageUrl: '',
          style: ImageStyle.defaultStyle,
        );
      case ComponentType.showcase:
        return ShowcaseComponent(
          id: _generateId(),
          items: const [],
          style: ShowcaseStyle.defaultStyle,
        );
      case ComponentType.button:
        return ButtonComponent(
          id: _generateId(),
          text: '按钮',
          style: ComponentButtonStyle.defaultStyle,
        );
      case ComponentType.divider:
        return DividerComponent(
          id: _generateId(),
          style: DividerStyle.defaultStyle,
        );
      default:
        return null;
    }
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }
}

class _ComponentListItem extends StatelessWidget {
  final ComponentType componentType;
  final VoidCallback onTap;

  const _ComponentListItem({
    required this.componentType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                componentType.icon,
                color: const Color(0xFF1A9B8E),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  componentType.displayName,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
