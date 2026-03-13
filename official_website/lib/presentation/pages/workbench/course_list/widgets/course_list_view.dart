import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/course/course_bloc.dart';
import 'package:official_website/application/blocs/course/course_event.dart';
import 'package:official_website/application/blocs/course/course_state.dart';
import 'package:official_website/presentation/pages/workbench/course_list/widgets/course_card.dart';

/// 课程列表视图
class CourseListContentView extends StatelessWidget {
  const CourseListContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索栏
        _buildSearchBar(context),

        // 课程列表
        const Expanded(child: _CourseListContent()),
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
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          final keyword = state is CourseLoaded ? state.searchKeyword : '';

          return TextField(
            decoration: InputDecoration(
              hintText: '搜索课程标题或描述',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: keyword != null && keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        context.read<CourseBloc>().add(
                              const SearchCoursesEvent(''),
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
              context.read<CourseBloc>().add(
                    SearchCoursesEvent(value),
                  );
            },
          );
        },
      ),
    );
  }
}

class _CourseListContent extends StatelessWidget {
  const _CourseListContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseError) {
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
                    context.read<CourseBloc>().add(
                          const LoadCoursesEvent(page: 1, pageSize: 10),
                        );
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is CourseLoaded) {
          if (state.courses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('暂无课程数据'),
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
                  '共 ${state.totalCount} 门课程',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),

              // 课程列表
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    return CourseCard(
                      course: course,
                      onTap: () => _showCourseDetail(context, course),
                      onDelete: () => _deleteCourse(context, course.id),
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

  Widget _buildPagination(BuildContext context, CourseLoaded state) {
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
                    context.read<CourseBloc>().add(
                          LoadCoursesEvent(
                            page: state.currentPage - 1,
                            pageSize: state.pageSize,
                            searchKeyword: state.searchKeyword,
                            instructorId: state.instructorId,
                            categoryId: state.categoryId,
                            formatId: state.formatId,
                            typeId: state.typeId,
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
                    context.read<CourseBloc>().add(
                          LoadCoursesEvent(
                            page: state.currentPage + 1,
                            pageSize: state.pageSize,
                            searchKeyword: state.searchKeyword,
                            instructorId: state.instructorId,
                            categoryId: state.categoryId,
                            formatId: state.formatId,
                            typeId: state.typeId,
                          ),
                        );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showCourseDetail(BuildContext context, course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(course.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  course.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('简介: ${course.description}'),
              const SizedBox(height: 8),
              Text('讲师: ${course.instructorName}'),
              const SizedBox(height: 8),
              Text('学员数: ${course.studentCount}'),
              const SizedBox(height: 8),
              Text('评分: ${course.rating} (${course.ratingCount}人评价)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    course.formattedPrice,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  if (course.hasDiscount) ...[
                    const SizedBox(width: 8),
                    Text(
                      course.formattedOriginalPrice,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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

  void _deleteCourse(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这门课程吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CourseBloc>().add(
                    DeleteCourseEvent(id),
                  );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
