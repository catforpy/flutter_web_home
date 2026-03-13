import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/page_component.dart';

/// 属性面板 - 右侧组件属性配置
class PropertyPanel extends StatelessWidget {
  final PageComponent? component;

  const PropertyPanel({
    super.key,
    this.component,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '属性配置',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const Divider(height: 1),

          // 属性内容
          Expanded(
            child: component != null
                ? _buildPropertyContent(context)
                : const Center(
                    child: Text(
                      '请选择组件',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPropertyItem(
          context,
          '组件类型',
          component!.type.displayName,
        ),
        _buildPropertyItem(
          context,
          '组件名称',
          component!.name,
        ),
        _buildPropertyItem(
          context,
          '组件ID',
          component!.id,
        ),
        _buildPropertyItem(
          context,
          '是否启用',
          component!.enabled ? '是' : '否',
        ),
        const Divider(),
        _buildStyleProperties(context),
      ],
    );
  }

  Widget _buildStyleProperties(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '样式配置',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // TODO: 根据不同组件类型显示不同的样式配置
        const Text('具体配置项待实现...'),
      ],
    );
  }

  Widget _buildPropertyItem(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
