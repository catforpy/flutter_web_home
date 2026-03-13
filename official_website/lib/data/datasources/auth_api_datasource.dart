import 'package:dartz/dartz.dart';
import 'package:official_website/core/error/failures.dart';
import 'package:official_website/core/network/api_client.dart';
import 'package:official_website/core/network/api_config.dart';
import 'package:official_website/domain/entities/user.dart';

/// 认证 API 数据源
///
/// 负责与后端认证接口交互
/// 这是接口对接的第一个示例
class AuthApiDatasource {
  final ApiClient _apiClient = ApiClient();

  /// 用户登录
  ///
  /// 对接后端登录接口
  /// POST /api/auth/login
  ///
  /// 参数:
  /// - phone: 手机号
  /// - password: 密码
  ///
  /// 返回:
  /// - Either<Failure, User>: 成功返回用户信息，失败返回错误
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  }) async {
    return _apiClient.post<User>(
      ApiConfig.authLogin,
      data: {
        'phone': phone,
        'password': password,
      },
      fromJson: (json) {
        // 解析后端返回的用户数据
        final data = json as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>? ?? data;

        // 保存 Token
        final token = data['accessToken'] as String? ?? data['token'] as String?;
        if (token != null) {
          _apiClient.setAuthToken(token);
        }

        return User.fromJson(userData);
      },
    );
  }

  /// 用户注册
  ///
  /// 对接后端注册接口
  /// POST /api/auth/register
  Future<Either<Failure, User>> register({
    required String phone,
    required String password,
    required String verifyCode,
    String? nickname,
  }) async {
    return _apiClient.post<User>(
      ApiConfig.authRegister,
      data: {
        'phone': phone,
        'password': password,
        'verifyCode': verifyCode,
        if (nickname != null) 'nickname': nickname,
      },
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>? ?? data;

        // 注册成功后自动保存 Token
        final token = data['accessToken'] as String? ?? data['token'] as String?;
        if (token != null) {
          _apiClient.setAuthToken(token);
        }

        return User.fromJson(userData);
      },
    );
  }

  /// 发送验证码
  ///
  /// POST /api/auth/send-code
  Future<Either<Failure, Unit>> sendVerifyCode({
    required String phone,
    required String type, // 'register' | 'login' | 'reset_password'
  }) async {
    return _apiClient.post(
      '/auth/send-code',
      data: {
        'phone': phone,
        'type': type,
      },
    );
  }

  /// 重置密码
  ///
  /// POST /api/auth/reset-password
  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String verifyCode,
    required String newPassword,
  }) async {
    return _apiClient.post(
      '/auth/reset-password',
      data: {
        'phone': phone,
        'verifyCode': verifyCode,
        'newPassword': newPassword,
      },
    );
  }

  /// 退出登录
  ///
  /// POST /api/auth/logout
  Future<Either<Failure, Unit>> logout() async {
    final result = await _apiClient.post(ApiConfig.authLogout);

    // 无论后端是否成功，都清除本地 Token
    await _apiClient.clearAuthToken();

    return result;
  }

  /// 刷新 Token
  ///
  /// POST /api/auth/refresh
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    return _apiClient.post<String>(
      ApiConfig.authRefresh,
      data: {'refreshToken': refreshToken},
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        final token = data['accessToken'] as String? ?? data['token'] as String?;

        // 保存新 Token
        if (token != null) {
          _apiClient.setAuthToken(token);
        }

        return token ?? '';
      },
    );
  }
}
