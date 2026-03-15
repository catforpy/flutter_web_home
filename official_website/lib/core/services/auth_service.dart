import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/network/api_config.dart';
import 'package:official_website/core/services/token_manager.dart';
import 'package:official_website/domain/models/login_response.dart';
import 'package:official_website/domain/models/login_request.dart';
import 'package:official_website/domain/models/register_request.dart';
import 'package:official_website/domain/models/user_info.dart';

/// 认证服务
/// 对接后端认证API，提供登录、注册、登出等功能
class AuthService {
  static AuthService? _instance;
  factory AuthService() {
    _instance ??= AuthService._internal();
    return _instance!;
  }
  AuthService._internal() {
    // 延迟初始化，避免循环依赖
  }

  ApiClient get _apiClient => _apiClientCache ??= ApiClient();
  ApiClient? _apiClientCache;

  TokenManager get _tokenManager => _tokenManagerCache ??= TokenManager();
  TokenManager? _tokenManagerCache;

  final Logger _logger = Logger();

  // ==================== 用户注册 ====================

  /// 用户注册（V1接口，向后兼容）
  ///
  /// 对接后端 POST /api/auth/register
  ///
  /// 参数:
  /// - [request] 注册请求对象
  ///
  /// 返回:
  /// - Either<Failure, LoginResponse>: 成功返回登录响应（包含Token），失败返回错误
  ///
  /// 注意：建议使用V2接口的注册方法（通过 AuthServiceV2）
  Future<Either<Failure, LoginResponse>> register(RegisterRequest request) async {
    try {
      _logger.i('📝 开始注册（V1接口）: ${request.userType} - ${request.registerType}');

      // 验证请求参数
      final validationError = request.validate();
      if (validationError != null) {
        _logger.w('⚠️  注册参数验证失败: $validationError');
        return Left(ValidationFailure(message: validationError));
      }

      // 使用V1注册接口
      final response = await _apiClient.dio.post(
        ApiConfig.authRegister,
        data: request.toJson(),
      );

      // 检查响应状态
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // 检查业务状态码
        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code != 200) {
            final message = data['message'] as String? ?? data['msg'] as String? ?? '注册失败';
            return Left(ServerFailure(message: message));
          }

          // 解析登录响应
          final responseData = data['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            final loginResponse = LoginResponse.fromJson(responseData);

            // 保存Token
            await _tokenManager.saveTokens(loginResponse);

            _logger.i('✅ 注册成功: userId=${loginResponse.userId}');
            return Right(loginResponse);
          }
        }
      }

      _logger.e('❌ 注册失败: ${response.statusCode}');
      return const Left(ServerFailure(message: '注册失败'));
    } catch (e) {
      _logger.e('❌ 注册异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 用户登录 ====================

  /// 用户登录
  ///
  /// 对接后端 POST /api/auth/login
  ///
  /// 参数:
  /// - [request] 登录请求对象
  ///
  /// 返回:
  /// - Either<Failure, LoginResponse>: 成功返回登录响应，失败返回错误
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      _logger.i('🔑 开始登录: ${request.userType} - ${request.loginType}');

      // 验证请求参数
      final validationError = request.validate();
      if (validationError != null) {
        _logger.w('⚠️  登录参数验证失败: $validationError');
        return Left(ValidationFailure(message: validationError));
      }

      final response = await _apiClient.dio.post(
        ApiConfig.authLogin,
        data: request.toJson(),
      );

      // 检查响应状态
      if (response.statusCode == 200) {
        final data = response.data;

        // 检查业务状态码
        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code != 200) {
            final message = data['message'] as String? ?? data['msg'] as String? ?? '登录失败';
            return Left(ServerFailure(message: message));
          }

          // 解析登录响应
          final responseData = data['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            final loginResponse = LoginResponse.fromJson(responseData);

            // 保存Token
            await _tokenManager.saveTokens(loginResponse);

            _logger.i('✅ 登录成功: userId=${loginResponse.userId}, username=${loginResponse.username}');
            return Right(loginResponse);
          }
        }
      }

      _logger.e('❌ 登录失败: ${response.statusCode}');
      return const Left(ServerFailure(message: '登录失败'));
    } catch (e) {
      _logger.e('❌ 登录异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 用户登出 ====================

  /// 用户登出
  ///
  /// 对接后端 POST /api/auth/logout
  ///
  /// 参数:
  /// - [userId] 用户ID
  ///
  /// 返回:
  /// - Either<Failure, Unit>: 成功返回Unit，失败返回错误
  Future<Either<Failure, Unit>> logout(int userId) async {
    try {
      _logger.i('🚪 开始登出: userId=$userId');

      final token = await _tokenManager.getAccessToken();
      if (token == null) {
        // 即使没有Token，也清除本地Token
        await _tokenManager.clearTokens();
        return const Right(unit);
      }

      final response = await _apiClient.dio.post(
        ApiConfig.authLogout,
        options: _optionsWithAuth(),
        queryParameters: {'userId': userId},
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

  // ==================== 刷新Token ====================

  /// 刷新Token
  ///
  /// 对接后端 POST /api/auth/refresh
  ///
  /// 返回:
  /// - Either<Failure, LoginResponse>: 成功返回新的登录响应，失败返回错误
  Future<Either<Failure, LoginResponse>> refreshToken() async {
    try {
      _logger.i('🔄 开始刷新Token');

      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logger.w('⚠️  没有刷新令牌');
        return const Left(ServerFailure(message: '没有刷新令牌'));
      }

      final response = await _apiClient.dio.post(
        ApiConfig.authRefresh,
        queryParameters: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code != 200) {
            final message = data['message'] as String? ?? data['msg'] as String? ?? '刷新Token失败';
            return Left(ServerFailure(message: message));
          }

          final responseData = data['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            final loginResponse = LoginResponse.fromJson(responseData);

            // 更新Token
            await _tokenManager.setAccessToken(
              loginResponse.accessToken,
              expiresIn: loginResponse.expiresIn,
            );

            _logger.i('✅ Token刷新成功');
            return Right(loginResponse);
          }
        }
      }

      _logger.e('❌ Token刷新失败: ${response.statusCode}');
      return const Left(ServerFailure(message: '刷新Token失败'));
    } catch (e) {
      _logger.e('❌ Token刷新异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 验证Token ====================

  /// 验证Token是否有效
  ///
  /// 对接后端 GET /api/auth/validate
  ///
  /// 返回:
  /// - Either<Failure, bool>: 成功返回Token是否有效，失败返回错误
  Future<Either<Failure, bool>> validateToken() async {
    try {
      _logger.d('🔍 验证Token有效性');

      final response = await _apiClient.dio.get(
        ApiConfig.authValidate,
        options: _optionsWithAuth(),
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
  /// 对接后端 GET /api/auth/user/info
  ///
  /// 返回:
  /// - Either<Failure, UserInfo>: 成功返回用户信息，失败返回错误
  Future<Either<Failure, UserInfo>> getUserInfo() async {
    try {
      _logger.d('👤 获取用户信息');

      final response = await _apiClient.dio.get(
        ApiConfig.authUserInfo,
        options: _optionsWithAuth(),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code == 200) {
            final userData = data['data'] as Map<String, dynamic>?;
            if (userData != null) {
              final userInfo = UserInfo.fromJson(userData);
              _logger.d('✅ 获取用户信息成功: ${userInfo.username}');
              return Right(userInfo);
            }
          }
        }
      }

      _logger.e('❌ 获取用户信息失败: ${response.statusCode}');
      return const Left(ServerFailure(message: '获取用户信息失败'));
    } catch (e) {
      _logger.e('❌ 获取用户信息异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 发送验证码 ====================

  /// 发送短信验证码
  ///
  /// 对接后端 POST /api/auth/sms/send
  ///
  /// 参数:
  /// - [phone] 手机号
  ///
  /// 返回:
  /// - Either<Failure, Unit>: 成功返回Unit，失败返回错误
  Future<Either<Failure, Unit>> sendSmsCode(String phone) async {
    try {
      _logger.i('📨 发送验证码: $phone');

      final response = await _apiClient.dio.post(
        ApiConfig.authSendSms,
        queryParameters: {'phone': phone},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final code = data['code'] as int?;
          if (code != null && code == 200) {
            _logger.i('✅ 验证码发送成功');
            return const Right(unit);
          }
        }
      }

      _logger.e('❌ 发送验证码失败: ${response.statusCode}');
      return const Left(ServerFailure(message: '发送验证码失败'));
    } catch (e) {
      _logger.e('❌ 发送验证码异常: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ==================== 私有辅助方法 ====================

  /// 创建带认证的请求选项
  Options _optionsWithAuth() {
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasValidToken();
  }

  /// 检查是否需要刷新Token
  Future<bool> shouldRefreshToken() async {
    return await _tokenManager.shouldRefreshToken();
  }
}
