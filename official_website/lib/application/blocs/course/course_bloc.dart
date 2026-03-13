import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/course/course_event.dart';
import 'package:official_website/application/blocs/course/course_state.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/course.dart';
import 'package:official_website/domain/repositories/course_repository.dart';

/// 课程管理 BLoC
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository repository;

  CourseBloc({required this.repository}) : super(const CourseInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<FilterCoursesEvent>(_onFilterCourses);
    on<DeleteCourseEvent>(_onDeleteCourse);
    on<UpdateCourseStatusEvent>(_onUpdateCourseStatus);
    on<LoadFilterOptionsEvent>(_onLoadFilterOptions);
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await repository.getCourses(
      page: event.page,
      pageSize: event.pageSize,
      searchKeyword: event.searchKeyword,
      instructorId: event.instructorId,
      categoryId: event.categoryId,
      formatId: event.formatId,
      typeId: event.typeId,
    );

    final countResult = await repository.getCourseCount(
      searchKeyword: event.searchKeyword,
      instructorId: event.instructorId,
      categoryId: event.categoryId,
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) {
        countResult.fold(
          (failure) => emit(CourseError(failure.message)),
          (totalCount) {
            final hasMore = (event.page * event.pageSize) < totalCount;
            emit(CourseLoaded(
              courses: courses,
              currentPage: event.page,
              pageSize: event.pageSize,
              totalCount: totalCount,
              hasMore: hasMore,
              searchKeyword: event.searchKeyword,
              instructorId: event.instructorId,
              categoryId: event.categoryId,
              formatId: event.formatId,
              typeId: event.typeId,
            ));
          },
        );
      },
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;

      emit(const CourseLoading());

      final result = await repository.getCourses(
        page: 1,
        pageSize: currentState.pageSize,
        searchKeyword: event.keyword,
        instructorId: currentState.instructorId,
        categoryId: currentState.categoryId,
        formatId: currentState.formatId,
        typeId: currentState.typeId,
      );

      result.fold(
        (failure) => emit(CourseError(failure.message)),
        (courses) {
          emit(currentState.copyWith(
            courses: courses,
            currentPage: 1,
            searchKeyword: event.keyword,
          ));
        },
      );
    }
  }

  Future<void> _onFilterCourses(
    FilterCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;

      add(LoadCoursesEvent(
        page: 1,
        pageSize: currentState.pageSize,
        searchKeyword: currentState.searchKeyword,
        instructorId: event.instructorId,
        categoryId: event.categoryId,
        formatId: event.formatId,
        typeId: event.typeId,
      ));
    }
  }

  Future<void> _onDeleteCourse(
    DeleteCourseEvent event,
    Emitter<CourseState> emit,
  ) async {
    final result = await repository.deleteCourse(event.id);

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (_) {
        if (state is CourseLoaded) {
          final currentState = state as CourseLoaded;
          add(LoadCoursesEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            searchKeyword: currentState.searchKeyword,
            instructorId: currentState.instructorId,
            categoryId: currentState.categoryId,
            formatId: currentState.formatId,
            typeId: currentState.typeId,
          ));
        }
      },
    );
  }

  Future<void> _onUpdateCourseStatus(
    UpdateCourseStatusEvent event,
    Emitter<CourseState> emit,
  ) async {
    final result = await repository.updateCourseStatus(
      event.id,
      event.status,
    );

    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (_) {
        if (state is CourseLoaded) {
          final currentState = state as CourseLoaded;
          add(LoadCoursesEvent(
            page: currentState.currentPage,
            pageSize: currentState.pageSize,
            searchKeyword: currentState.searchKeyword,
            instructorId: currentState.instructorId,
            categoryId: currentState.categoryId,
            formatId: currentState.formatId,
            typeId: currentState.typeId,
          ));
        }
      },
    );
  }

  Future<void> _onLoadFilterOptions(
    LoadFilterOptionsEvent event,
    Emitter<CourseState> emit,
  ) async {
    // 并行加载所有筛选选项
    final results = await Future.wait([
      repository.getInstructorCategories(),
      repository.getIndustryCategories(),
      repository.getFormatCategories(),
      repository.getTypeCategories(),
    ]);

    final instructorCategories = results[0] as Either<Failure, List<InstructorCategory>>;
    final industryCategories = results[1] as Either<Failure, List<IndustryCategoryNode>>;
    final formatCategories = results[2] as Either<Failure, List<FormatCategory>>;
    final typeCategories = results[3] as Either<Failure, List<TypeCategory>>;

    if (state is CourseLoaded) {
      final currentState = state as CourseLoaded;

      emit(currentState.copyWith(
        instructorCategories: instructorCategories.getOrElse(() => []),
        industryCategories: industryCategories.getOrElse(() => []),
        formatCategories: formatCategories.getOrElse(() => []),
        typeCategories: typeCategories.getOrElse(() => []),
      ));
    }
  }
}
