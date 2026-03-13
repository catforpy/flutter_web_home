import 'package:flutter/material.dart';

/// 公司详情页面 - 展示公司各模块状态
class CompanyDetailPage extends StatefulWidget {
  final String companyId;
  final String companyName;

  const CompanyDetailPage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  // TODO: 从后端获取实际数据
  bool _basicInfoCompleted = true; // 基本信息
  bool _legalPersonVerified = false; // 法人认证
  bool _qualificationsCompleted = false; // 资质证书
  bool _bankAccountVerified = false; // 银行账户

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.companyName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 基本信息模块
            _buildModuleCard(
              icon: Icons.business,
              title: '公司基本信息',
              status: _basicInfoCompleted ? '已完成' : '待完善',
              statusColor: _basicInfoCompleted ? const Color(0xFF52C41A) : const Color(0xFFFFA940),
              statusIcon: _basicInfoCompleted ? Icons.check_circle : Icons.warning,
              description: _basicInfoCompleted ? '企业基本信息已完整填写' : '请完善企业基本信息',
              onTap: () => _navigateToModule('basic_info'),
            ),

            const SizedBox(height: 20),

            // 法人认证模块
            _buildModuleCard(
              icon: Icons.verified_user,
              title: '法人认证',
              status: _legalPersonVerified ? '已实名' : '未实名',
              statusColor: _legalPersonVerified ? const Color(0xFF52C41A) : const Color(0xFFFF4D4F),
              statusIcon: _legalPersonVerified ? Icons.check_circle : Icons.cancel,
              description: _legalPersonVerified ? '法人已完成实名认证' : '请完成法人实名认证',
              onTap: () => _navigateToModule('legal_person'),
            ),

            const SizedBox(height: 20),

            // 资质证书模块
            _buildModuleCard(
              icon: Icons.folder_special,
              title: '公司资质证书',
              status: _qualificationsCompleted ? '已添加' : '待添加资质',
              statusColor: _qualificationsCompleted ? const Color(0xFF52C41A) : const Color(0xFFFFA940),
              statusIcon: _qualificationsCompleted ? Icons.check_circle : Icons.warning,
              description: _qualificationsCompleted ? '已添加相关资质证书' : '请上传企业相关资质证书',
              onTap: () => _navigateToModule('qualifications'),
              extraInfo: !_legalPersonVerified
                  ? _buildWarningTip('需先完成法人认证才能添加资质')
                  : null,
            ),

            const SizedBox(height: 20),

            // 银行账户模块
            _buildModuleCard(
              icon: Icons.account_balance,
              title: '银行账户信息',
              status: _bankAccountVerified ? '已认证' : '待认证银行账号',
              statusColor: _bankAccountVerified ? const Color(0xFF52C41A) : const Color(0xFFFFA940),
              statusIcon: _bankAccountVerified ? Icons.check_circle : Icons.warning,
              description: _bankAccountVerified ? '银行账户已认证' : '请完善银行账户信息',
              onTap: () => _navigateToModule('bank_account'),
              extraInfo: !_legalPersonVerified
                  ? _buildWarningTip('需先完成法人认证才能添加银行账户')
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
    required IconData statusIcon,
    required String description,
    required VoidCallback onTap,
    Widget? extraInfo,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 24, color: statusColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (extraInfo != null) ...[
                const SizedBox(height: 16),
                extraInfo!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningTip(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFA940)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Color(0xFFFFA940)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToModule(String module) {
    // TODO: 导航到对应的模块页面
    switch (module) {
      case 'basic_info':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('进入基本信息编辑页面')),
        );
        break;
      case 'legal_person':
        if (!_legalPersonVerified) {
          _showLegalPersonVerificationDialog();
        }
        break;
      case 'qualifications':
        if (!_legalPersonVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请先完成法人认证'),
              backgroundColor: Color(0xFFFF4D4F),
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('进入资质证书管理页面')),
        );
        break;
      case 'bank_account':
        if (!_legalPersonVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请先完成法人认证'),
              backgroundColor: Color(0xFFFF4D4F),
            ),
          );
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('进入银行账户管理页面')),
        );
        break;
    }
  }

  void _showLegalPersonVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('法人认证'),
        content: const Text('是否开始法人实名认证流程？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 跳转到法人认证页面
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('进入法人认证流程')),
              );
            },
            child: const Text('开始认证'),
          ),
        ],
      ),
    );
  }
}
