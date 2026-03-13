import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/data/datasources/account_settings_mock_datasource.dart';
import 'package:official_website/domain/entities/account_settings.dart';
import 'package:official_website/domain/repositories/account_settings_repository.dart';

/// 账号设置仓储实现
class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  @override
  Future<Either<Failure, AccountSettings>> getSettings(
    String userId,
  ) async {
    try {
      final settings = AccountSettingsMockDatasource.getSettings(userId);
      return Right(settings);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountSettings>> updateSettings(
    AccountSettings settings,
  ) async {
    try {
      final updatedSettings =
          AccountSettingsMockDatasource.updateSettings(settings);
      return Right(updatedSettings);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final success = AccountSettingsMockDatasource.changePassword(
        oldPassword,
        newPassword,
      );

      if (!success) {
        return const Left(ValidationFailure(message: '原密码错误'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    try {
      final avatarUrl =
          AccountSettingsMockDatasource.uploadAvatar(filePath);
      return Right(avatarUrl);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> bindPhone({
    required String userId,
    required String phone,
    required String code,
  }) async {
    try {
      final success =
          AccountSettingsMockDatasource.bindPhone(phone, code);

      if (!success) {
        return const Left(ValidationFailure(message: '验证码错误'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> bindEmail({
    required String userId,
    required String email,
    required String code,
  }) async {
    try {
      final success =
          AccountSettingsMockDatasource.bindEmail(email, code);

      if (!success) {
        return const Left(ValidationFailure(message: '验证码错误'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount({
    required String userId,
    required String password,
  }) async {
    try {
      final success =
          AccountSettingsMockDatasource.deleteAccount(password);

      if (!success) {
        return const Left(ValidationFailure(message: '密码错误'));
      }

      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
