import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/error/exceptions.dart';
import 'package:official_website/data/datasources/instructor_mock_datasource.dart';
import 'package:official_website/domain/entities/instructor.dart';
import 'package:official_website/domain/repositories/instructor_repository.dart';

/// 讲师仓储实现
class InstructorRepositoryImpl implements InstructorRepository {
  @override
  Future<Either<Failure, List<Instructor>>> getInstructors({
    required int page,
    required int pageSize,
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  }) async {
    try {
      final instructors = InstructorMockDatasource.getInstructors(
        page: page,
        pageSize: pageSize,
        searchKeyword: searchKeyword,
        filterSubject: filterSubject,
        filterStatus: filterStatus,
      );
      return Right(instructors);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Instructor>>> searchInstructors(
    String keyword,
  ) async {
    try {
      final instructors = InstructorMockDatasource.searchInstructors(keyword);
      return Right(instructors);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Instructor>> getInstructorById(String id) async {
    try {
      final instructor = InstructorMockDatasource.getInstructorById(id);
      if (instructor == null) {
        throw const NotFoundException(message: '讲师不存在');
      }
      return Right(instructor);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateInstructorStatus(
    String id,
    InstructorStatus status,
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
  Future<Either<Failure, Unit>> deleteInstructor(String id) async {
    try {
      // TODO: 实现删除逻辑
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getInstructorCount({
    String? searchKeyword,
    String? filterSubject,
    InstructorStatus? filterStatus,
  }) async {
    try {
      final count = InstructorMockDatasource.getInstructorCount(
        searchKeyword: searchKeyword,
        filterSubject: filterSubject,
        filterStatus: filterStatus,
      );
      return Right(count);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
