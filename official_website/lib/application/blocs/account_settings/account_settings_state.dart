import 'package:equatable/equatable.dart';
import 'package:official_website/domain/entities/account_settings.dart';

/// 账号设置状态基类
abstract class AccountSettingsState extends Equatable {
  const AccountSettingsState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class AccountSettingsInitial extends AccountSettingsState {
  const AccountSettingsInitial();
}

/// 加载中
class AccountSettingsLoading extends AccountSettingsState {
  const AccountSettingsLoading();
}

/// 已加载
class AccountSettingsLoaded extends AccountSettingsState {
  final AccountSettings settings;

  const AccountSettingsLoaded({
    required this.settings,
  });

  @override
  List<Object?> get props => [settings];

  AccountSettingsLoaded copyWith({
    AccountSettings? settings,
  }) {
    return AccountSettingsLoaded(
      settings: settings ?? this.settings,
    );
  }
}

/// 更新中
class AccountSettingsUpdating extends AccountSettingsState {
  final AccountSettings settings;

  const AccountSettingsUpdating({
    required this.settings,
  });

  @override
  List<Object?> get props => [settings];
}

/// 错误状态
class AccountSettingsError extends AccountSettingsState {
  final String message;

  const AccountSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
