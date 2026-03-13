import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/domain/entities/account_settings.dart';

/// 账号设置仓储接口
abstract class AccountSettingsRepository {
  /// 获取设置
  Future<Either<Failure, AccountSettings>> getSettings(String userId);

  /// 更新设置
  Future<Either<Failure, AccountSettings>> updateSettings(
    AccountSettings settings,
  );

  /// 修改密码
  Future<Either<Failure, Unit>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

  /// 上传头像
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required String filePath,
  });

  /// 绑定手机
  Future<Either<Failure, Unit>> bindPhone({
    required String userId,
    required String phone,
    required String code,
  });

  /// 绑定邮箱
  Future<Either<Failure, Unit>> bindEmail({
    required String userId,
    required String email,
    required String code,
  });

  /// 注销账号
  Future<Either<Failure, Unit>> deleteAccount({
    required String userId,
    required String password,
  });
}
