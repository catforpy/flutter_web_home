import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/config/backend_api_config.dart';
import 'package:official_website/core/services/token_manager.dart';
import 'package:official_website/domain/models/login_response_v2.dart';
import 'package:official_website/domain/models/register_response_v2.dart';

/// 认证服务 V2
/// 对接后端认证V2 API
///
/// 后端示例：
/// - 都达网账户登录：POST /api/auth/v2/platform-account/login/password
/// - 服务商登录：POST /api/auth/v2/service-provider/login/password
class AuthServiceV2 {
  static AuthServiceV2? _instance;
  factory AuthServiceV2() {
    _instance ??= AuthServiceV2._internal();
    return _instance!;
  }
  AuthServiceV2._internal();

  ApiClient get _apiClient => _apiClientCache ??= ApiClient();
  ApiClient? _apiClientCache;

  TokenManager get _tokenManager => _tokenManagerCache ??= TokenManager();
  TokenManager? _tokenManagerCache;

  final Logger _logger = Logger();

  // ==================== 都达网账户 ====================

  /// 都达网账户 - 账号密码注册
  ///
  /// 注意：注册接口不返回token，注册成功后需要用户重新登录
  Future<Either<Failure, RegisterDataV2>> registerPlatformAccountByPassword({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      _logger.i('📝 都达网账户注册: $username');
      final response = await _apiClient.dio.post(
        BackendApiConfig.platformAccountRegisterPassword,
        data: {
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      return _handleRegisterResponse(response);
    } catch (e) {
      _logger.e('❌ 注册失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 都达网账户 - 账号密码登录
  Future<Either<Failure, LoginDataV2>> loginPlatformAccountByPassword({
    required String username,
    required String password,
  }) async {
    try {
      _logger.i('🔑 都达网账户登录: $username');
      final response = await _apiClient.dio.post(
        BackendApiConfig.platformAccountLoginPassword,
        data: {'username': username, 'password': password},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 都达网账户 - 手机验证码登录
  Future<Either<Failure, LoginDataV2>> loginPlatformAccountBySms({
    required String phone,
    required String phoneVerifyCode,
  }) async {
    try {
      _logger.i('🔑 都达网账户登录(验证码): $phone');
      final response = await _apiClient.dio.post(
        BackendApiConfig.platformAccountLoginSms,
        data: {'phone': phone, 'phoneVerifyCode': phoneVerifyCode},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 服务商 ====================

  /// 服务商 - 账号密码登录
  Future<Either<Failure, LoginDataV2>> loginServiceProviderByPassword({
    required String username,
    required String password,
  }) async {
    try {
      _logger.i('🔑 服务商登录: $username');
      final response = await _apiClient.dio.post(
        BackendApiConfig.serviceProviderLoginPassword,
        data: {'username': username, 'password': password},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 服务商 - 手机验证码登录
  Future<Either<Failure, LoginDataV2>> loginServiceProviderBySms({
    required String phone,
    required String phoneVerifyCode,
  }) async {
    try {
      _logger.i('🔑 服务商登录(验证码): $phone');
      final response = await _apiClient.dio.post(
        BackendApiConfig.serviceProviderLoginSms,
        data: {'phone': phone, 'phoneVerifyCode': phoneVerifyCode},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 平台管理员 ====================

  /// 平台管理员 - 账号密码登录
  Future<Either<Failure, LoginDataV2>> loginPlatformAdminByPassword({
    required String username,
    required String password,
  }) async {
    try {
      _logger.i('🔑 平台管理员登录: $username');
      final response = await _apiClient.dio.post(
        BackendApiConfig.platformAdminLoginPassword,
        data: {'username': username, 'password': password},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 后台管理员 ====================

  /// 后台管理员 - 账号密码登录
  Future<Either<Failure, LoginDataV2>> loginBackendAdminByPassword({
    required String username,
    required String password,
  }) async {
    try {
      _logger.i('🔑 后台管理员登录: $username');
      final response = await _apiClient.dio.post(
        BackendApiConfig.backendAdminLoginPassword,
        data: {'username': username, 'password': password},
      );
      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ 登录失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 通用接口 ====================

  /// 发送验证码
  Future<Either<Failure, Unit>> sendSmsCode(String phone) async {
    try {
      _logger.i('📨 发送验证码: $phone');
      final response = await _apiClient.dio.post(
        BackendApiConfig.sendSms,
        queryParameters: {'phone': phone},
      );
      if (response.statusCode == 200) return const Right(unit);
      return const Left(ServerFailure(message: '发送失败'));
    } catch (e) {
      _logger.e('❌ 发送验证码失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 处理登录响应
  Future<Either<Failure, LoginDataV2>> _handleLoginResponse(Response response) async {
    try {
      if (response.statusCode == 200 && response.data != null) {
        final loginResponse = LoginResponseV2.fromJson(response.data);
        if (loginResponse.isSuccess && loginResponse.data != null) {
          await _tokenManager.saveTokensFromV2(loginResponse.data!);
          _logger.i('✅ 登录成功');
          return Right(loginResponse.data!);
        }
      }
      return const Left(ServerFailure(message: '登录失败'));
    } catch (e) {
      _logger.e('❌ 解析响应失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 处理注册响应
  Future<Either<Failure, RegisterDataV2>> _handleRegisterResponse(Response response) async {
    try {
      if (response.statusCode == 200 && response.data != null) {
        final registerResponse = RegisterResponseV2.fromJson(response.data);
        if (registerResponse.isSuccess == true && registerResponse.data != null) {
          _logger.i('✅ 注册成功: userId=${registerResponse.data!.userId}');
          // 注册成功不保存token，需要用户重新登录
          return Right(registerResponse.data!);
        }
      }
      return const Left(ServerFailure(message: '注册失败'));
    } catch (e) {
      _logger.e('❌ 解析注册响应失败: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasValidToken();
  }
}
