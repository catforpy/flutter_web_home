import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:official_website/core/services/auth_service.dart';
import 'package:official_website/core/services/auth_v2_service.dart';
import 'package:official_website/core/services/token_manager.dart';
import 'package:official_website/domain/models/user_info.dart';
import 'package:official_website/domain/models/login_request.dart';
import 'package:official_website/domain/models/register_request.dart';

/// 用户类型枚举（向后兼容）
enum UserType {
  /// 客户（都达网账户）
  customer,
  /// 商户（服务商）
  merchant,
  /// 后台管理
  backend,
}

/// 认证状态管理
/// 使用简单的 ChangeNotifier 进行状态管理
/// 对接真实的后端API，不再使用假数据
class AuthState extends ChangeNotifier {
  static AuthState? _instance;
  factory AuthState() {
    _instance ??= AuthState._internal();
    return _instance!;
  }
  AuthState._internal() {
    // Don't initialize services here to avoid circular dependency
  }

  AuthService get _authService => _authServiceCache ??= AuthService();
  AuthService? _authServiceCache;

  AuthServiceV2 get _authServiceV2 => _authServiceV2Cache ??= AuthServiceV2();
  AuthServiceV2? _authServiceV2Cache;

  TokenManager get _tokenManager => _tokenManagerCache ??= TokenManager();
  TokenManager? _tokenManagerCache;

  final Logger _logger = Logger();

  /// 用户信息
  UserInfo? _userInfo;

  /// 是否已登录
  bool _isLoggedIn = false;

  /// 是否正在加载
  bool _isLoading = false;

  /// 错误信息
  String? _errorMessage;

  /// 用户信息
  UserInfo? get userInfo => _userInfo;

  /// 是否已登录
  bool get isLoggedIn => _isLoggedIn;

  /// 是否正在加载
  bool get isLoading => _isLoading;

  /// 错误信息
  String? get errorMessage => _errorMessage;

  /// 用户ID
  int? get userId => _userInfo?.userId;

  /// 用户名
  String? get username => _userInfo?.username;

  /// 真实姓名
  String? get realName => _userInfo?.realName;

  /// 显示名称（优先使用真实姓名，否则用户名）
  String? get displayName => _userInfo?.realName?.isNotEmpty == true
      ? _userInfo!.realName!
      : _userInfo?.username;

  /// 用户昵称（向后兼容）
  String get nickname => displayName ?? '都达用户';

  /// 用户类型
  String? get userType => _userInfo?.userType;

  /// 用户类型枚举（从String转换）
  UserType? get userTypeEnum {
    final type = _userInfo?.userType;
    if (type == null) return null;

    // 后端类型映射到前端枚举
    switch (type) {
      case 'normal':
      case 'platform_account':
        return UserType.customer;
      case 'merchant':
      case 'service_provider':
        return UserType.merchant;
      case 'backend_admin':
      case 'platform_admin':
        return UserType.backend;
      default:
        return null;
    }
  }

  /// 头像URL
  String? get avatarUrl => _userInfo?.avatar;

  /// 手机号
  String? get phone => _userInfo?.phone;

  /// 邮箱
  String? get email => _userInfo?.email;

  /// 是否为普通用户
  bool get isNormalUser => _userInfo?.isNormalUser ?? false;

  /// 是否为商家
  bool get isMerchant => _userInfo?.isMerchant ?? false;

  /// 是否为服务商
  bool get isServiceProvider => _userInfo?.isServiceProvider ?? false;

  /// 是否为平台管理员
  bool get isPlatformAdmin => _userInfo?.isPlatformAdmin ?? false;

  /// 是否为后台管理员
  bool get isBackendAdmin => _userInfo?.isBackendAdmin ?? false;

  // ==================== 初始化 ====================

