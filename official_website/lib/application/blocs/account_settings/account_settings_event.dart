import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/account_settings.dart';

/// 账号设置事件基类
abstract class AccountSettingsEvent extends Equatable {
  const AccountSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// 加载设置
class LoadSettingsEvent extends AccountSettingsEvent {
  final String userId;

  const LoadSettingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// 更新基本信息
class UpdateBasicInfoEvent extends AccountSettingsEvent {
  final String username;
  final String? bio;
  final String? location;
  final String? website;
  final DateTime? birthdate;
  final Gender? gender;

  const UpdateBasicInfoEvent({
    required this.username,
    this.bio,
    this.location,
    this.website,
    this.birthdate,
    this.gender,
  });

  @override
  List<Object?> get props =>
      [username, bio, location, website, birthdate, gender];
}

/// 修改密码
class ChangePasswordEvent extends AccountSettingsEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

/// 上传头像
class UploadAvatarEvent extends AccountSettingsEvent {
  final String filePath;

  const UploadAvatarEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// 绑定手机
class BindPhoneEvent extends AccountSettingsEvent {
  final String phone;
  final String code;

  const BindPhoneEvent({
    required this.phone,
    required this.code,
  });

  @override
  List<Object?> get props => [phone, code];
}

/// 绑定邮箱
class BindEmailEvent extends AccountSettingsEvent {
  final String email;
  final String code;

  const BindEmailEvent({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}

/// 更新通知设置
class UpdateNotificationSettingsEvent extends AccountSettingsEvent {
  final NotificationSettings settings;

  const UpdateNotificationSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// 更新隐私设置
class UpdatePrivacySettingsEvent extends AccountSettingsEvent {
  final PrivacySettings settings;

  const UpdatePrivacySettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// 注销账号
class DeleteAccountEvent extends AccountSettingsEvent {
  final String password;

  const DeleteAccountEvent(this.password);

  @override
  List<Object?> get props => [password];
}
