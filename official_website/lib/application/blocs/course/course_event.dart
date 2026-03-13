import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/course.dart';

/// 课程管理事件基类
abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

/// 加载课程列表
class LoadCoursesEvent extends CourseEvent {
  final int page;
  final int pageSize;
  final String? searchKeyword;
  final String? instructorId;
  final String? categoryId;
  final String? formatId;
  final String? typeId;

  const LoadCoursesEvent({
    this.page = 1,
    this.pageSize = 10,
    this.searchKeyword,
    this.instructorId,
    this.categoryId,
    this.formatId,
    this.typeId,
  });

  @override
  List<Object?> get props => [
        page,
        pageSize,
        searchKeyword,
        instructorId,
        categoryId,
        formatId,
        typeId,
      ];
}

/// 搜索课程
class SearchCoursesEvent extends CourseEvent {
  final String keyword;

  const SearchCoursesEvent(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

/// 筛选课程
class FilterCoursesEvent extends CourseEvent {
  final String? instructorId;
  final String? categoryId;
  final String? formatId;
  final String? typeId;

  const FilterCoursesEvent({
    this.instructorId,
    this.categoryId,
    this.formatId,
    this.typeId,
  });

  @override
  List<Object?> get props => [instructorId, categoryId, formatId, typeId];
}

/// 删除课程
class DeleteCourseEvent extends CourseEvent {
  final String id;

  const DeleteCourseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// 更新课程状态
class UpdateCourseStatusEvent extends CourseEvent {
  final String id;
  final CourseStatus status;

  const UpdateCourseStatusEvent({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}

/// 加载筛选选项
class LoadFilterOptionsEvent extends CourseEvent {
  const LoadFilterOptionsEvent();
}
