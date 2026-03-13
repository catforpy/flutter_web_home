import 'package:official_website/domain/entities/account_settings.dart';

/// 账号设置模拟数据源
///
/// 所有假数据集中管理
class AccountSettingsMockDatasource {
  /// 获取用户设置
  static AccountSettings getSettings(String userId) {
    final now = DateTime.now();

    return AccountSettings(
      userId: userId,
      username: '张三',
      email: 'zhangsan@example.com',
      phone: '13800138000',
      avatar: 'https://via.placeholder.com/150',
      bio: '热爱编程，专注于 Flutter 开发',
      location: '北京市',
      website: 'https://github.com/zhangsan',
      birthdate: DateTime(1990, 1, 1),
      gender: Gender.male,
      notificationSettings: const NotificationSettings(
        emailNotification: true,
        pushNotification: true,
        smsNotification: false,
        marketingEmail: false,
      ),
      privacySettings: const PrivacySettings(
        profilePublic: true,
        showEmail: false,
        showPhone: false,
        allowSearch: true,
        showActivity: true,
      ),
    );
  }

  /// 更新设置
  static AccountSettings updateSettings(AccountSettings settings) {
    // TODO: 实现更新逻辑
    return settings;
  }

  /// 修改密码
  static bool changePassword(
    String oldPassword,
    String newPassword,
  ) {
    // TODO: 实现密码验证和修改
    if (oldPassword == '123456') {
      // 模拟验证失败
      return false;
    }
    return true;
  }

  /// 上传头像
  static String uploadAvatar(String filePath) {
    // TODO: 实现头像上传
    return 'https://via.placeholder.com/150';
  }

  /// 绑定手机
  static bool bindPhone(String phone, String code) {
    // TODO: 实现手机绑定验证
    if (code == '123456') {
      return true;
    }
    return false;
  }

  /// 绑定邮箱
  static bool bindEmail(String email, String code) {
    // TODO: 实现邮箱绑定验证
    if (code == '123456') {
      return true;
    }
    return false;
  }

  /// 注销账号
  static bool deleteAccount(String password) {
    // TODO: 实现账号注销
    if (password == '123456') {
      return true;
    }
    return false;
  }
}
