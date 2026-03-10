import 'package:flutter/material.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../routes/app_router.dart';
import '../../../core/auth/auth_state.dart';
import 'platform_initialization_page.dart';
import 'merchant_dashboard.dart';

/// 工作台页面
/// 根据用户身份显示不同的后台管理内容
/// - 商户：管理自己的小程序、租赁、合作等
/// - 后台：管理整个平台（审核商户、数据分析、系统配置等）
class WorkbenchPage extends StatefulWidget {
  const WorkbenchPage({super.key});

  @override
  State<WorkbenchPage> createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage> {
  @override
  void initState() {
    super.initState();
    // 监听认证状态变化
    authState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    authState.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  /// 认证状态变化时的回调
  void _onAuthStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 商户直接返回平台接入中心页面（有完整的 Scaffold）
    if (authState.userType == UserType.merchant) {
      return const PlatformInitializationPage();
    }

    // 其他用户使用标准布局（导航栏 + 内容 + Footer）
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 导航栏
            const UnifiedNavigationBar(
              currentPath: AppRouter.workbench,
            ),

            // 主内容区
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    // 根据用户身份显示不同内容
                    _buildWorkbenchContent(),
                  ],
                ),
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  /// 根据用户身份构建工作台内容（非商户）
  Widget _buildWorkbenchContent() {
    switch (authState.userType) {
      case UserType.backend:
        return _buildBackendWorkbench();
      case UserType.customer:
      case null:
        return _buildNoAccessPage();
      case UserType.merchant:
        // 商户不会走到这里，上面已经直接返回了
        return const SizedBox.shrink();
    }
  }

  /// 商户工作台
  Widget _buildMerchantWorkbench() {
    return const PlatformInitializationPage();
  }

  /// 后台工作台
  Widget _buildBackendWorkbench() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题
        _buildPageHeader(
          title: '平台管理后台',
          subtitle: '管理整个平台的运营和配置',
        ),

        const SizedBox(height: 32),

        // 快捷操作卡片
        Row(
          children: [
            Expanded(child: _buildQuickActionCard('商户审核', Icons.verified_user, 0xFFF44336)),
            const SizedBox(width: 24),
            Expanded(child: _buildQuickActionCard('用户管理', Icons.people, 0xFF2196F3)),
            const SizedBox(width: 24),
            Expanded(child: _buildQuickActionCard('数据统计', Icons.analytics, 0xFF00C853)),
            const SizedBox(width: 24),
            Expanded(child: _buildQuickActionCard('系统配置', Icons.settings, 0xFF9C27B0)),
          ],
        ),

        const SizedBox(height: 32),

        // 待审核商户
        _buildPendingMerchantsSection(),

        const SizedBox(height: 32),

        // 平台数据概览
        _buildPlatformDataOverviewSection(),
      ],
    );
  }

  /// 无权限访问页面
  Widget _buildNoAccessPage() {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 80,
            color: Color(0xFF999999),
          ),
          const SizedBox(height: 24),
          const Text(
            '无权限访问',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '工作台仅对商户和后台管理员开放',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建页面标题
  Widget _buildPageHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  /// 构建快捷操作卡片
  Widget _buildQuickActionCard(String title, IconData icon, int color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击：$title');
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Color(color),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建商户工作台的"我的小程序"区域
  Widget _buildMyMiniProgramsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    debugPrint('查看全部');
                  },
                  child: const Text(
                    '查看全部 >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMiniProgramList(),
        ],
      ),
    );
  }

  /// 构建小程序列表
  Widget _buildMiniProgramList() {
    final programs = [
      {'name': '电商购物小程序', 'status': '使用中', 'users': '1,234'},
      {'name': '餐饮系统小程序', 'status': '使用中', 'users': '567'},
      {'name': '教育类小程序', 'status': '即将到期', 'users': '890'},
    ];

    return Column(
      children: programs.map((program) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '用户数：${program['users']}',
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
                  color: program['status'] == '使用中'
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  program['status'] as String,
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

  /// 构建商户工作台的"最新消息"区域
  Widget _buildLatestMessagesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '最新消息',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildMessageList(),
        ],
      ),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList() {
    final messages = [
      {'title': '您的小程序"电商购物"审核已通过', 'time': '10分钟前'},
      {'title': '租赁续费提醒', 'time': '2小时前'},
      {'title': '新的合作邀请', 'time': '昨天'},
    ];

    return Column(
      children: messages.map((msg) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  msg['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Text(
                msg['time'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建后台工作台的"待审核商户"区域
  Widget _buildPendingMerchantsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '待审核商户',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '5个待审核',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF9800),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPendingMerchantsList(),
        ],
      ),
    );
  }

  /// 构建待审核商户列表
  Widget _buildPendingMerchantsList() {
    final merchants = [
      {'name': '某科技公司', 'type': '小程序购买', 'time': '10分钟前'},
      {'name': '某电商平台', 'type': '小程序租赁', 'time': '1小时前'},
      {'name': '某教育机构', 'type': '小程序合作', 'time': '2小时前'},
    ];

    return Column(
      children: merchants.map((merchant) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '类型：${merchant['type']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    merchant['time'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('审核商户');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '审核',
                          style: TextStyle(
                            fontSize: 12,
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
        );
      }).toList(),
    );
  }

  /// 构建后台工作台的"平台数据概览"区域
  Widget _buildPlatformDataOverviewSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '平台数据概览',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDataCard('总用户数', '12,345', Icons.people, 0xFF2196F3)),
              const SizedBox(width: 24),
              Expanded(child: _buildDataCard('活跃商户', '1,234', Icons.store, 0xFF00C853)),
              const SizedBox(width: 24),
              Expanded(child: _buildDataCard('小程序数', '3,456', Icons.phone_android, 0xFFFF9800)),
              const SizedBox(width: 24),
              Expanded(child: _buildDataCard('今日订单', '789', Icons.shopping_cart, 0xFF9C27B0)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建数据卡片
  Widget _buildDataCard(String label, String value, IconData icon, int color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
