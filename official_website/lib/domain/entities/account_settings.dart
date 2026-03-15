import 'package:flutter/material.dart';

/// 账号设置实体
class AccountSettings {
  final String userId;
  final String username;
  final String email;
  final String? phone;
  final String? avatar;
  final String? bio;
  final String? location;
  final String? website;
  final DateTime birthdate;
  final Gender gender;
  final NotificationSettings notificationSettings;
  final PrivacySettings privacySettings;

  const AccountSettings({
    required this.userId,
    required this.username,
    required this.email,
    this.phone,
    this.avatar,
    this.bio,
    this.location,
    this.website,
    required this.birthdate,
    required this.gender,
    required this.notificationSettings,
    required this.privacySettings,
  });

  AccountSettings copyWith({
    String? userId,
    String? username,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    String? location,
    String? website,
    DateTime? birthdate,
    Gender? gender,
    NotificationSettings? notificationSettings,
    PrivacySettings? privacySettings,
  }) {
    return AccountSettings(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      notificationSettings:
          notificationSettings ?? this.notificationSettings,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
}

/// 性别
enum Gender {
  male('男'),
  female('女'),
  other('其他');

  final String displayName;

  const Gender(this.displayName);
}

/// 通知设置
class NotificationSettings {
  final bool emailNotification;
  final bool pushNotification;
  final bool smsNotification;
  final bool marketingEmail;

  const NotificationSettings({
    this.emailNotification = true,
    this.pushNotification = true,
    this.smsNotification = false,
    this.marketingEmail = false,
  });

  NotificationSettings copyWith({
    bool? emailNotification,
    bool? pushNotification,
    bool? smsNotification,
    bool? marketingEmail,
  }) {
    return NotificationSettings(
      emailNotification:
          emailNotification ?? this.emailNotification,
      pushNotification: pushNotification ?? this.pushNotification,
      smsNotification: smsNotification ?? this.smsNotification,
      marketingEmail: marketingEmail ?? this.marketingEmail,
    );
  }

  Map<String, dynamic> toJson() => {
        'emailNotification': emailNotification,
        'pushNotification': pushNotification,
        'smsNotification': smsNotification,
        'marketingEmail': marketingEmail,
      };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      emailNotification: json['emailNotification'] as bool? ?? true,
      pushNotification: json['pushNotification'] as bool? ?? true,
      smsNotification: json['smsNotification'] as bool? ?? false,
      marketingEmail: json['marketingEmail'] as bool? ?? false,
    );
  }
}

/// 隐私设置
class PrivacySettings {
  final bool profilePublic;
  final bool showEmail;
  final bool showPhone;
  final bool allowSearch;
  final bool showActivity;

  const PrivacySettings({
    this.profilePublic = true,
    this.showEmail = false,
    this.showPhone = false,
    this.allowSearch = true,
    this.showActivity = true,
  });

  PrivacySettings copyWith({
    bool? profilePublic,
    bool? showEmail,
    bool? showPhone,
    bool? allowSearch,
    bool? showActivity,
  }) {
    return PrivacySettings(
      profilePublic: profilePublic ?? this.profilePublic,
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      allowSearch: allowSearch ?? this.allowSearch,
      showActivity: showActivity ?? this.showActivity,
    );
  }

  Map<String, dynamic> toJson() => {
        'profilePublic': profilePublic,
        'showEmail': showEmail,
        'showPhone': showPhone,
        'allowSearch': allowSearch,
        'showActivity': showActivity,
      };

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profilePublic: json['profilePublic'] as bool? ?? true,
      showEmail: json['showEmail'] as bool? ?? false,
      showPhone: json['showPhone'] as bool? ?? false,
      allowSearch: json['allowSearch'] as bool? ?? true,
      showActivity: json['showActivity'] as bool? ?? true,
    );
  }
}

/// 设置分类
enum SettingsCategory {
  basic('基本信息', Icons.person),
  security('安全设置', Icons.lock),
  notification('通知设置', Icons.notifications),
  privacy('隐私设置', Icons.privacy_tip),
  appearance('外观设置', Icons.palette);

  final String displayName;
  final IconData icon;

  const SettingsCategory(this.displayName, this.icon);
}
