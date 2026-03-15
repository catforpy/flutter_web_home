import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../../domain/models/user_info.dart';

/// 本地存储服务
/// 统一管理应用的所有本地存储操作
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Logger _logger = Logger();
  SharedPreferences? _prefs;

  /// 初始化存储服务
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('✅ StorageService 初始化成功');
    } catch (e) {
      _logger.e('❌ StorageService 初始化失败: $e');
      rethrow;
    }
  }

  /// 确保已初始化
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('StorageService 未初始化，请先调用 init()');
    }
    return _prefs!;
  }

  // ==================== Token 存储 ====================

  /// 存储键常量
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyTokenExpireTime = 'auth_token_expire_time';
  static const String _keyUserInfo = 'user_info';

  /// 保存访问令牌
  Future<bool> saveAccessToken(String token) async {
    try {
      return await _preferences.setString(_keyAccessToken, token);
    } catch (e) {
      _logger.e('❌ 保存访问令牌失败: $e');
      return false;
    }
  }

  /// 获取访问令牌
  Future<String?> getAccessToken() async {
    try {
      return _preferences.getString(_keyAccessToken);
    } catch (e) {
      _logger.e('❌ 获取访问令牌失败: $e');
      return null;
    }
  }

  /// 保存刷新令牌
  Future<bool> saveRefreshToken(String token) async {
    try {
      return await _preferences.setString(_keyRefreshToken, token);
    } catch (e) {
      _logger.e('❌ 保存刷新令牌失败: $e');
      return false;
    }
  }

  /// 获取刷新令牌
  Future<String?> getRefreshToken() async {
    try {
      return _preferences.getString(_keyRefreshToken);
    } catch (e) {
      _logger.e('❌ 获取刷新令牌失败: $e');
      return null;
    }
  }

  /// 保存Token过期时间
  Future<bool> saveTokenExpireTime(int expireTimestamp) async {
    try {
      return await _preferences.setInt(_keyTokenExpireTime, expireTimestamp);
    } catch (e) {
      _logger.e('❌ 保存Token过期时间失败: $e');
      return false;
    }
  }

  /// 获取Token过期时间
  Future<int?> getTokenExpireTime() async {
    try {
      return _preferences.getInt(_keyTokenExpireTime);
    } catch (e) {
      _logger.e('❌ 获取Token过期时间失败: $e');
      return null;
    }
  }

  /// 清除所有Token
  Future<bool> clearTokens() async {
    try {
      await _preferences.remove(_keyAccessToken);
      await _preferences.remove(_keyRefreshToken);
      await _preferences.remove(_keyTokenExpireTime);
      return true;
    } catch (e) {
      _logger.e('❌ 清除Token失败: $e');
      return false;
    }
  }

  // ==================== 用户信息存储 ====================

  /// 保存用户信息
  Future<bool> saveUserInfo(UserInfo userInfo) async {
    try {
      final jsonString = jsonEncode(userInfo.toJson());
      return await _preferences.setString(_keyUserInfo, jsonString);
    } catch (e) {
      _logger.e('❌ 保存用户信息失败: $e');
      return false;
    }
  }

  /// 获取用户信息
  Future<UserInfo?> getUserInfo() async {
    try {
      final jsonString = _preferences.getString(_keyUserInfo);
      if (jsonString == null) return null;

      // 解析JSON字符串
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserInfo.fromJson(jsonMap);
    } catch (e) {
      _logger.e('❌ 获取用户信息失败: $e');
      return null;
    }
  }

  /// 清除用户信息
  Future<bool> clearUserInfo() async {
    try {
      return await _preferences.remove(_keyUserInfo);
    } catch (e) {
      _logger.e('❌ 清除用户信息失败: $e');
      return false;
    }
  }

  // ==================== 通用存储方法 ====================

  /// 保存字符串
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      _logger.e('❌ 保存字符串失败 [$key]: $e');
      return false;
    }
  }

  /// 获取字符串
  Future<String?> getString(String key) async {
    try {
      return _preferences.getString(key);
    } catch (e) {
      _logger.e('❌ 获取字符串失败 [$key]: $e');
      return null;
    }
  }

  /// 保存整数
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      _logger.e('❌ 保存整数失败 [$key]: $e');
      return false;
    }
  }

  /// 获取整数
  Future<int?> getInt(String key) async {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      _logger.e('❌ 获取整数失败 [$key]: $e');
      return null;
    }
  }

  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      _logger.e('❌ 保存布尔值失败 [$key]: $e');
      return false;
    }
  }

  /// 获取布尔值
  Future<bool?> getBool(String key) async {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      _logger.e('❌ 获取布尔值失败 [$key]: $e');
      return null;
    }
  }

  /// 保存双精度浮点数
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      _logger.e('❌ 保存双精度浮点数失败 [$key]: $e');
      return false;
    }
  }

  /// 获取双精度浮点数
  Future<double?> getDouble(String key) async {
    try {
      return _preferences.getDouble(key);
    } catch (e) {
      _logger.e('❌ 获取双精度浮点数失败 [$key]: $e');
      return null;
    }
  }

  /// 保存字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (e) {
      _logger.e('❌ 保存字符串列表失败 [$key]: $e');
      return false;
    }
  }

  /// 获取字符串列表
  Future<List<String>?> getStringList(String key) async {
    try {
      return _preferences.getStringList(key);
    } catch (e) {
      _logger.e('❌ 获取字符串列表失败 [$key]: $e');
      return null;
    }
  }

  /// 删除指定键
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      _logger.e('❌ 删除键失败 [$key]: $e');
      return false;
    }
  }

  /// 检查键是否存在
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// 清空所有数据
  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      _logger.e('❌ 清空存储失败: $e');
      return false;
    }
  }

  /// 获取所有键
  Set<String> getKeys() {
    return _preferences.getKeys();
  }
}
