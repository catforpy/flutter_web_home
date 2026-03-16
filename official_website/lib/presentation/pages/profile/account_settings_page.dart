import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/auth/auth_state.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/enhanced_image_upload_dialog.dart';
import '../../routes/app_router.dart';
import '../../models/cloud_storage_config.dart';
import '../../services/cloud_storage_manager.dart';

/// 账户管理页面
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final ScrollController _scrollController = ScrollController();

  // 当前选中的菜单项（0: 账户绑定, 1: 个人信息, 2: 操作记录, 3: 实名认证, 4: 存储设置, 5: 收件地址）
  int _selectedMenuIndex = 0;

  // 本地存储的头像URL（用于覆盖服务器的头像）
  String? _localAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadLocalAvatar();
    _initFakeCloudStorageData();
  }

  /// 初始化假数据（用于测试云存储功能）
  Future<void> _initFakeCloudStorageData() async {
    final storageManager = CloudStorageManager();

    // 检查是否已有配置，如果没有则添加假数据
    final hasConfig = await storageManager.hasAnyConfig();
    if (!hasConfig) {
      // 添加多个云存储配置用于测试
      final configs = [
        CloudStorageConfig(
          id: 'aliyun_001',
          provider: CloudProvider.aliyun,
          roleName: 'oss-admin-role',
          accessKeyId: 'LTAI5tXXXXXXXXXXXX',
          accessKeySecret: 'xxxx_secret_key_xxxx',
          bucketName: 'duda-public',
          region: 'oss-cn-hangzhou',
        ),
        CloudStorageConfig(
          id: 'tencent_001',
          provider: CloudProvider.tencent,
          roleName: 'cos-admin-role',
          accessKeyId: 'AKIDxxxxxxxxxxxxxxxxxxxx',
          accessKeySecret: 'xxxx_tencent_secret_xxxx',
          bucketName: 'duda-media',
          region: 'ap-beijing',
        ),
        CloudStorageConfig(
          id: 'qiniu_001',
          provider: CloudProvider.qiniu,
          roleName: 'qiniu-admin-role',
          accessKeyId: 'qiniu_access_key',
          accessKeySecret: 'xxxx_qiniu_secret_xxxx',
          bucketName: 'duda-images',
          region: 'z0',
        ),
      ];

      for (var config in configs) {
        await storageManager.saveConfig(config);
      }

      print('✅ 已添加3个云存储配置假数据用于测试');
    }
  }

  /// 加载本地存储的头像
  Future<void> _loadLocalAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString('local_avatar_url');
    if (savedAvatar != null && savedAvatar.isNotEmpty) {
      setState(() {
        _localAvatarUrl = savedAvatar;
      });
    }
  }

  /// 保存头像到本地存储
  Future<void> _saveLocalAvatar(String avatarUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local_avatar_url', avatarUrl);
    setState(() {
      _localAvatarUrl = avatarUrl;
    });
  }

  /// 获取当前应该显示的头像URL
  String? get _displayAvatarUrl => _localAvatarUrl ?? authState.avatarUrl;

  // 实名认证状态
  final bool _isVerified = false; // 默认未认证
  final String _verifiedName = ''; // 已认证的姓名
  final String _verifiedIdCard = ''; // 已认证的身份证号（脱敏）

  // 解绑手机号输入控制器
  final TextEditingController _currentPhoneController = TextEditingController();
  final TextEditingController _newPhoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  // 当前绑定的手机号（完整号码，从后端获取）
  final String _currentBoundPhone = '15251513885'; // 假数据，后续从后端获取
  bool _isPhoneVerified = false; // 当前手机号是否验证通过

  // 个人信息编辑控制器
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  String? _selectedGender; // '男' 或 '女'
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _birthYearController = TextEditingController();
  final TextEditingController _birthMonthController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  // 存储配置状态
  String? _currentStorageProvider; // 当前配置的云服务商: 'aliyun', 'tencent', 'qiniu'
  final TextEditingController _aliyunRoleNameController = TextEditingController();
  final TextEditingController _aliyunAccessKeyIdController = TextEditingController();
  final TextEditingController _aliyunAccessKeySecretController = TextEditingController();

  // 已配置的OSS列表
  final List<Map<String, String>> _aliyunConfigs = [];

  // 云存储管理器
  final CloudStorageManager _storageManager = CloudStorageManager();

  @override
  void dispose() {
    _scrollController.dispose();
    _currentPhoneController.dispose();
    _newPhoneController.dispose();
    _smsCodeController.dispose();
    _nicknameController.dispose();
    _industryController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _birthYearController.dispose();
    _birthMonthController.dispose();
    _birthDayController.dispose();
    _hobbiesController.dispose();
    _signatureController.dispose();
    _aliyunRoleNameController.dispose();
    _aliyunAccessKeyIdController.dispose();
    _aliyunAccessKeySecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          controller: _scrollController,
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
                  minHeight: 800, // 设置最小高度，确保内容完整显示
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 左侧导航栏
                      _buildLeftSidebar(),
                      const SizedBox(width: 20),

                      // 右侧内容区
                      Expanded(
                        child: _buildRightContent(),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部用户信息横幅
  Widget _buildUserBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
  Widget _buildLeftSidebar() {
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
          _buildSidebarAvatar(),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // 菜单列表
          ...[
            _buildMenuItem('账户绑定', 0),
            _buildMenuItem('个人信息', 1),
            _buildMenuItem('操作记录', 2),
            _buildMenuItem('实名认证', 3),
            _buildMenuItem('存储设置', 4),
            _buildMenuItem('收件地址', 5),
          ],
        ],
      ),
    );
  }

  /// 显示头像上传对话框
  void _showAvatarUploadDialog() {
    // 切换到存储设置标签页
    void goToStorageSettings() {
      setState(() {
        _selectedMenuIndex = 4; // 存储设置的索引
      });
    }

    showDialog(
      context: context,
      builder: (context) => EnhancedImageUploadDialog(
        onImageSelected: (imageUrl) {
          // 保存头像到本地存储
          _saveLocalAvatar(imageUrl);
          // 显示成功提示
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('头像更新成功')),
          );
        },
        onGoToSettings: goToStorageSettings,
      ),
    );
  }

  /// 构建侧边栏头像区域
  Widget _buildSidebarAvatar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 头像
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _showAvatarUploadDialog,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: _displayAvatarUrl != null && _displayAvatarUrl!.isNotEmpty
                          ? Image.network(
                              _displayAvatarUrl!,
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
                    // 悬停时显示的遮罩和相机图标
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showAvatarUploadDialog,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 8),

          // 用户名（显示登录用户名）
          Text(
            authState.username?.isNotEmpty == true ? authState.username! : '未设置',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),

          // 用户ID
          const Text(
            'ID: 11722834',
            style: TextStyle(
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
        color: Color(0xFFD93025), // 红色
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
  Widget _buildMenuItem(String label, int index) {
    final isSelected = _selectedMenuIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMenuIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD93025) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : const Color(0xFF333333),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected)
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
  Widget _buildRightContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 安全评分模块
          _buildSecurityScore(),
          const SizedBox(height: 24),

          // 根据选中的菜单显示对应内容
          if (_selectedMenuIndex == 0) ...[
            // 账户绑定
            _buildModuleCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '绑定手机',
              description: '当前已绑定 152**85，可通过手机+密码登录',
              buttonText: '操作',
              onButtonTap: () {
                _showPhoneBindingDialog();
              },
            ),
            const SizedBox(height: 16),
            _buildRealNameAuthModule(),
            const SizedBox(height: 16),
            _buildModuleCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '登录密码',
              description: '设置安全的密码，可提升账号安全系数',
              buttonText: '重设',
              onButtonTap: () {
                debugPrint('点击重设密码');
              },
            ),
            const SizedBox(height: 16),
            _buildModuleCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF4CAF50),
              title: '设置邮箱',
              description: '当前已绑定 81**@qq.com，可通过邮箱+密码登录',
              buttonText: '更改',
              onButtonTap: () {
                debugPrint('点击更改邮箱');
              },
            ),
          ] else if (_selectedMenuIndex == 1) ...[
            // 个人信息
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '个人信息',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '1/7',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 信息列表
                  _buildInfoRow('用户名', '光_cfstOQ'),
                  _buildInfoRow('性别', '暂未填写'),
                  _buildInfoRow('生日', '暂未填写'),
                  _buildInfoRow('行业', '暂未填写'),
                  _buildInfoRow('城市', '暂未填写'),
                  _buildInfoRow('兴趣爱好', '暂未填写'),
                  _buildInfoRow('个性签名', '暂未填写'),

                  const SizedBox(height: 24),

                  // 修改信息按钮
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          _showEditInfoDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '修改信息',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_selectedMenuIndex == 3) ...[
            // 实名认证
            _buildRealNameAuthModule(),
          ] else if (_selectedMenuIndex == 4) ...[
            // 存储设置
            _buildStorageSettingsModule(),
          ] else ...[
            // 其他标签显示占位内容
            _buildModuleCard(
              icon: Icons.info_outline,
              iconColor: const Color(0xFF2196F3),
              title: _getMenuTitle(_selectedMenuIndex),
              description: '此功能正在开发中，敬请期待',
              buttonText: '返回',
              onButtonTap: () {
                setState(() {
                  _selectedMenuIndex = 0;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  /// 显示解绑手机号确认对话框
  void _showUnbindPhoneStep1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：标题 + 关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '解绑手机号',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 提示文字
                const Text(
                  '是否继续解绑手机号？账号在未绑定手机号状态下将无法下单购买产品/服务。',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 32),

                // 按钮行
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 取消按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 继续解绑按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showChangePhoneStep1();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '继续解绑',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示更换手机号 - 第一步：验证当前绑定手机号
  void _showChangePhoneStep1() {
    _currentPhoneController.clear();
    _isPhoneVerified = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // 监听输入框变化
            void onPhoneChanged(String value) {
              setDialogState(() {
                _isPhoneVerified = value == _currentBoundPhone;
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题行：标题 + 关闭按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '验证当前绑定手机号',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 提示文字
                    const Text(
                      '解绑后，您将无法再使用该手机号对此账号进行登录及找回密码登操作',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 当前绑定手机号
                    Text(
                      '当前绑定手机号：${_currentBoundPhone.substring(0, 3)}*****${_currentBoundPhone.substring(7)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 输入框提示
                    const Text(
                      '请输入当前绑定手机号：',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 输入框
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentPhoneController.text.isNotEmpty && !_isPhoneVerified
                              ? const Color(0xFFD93025)
                              : const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: _currentPhoneController,
                        onChanged: onPhoneChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入手机号',
                          hintStyle: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),

                    // 错误提示
                    if (_currentPhoneController.text.isNotEmpty && !_isPhoneVerified)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 14,
                              color: Color(0xFFD93025),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '手机号不正确',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD93025),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // 按钮行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 取消按钮
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '取消',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 下一步按钮
                        MouseRegion(
                          cursor: _isPhoneVerified
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.forbidden,
                          child: GestureDetector(
                            onTap: _isPhoneVerified
                                ? () {
                                    Navigator.of(context).pop();
                                    _showChangePhoneStep2();
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: _isPhoneVerified
                                    ? const Color(0xFF2196F3)
                                    : const Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '下一步',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 显示更换手机号 - 第二步：绑定新手机号
  void _showChangePhoneStep2() {
    _newPhoneController.clear();
    _smsCodeController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：标题 + 关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '绑定新手机号',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 手机号输入框
                const Text(
                  '手机号',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: _newPhoneController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入您的手机号',
                      hintStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 短信验证码输入框
                const Text(
                  '短信验证码',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: _smsCodeController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 按钮行
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 取消按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 确定按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          debugPrint('确定绑定新手机号');
                          // TODO: 实现绑定新手机号逻辑
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '确定',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示绑定手机弹窗
  void _showPhoneBindingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：标题 + 关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '当前绑定手机号：152*****85',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 提示文字
                const Text(
                  '为保障您的账号安全和订购商品/服务的正常业务开展，小都希望您能为账号绑定手机号，更换手机号后请及时换绑。（1个手机号只能绑定一个都达网账号）',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 32),

                // 按钮行
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 解绑手机号按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showUnbindPhoneStep1();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF2196F3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '解绑手机号',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 更换手机号按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showChangePhoneStep1();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '更换手机号',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: value == '暂未填写'
                    ? const Color(0xFF999999)
                    : const Color(0xFF333333),
                fontWeight: value == '暂未填写'
                    ? FontWeight.normal
                    : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建安全评分模块
  Widget _buildSecurityScore() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock,
                size: 24,
                color: Color(0xFFD93025),
              ),
              const SizedBox(width: 12),
              const Text(
                '安全评分',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '90分',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 进度条
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 提示语
          const Text(
            '你的账号安全等级较低，建议优化以下 1 项',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
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
        return '存储设置';
      case 5:
        return '收件地址';
      default:
        return '未知';
    }
  }

  /// 构建实名认证模块
  Widget _buildRealNameAuthModule() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 如果当前不在实名认证标签，切换到实名认证标签
          if (_selectedMenuIndex != 3) {
            setState(() {
              _selectedMenuIndex = 3;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：图标和标题
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isVerified
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                          : const Color(0xFFD93025).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isVerified ? Icons.check_circle : Icons.error,
                      size: 24,
                      color: _isVerified
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFD93025),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '实名认证',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isVerified ? '✅ 已通过实名认证' : '应国家相关政策要求，使用互联网服务需进行实名认证',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 操作按钮
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _isVerified ? '重新认证' : '去认证',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // 已认证状态下的详细信息
              if (_isVerified) ...[
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 20),

                // 认证信息
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '真实姓名：',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          Text(
                            _verifiedName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '身份证号：',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          Text(
                            _verifiedIdCard,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 认证须知
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6), // 浅黄色背景
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFD54F),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Color(0xFFF57C00),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '认证须知',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF57C00),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '1. 实名认证可以提升您在都达网的个人信息及虚拟财产安全等级，同时也能更好地体验都达网的各项虚拟服务。\n'
                        '2. 实名认证通过后，将无法修改和删除，请谨慎填写。\n'
                        '3. 实名认证通过后，系统将自动发放 10 个积分作为奖励，可在积分中心查看。\n'
                        '4. 我们将对您所提供的信息进行严格保密，不会泄露。\n'
                        '5. 实名认证由阿里云提供认证服务，您可放心使用，我们将对您所提供的信息进行严格保密，不会泄露。\n'
                        '6. 若多次认证不通过，请联系客服邮箱：user@doudawang.com\n'
                        '7. 如存在恶意乱填姓名、身份证号码，或上传与身份证无关的图片，一经发现将冻结都达网账号。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 显示编辑个人信息对话框
  void _showEditInfoDialog() {
    // 初始化数据
    _nicknameController.clear();
    _industryController.clear();
    _selectedGender = null;
    _provinceController.clear();
    _cityController.clear();
    _districtController.clear();
    _birthYearController.clear();
    _birthMonthController.clear();
    _birthDayController.clear();
    _hobbiesController.clear();
    _signatureController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 600,
                constraints: const BoxConstraints(maxHeight: 700),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题行：标题 + 关闭按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '编辑个人信息',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 表单内容
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 昵称
                            _buildRequiredLabel('昵称'),
                            const SizedBox(height: 8),
                            _buildInputField(_nicknameController, '请输入昵称'),
                            const SizedBox(height: 16),

                            // 行业
                            _buildRequiredLabel('行业'),
                            const SizedBox(height: 8),
                            _buildDropdownField(
                              _industryController,
                              ['互联网', '金融', '教育', '医疗', '制造业', '其他'],
                              '请选择行业',
                              setDialogState,
                            ),
                            const SizedBox(height: 16),

                            // 性别
                            _buildRequiredLabel('性别'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildGenderCheckbox('男', setDialogState),
                                const SizedBox(width: 24),
                                _buildGenderCheckbox('女', setDialogState),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 所在地区
                            _buildRequiredLabel('所在地区'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownField(
                                    _provinceController,
                                    ['北京市', '上海市', '广东省', '浙江省', '江苏省', '其他'],
                                    '省',
                                    setDialogState,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDropdownField(
                                    _cityController,
                                    ['北京市', '上海市', '广州市', '深圳市', '杭州市', '南京市'],
                                    '市',
                                    setDialogState,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDropdownField(
                                    _districtController,
                                    ['东城区', '西城区', '朝阳区', '海淀区', '其他'],
                                    '区县',
                                    setDialogState,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 出生日期
                            _buildRequiredLabel('出生日期'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownField(
                                    _birthYearController,
                                    List.generate(100, (index) => '${2024 - index}年'),
                                    '年',
                                    setDialogState,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDropdownField(
                                    _birthMonthController,
                                    List.generate(12, (index) => '${index + 1}月'),
                                    '月',
                                    setDialogState,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDropdownField(
                                    _birthDayController,
                                    List.generate(31, (index) => '${index + 1}日'),
                                    '日',
                                    setDialogState,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 兴趣爱好
                            const Text(
                              '兴趣爱好',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildMultilineField(
                              _hobbiesController,
                              '可以输入128个字符',
                            ),
                            const SizedBox(height: 16),

                            // 个性签名
                            const Text(
                              '个性签名',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildMultilineField(
                              _signatureController,
                              '可以输入128个字符',
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // 保存按钮
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            debugPrint('保存个人信息');
                            // TODO: 保存个人信息到后端
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '保存',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 构建必填标签
  Widget _buildRequiredLabel(String label) {
    return Row(
      children: [
        const Text(
          '*',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD93025),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    );
  }

  /// 构建输入框
  Widget _buildInputField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  /// 构建多行输入框
  Widget _buildMultilineField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        maxLength: 128,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          counterText: '', // 隐藏字符计数
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdownField(
    TextEditingController controller,
    List<String> items,
    String hint,
    StateSetter setDialogState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
          ),
          value: controller.text.isNotEmpty ? controller.text : null,
          items: items.map((String value) {
            return material.DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setDialogState(() {
              controller.text = newValue ?? '';
            });
          },
        ),
      ),
    );
  }

  /// 构建性别单选框
  Widget _buildGenderCheckbox(String gender, StateSetter setDialogState) {
    final isSelected = _selectedGender == gender;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setDialogState(() {
            _selectedGender = gender;
          });
        },
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFE0E0E0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Color(0xFF2196F3),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建功能模块卡片
  Widget _buildModuleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    String? buttonText,
    String? statusText,
    Color? statusColor,
    VoidCallback? onButtonTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),

          // 标题和描述
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (statusText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor ?? const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // 操作按钮
          if (buttonText != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onButtonTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2196F3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建存储设置模块
  Widget _buildStorageSettingsModule() {
    // 获取当前配置的服务商名称
    String getProviderName() {
      switch (_currentStorageProvider) {
        case 'aliyun':
          return '阿里云 OSS';
        case 'tencent':
          return '腾讯云 COS';
        case 'qiniu':
          return '七牛云';
        default:
          return '未配置';
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '云存储配置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),

          // 当前配置显示
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD54F),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_queue,
                  size: 20,
                  color: Color(0xFFF57C00),
                ),
                const SizedBox(width: 12),
                const Text(
                  '当前云存储：',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  getProviderName(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFF57C00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 云服务商列表
          const Text(
            '选择云存储服务商',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // 阿里云 OSS
          _buildCloudProviderCard(
            providerName: '阿里云 OSS',
            description: '对象存储服务',
            color: const Color(0xFFFF6B6B),
            isConfigured: _aliyunConfigs.isNotEmpty,
            configCount: _aliyunConfigs.length,
            onTap: () {
              _showAliyunConfigDialog();
            },
          ),

          // 已配置的阿里云OSS列表
          if (_aliyunConfigs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '已配置的阿里云OSS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_aliyunConfigs.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAliyunConfigCard(
                  config: _aliyunConfigs[index],
                  index: index,
                  onEdit: () {
                    _showAliyunConfigDialog(editIndex: index);
                  },
                  onDelete: () {
                    _showDeleteConfirmDialog(index);
                  },
                ),
              );
            }),
          ],

          const SizedBox(height: 12),

          // 腾讯云 COS
          _buildCloudProviderCard(
            providerName: '腾讯云 COS',
            description: '对象存储服务',
            color: const Color(0xFF00A1D6),
            isConfigured: _currentStorageProvider == 'tencent',
            onTap: () {
              _showTencentDevelopingDialog();
            },
          ),
          const SizedBox(height: 12),

          // 七牛云
          _buildCloudProviderCard(
            providerName: '七牛云',
            description: '云存储服务',
            color: const Color(0xFF42D4F4),
            isConfigured: _currentStorageProvider == 'qiniu',
            onTap: () {
              _showQiniuDevelopingDialog();
            },
          ),
          const SizedBox(height: 24),

          // 配置步骤说明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '配置说明',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. 选择云服务商进行配置\n'
                  '2. 按照要求填写配置信息\n'
                  '3. 不知道如何获取？点击下方按钮查看详细步骤',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 查看步骤按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _showHelpStepsDialog();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFF5C31),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book,
                      size: 18,
                      color: Color(0xFFFF5C31),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '查看获取阿里云OSS密钥的详细步骤',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF5C31),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建云服务商卡片
  Widget _buildCloudProviderCard({
    required String providerName,
    required String description,
    required Color color,
    required bool isConfigured,
    int? configCount,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isConfigured ? color : const Color(0xFFE0E0E0),
              width: isConfigured ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // 图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    providerName.substring(0, 2),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          providerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isConfigured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              configCount != null && configCount > 0
                                  ? '已配置 $configCount 个'
                                  : '已配置',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),

              // 箭头
              Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建已配置的阿里云OSS卡片
  Widget _buildAliyunConfigCard({
    required Map<String, String> config,
    required int index,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    // 加密显示AccessKey ID（只显示前4位和后4位）
    String maskAccessKeyId(String keyId) {
      if (keyId.length <= 8) return '****';
      return '${keyId.substring(0, 4)}****${keyId.substring(keyId.length - 4)}';
    }

    // 加密显示AccessKey Secret（全部显示为星号）
    const String maskedSecret = '********************************';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行：RAM名称 + 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.cloud,
                      size: 18,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    config['roleName'] ?? '未命名',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // 编辑按钮
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2196F3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: Color(0xFF2196F3),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '编辑',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2196F3),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 删除按钮
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD93025),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 14,
                              color: Color(0xFFD93025),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '删除',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD93025),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 12),

          // 配置信息
          _buildConfigInfoRow('AccessKey ID', maskAccessKeyId(config['accessKeyId'] ?? '')),
          const SizedBox(height: 8),
          _buildConfigInfoRow('AccessKey Secret', maskedSecret),
        ],
      ),
    );
  }

  /// 构建配置信息行
  Widget _buildConfigInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
              fontFamily: 'Courier',
            ),
          ),
        ),
      ],
    );
  }

  /// 显示阿里云配置对话框
  void _showAliyunConfigDialog({int? editIndex}) {
    // 判断是新增还是编辑
    final bool isEdit = editIndex != null;

    // 加载已保存的配置（如果有）
    if (isEdit && editIndex != null && editIndex < _aliyunConfigs.length) {
      final config = _aliyunConfigs[editIndex];
      _aliyunRoleNameController.text = config['roleName'] ?? '';
      _aliyunAccessKeyIdController.text = config['accessKeyId'] ?? '';
      _aliyunAccessKeySecretController.text = config['accessKeySecret'] ?? '';
    } else {
      _aliyunRoleNameController.clear();
      _aliyunAccessKeyIdController.clear();
      _aliyunAccessKeySecretController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 600,
                constraints: const BoxConstraints(maxHeight: 800),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题行：标题 + 关闭按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEdit ? '编辑阿里云OSS配置' : '配置阿里云OSS',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 表单内容
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // RAM角色名
                            _buildRequiredLabel('RAM角色名'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              _aliyunRoleNameController,
                              '请输入RAM角色名',
                            ),
                            const SizedBox(height: 16),

                            // AccessKey ID
                            _buildRequiredLabel('AccessKey ID'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              _aliyunAccessKeyIdController,
                              '请输入AccessKey ID',
                            ),
                            const SizedBox(height: 16),

                            // AccessKey Secret
                            _buildRequiredLabel('AccessKey Secret'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: TextField(
                                controller: _aliyunAccessKeySecretController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入AccessKey Secret',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 14,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 帮助提示
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFFD54F),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.help_outline,
                                    size: 18,
                                    color: Color(0xFFF57C00),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '不知道如何获取？',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFF57C00),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _showHelpStepsDialog();
                                          },
                                          child: const Text(
                                            '点击查看获取步骤',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF2196F3),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 按钮行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 取消按钮
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '取消',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 保存配置按钮
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              // 验证必填项
                              if (_aliyunRoleNameController.text.isEmpty ||
                                  _aliyunAccessKeyIdController.text.isEmpty ||
                                  _aliyunAccessKeySecretController.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('提示'),
                                    content: const Text('请填写完整信息'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('确定'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              // 保存配置
                              final storageConfig = CloudStorageConfig(
                                id: 'aliyun_${DateTime.now().millisecondsSinceEpoch}',
                                provider: CloudProvider.aliyun,
                                roleName: _aliyunRoleNameController.text,
                                accessKeyId: _aliyunAccessKeyIdController.text,
                                accessKeySecret: _aliyunAccessKeySecretController.text,
                              );

                              // 保存到CloudStorageManager
                              await _storageManager.saveConfig(storageConfig);

                              final config = {
                                'roleName': _aliyunRoleNameController.text,
                                'accessKeyId': _aliyunAccessKeyIdController.text,
                                'accessKeySecret': _aliyunAccessKeySecretController.text,
                              };

                              setState(() {
                                _currentStorageProvider = 'aliyun';
                                if (isEdit && editIndex != null) {
                                  // 编辑现有配置
                                  _aliyunConfigs[editIndex] = config;
                                } else {
                                  // 新增配置
                                  _aliyunConfigs.add(config);
                                }
                              });

                              Navigator.of(context).pop();

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('成功'),
                                  content: Text(isEdit ? '配置更新成功' : '配置保存成功'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('确定'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5C31),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '保存配置',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 显示腾讯云开发中提示
  void _showTencentDevelopingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 48,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(height: 16),
                const Text(
                  '提示',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '腾讯云COS配置功能',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '开发中，敬请期待',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '我知道了',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示七牛云开发中提示
  void _showQiniuDevelopingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 48,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(height: 16),
                const Text(
                  '提示',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '七牛云配置功能',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '开发中，敬请期待',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '我知道了',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(int index) {
    final config = _aliyunConfigs[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 48,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(height: 16),
                const Text(
                  '确认删除',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '确定要删除配置"${config['roleName']}"吗？',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '删除后无法恢复，请谨慎操作',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD93025),
                  ),
                ),
                const SizedBox(height: 24),

                // 按钮行
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 取消按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 确认删除按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _aliyunConfigs.removeAt(index);
                            if (_aliyunConfigs.isEmpty) {
                              _currentStorageProvider = null;
                            }
                          });
                          Navigator.of(context).pop();

                          // 显示删除成功提示
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('成功'),
                                  content: const Text('配置已删除'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('确定'),
                                    ),
                                  ],
                                ),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD93025),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '确认删除',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示帮助步骤对话框
  void _showHelpStepsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600,
            constraints: const BoxConstraints(maxHeight: 700),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '阿里云OSS密钥获取步骤',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 步骤内容
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepItem(1, '登录阿里云官网',
                            '访问 https://www.aliyun.com 并登录'),
                        const SizedBox(height: 12),
                        _buildStepItem(2, '购买OSS后进入OSS控制台',
                            '在控制台搜索"OSS"，进入对象存储服务'),
                        const SizedBox(height: 12),
                        _buildStepItem(3, '创建RAM用户',
                            '在RAM控制台创建一个RAM用户，选择"编程访问"'),
                        const SizedBox(height: 12),
                        _buildStepItem(4, '创建AccessKey',
                            '为RAM用户创建AccessKey，获取AccessKey ID和Secret'),
                        const SizedBox(height: 12),
                        _buildStepItem(5, '创建RAM角色',
                            '创建RAM角色并添加OSS访问权限，获取角色名称'),
                        const SizedBox(height: 16),

                        // 温馨提示
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFFD54F),
                              width: 1,
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber,
                                    size: 18,
                                    color: Color(0xFFF57C00),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '温馨提示',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF57C00),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                '• AccessKey Secret只在创建时显示一次，请务必妥善保存\n'
                                '• 建议定期更换AccessKey，提高账号安全性\n'
                                '• 不要将AccessKey泄露给他人或提交到公开代码仓库',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                  height: 1.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 关闭按钮
                Align(
                  alignment: Alignment.center,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '我知道了',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建步骤项
  Widget _buildStepItem(int stepNumber, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5C31),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
