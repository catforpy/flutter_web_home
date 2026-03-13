import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_website/application/blocs/account_settings/account_settings_bloc.dart';
import 'package:official_website/application/blocs/account_settings/account_settings_event.dart';
import 'package:official_website/application/blocs/account_settings/account_settings_state.dart';
import 'package:official_website/data/repositories/account_settings_repository_impl.dart';
import 'package:official_website/domain/entities/account_settings.dart';
import 'package:official_website/presentation/widgets/common/unified_navigation_bar.dart';
import 'package:official_website/presentation/widgets/common/footer_widget.dart';
import 'package:official_website/presentation/widgets/common/floating_widget.dart';
import 'package:official_website/presentation/pages/profile/widgets/security_score_card.dart';
import 'package:official_website/presentation/pages/profile/widgets/account_binding_section.dart';
import 'package:official_website/presentation/pages/profile/widgets/basic_info_section.dart';
import 'package:official_website/presentation/pages/profile/widgets/real_name_auth_section.dart';
import 'package:official_website/presentation/routes/app_router.dart';

/// 账户管理页面 - 重构版
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountSettingsBloc(
        repository: AccountSettingsRepositoryImpl(),
      )..add(const LoadSettingsEvent('current_user_id')),
      child: const _AccountSettingsView(),
    );
  }
}

