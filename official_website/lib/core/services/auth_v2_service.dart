import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/config/backend_api_config.dart';
import 'package:official_website/core/services/token_manager.dart';
import 'package:official_website/domain/models/login_response_v2.dart';
import 'package:official_website/domain/models/register_response_v2.dart';
import 'package:official_website/domain/models/user_info.dart';

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
          final loginData = loginResponse.data!;
          _logger.i('✅ 登录成功 - userType: ${loginData.userType}, userId: ${loginData.userId}, username: ${loginData.username}');
          await _tokenManager.saveTokensFromV2(loginData);
          return Right(loginData);
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

  // ==================== Token刷新 ====================

  /// 刷新Token
  ///
  /// 对接后端 POST /api/auth/v2/refresh
  ///
  /// 返回:
  /// - Either<Failure, LoginDataV2>: 成功返回新的登录数据，失败返回错误
  Future<Either<Failure, LoginDataV2>> refreshToken() async {
    try {
      _logger.i('🔄 开始刷新Token（V2接口）');

      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.w('⚠️  没有刷新令牌');
        return const Left(ServerFailure(message: '没有刷新令牌'));
      }

      final response = await _apiClient.dio.post(
        BackendApiConfig.refresh,
        data: {'refreshToken': refreshToken},
      );

      return _handleLoginResponse(response);
    } catch (e) {
      _logger.e('❌ Token刷新异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 用户登出 ====================

  /// 用户登出
  ///
  /// 对接后端 POST /api/auth/v2/logout
  ///
  /// 返回:
  /// - Either<Failure, Unit>: 成功返回Unit，失败返回错误
  Future<Either<Failure, Unit>> logout() async {
    try {
      _logger.i('🚪 开始登出（V2接口）');

      final response = await _apiClient.dio.post(
        BackendApiConfig.logout,
      );

      // 无论后端是否成功，都清除本地Token
      await _tokenManager.clearTokens();

      if (response.statusCode == 200) {
        _logger.i('✅ 登出成功');
        return const Right(unit);
      }

      _logger.w('⚠️  登出请求失败，但已清除本地Token');
      return const Right(unit);
    } catch (e) {
      _logger.e('❌ 登出异常: $e');
      // 即使发生异常，也清除本地Token
      await _tokenManager.clearTokens();
      return const Right(unit);
    }
  }

  // ==================== 验证Token ====================

  /// 验证Token是否有效
  ///
  /// 对接后端 GET /api/auth/v2/validate
  ///
  /// 返回:
  /// - Either<Failure, bool>: 成功返回Token是否有效，失败返回错误
  Future<Either<Failure, bool>> validateToken() async {
    try {
      _logger.d('🔍 验证Token有效性（V2接口）');

      final response = await _apiClient.dio.get(
        BackendApiConfig.validate,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code == 200) {
            final isValid = data['data'] as bool? ?? false;
            _logger.d('✅ Token验证结果: $isValid');
            return Right(isValid);
          }
        }
      }

      _logger.w('⚠️  Token无效');
      return const Right(false);
    } catch (e) {
      _logger.e('❌ 验证Token异常: $e');
      return const Right(false);
    }
  }

  // ==================== 获取用户信息 ====================

  /// 获取当前用户信息
  ///
  /// 对接后端 GET /api/auth/v2/user/info
  ///
  /// 返回:
  /// - Either<Failure, UserInfo>: 成功返回用户信息，失败返回错误
  Future<Either<Failure, UserInfo>> getUserInfo() async {
    try {
      _logger.i('👤 获取用户信息（V2接口）');

      final response = await _apiClient.dio.get(
        BackendApiConfig.userInfo,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code == 200) {
            final userData = data['data'] as Map<String, dynamic>?;
            if (userData != null) {
              final userInfo = UserInfo.fromJson(userData);
              _logger.i('✅ 获取用户信息成功: userId=${userInfo.userId}');
              return Right(userInfo);
            }
          }
        }
      }

      _logger.e('❌ 获取用户信息失败');
      return const Left(ServerFailure(message: '获取用户信息失败'));
    } catch (e) {
      _logger.e('❌ 获取用户信息异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasValidToken();
  }
}
