import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/course/course_bloc.dart';
import 'package:official_website/application/blocs/course/course_event.dart';
import 'package:official_website/application/blocs/course/course_state.dart';
import 'package:official_website/domain/entities/course.dart';

/// 课程筛选面板
class CourseFilterPanel extends StatefulWidget {
  final Function(String? instructorId, String? categoryId, String? formatId, String? typeId)
      onFilter;

  const CourseFilterPanel({
    super.key,
    required this.onFilter,
  });

  @override
  State<CourseFilterPanel> createState() => _CourseFilterPanelState();
}

class _CourseFilterPanelState extends State<CourseFilterPanel> {
  String? _selectedInstructorId;
  String? _selectedCategoryId;
  String? _selectedFormatId;
  String? _selectedTypeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        final instructorCategories = state is CourseLoaded
            ? state.instructorCategories
            : <InstructorCategory>[];
        final industryCategories = state is CourseLoaded
            ? state.industryCategories
            : <IndustryCategoryNode>[];
        final formatCategories = state is CourseLoaded
            ? state.formatCategories
            : <FormatCategory>[];
        final typeCategories = state is CourseLoaded
            ? state.typeCategories
            : <TypeCategory>[];

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
                    _buildInstructorFilter(instructorCategories ?? []),
                    const SizedBox(height: 24),
                    _buildCategoryFilter(industryCategories ?? []),
                    const SizedBox(height: 24),
                    _buildFormatFilter(formatCategories ?? []),
                    const SizedBox(height: 24),
                    _buildTypeFilter(typeCategories ?? []),
                    const SizedBox(height: 24),
                    _buildResetButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructorFilter(List<InstructorCategory> categories) {
    return _buildDropdownFilter(
      icon: Icons.person,
      label: '讲师',
      placeholder: '全部讲师',
      selectedId: _selectedInstructorId,
      items: categories,
      onChanged: (id) {
        setState(() {
          _selectedInstructorId = id;
          widget.onFilter(_selectedInstructorId, _selectedCategoryId,
              _selectedFormatId, _selectedTypeId);
        });
      },
    );
  }

  Widget _buildCategoryFilter(List<IndustryCategoryNode> categories) {
    return _buildTreeFilter(
      icon: Icons.category,
      label: '行业分类',
      placeholder: '全部分类',
      items: categories,
      onChanged: (id) {
        setState(() {
          _selectedCategoryId = id;
          widget.onFilter(_selectedInstructorId, _selectedCategoryId,
              _selectedFormatId, _selectedTypeId);
        });
      },
    );
  }

  Widget _buildFormatFilter(List<FormatCategory> categories) {
    return _buildDropdownFilter(
      icon: Icons.video_library,
      label: '课程形式',
      placeholder: '全部形式',
      selectedId: _selectedFormatId,
      items: categories,
      onChanged: (id) {
        setState(() {
          _selectedFormatId = id;
          widget.onFilter(_selectedInstructorId, _selectedCategoryId,
              _selectedFormatId, _selectedTypeId);
        });
      },
    );
  }

  Widget _buildTypeFilter(List<TypeCategory> categories) {
    return _buildDropdownFilter(
      icon: Icons.class_,
      label: '课程类型',
      placeholder: '全部类型',
      selectedId: _selectedTypeId,
      items: categories,
      onChanged: (id) {
        setState(() {
          _selectedTypeId = id;
          widget.onFilter(_selectedInstructorId, _selectedCategoryId,
              _selectedFormatId, _selectedTypeId);
        });
      },
    );
  }

  Widget _buildDropdownFilter<T>({
    required IconData icon,
    required String label,
    required String placeholder,
    required String? selectedId,
    required List<T> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          hint: Text(placeholder, style: const TextStyle(fontSize: 14)),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(placeholder, style: const TextStyle(fontSize: 14)),
            ),
            ...items.map<DropdownMenuItem<String>>((item) {
              String id = '';
              String name = '';

              if (item is InstructorCategory) {
                id = item.id;
                name = item.name;
              } else if (item is FormatCategory) {
                id = item.id;
                name = item.name;
              } else if (item is TypeCategory) {
                id = item.id;
                name = item.name;
              }

              return DropdownMenuItem<String>(
                value: id,
                child: Text(name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTreeFilter({
    required IconData icon,
    required String label,
    required String placeholder,
    required List<IndustryCategoryNode> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showCategoryDialog(items, onChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSelectedCategoryName(items) ?? placeholder,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedCategoryId != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _getSelectedCategoryName(List<IndustryCategoryNode> categories) {
    if (_selectedCategoryId == null) return null;

    for (var category in categories) {
      if (category.id == _selectedCategoryId) {
        return category.name;
      }
      if (category.children != null) {
        for (var child in category.children!) {
          if (child.id == _selectedCategoryId) {
            return '${category.name} / ${child.name}';
          }
        }
      }
    }
    return null;
  }

  void _showCategoryDialog(
    List<IndustryCategoryNode> categories,
    Function(String?) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择分类'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ExpansionTile(
                title: Text(category.name),
                children: category.children?.map<Widget>((child) {
                  return ListTile(
                    title: Text(child.name),
                    onTap: () {
                      Navigator.pop(context);
                      onChanged(child.id);
                    },
                  );
                }).toList() ?? [],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _selectedInstructorId = null;
            _selectedCategoryId = null;
            _selectedFormatId = null;
            _selectedTypeId = null;
            widget.onFilter(null, null, null, null);
          });
        },
        icon: const Icon(Icons.refresh),
        label: const Text('重置筛选'),
      ),
    );
  }
}