class _AccountSettingsView extends StatelessWidget {
  const _AccountSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
        builder: (context, state) {
          if (state is AccountSettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountSettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AccountSettingsBloc>().add(
                            const LoadSettingsEvent('current_user_id'),
                          );
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (state is! AccountSettingsLoaded) {
            return const Center(child: Text('无数据'));
          }

          final settings = state.settings;

          return FloatingWidget(
            child: Column(
              children: [
                // 顶部用户信息横幅
                _buildUserBanner(),

                // 导航栏
                const UnifiedNavigationBar(
                  currentPath: AppRouter.profile,
                ),

                // 主内容区
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 800,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 24,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左侧导航栏
                      _buildLeftSidebar(context, settings),
                      const SizedBox(width: 20),

                      // 右侧内容区
                      Expanded(
                        child: _buildRightContent(context, settings),
                      ),
                    ],
                  ),
                ),

                // Footer
                const FooterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建顶部用户信息横幅
  Widget _buildUserBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C5F8D),
            Color(0xFF1E3A5F),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          '账户管理',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 构建左侧导航栏
  Widget _buildLeftSidebar(BuildContext context, AccountSettings settings) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 头像区域
          _buildSidebarAvatar(settings),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // 菜单列表
          _buildMenuItem(context, '账户绑定', 0),
          _buildMenuItem(context, '个人信息', 1),
          _buildMenuItem(context, '操作记录', 2),
          _buildMenuItem(context, '实名认证', 3),
          _buildMenuItem(context, '收件地址', 4),
        ],
      ),
    );
  }

  /// 构建侧边栏头像区域
  Widget _buildSidebarAvatar(AccountSettings settings) {
    final avatarUrl = settings.avatar;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 头像
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF999999),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF999999),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // 用户名
          Text(
            settings.username,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),

          // 用户ID
          Text(
            'ID: ${settings.userId}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 16),

          // 三个小图标
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusIcon(Icons.person),
              const SizedBox(width: 12),
              _buildStatusIcon(Icons.phone_android),
              const SizedBox(width: 12),
              _buildStatusIcon(Icons.email),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建状态图标
  Widget _buildStatusIcon(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFD93025),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(BuildContext context, String label, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onMenuTap(context, index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _getSelectedIndex(context) == index
                ? const Color(0xFFD93025)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: _getSelectedIndex(context) == index
                      ? Colors.white
                      : const Color(0xFF333333),
                  fontWeight: _getSelectedIndex(context) == index
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              if (_getSelectedIndex(context) == index)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建右侧内容区
  Widget _buildRightContent(BuildContext context, AccountSettings settings) {
    final selectedIndex = _getSelectedIndex(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 安全评分模块
          const SecurityScoreCard(
            score: 90,
            message: '你的账号安全等级较低，建议优化以下 1 项',
          ),
          const SizedBox(height: 24),

          // 根据选中的菜单显示对应内容
          if (selectedIndex == 0) ...[
            // 账户绑定
            AccountBindingCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '绑定手机',
              description: settings.phone != null
                  ? '当前已绑定 ${_maskPhone(settings.phone)}，可通过手机+密码登录'
                  : '未绑定手机号',
              buttonText: '操作',
              onButtonTap: () => _showPhoneBindingDialog(context, settings),
            ),
            const SizedBox(height: 16),
            AccountBindingCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '登录密码',
              description: '设置安全的密码，可提升账号安全系数',
              buttonText: '重设',
              onButtonTap: () => _showChangePasswordDialog(context),
            ),
            const SizedBox(height: 16),
            AccountBindingCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '设置邮箱',
              description:
                  '当前已绑定 ${_maskEmail(settings.email)}，可通过邮箱+密码登录',
              buttonText: '更改',
              onButtonTap: () => _showChangeEmailDialog(context),
            ),
            const SizedBox(height: 16),
            RealNameAuthSection(
              isVerified: false,
              onAuthTap: () => _onMenuTap(context, 3),
            ),
          ] else if (selectedIndex == 1) ...[
            // 个人信息
            BasicInfoSection(
              settings: settings,
              onEditTap: () => _showEditInfoDialog(context, settings),
            ),
          ] else if (selectedIndex == 3) ...[
            // 实名认证
            RealNameAuthSection(
              isVerified: false,
              onAuthTap: () {},
            ),
          ] else ...[
            // 其他标签显示占位内容
            AccountBindingCard(
              icon: Icons.info_outline,
              iconColor: const Color(0xFF2196F3),
              title: _getMenuTitle(selectedIndex),
              description: '此功能正在开发中，敬请期待',
              buttonText: '返回',
              onButtonTap: () => _onMenuTap(context, 0),
            ),
          ],
        ],
      ),
    );
  }

  /// 获取当前选中的菜单索引
  int _getSelectedIndex(BuildContext context) {
    // 简化版本,实际可以使用状态管理
    return 0;
  }

  /// 菜单点击处理
  void _onMenuTap(BuildContext context, int index) {
    // 实际应该使用 BLoC 更新状态
    debugPrint('切换到菜单: $index');
  }

  /// 获取菜单标题
  String _getMenuTitle(int index) {
    switch (index) {
      case 0:
        return '账户绑定';
      case 1:
        return '个人信息';
      case 2:
        return '操作记录';
      case 3:
        return '实名认证';
      case 4:
        return '收件地址';
      default:
        return '未知';
    }
  }

  /// 手机号脱敏
  String _maskPhone(String? phone) {
    if (phone == null || phone.length < 11) return '***';
    return '${phone.substring(0, 3)}*****${phone.substring(7)}';
  }

  /// 邮箱脱敏
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***';
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return '$name@$domain';
    }
    return '${name.substring(0, 2)}***@$domain';
  }

  /// 显示手机绑定对话框
  void _showPhoneBindingDialog(BuildContext context, AccountSettings settings) {
    // TODO: 实现对话框逻辑
    debugPrint('显示手机绑定对话框');
  }

  /// 显示修改密码对话框
  void _showChangePasswordDialog(BuildContext context) {
    // TODO: 实现对话框逻辑
    debugPrint('显示修改密码对话框');
  }

  /// 显示修改邮箱对话框
  void _showChangeEmailDialog(BuildContext context) {
    // TODO: 实现对话框逻辑
    debugPrint('显示修改邮箱对话框');
  }

  /// 显示编辑信息对话框
  void _showEditInfoDialog(BuildContext context, AccountSettings settings) {
    // TODO: 实现对话框逻辑
    debugPrint('显示编辑信息对话框');
  }
}
