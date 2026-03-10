import 'package:flutter/material.dart';

/// 用户类型枚举
enum UserType {
  /// 客户
  customer,
  /// 商户
  merchant,
  /// 后台管理
  backend,
}

/// 认证状态管理
/// 使用简单的 ChangeNotifier 进行状态管理
class AuthState extends ChangeNotifier {
  /// 是否已登录
  bool _isLoggedIn = false;

  /// 用户类型
  UserType? _userType;

  /// 用户头像URL
  String? _avatarUrl;

  /// 用户昵称
  String _nickname = '都达用户';

  /// 是否已登录
  bool get isLoggedIn => _isLoggedIn;

  /// 用户类型
  UserType? get userType => _userType;

  /// 用户头像URL
  String? get avatarUrl => _avatarUrl;

  /// 用户昵称
  String get nickname => _nickname;

  /// 登录
  void login({
    required UserType userType,
    String? avatarUrl,
    String? nickname,
  }) {
    _isLoggedIn = true;
    _userType = userType;
    _avatarUrl = avatarUrl;
    if (nickname != null && nickname.isNotEmpty) {
      _nickname = nickname;
    }
    notifyListeners();
  }

  /// 退出登录
  void logout() {
    _isLoggedIn = false;
    _userType = null;
    _avatarUrl = null;
    _nickname = '都达用户';
    notifyListeners();
  }

  /// 更新用户头像
  void updateAvatar(String avatarUrl) {
    _avatarUrl = avatarUrl;
    notifyListeners();
  }

  /// 更新用户昵称
  void updateNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  /// 获取用户类型的中文名称
  String getUserTypeName() {
    switch (_userType) {
      case UserType.customer:
        return '客户';
      case UserType.merchant:
        return '商户';
      case UserType.backend:
        return '后台管理';
      case null:
        return '未登录';
    }
  }
}

/// 全局认证状态实例
final AuthState authState = AuthState();
