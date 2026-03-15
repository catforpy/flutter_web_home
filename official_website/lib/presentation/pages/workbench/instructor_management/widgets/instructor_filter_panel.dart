import 'package:flutter/material.dart';
import 'package:official_website/domain/entities/instructor.dart';

/// 讲师筛选面板
class InstructorFilterPanel extends StatefulWidget {
  final Function(String? subject, InstructorStatus? status) onFilter;

  const InstructorFilterPanel({
    super.key,
    required this.onFilter,
  });

  @override
  State<InstructorFilterPanel> createState() => _InstructorFilterPanelState();
}

class _InstructorFilterPanelState extends State<InstructorFilterPanel> {
  String? _selectedSubject;
  InstructorStatus? _selectedStatus;

  final List<String> _subjects = [
    '全部',
    '计算机',
    'Python',
    'Java',
    '前端开发',
    '移动开发',
    '数据科学',
    '人工智能',
  ];

  @override
  Widget build(BuildContext context) {
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
              '筛选条件',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const Divider(height: 1),

          // 筛选选项
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSubjectFilter(),
                const SizedBox(height: 24),
                _buildStatusFilter(),
                const SizedBox(height: 24),
                _buildResetButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '专业领域',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _subjects.map((subject) {
            final isSelected = _selectedSubject == subject || (subject == '全部' && _selectedSubject == null);

            return FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSubject = selected && subject != '全部' ? subject : null;
                  widget.onFilter(_selectedSubject, _selectedStatus);
                });
              },
              selectedColor: const Color(0xFF1A9B8E).withOpacity(0.2),
              checkmarkColor: const Color(0xFF1A9B8E),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '在线状态',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: InstructorStatus.values.map((status) {
            final isSelected = _selectedStatus == status;

            return CheckboxListTile(
              title: Text(status.displayName),
              value: isSelected,
              onChanged: (selected) {
                setState(() {
                  _selectedStatus = selected! ? status : null;
                  widget.onFilter(_selectedSubject, _selectedStatus);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: status.color,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _selectedSubject = null;
            _selectedStatus = null;
            widget.onFilter(null, null);
          });
        },
        icon: const Icon(Icons.refresh),
        label: const Text('重置筛选'),
      ),
    );
  }
}
