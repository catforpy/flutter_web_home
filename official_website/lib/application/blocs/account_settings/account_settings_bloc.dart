import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/account_settings/account_settings_event.dart';
import 'package:official_website/application/blocs/account_settings/account_settings_state.dart';
import 'package:official_website/domain/repositories/account_settings_repository.dart';

/// 账号设置 BLoC
class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final AccountSettingsRepository repository;

  AccountSettingsBloc({required this.repository})
      : super(const AccountSettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateBasicInfoEvent>(_onUpdateBasicInfo);
    on<ChangePasswordEvent>(_onChangePassword);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<BindPhoneEvent>(_onBindPhone);
    on<BindEmailEvent>(_onBindEmail);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<UpdatePrivacySettingsEvent>(_onUpdatePrivacySettings);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    emit(const AccountSettingsLoading());

    final result = await repository.getSettings(event.userId);

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (settings) => emit(AccountSettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateBasicInfo(
    UpdateBasicInfoEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    if (state is! AccountSettingsLoaded) return;

    final currentState = state as AccountSettingsLoaded;
    emit(AccountSettingsUpdating(settings: currentState.settings));

    final updatedSettings = currentState.settings.copyWith(
      username: event.username,
      bio: event.bio,
      location: event.location,
      website: event.website,
      birthdate: event.birthdate,
      gender: event.gender,
    );

    final result = await repository.updateSettings(updatedSettings);

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) => emit(AccountSettingsLoaded(settings: updatedSettings)),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    final result = await repository.changePassword(
      userId: 'current_user_id', // TODO: 从认证服务获取
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) {
        // 密码修改成功，可以显示成功提示
        if (state is AccountSettingsLoaded) {
          emit(state); // 保持当前状态
        }
      },
    );
  }

  Future<void> _onUploadAvatar(
    UploadAvatarEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    if (state is! AccountSettingsLoaded) return;

    final currentState = state as AccountSettingsLoaded;

    final result = await repository.uploadAvatar(
      userId: currentState.settings.userId,
      filePath: event.filePath,
    );

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (avatarUrl) {
        final updatedSettings =
            currentState.settings.copyWith(avatar: avatarUrl);
        emit(AccountSettingsLoaded(settings: updatedSettings));
      },
    );
  }

  Future<void> _onBindPhone(
    BindPhoneEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    final result = await repository.bindPhone(
      userId: 'current_user_id', // TODO: 从认证服务获取
      phone: event.phone,
      code: event.code,
    );

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) {
        // 绑定成功
        if (state is AccountSettingsLoaded) {
          emit(state); // 保持当前状态
        }
      },
    );
  }

  Future<void> _onBindEmail(
    BindEmailEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    final result = await repository.bindEmail(
      userId: 'current_user_id', // TODO: 从认证服务获取
      email: event.email,
      code: event.code,
    );

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) {
        // 绑定成功
        if (state is AccountSettingsLoaded) {
          emit(state); // 保持当前状态
        }
      },
    );
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    if (state is! AccountSettingsLoaded) return;

    final currentState = state as AccountSettingsLoaded;

    final updatedSettings = currentState.settings.copyWith(
      notificationSettings: event.settings,
    );

    final result = await repository.updateSettings(updatedSettings);

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) => emit(AccountSettingsLoaded(settings: updatedSettings)),
    );
  }

  Future<void> _onUpdatePrivacySettings(
    UpdatePrivacySettingsEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    if (state is! AccountSettingsLoaded) return;

    final currentState = state as AccountSettingsLoaded;

    final updatedSettings = currentState.settings.copyWith(
      privacySettings: event.settings,
    );

    final result = await repository.updateSettings(updatedSettings);

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) => emit(AccountSettingsLoaded(settings: updatedSettings)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountSettingsState> emit,
  ) async {
    final result = await repository.deleteAccount(
      userId: 'current_user_id', // TODO: 从认证服务获取
      password: event.password,
    );

    result.fold(
      (failure) => emit(AccountSettingsError(failure.message)),
      (_) {
        // 注销成功
        emit(const AccountSettingsInitial());
      },
    );
  }
}