  /// 初始化认证状态
  /// 检查本地是否有有效的Token
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final hasToken = await _tokenManager.hasValidToken();
      if (hasToken) {
        // 有Token，尝试获取用户信息
        final result = await _authService.getUserInfo();
        result.fold(
          (failure) {
            // Token无效，清除登录状态
            _clearAuthState();
          },
          (userInfo) {
            // Token有效，恢复登录状态
            _userInfo = userInfo;
            _isLoggedIn = true;
            notifyListeners();
          },
        );
      }
    } catch (e) {
      _setError('初始化认证状态失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  // ==================== 登录相关（使用V2接口） ====================

  /// 都达网账户 - 账号密码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/platform-account/login/password
  Future<bool> loginPlatformAccount({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginPlatformAccountByPassword(
        username: username,
        password: password,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _logger.i('✅ 登录成功并保存用户信息 - userType: ${_userInfo?.userType}, userId: ${_userInfo?.userId}');
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 都达网账户 - 手机验证码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/platform-account/login/sms
  Future<bool> loginPlatformAccountWithSms({
    required String phone,
    required String verifyCode,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginPlatformAccountBySms(
        phone: phone,
        phoneVerifyCode: verifyCode,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 服务商 - 账号密码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/service-provider/login/password
  Future<bool> loginServiceProvider({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginServiceProviderByPassword(
        username: username,
        password: password,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 服务商 - 手机验证码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/service-provider/login/sms
  Future<bool> loginServiceProviderWithSms({
    required String phone,
    required String verifyCode,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginServiceProviderBySms(
        phone: phone,
        phoneVerifyCode: verifyCode,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 平台管理员 - 账号密码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/platform-admin/login/password
  Future<bool> loginPlatformAdmin({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginPlatformAdminByPassword(
        username: username,
        password: password,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 后台管理员 - 账号密码登录
  ///
  /// 使用V2接口：POST /api/auth/v2/backend-admin/login/password
  Future<bool> loginBackendAdmin({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.loginBackendAdminByPassword(
        username: username,
        password: password,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== V1通用接口（保留向后兼容） ====================

  /// 用户登录（V1通用接口，向后兼容）
  ///
  /// 支持只传userType的简化调用方式（用于TODO代码）
  Future<bool> login({
    String? username,
    String? password,
    String? userType,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest.forAccountPassword(
        userType: userType ?? 'normal',
        username: username ?? '',
        password: password ?? '',
      );

      final result = await _authService.login(request);

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 手机验证码登录（V1通用接口）
  ///
  /// 对接后端 POST /api/auth/login
  Future<bool> loginWithSms({
    required String phone,
    required String verifyCode,
    String userType = 'normal',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest.forPhoneSms(
        userType: userType,
        phone: phone,
        phoneVerifyCode: verifyCode,
      );

      final result = await _authService.login(request);

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
                  return true;
        },
      );
    } catch (e) {
      _setError('登录失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== 注册相关 ====================

  /// 都达网账户 - 账号密码注册（V2接口）
  ///
  /// 对接后端 POST /api/auth/v2/platform-account/register/password
  ///
  /// 注意：注册成功不返回token，需要用户重新登录
  ///
  /// 参数:
  /// - [username] 用户名
  /// - [password] 密码
  /// - [confirmPassword] 确认密码
  ///
  /// 返回:
  /// - bool: 是否注册成功
  Future<bool> registerPlatformAccount({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authServiceV2.registerPlatformAccountByPassword(
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (registerData) {
          // 注册成功，但不设置登录状态（需要用户重新登录获取token）
          _logger.i('✅ 注册成功，请登录: userId=${registerData.userId}');
          return true;
        },
      );
    } catch (e) {
      _setError('注册失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 用户注册（账号密码，V1接口，向后兼容）
  ///
  /// 参数:
  /// - [username] 用户名
  /// - [password] 密码
  /// - [confirmPassword] 确认密码
  /// - [userType] 用户类型（默认为普通用户）
  /// - [realName] 真实姓名（可选）
  /// - [phone] 手机号（可选）
  ///
  /// 返回:
  /// - bool: 是否注册成功
  Future<bool> register({
    required String username,
    required String password,
    required String confirmPassword,
    String userType = 'normal',
    String? realName,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest.forAccountPassword(
        userType: userType,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
        realName: realName,
        phone: phone,
      );

      final result = await _authService.register(request);

      return result.fold(
        (failure) {
          _setError(failure.message);
          return false;
        },
        (loginResponse) {
          // 注册成功后自动登录
          _userInfo = UserInfo.fromLoginResponse(loginResponse);
          _isLoggedIn = true;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _setError('注册失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ==================== 登出 ====================

  /// 退出登录
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      // 调用V2登出接口
      await _authServiceV2.logout();

      // 清除认证状态
      _clearAuthState();

      _logger.i('✅ 退出登录成功');
    } catch (e) {
      _logger.e('❌ 退出登录失败: $e');
      _setError('登出失败: $e');
      // 即使失败也清除本地状态
      _clearAuthState();
    } finally {
      _setLoading(false);
    }
  }

  // ==================== 用户信息更新 ====================

  /// 刷新用户信息
  Future<void> refreshUserInfo() async {
    if (!isLoggedIn) return;

    try {
      final result = await _authService.getUserInfo();
      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (userInfo) {
          _userInfo = userInfo;
          notifyListeners();
        },
      );
    } catch (e) {
      _setError('刷新用户信息失败: $e');
    }
  }

  // ==================== 私有方法 ====================

  /// 清除认证状态
  void _clearAuthState() {
    _userInfo = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 设置错误信息
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// 清除错误信息
  void _clearError() {
    _errorMessage = null;
  }

  /// 获取用户类型的中文名称
  String getUserTypeName() {
    return _userInfo?.getUserTypeName ?? '未登录';
  }
}

/// 全局认证状态实例（保留向后兼容）
final AuthState authState = AuthState();

/// UserType枚举扩展
extension UserTypeExtension on UserType {
  /// 转换为后端使用的用户类型字符串
  String toBackendString() {
    switch (this) {
      case UserType.customer:
        return 'normal';
      case UserType.merchant:
        return 'merchant';
      case UserType.backend:
        return 'backend_admin';
    }
  }
}
