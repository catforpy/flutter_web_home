import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/course.dart';

/// 课程管理状态基类
abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class CourseInitial extends CourseState {
  const CourseInitial();
}

/// 加载中
class CourseLoading extends CourseState {
  const CourseLoading();
}

/// 已加载
class CourseLoaded extends CourseState {
  final List<Course> courses;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
  final String? searchKeyword;
  final String? instructorId;
  final String? categoryId;
  final String? formatId;
  final String? typeId;

  // 筛选选项
  final List<InstructorCategory>? instructorCategories;
  final List<IndustryCategoryNode>? industryCategories;
  final List<FormatCategory>? formatCategories;
  final List<TypeCategory>? typeCategories;

  const CourseLoaded({
    this.courses = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.hasMore = false,
    this.searchKeyword,
    this.instructorId,
    this.categoryId,
    this.formatId,
    this.typeId,
    this.instructorCategories,
    this.industryCategories,
    this.formatCategories,
    this.typeCategories,
  });

  @override
  List<Object?> get props => [
        courses,
        currentPage,
        pageSize,
        totalCount,
        hasMore,
        searchKeyword,
        instructorId,
        categoryId,
        formatId,
        typeId,
        instructorCategories,
        industryCategories,
        formatCategories,
        typeCategories,
      ];

  CourseLoaded copyWith({
    List<Course>? courses,
    int? currentPage,
    int? pageSize,
    int? totalCount,
    bool? hasMore,
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
    String? formatId,
    String? typeId,
    List<InstructorCategory>? instructorCategories,
    List<IndustryCategoryNode>? industryCategories,
    List<FormatCategory>? formatCategories,
    List<TypeCategory>? typeCategories,
  }) {
    return CourseLoaded(
      courses: courses ?? this.courses,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      instructorId: instructorId ?? this.instructorId,
      categoryId: categoryId ?? this.categoryId,
      formatId: formatId ?? this.formatId,
      typeId: typeId ?? this.typeId,
      instructorCategories: instructorCategories ?? this.instructorCategories,
      industryCategories: industryCategories ?? this.industryCategories,
      formatCategories: formatCategories ?? this.formatCategories,
      typeCategories: typeCategories ?? this.typeCategories,
    );
  }
}

/// 错误状态
class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object?> get props => [message];
}
