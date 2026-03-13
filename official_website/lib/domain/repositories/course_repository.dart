import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/course.dart';

/// 课程仓储接口
abstract class CourseRepository {
  /// 获取课程列表
  Future<Either<Failure, List<Course>>> getCourses({
    required int page,
    required int pageSize,
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
    String? formatId,
    String? typeId,
  });

  /// 搜索课程
  Future<Either<Failure, List<Course>>> searchCourses(String keyword);

  /// 获取课程详情
  Future<Either<Failure, Course>> getCourseById(String id);

  /// 获取讲师分类列表
  Future<Either<Failure, List<InstructorCategory>>> getInstructorCategories();

  /// 获取行业分类树
  Future<Either<Failure, List<IndustryCategoryNode>>> getIndustryCategories();

  /// 获取形式分类列表
  Future<Either<Failure, List<FormatCategory>>> getFormatCategories();

  /// 获取类型分类列表
  Future<Either<Failure, List<TypeCategory>>> getTypeCategories();

  /// 更新课程状态
  Future<Either<Failure, Unit>> updateCourseStatus(
    String id,
    CourseStatus status,
  );

  /// 删除课程
  Future<Either<Failure, Unit>> deleteCourse(String id);

  /// 获取课程总数
  Future<Either<Failure, int>> getCourseCount({
    String? searchKeyword,
    String? instructorId,
    String? categoryId,
  });
}
