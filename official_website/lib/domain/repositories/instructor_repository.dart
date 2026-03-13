import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/instructor.dart';

/// 讲师仓储接口
abstract class InstructorRepository {
  /// 获取讲师列表
  Future<Either<Failure, List<Instructor>>> getInstructors({
    required int page,
    required int pageSize,
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  });

  /// 搜索讲师
  Future<Either<Failure, List<Instructor>>> searchInstructors(String keyword);

  /// 获取讲师详情
  Future<Either<Failure, Instructor>> getInstructorById(String id);

  /// 更新讲师状态
  Future<Either<Failure, Unit>> updateInstructorStatus(
    String id,
    InstructorStatus status,
  );

  /// 删除讲师
  Future<Either<Failure, Unit>> deleteInstructor(String id);

  /// 获取讲师总数
  Future<Either<Failure, int>> getInstructorCount({
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  });
}
