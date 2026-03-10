import 'package:flutter/material.dart';
import 'merchant_models.dart';
import 'payment_config_dashboard.dart';
import 'merchant_list_view.dart';
import 'add_merchant_wizard.dart';

/// 微信支付特约商户进件工作台 V2
/// 核心功能：
/// 1. 进件状态概览
/// 2. 商户列表管理
/// 3. 新增商户进件
/// 4. 进度跟踪
class PaymentConfigV2Page extends StatefulWidget {
  const PaymentConfigV2Page({super.key});

  @override
  State<PaymentConfigV2Page> createState() => _PaymentConfigV2PageState();
}

class _PaymentConfigV2PageState extends State<PaymentConfigV2Page> {
  // 当前选中的Tab
  int _selectedTab = 0;

  // 模拟商户数据
  final List<MerchantInfo> _merchants = [
    MerchantInfo(
      id: 'M001',
      shortName: '上海某某餐饮店',
      fullName: '上海某某餐饮有限公司',
      subjectType: MerchantSubjectType.enterprise,
      servicePhone: '021-12345678',
      businessScenes: [BusinessScene.miniProgram.label, BusinessScene.offlineStore.label],
      adminName: '张三',
      adminPhone: '13800138000',
      adminEmail: 'zhangsan@example.com',
      status: MerchantStatus.pendingVerification,
      submitTime: DateTime.now().subtract(const Duration(days: 2)),
      currentStep: ProgressStep.pendingVerification,
      completedSteps: [ProgressStep.submitted, ProgressStep.reviewPassed],
    ),
    MerchantInfo(
      id: 'M002',
      shortName: '北京某某服装店',
      fullName: '北京某某服装店',
      subjectType: MerchantSubjectType.individual,
      servicePhone: '010-87654321',
      businessScenes: [BusinessScene.miniProgram.label],
      adminName: '李四',
      adminPhone: '13900139000',
      adminEmail: 'lisi@example.com',
      status: MerchantStatus.pendingContract,
      submitTime: DateTime.now().subtract(const Duration(days: 5)),
      reviewTime: DateTime.now().subtract(const Duration(days: 3)),
      currentStep: ProgressStep.pendingContract,
      completedSteps: [ProgressStep.submitted, ProgressStep.reviewPassed, ProgressStep.pendingVerification],
    ),
    MerchantInfo(
      id: 'M003',
      shortName: '深圳某某科技公司',
      fullName: '深圳某某科技有限公司',
      subjectType: MerchantSubjectType.enterprise,
      servicePhone: '0755-12345678',
      businessScenes: [BusinessScene.miniProgram.label, BusinessScene.officialAccount.label, BusinessScene.app.label],
      adminName: '王五',
      adminPhone: '13700137000',
      adminEmail: 'wangwu@example.com',
      status: MerchantStatus.completed,
      submitTime: DateTime.now().subtract(const Duration(days: 10)),
      reviewTime: DateTime.now().subtract(const Duration(days: 8)),
      completeTime: DateTime.now().subtract(const Duration(days: 1)),
      currentStep: ProgressStep.completed,
      completedSteps: [
        ProgressStep.submitted,
        ProgressStep.reviewPassed,
        ProgressStep.pendingVerification,
        ProgressStep.pendingContract,
        ProgressStep.completed,
      ],
    ),
    MerchantInfo(
      id: 'M004',
      shortName: '广州某某便利店',
      fullName: '广州某某便利店',
      subjectType: MerchantSubjectType.individual,
      servicePhone: '020-11112222',
      businessScenes: [BusinessScene.miniProgram.label, BusinessScene.offlineStore.label],
      adminName: '赵六',
      adminPhone: '13600136000',
      adminEmail: 'zhaoliu@example.com',
      status: MerchantStatus.reviewing,
      submitTime: DateTime.now().subtract(const Duration(hours: 6)),
      currentStep: ProgressStep.submitted,
      completedSteps: [ProgressStep.submitted],
    ),
  ];

  // 获取统计数据
  MerchantStatistics get _statistics {
    return MerchantStatistics(
      totalInProgress: _merchants.where((m) => m.status != MerchantStatus.completed).length,
      pendingVerification: _merchants.where((m) => m.status == MerchantStatus.pendingVerification).length,
      pendingContract: _merchants.where((m) => m.status == MerchantStatus.pendingContract).length,
      completedToday: _merchants.where((m) {
        return m.status == MerchantStatus.completed &&
            m.completeTime != null &&
            m.completeTime!.day == DateTime.now().day;
      }).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Column(
        children: [
          // 顶部状态概览区
          PaymentConfigDashboard(
            statistics: _statistics,
            onAddMerchant: _showAddMerchantWizard,
          ),

          // Tab切换栏
          _buildTabBar(),

          // 主内容区
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// 构建Tab切换栏
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem('全部商户', 0, _merchants.length),
          const SizedBox(width: 8),
          _buildTabItem('审核中', 1, _merchants.where((m) => m.status == MerchantStatus.reviewing).length),
          const SizedBox(width: 8),
          _buildTabItem('待验证', 2, _statistics.pendingVerification),
          const SizedBox(width: 8),
          _buildTabItem('待签约', 3, _statistics.pendingContract),
          const SizedBox(width: 8),
          _buildTabItem('已完成', 4, _merchants.where((m) => m.status == MerchantStatus.completed).length),
        ],
      ),
    );
  }

  /// 构建单个Tab项
  Widget _buildTabItem(String label, int index, int count) {
    final isSelected = _selectedTab == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF07C160).withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFF07C160) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF07C160) : const Color(0xFF333333),
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF07C160) : const Color(0xFF999999),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建主内容区
  Widget _buildContent() {
    // 根据选中的Tab筛选商户
    List<MerchantInfo> filteredMerchants = _merchants;
    switch (_selectedTab) {
      case 1: // 审核中
        filteredMerchants = _merchants.where((m) => m.status == MerchantStatus.reviewing).toList();
        break;
      case 2: // 待验证
        filteredMerchants = _merchants.where((m) => m.status == MerchantStatus.pendingVerification).toList();
        break;
      case 3: // 待签约
        filteredMerchants = _merchants.where((m) => m.status == MerchantStatus.pendingContract).toList();
        break;
      case 4: // 已完成
        filteredMerchants = _merchants.where((m) => m.status == MerchantStatus.completed).toList();
        break;
      default: // 全部
        filteredMerchants = _merchants;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: MerchantListView(
        merchants: filteredMerchants,
        onRefresh: _refreshMerchants,
      ),
    );
  }

  /// 显示新增商户向导
  void _showAddMerchantWizard() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMerchantWizard(),
    );

    if (result != null && result is MerchantInfo) {
      setState(() {
        _merchants.insert(0, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 商户进件提交成功，等待微信审核'),
          backgroundColor: Color(0xFF07C160),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// 刷新商户列表
  Future<void> _refreshMerchants() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // 模拟刷新数据
    });
  }
}
