import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/error/exceptions.dart';
import 'package:official_website/data/datasources/course_mock_datasource.dart';
import 'package:official_website/domain/entities/course.dart';
import 'package:official_website/domain/repositories/course_repository.dart';

/// 课程仓储实现
class CourseRepositoryImpl implements CourseRepository {
  @override
  Future<Either<Failure, List<Course>>> getCourses({
    required int page,
    required int pageSize,
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
    String? formatId,
    String? typeId,
  }) async {
    try {
      final courses = CourseMockDatasource.getCourses(
        page: page,
        pageSize: pageSize,
        searchKeyword: searchKeyword,
        instructorId: instructorId,
        categoryId: categoryId,
        formatId: formatId,
        typeId: typeId,
      );
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> searchCourses(String keyword) async {
    try {
      final courses = CourseMockDatasource.searchCourses(keyword);
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Course>> getCourseById(String id) async {
    try {
      final course = CourseMockDatasource.getCourseById(id);
      if (course == null) {
        throw const NotFoundException(message: '课程不存在');
      }
      return Right(course);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InstructorCategory>>> getInstructorCategories() async {
    try {
      final categories = CourseMockDatasource.getInstructorCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IndustryCategoryNode>>> getIndustryCategories() async {
    try {
      final categories = CourseMockDatasource.getIndustryCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FormatCategory>>> getFormatCategories() async {
    try {
      final categories = CourseMockDatasource.getFormatCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TypeCategory>>> getTypeCategories() async {
    try {
      final categories = CourseMockDatasource.getTypeCategories();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCourseStatus(
    String id,
    CourseStatus status,
  ) async {
    try {
      // TODO: 实现更新逻辑
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCourse(String id) async {
    try {
      // TODO: 实现删除逻辑
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCourseCount({
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
  }) async {
    try {
      final count = CourseMockDatasource.getCourseCount(
        searchKeyword: searchKeyword,
        instructorId: instructorId,
        categoryId: categoryId,
      );
      return Right(count);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
