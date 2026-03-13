import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/instructor/instructor_bloc.dart';
import 'package:official_website/application/blocs/instructor/instructor_event.dart';
import 'package:official_website/application/blocs/instructor/instructor_state.dart';
import 'package:official_website/presentation/pages/workbench/instructor_management/widgets/instructor_card.dart';

/// 讲师列表视图
class InstructorListView extends StatelessWidget {
  const InstructorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索栏
        _buildSearchBar(context),

        // 讲师列表
        const Expanded(child: _InstructorListContent()),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: BlocBuilder<InstructorBloc, InstructorState>(
        builder: (context, state) {
          final keyword = state is InstructorLoaded ? state.searchKeyword : '';

          return TextField(
            decoration: InputDecoration(
              hintText: '搜索讲师姓名或简介',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: keyword != null && keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        context.read<InstructorBloc>().add(
                              const SearchInstructorsEvent(''),
                            );
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              // 防抖搜索
              context.read<InstructorBloc>().add(
                    SearchInstructorsEvent(value),
                  );
            },
          );
        },
      ),
    );
  }
}

class _InstructorListContent extends StatelessWidget {
  const _InstructorListContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstructorBloc, InstructorState>(
      builder: (context, state) {
        if (state is InstructorLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InstructorError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('错误: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<InstructorBloc>().add(
                          const LoadInstructorsEvent(page: 1, pageSize: 10),
                        );
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is InstructorLoaded) {
          if (state.instructors.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('暂无讲师数据'),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 统计信息
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '共 ${state.totalCount} 位讲师',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),

              // 讲师列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.instructors.length,
                  itemBuilder: (context, index) {
                    final instructor = state.instructors[index];
                    return InstructorCard(
                      instructor: instructor,
                      onTap: () => _showInstructorDetail(context, instructor),
                      onDelete: () => _deleteInstructor(context, instructor.id),
                    );
                  },
                ),
              ),

              // 分页控制
              _buildPagination(context, state),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPagination(BuildContext context, InstructorLoaded state) {
    final totalPages = (state.totalCount / state.pageSize).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.currentPage > 1
                ? () {
                    context.read<InstructorBloc>().add(
                          LoadInstructorsEvent(
                            page: state.currentPage - 1,
                            pageSize: state.pageSize,
                            searchKeyword: state.searchKeyword,
                            filterSubject: state.filterSubject,
                            filterStatus: state.filterStatus,
                          ),
                        );
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${state.currentPage} / $totalPages',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.hasMore
                ? () {
                    context.read<InstructorBloc>().add(
                          LoadInstructorsEvent(
                            page: state.currentPage + 1,
                            pageSize: state.pageSize,
                            searchKeyword: state.searchKeyword,
                            filterSubject: state.filterSubject,
                            filterStatus: state.filterStatus,
                          ),
                        );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showInstructorDetail(BuildContext context, instructor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(instructor.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('简介: ${instructor.bio}'),
            const SizedBox(height: 8),
            Text('专业: ${instructor.subjects.join(", ")}'),
            const SizedBox(height: 8),
            Text('学员数: ${instructor.studentCount}'),
            const SizedBox(height: 8),
            Text('粉丝数: ${instructor.followerCount}'),
            const SizedBox(height: 8),
            Text('评分: ${instructor.averageRating}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _deleteInstructor(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这位讲师吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<InstructorBloc>().add(
                    DeleteInstructorEvent(id),
                  );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
