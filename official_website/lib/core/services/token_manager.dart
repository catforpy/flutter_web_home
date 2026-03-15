import 'package:logger/logger.dart';
import 'storage_service.dart';
import '../../domain/models/login_response_v2.dart';

/// Token管理器
/// 负责管理访问令牌和刷新令牌的生命周期
class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final StorageService _storageService = StorageService();
  final Logger _logger = Logger();

  /// 当前访问令牌（内存缓存）
  String? _accessToken;

  /// 当前刷新令牌（内存缓存）
  String? _refreshToken;

  /// Token过期时间戳（秒）
  int? _expireTimestamp;

  // ==================== Token 设置 ====================

  /// 保存登录响应中的Token信息（V2）
  Future<void> saveTokensFromV2(LoginDataV2 loginData) async {
    try {
      final accessToken = loginData.accessToken ?? '';
      final refreshToken = loginData.refreshToken ?? '';
      final expiresIn = loginData.expiresIn ?? 7200;

      // 保存到本地存储
      await _storageService.saveAccessToken(accessToken);
      await _storageService.saveRefreshToken(refreshToken);

      // 计算过期时间戳
      final expireTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn;
      await _storageService.saveTokenExpireTime(expireTime);

      // 更新内存缓存
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      _expireTimestamp = expireTime;

      _logger.i('✅ Token保存成功（V2）');
      _logger.d('📅 Token过期时间: ${DateTime.fromMillisecondsSinceEpoch(expireTime * 1000)}');
      _logger.d('👤 用户: ${loginData.username} (${loginData.userType})');
    } catch (e) {
      _logger.e('❌ 保存Token失败: $e');
      rethrow;
    }
  }

  /// 保存登录响应中的Token信息（V1兼容）
  Future<void> saveTokens(dynamic loginResponse) async {
    try {
      // 如果是V2的LoginDataV2
      if (loginResponse is LoginDataV2) {
        await saveTokensFromV2(loginResponse);
        return;
      }

      // V1的兼容代码
      _logger.w('⚠️  使用V1 Token保存方式，建议升级到V2');
      // 这里可以添加V1的Token保存逻辑
    } catch (e) {
      _logger.e('❌ 保存Token失败: $e');
      rethrow;
    }
  }

  /// 设置访问令牌（用于刷新Token后）
  Future<void> setAccessToken(String token, {int? expiresIn}) async {
    try {
      await _storageService.saveAccessToken(token);

      // 更新过期时间
      if (expiresIn != null) {
        final expireTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn;
        await _storageService.saveTokenExpireTime(expireTime);
        _expireTimestamp = expireTime;
      }

      _accessToken = token;
      _logger.i('✅ 访问令牌更新成功');
    } catch (e) {
      _logger.e('❌ 更新访问令牌失败: $e');
      rethrow;
    }
  }

  // ==================== Token 获取 ====================

  /// 获取访问令牌
  /// 优先从内存获取，如果内存没有则从本地存储获取
  Future<String?> getAccessToken() async {
    try {
      // 先返回内存中的Token
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        return _accessToken;
      }

      // 从本地存储获取
      _accessToken = await _storageService.getAccessToken();
      return _accessToken;
    } catch (e) {
      _logger.e('❌ 获取访问令牌失败: $e');
      return null;
    }
  }

  /// 获取刷新令牌
  Future<String?> getRefreshToken() async {
    try {
      // 先返回内存中的Token
      if (_refreshToken != null && _refreshToken!.isNotEmpty) {
        return _refreshToken;
      }

      // 从本地存储获取
      _refreshToken = await _storageService.getRefreshToken();
      return _refreshToken;
    } catch (e) {
      _logger.e('❌ 获取刷新令牌失败: $e');
      return null;
    }
  }

  // ==================== Token 验证 ====================

  /// 检查是否有有效的访问令牌
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// 检查是否有刷新令牌
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  /// 检查Token是否即将过期（5分钟内）
  Future<bool> isTokenAboutToExpire() async {
    try {
      final expireTime = await _storageService.getTokenExpireTime();
      if (expireTime == null) return false;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final warningTime = now + 300; // 5分钟后

      return expireTime < warningTime;
    } catch (e) {
      _logger.e('❌ 检查Token过期状态失败: $e');
      return false;
    }
  }

  /// 检查Token是否已过期
  Future<bool> isTokenExpired() async {
    try {
      final expireTime = await _storageService.getTokenExpireTime();
      if (expireTime == null) return false;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expireTime < now;
    } catch (e) {
      _logger.e('❌ 检查Token过期失败: $e');
      return false;
    }
  }

  /// 检查是否需要刷新Token
  Future<bool> shouldRefreshToken() async {
    if (!await hasValidToken()) return false;
    if (!await hasRefreshToken()) return false;
    return await isTokenAboutToExpire();
  }

  // ==================== Token 清除 ====================

  /// 清除所有Token
  Future<void> clearTokens() async {
    try {
      await _storageService.clearTokens();

      // 清除内存缓存
      _accessToken = null;
      _refreshToken = null;
      _expireTimestamp = null;

      _logger.i('✅ Token清除成功');
    } catch (e) {
      _logger.e('❌ 清除Token失败: $e');
      rethrow;
    }
  }

  // ==================== 辅助方法 ====================

  /// 获取Token过期时间
  Future<DateTime?> getExpireTime() async {
    try {
      final timestamp = await _storageService.getTokenExpireTime();
      if (timestamp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } catch (e) {
      _logger.e('❌ 获取Token过期时间失败: $e');
      return null;
    }
  }

  /// 获取Token剩余有效时间（秒）
  Future<int?> getRemainingTime() async {
    try {
      final expireTime = await _storageService.getTokenExpireTime();
      if (expireTime == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final remaining = expireTime - now;

      return remaining > 0 ? remaining : 0;
    } catch (e) {
      _logger.e('❌ 获取Token剩余时间失败: $e');
      return null;
    }
  }

  /// 打印Token状态（调试用）
  Future<void> printTokenStatus() async {
    final hasToken = await hasValidToken();
    final hasRefresh = await hasRefreshToken();
    final expired = await isTokenExpired();
    final aboutToExpire = await isTokenAboutToExpire();
    final expireTime = await getExpireTime();
    final remaining = await getRemainingTime();

    _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    _logger.d('📊 Token状态');
    _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    _logger.d('✅ 有访问令牌: $hasToken');
    _logger.d('🔄 有刷新令牌: $hasRefresh');
    _logger.d('⏰ 已过期: $expired');
    _logger.d('⚠️  即将过期(5分钟内): $aboutToExpire');
    _logger.d('📅 过期时间: $expireTime');
    _logger.d('⏳ 剩余时间: ${remaining != null ? '$remaining秒' : '未知'}');
    _logger.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
