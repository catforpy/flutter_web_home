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
    switch (module) {
      case 'basic_info':
        _showBasicInfoDialog();
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
        _showQualificationsDialog();
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
        _showBankAccountDialog();
        break;
    }
  }

  void _showBasicInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BasicInfoDialog(
        onSubmit: (data) {
          setState(() {
            _basicInfoCompleted = true;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('公司基本信息已更新'),
              backgroundColor: Color(0xFF52C41A),
            ),
          );
        },
      ),
    );
  }

  void _showQualificationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => QualificationsDialog(
        onSubmit: (data) {
          setState(() {
            _qualificationsCompleted = true;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('资质证书已更新'),
              backgroundColor: Color(0xFF52C41A),
            ),
          );
        },
      ),
    );
  }

  void _showBankAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BankAccountDialog(
        onSubmit: (data) {
          setState(() {
            _bankAccountVerified = true;
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('银行账户信息已保存'),
              backgroundColor: Color(0xFF52C41A),
            ),
          );
        },
      ),
    );
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

/// 公司基本信息编辑对话框
class BasicInfoDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const BasicInfoDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<BasicInfoDialog> createState() => _BasicInfoDialogState();
}

class _BasicInfoDialogState extends State<BasicInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController(text: '都达科技有限公司');
  final _creditCodeController = TextEditingController(text: '91110108MA1234567X');
  final _legalPersonNameController = TextEditingController(text: '张三');
  final _legalPersonPhoneController = TextEditingController(text: '13800138000');
  final _managerNameController = TextEditingController(text: '李四');
  final _managerPhoneController = TextEditingController(text: '13900139000');
  final _businessScopeController = TextEditingController(text: '软件开发、技术服务、技术咨询');

  String _companyType = '企业';

  @override
  void dispose() {
    _companyNameController.dispose();
    _creditCodeController.dispose();
    _legalPersonNameController.dispose();
    _legalPersonPhoneController.dispose();
    _managerNameController.dispose();
    _managerPhoneController.dispose();
    _businessScopeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCompanyTypeSelector(),
                        const SizedBox(height: 16),
                        _buildTextField('企业名称', _companyNameController),
                        const SizedBox(height: 16),
                        _buildTextField('统一社会信用代码', _creditCodeController),
                        const SizedBox(height: 16),
                        _buildTextField('法人姓名', _legalPersonNameController),
                        const SizedBox(height: 16),
                        _buildTextField('法人手机号', _legalPersonPhoneController, phone: true),
                        const SizedBox(height: 16),
                        _buildTextField('管理人员姓名', _managerNameController),
                        const SizedBox(height: 16),
                        _buildTextField('管理人员手机号', _managerPhoneController, phone: true),
                        const SizedBox(height: 16),
                        _buildTextareaField('经营范围', _businessScopeController),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '编辑公司基本信息',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTypeSelector() {
    return Row(
      children: [
        Radio<String>(
          value: '企业',
          groupValue: _companyType,
          onChanged: (v) => setState(() => _companyType = v!),
        ),
        const Text('企业'),
        const SizedBox(width: 32),
        Radio<String>(
          value: '个体工商户',
          groupValue: _companyType,
          onChanged: (v) => setState(() => _companyType = v!),
        ),
        const Text('个体工商户'),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool phone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: phone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildTextareaField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit({});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1890FF)),
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// 资质证书上传对话框
class QualificationsDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const QualificationsDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<QualificationsDialog> createState() => _QualificationsDialogState();
}

class _QualificationsDialogState extends State<QualificationsDialog> {
  final List<Map<String, String>> _qualifications = [
    {'name': '营业执照', 'path': ''},
    {'name': '组织机构代码证', 'path': ''},
    {'name': '税务登记证', 'path': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildUploadSection(),
                      const SizedBox(height: 24),
                      _buildAddButton(),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '资质证书管理',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '已上传证书',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        ..._qualifications.asMap().entries.map((entry) {
          final index = entry.key;
          final qual = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildQualificationItem(qual['name']!, qual['path']!, () {
              // TODO: 上传文件
              setState(() {
                _qualifications[index]['path'] = 'uploaded';
              });
            }),
          );
        }),
      ],
    );
  }

  Widget _buildQualificationItem(String name, String path, VoidCallback onUpload) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, size: 32, color: Color(0xFF1890FF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  path.isNotEmpty ? '已上传' : '未上传',
                  style: TextStyle(
                    fontSize: 12,
                    color: path.isNotEmpty ? const Color(0xFF52C41A) : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          if (path.isEmpty)
            ElevatedButton(
              onPressed: onUpload,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1890FF)),
              child: const Text('上传', style: TextStyle(color: Colors.white)),
            )
          else
            const Icon(Icons.check_circle, color: Color(0xFF52C41A)),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: 添加新的资质类型
      },
      icon: const Icon(Icons.add),
      label: const Text('添加其他资质'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1890FF),
        side: const BorderSide(color: Color(0xFF1890FF)),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => widget.onSubmit({}),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1890FF)),
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// 银行账户信息对话框
class BankAccountDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const BankAccountDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<BankAccountDialog> createState() => _BankAccountDialogState();
}

class _BankAccountDialogState extends State<BankAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _branchNameController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _branchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField('开户银行', _bankNameController, hint: '如：中国工商银行'),
                      const SizedBox(height: 16),
                      _buildTextField('账户持有人', _accountHolderController, hint: '企业名称或法人姓名'),
                      const SizedBox(height: 16),
                      _buildTextField('银行账号', _accountNumberController,
                          hint: '请输入银行账号', required: true),
                      const SizedBox(height: 16),
                      _buildTextField('开户行支行名称', _branchNameController, hint: '如：北京分行营业部'),
                      const SizedBox(height: 24),
                      _buildTipsBox(),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '银行账户信息',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, bool required = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '请输入$label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildTipsBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFA940)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('⚠️ 温馨提示', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFA940))),
          SizedBox(height: 8),
          Text('• 请确保银行账户信息准确无误', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          Text('• 账户持有人必须为企业名称或法人姓名', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
          Text('• 用于小程序收益结算，请认真填写', style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit({});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1890FF)),
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
