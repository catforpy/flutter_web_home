import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/workbench/register_mini_program_dialog.dart';
import '../../routes/app_router.dart';
import '../../../core/auth/auth_state.dart';
import '../../../domain/models/mini_program_registration.dart';

/// 个人中心页面 - 慕课网风格
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0; // 0: 我的公司, 1: 我在销售, 2: 我在租赁, 3: 我在合作
  int _miniProgramFilterIndex = 0; // 0: 全部, 1: 已上架, 2: 开发中
  int _appFilterIndex = 0; // 0: 全部, 1: 已上架, 2: 开发中

  // 注册小程序弹窗控制
  bool _showRegisterMiniProgramDialog = false;

  @override
  void initState() {
    super.initState();
    // 监听认证状态变化
    authState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    authState.removeListener(_onAuthStateChanged);
    _scrollController.dispose();
    super.dispose();
  }

  /// 认证状态变化时的回调
  void _onAuthStateChanged() {
    // 当登录状态或用户类型变化时刷新UI
    if (mounted) {
      setState(() {});
    }
  }

  /// 标签列表
  final List<String> _tabs = ['我的公司', '我在销售', '我在租赁', '我在合作'];

  /// 筛选标签列表
  final List<String> _filterTabs = ['全部', '已上架', '开发中'];

  /// 处理小程序注册完成
  void _handleMiniProgramRegistrationComplete(MiniProgramRegistration registration) {
    // TODO: 保存注册信息到后端
    // TODO: 刷新小程序列表
    setState(() {
      _showRegisterMiniProgramDialog = false;
    });

    // 显示成功提示
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('小程序注册成功！'),
          backgroundColor: Color(0xFF00C853),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 顶部用户信息横幅
                  _buildUserBanner(),

                  // 导航栏
                  const UnifiedNavigationBar(
                    currentPath: AppRouter.profile,
                  ),

                  // 新的标签导航栏
                  _buildTabNavigationBar(),

                  // 主内容区域
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: _buildTabContent(),
                  ),

                  // Footer
                  const FooterWidget(),
                ],
              ),
            ),

            // 注册小程序弹窗
            if (_showRegisterMiniProgramDialog)
              RegisterMiniProgramDialog(
                onRegistrationComplete: _handleMiniProgramRegistrationComplete,
                onClose: () {
                  setState(() {
                    _showRegisterMiniProgramDialog = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息横幅（慕课网风格）
  Widget _buildUserBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C5F8D), // 深蓝色
            Color(0xFF1E3A5F), // 更深的蓝色
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Row(
            children: [
              // 左侧：用户头像和信息
              _buildUserInfo(),
              const SizedBox(width: 80),

              // 右侧：数据统计
              Expanded(
                child: _buildUserStats(),
              ),

              const SizedBox(width: 40),

              // 最右侧：个人设置按钮
              _buildSettingsButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建用户头像和信息
  Widget _buildUserInfo() {
    return Row(
      children: [
        // 大头像
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: authState.avatarUrl != null && authState.avatarUrl!.isNotEmpty
                ? Image.network(
                    authState.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        const SizedBox(width: 24),

        // 用户名和状态
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authState.nickname,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // 金色
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VIP',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Color(0xFF999999),
      ),
    );
  }

  /// 构建用户数据统计
  Widget _buildUserStats() {
    // 根据用户身份显示不同的统计数据
    switch (authState.userType) {
      case UserType.customer:
        // 客户：客户 + 商户的统计数据
        return _buildCustomerStats();
      case UserType.merchant:
        // 商户：空白占位
        return _buildMerchantPlaceholderStats();
      case UserType.backend:
        return _buildBackendStats();
      case null:
        return const SizedBox.shrink();
    }
  }

  /// 客户数据统计（合并商户内容）
  Widget _buildCustomerStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('15', '小程序'),  // 商户
        const SizedBox(width: 40),
        _buildStatItem('32', '收藏'),    // 客户
        const SizedBox(width: 40),
        _buildStatItem('2', '关注'),     // 客户
        const SizedBox(width: 40),
        _buildStatItem('238', '租赁'),   // 商户
        const SizedBox(width: 40),
        _buildStatItem('56', '合作'),    // 商户
      ],
    );
  }

  /// 服务商数据统计
  Widget _buildMerchantPlaceholderStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('156', '完成订单'),
        const SizedBox(width: 40),
        _buildStatItem('4.8', '服务评分'),
        const SizedBox(width: 40),
        _buildStatItem('98%', '满意度'),
        const SizedBox(width: 40),
        _buildStatItem('32', '模板数'),
        const SizedBox(width: 40),
        _buildStatItem('89', '客户数'),
      ],
    );
  }

  /// 后台数据统计
  Widget _buildBackendStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('128', '任务'),
        const SizedBox(width: 40),
        _buildStatItem('89', '完成'),
        const SizedBox(width: 40),
        _buildStatItem('3', '排名'),
        const SizedBox(width: 40),
        _buildStatItem('12', '站内信'),
      ],
    );
  }

  /// 构建单个统计项
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB0C4DE),
          ),
        ),
      ],
    );
  }

  /// 构建标签导航栏
  Widget _buildTabNavigationBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = _selectedTabIndex == index;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1890FF).withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? const Color(0xFF1890FF) : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建标签内容
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildMyCompanyTab();
      case 1:
        return _buildMySalesTab();
      case 2:
        return _buildMyLeasingTab();
      case 3:
        return _buildMyCooperationTab();
      default:
        return const SizedBox.shrink();
    }
  }

  /// 我的公司标签页内容
  Widget _buildMyCompanyTab() {
    return Column(
      children: [
        // 第一行：我的公司
        _buildMyCompanySection(),
        const SizedBox(height: 24),

        // 第二行：我的小程序
        _buildMyMiniProgramSection(),
        const SizedBox(height: 24),

        // 第三行：我的app
        _buildMyAppSection(),
      ],
    );
  }

  /// 我在公司模块
  Widget _buildMyCompanySection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的公司',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              // 右上角的添加按钮
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 添加公司
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '添加公司',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
          const SizedBox(height: 20),
          // 公司列表
          _buildCompanyList(),
        ],
      ),
    );
  }

  /// 构建公司列表
  Widget _buildCompanyList() {
    final companies = [
      {
        'name': '都达科技有限公司',
        'type': '科技有限公司',
        'status': '已认证',
        'statusColor': 0xFF00C853,
        'time': '2024-01-15',
      },
    ];

    if (companies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: Column(
            children: [
              Icon(
                Icons.business_outlined,
                size: 64,
                color: Color(0xFFCCCCCC),
              ),
              SizedBox(height: 16),
              Text(
                '还没有公司信息',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: companies.map((company) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.business,
                size: 40,
                color: Color(0xFF1890FF),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '类型：${company['type']} | 成立时间：${company['time']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(company['statusColor'] as int),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  company['status'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 我的小程序模块
  Widget _buildMyMiniProgramSection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的小程序',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showRegisterMiniProgramDialog = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '添加小程序',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
          const SizedBox(height: 20),

          // 筛选标签栏
          _buildFilterTabs(
            filterIndex: _miniProgramFilterIndex,
            onFilterChanged: (index) {
              setState(() {
                _miniProgramFilterIndex = index;
              });
            },
          ),

          const SizedBox(height: 20),
          _buildMiniProgramList(),
        ],
      ),
    );
  }

  /// 构建筛选标签栏
  Widget _buildFilterTabs({
    required int filterIndex,
    required Function(int) onFilterChanged,
  }) {
    return Row(
      children: _filterTabs.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isSelected = filterIndex == index;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onFilterChanged(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1890FF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1890FF)
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF666666),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建小程序列表
  Widget _buildMiniProgramList() {
    // 所有小程序数据
    final allMiniPrograms = [
      {
        'name': 'AI智能助手小程序',
        'icon': '🤖',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'views': '1.2k',
        'likes': '89',
      },
      {
        'name': '数据分析工具',
        'icon': '📊',
        'status': '开发中',
        'statusColor': 0xFFFF9800,
        'views': '0',
        'likes': '0',
      },
      {
        'name': '智能客服机器人',
        'icon': '🤖',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'views': '856',
        'likes': '67',
      },
      {
        'name': '在线教育平台',
        'icon': '📚',
        'status': '开发中',
        'statusColor': 0xFFFF9800,
        'views': '0',
        'likes': '0',
      },
      {
        'name': 'OCR识别小程序',
        'icon': '📷',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'views': '2.3k',
        'likes': '124',
      },
    ];

    // 根据筛选条件过滤
    List<Map<String, dynamic>> filteredPrograms;
    switch (_miniProgramFilterIndex) {
      case 0: // 全部
        filteredPrograms = allMiniPrograms;
        break;
      case 1: // 已上架
        filteredPrograms = allMiniPrograms
            .where((p) => p['status'] == '已上架')
            .toList();
        break;
      case 2: // 开发中
        filteredPrograms = allMiniPrograms
            .where((p) => p['status'] == '开发中')
            .toList();
        break;
      default:
        filteredPrograms = allMiniPrograms;
    }

    if (filteredPrograms.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.phone_iphone_outlined,
                size: 64,
                color: Color(0xFFCCCCCC),
              ),
              const SizedBox(height: 16),
              Text(
                '没有${_filterTabs[_miniProgramFilterIndex]}的小程序',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: filteredPrograms.length,
      itemBuilder: (context, index) {
        final program = filteredPrograms[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    program['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      program['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Color(0xFF999999),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        program['views'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(program['statusColor'] as int),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      program['status'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 我的app模块
  Widget _buildMyAppSection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // TODO: 添加app
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '添加app',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
          const SizedBox(height: 20),

          // 筛选标签栏
          _buildFilterTabs(
            filterIndex: _appFilterIndex,
            onFilterChanged: (index) {
              setState(() {
                _appFilterIndex = index;
              });
            },
          ),

          const SizedBox(height: 20),
          _buildAppList(),
        ],
      ),
    );
  }

  /// 构建app列表
  Widget _buildAppList() {
    // 所有app数据
    final allApps = [
      {
        'name': '都达办公app',
        'icon': '💼',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'platform': 'iOS/Android',
        'downloads': '3.5k',
      },
      {
        'name': '项目管理工具',
        'icon': '📋',
        'status': '开发中',
        'statusColor': 0xFFFF9800,
        'platform': 'Android',
        'downloads': '0',
      },
      {
        'name': '在线协作平台',
        'icon': '👥',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'platform': 'iOS/Android',
        'downloads': '8.2k',
      },
      {
        'name': '数据分析app',
        'icon': '📊',
        'status': '开发中',
        'statusColor': 0xFFFF9800,
        'platform': 'iOS',
        'downloads': '0',
      },
      {
        'name': '智能考勤系统',
        'icon': '⏰',
        'status': '已上架',
        'statusColor': 0xFF00C853,
        'platform': 'Android',
        'downloads': '1.8k',
      },
    ];

    // 根据筛选条件过滤
    List<Map<String, dynamic>> filteredApps;
    switch (_appFilterIndex) {
      case 0: // 全部
        filteredApps = allApps;
        break;
      case 1: // 已上架
        filteredApps = allApps.where((a) => a['status'] == '已上架').toList();
        break;
      case 2: // 开发中
        filteredApps = allApps.where((a) => a['status'] == '开发中').toList();
        break;
      default:
        filteredApps = allApps;
    }

    if (filteredApps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.phone_android_outlined,
                size: 64,
                color: Color(0xFFCCCCCC),
              ),
              const SizedBox(height: 16),
              Text(
                '没有${_filterTabs[_appFilterIndex]}的app',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: filteredApps.length,
      itemBuilder: (context, index) {
        final app = filteredApps[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    app['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app['platform'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.download_outlined,
                        size: 14,
                        color: Color(0xFF999999),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        app['downloads'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(app['statusColor'] as int),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      app['status'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 我在销售标签页内容
  Widget _buildMySalesTab() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
              '我在销售',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 我在租赁标签页内容
  Widget _buildMyLeasingTab() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.leak_add_outlined,
              size: 64,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
              '我在租赁',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 我在合作标签页内容
  Widget _buildMyCooperationTab() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.handshake_outlined,
              size: 64,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16),
            Text(
              '我在合作',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建个人设置按钮
  Widget _buildSettingsButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 跳转到账户管理页面
          AppRouter.goToAccountSettings(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.settings,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                '个人设置',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
