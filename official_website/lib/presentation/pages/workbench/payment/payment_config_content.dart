import 'package:flutter/material.dart';

/// 支付配置页面内容区
/// 特约商户进件申请
class PaymentConfigContent extends StatefulWidget {
  const PaymentConfigContent({super.key});

  @override
  State<PaymentConfigContent> createState() => _PaymentConfigContentState();
}

class _PaymentConfigContentState extends State<PaymentConfigContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 特约商户进件模块
            _buildMerchantOnboardingModule(),
          ],
        ),
      ),
    );
  }

  /// 构建特约商户进件模块
  Widget _buildMerchantOnboardingModule() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              const Icon(
                Icons.store,
                size: 24,
                color: Color(0xFF07C160),
              ),
              const SizedBox(width: 12),
              const Text(
                '特约商户进件',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              // 帮助提示
              MouseRegion(
                cursor: SystemMouseCursors.help,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('按照以下步骤完成特约商户进件申请'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.help_outline,
                    size: 20,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 进件步骤列表
          _buildStepList(),

          const SizedBox(height: 24),

          // 底部操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showApplicationStatusDialog(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF07C160),
                    side: const BorderSide(color: Color(0xFF07C160)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('查看进件进度'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showMerchantApplicationDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF07C160),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('开始申请'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建步骤列表
  Widget _buildStepList() {
    final steps = [
      {
        'number': '1',
        'title': '主体资质',
        'description': '准备商户简称、主体类型、营业执照、法人信息等',
        'icon': Icons.business,
        'status': 'pending',
      },
      {
        'number': '2',
        'title': '管理员信息',
        'description': '填写超级管理员姓名、身份证、手机号等信息',
        'icon': Icons.person,
        'status': 'pending',
      },
      {
        'number': '3',
        'title': '结算账户',
        'description': '配置银行账户信息，用于资金结算',
        'icon': Icons.account_balance,
        'status': 'pending',
      },
      {
        'number': '4',
        'title': '经营场景',
        'description': '选择经营场景（小程序、公众号、线下门店等）',
        'icon': Icons.store,
        'status': 'pending',
      },
    ];

    return Column(
      children: steps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 步骤编号
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF07C160),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    step['number'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // 步骤内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          step['icon'] as IconData,
                          size: 20,
                          color: const Color(0xFF07C160),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step['description'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 显示特约商户进件申请对话框
  void _showMerchantApplicationDialog() {
    showDialog(
      context: context,
      builder: (context) => MerchantApplicationDialog(),
    );
  }

  /// 显示申请状态查询对话框
  void _showApplicationStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => const ApplicationStatusDialog(),
    );
  }
}

/// 特约商户进件申请对话框
class MerchantApplicationDialog extends StatefulWidget {
  const MerchantApplicationDialog({super.key});

  @override
  State<MerchantApplicationDialog> createState() => _MerchantApplicationDialogState();
}

class _MerchantApplicationDialogState extends State<MerchantApplicationDialog> {
  final _formKey = GlobalKey<FormState>();

  // 联系信息
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactIdNumberController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  String _contactIdDocType = '身份证';
  final List<String> _contactIdDocTypes = ['身份证', '护照', '港澳居民来往内地通行证', '台湾居民来往大陆通行证', '外国人永久居留身份证', '香港永久性居民身份证', '澳门特别行政区永久性居民身份证'];

  // 主体信息
  String _subjectType = '企业';
  final List<String> _subjectTypes = ['企业', '个体工商户', '党政机关', '事业单位', '社会组织', '其他组织'];
  final TextEditingController _merchantShortnameController = TextEditingController();
  final TextEditingController _servicePhoneController = TextEditingController();
  final TextEditingController _licenseNoController = TextEditingController();
  final TextEditingController _licenseNameController = TextEditingController();

  // 银行账户信息
  String _bankAccountType = '对公账户';
  final List<String> _bankAccountTypes = ['对公账户', '对私账户'];
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountBankController = TextEditingController();
  final TextEditingController _bankAddressCodeController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  // 经营场景
  List<String> _selectedSalesScenes = [];

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactIdNumberController.dispose();
    _mobilePhoneController.dispose();
    _contactEmailController.dispose();
    _merchantShortnameController.dispose();
    _servicePhoneController.dispose();
    _licenseNoController.dispose();
    _licenseNameController.dispose();
    _accountNameController.dispose();
    _accountBankController.dispose();
    _bankAddressCodeController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '特约商户进件申请',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 表单内容区（可滚动）
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 联系信息
                      _buildSectionTitle('联系信息'),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _contactNameController,
                        label: '联系人姓名',
                        hintText: '请输入联系人姓名',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: '联系人证件类型',
                        value: _contactIdDocType,
                        items: _contactIdDocTypes,
                        onChanged: (value) => setState(() => _contactIdDocType = value!),
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _contactIdNumberController,
                        label: '联系人证件号码',
                        hintText: '请输入联系人证件号码',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _mobilePhoneController,
                        label: '联系人手机号',
                        hintText: '请输入手机号',
                        required: true,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _contactEmailController,
                        label: '联系邮箱',
                        hintText: '请输入邮箱地址',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      // 主体信息
                      _buildSectionTitle('主体信息'),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: '主体类型',
                        value: _subjectType,
                        items: _subjectTypes,
                        onChanged: (value) => setState(() => _subjectType = value!),
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _licenseNoController,
                        label: '营业执照注册号/统一社会信用代码',
                        hintText: '请输入营业执照号',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _licenseNameController,
                        label: '商户名称',
                        hintText: '请输入营业执照上的商户名称',
                        required: true,
                      ),
                      const SizedBox(height: 24),

                      // 经营信息
                      _buildSectionTitle('经营信息'),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _merchantShortnameController,
                        label: '商户简称',
                        hintText: '请输入商户简称（常用名）',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _servicePhoneController,
                        label: '客服电话',
                        hintText: '请输入客服电话',
                        required: true,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildCheckboxGroup(
                        label: '经营场景',
                        options: const [
                          {'value': 'STORE', 'label': '线下门店'},
                          {'value': 'MP', 'label': '公众号'},
                          {'value': 'MINI_PROGRAM', 'label': '小程序'},
                          {'value': 'WEB', 'label': 'PC网站'},
                          {'value': 'APP', 'label': 'APP'},
                          {'value': 'WEWORK', 'label': '企业微信'},
                        ],
                        selectedValues: _selectedSalesScenes,
                        onChanged: (values) {
                          setState(() {
                            _selectedSalesScenes = values;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // 结算信息
                      _buildSectionTitle('结算信息'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Color(0xFF1890FF),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '结算方式',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '特约商户进件默认使用银行卡结算，请在下方填写银行账户信息',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 银行账户信息
                      _buildSectionTitle('银行账户信息'),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        label: '银行账户类型',
                        value: _bankAccountType,
                        items: _bankAccountTypes,
                        onChanged: (value) => setState(() => _bankAccountType = value!),
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _accountNameController,
                        label: '账户名称',
                        hintText: '请输入银行账户名称',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _accountBankController,
                        label: '开户银行',
                        hintText: '请输入开户银行名称',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _bankAddressCodeController,
                        label: '开户银行省市编码',
                        hintText: '请输入开户银行所在省市编码（如：110000）',
                        required: true,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _accountNumberController,
                        label: '银行账号',
                        hintText: '请输入银行账号',
                        required: true,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 底部按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF666666),
                      side: const BorderSide(color: Color(0xFFD9D9D9)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07C160),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('提交申请'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxGroup({
    required String label,
    required List<Map<String, String>> options,
    required List<String> selectedValues,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: options.map((option) {
            final value = option['value']!;
            final label = option['label']!;
            final isSelected = selectedValues.contains(value);
            return InkWell(
              onTap: () {
                final newValues = List<String>.from(selectedValues);
                if (isSelected) {
                  newValues.remove(value);
                } else {
                  newValues.add(value);
                }
                onChanged(newValues);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? checked) {
                      final newValues = List<String>.from(selectedValues);
                      if (checked == true && !isSelected) {
                        newValues.add(value);
                      } else if (checked == false && isSelected) {
                        newValues.remove(value);
                      }
                      onChanged(newValues);
                    },
                  ),
                  Text(label),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSalesScenes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请至少选择一个经营场景'),
            backgroundColor: Color(0xFFFF4D4F),
          ),
        );
        return;
      }

      // TODO: 调用微信支付API提交申请

      // 中文证件类型转英文
      final contactIdDocTypeMap = {
        '身份证': 'IDCARD',
        '护照': 'OVERSEA_PASSPORT',
        '港澳居民来往内地通行证': 'HONGKONG_PASSPORT',
        '台湾居民来往大陆通行证': 'TAIWAN_PASSPORT',
        '外国人永久居留身份证': 'FOREIGNER_PERMANENT_RESIDENCE',
        '香港永久性居民身份证': 'HONGKONG_MACAO_PASS',
        '澳门特别行政区永久性居民身份证': 'HONGKONG_MACAO_PASS',
      };

      // 中文主体类型转英文
      final subjectTypeMap = {
        '企业': 'ENTERPRISE',
        '个体工商户': 'INDIVIDUAL',
        '党政机关': 'GOVERNMENT',
        '事业单位': 'INSTITUTIONS',
        '社会组织': 'OTHERS',
        '其他组织': 'OTHERS',
      };

      // 中文银行账户类型转英文
      final bankAccountTypeMap = {
        '对公账户': 'CORPORATE',
        '对私账户': 'PERSONAL',
      };

      final applicationData = {
        'contact_info': {
          'contact_type': '65',
          'contact_name': _contactNameController.text,
          'contact_id_doc_type': contactIdDocTypeMap[_contactIdDocType] ?? _contactIdDocType,
          'contact_id_number': _contactIdNumberController.text,
          'mobile_phone': _mobilePhoneController.text,
          'contact_email': _contactEmailController.text,
        },
        'subject_info': {
          'subject_type': subjectTypeMap[_subjectType] ?? _subjectType,
          'business_license_info': {
            'license_copy': '待上传',
            'license_number': _licenseNoController.text,
            'merchant_name': _licenseNameController.text,
          },
        },
        'business_info': {
          'merchant_shortname': _merchantShortnameController.text,
          'service_phone': _servicePhoneController.text,
          'sales_info': {
            'sales_scenes': _selectedSalesScenes.map((scene) => {'scene': scene}).toList(),
          },
        },
        'settlement_info': {
          'qualification_type': 'BANK',
        },
        'bank_account_info': {
          'bank_account_type': bankAccountTypeMap[_bankAccountType] ?? _bankAccountType,
          'account_name': _accountNameController.text,
          'account_bank': _accountBankController.text,
          'bank_address_code': _bankAddressCodeController.text,
          'account_number': _accountNumberController.text,
        },
      };

      debugPrint('提交进件申请数据：$applicationData');

      // 模拟API调用，后端返回业务申请编号和申请单号
      await Future.delayed(const Duration(seconds: 1));

      // TODO: 从后端API获取真实的返回数据
      final mockResponse = {
        'business_code': 'MCH_${DateTime.now().millisecondsSinceEpoch}',
        'applyment_id': 2000002124775691,
        'sign_url': 'https://pay.weixin.qq.com/public/apply4ec_sign/s?applymentId=2000002126198476',
        'applyment_state': 'APPLYMENT_STATE_AUDITING',
        'applyment_state_msg': '审核中',
      };

      // 关闭申请对话框
      Navigator.pop(context);

      // 显示申请成功页面
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ApplicationSuccessDialog(
            applicationData: applicationData,
            responseData: mockResponse,
          ),
        );
      }
    }
  }
}

/// 申请成功对话框
class ApplicationSuccessDialog extends StatelessWidget {
  final Map<String, dynamic> applicationData;
  final Map<String, dynamic> responseData;

  const ApplicationSuccessDialog({
    super.key,
    required this.applicationData,
    required this.responseData,
  });

  @override
  Widget build(BuildContext context) {
    final businessCode = responseData['business_code'] as String;
    final applymentId = responseData['applyment_id'] as int;
    final state = responseData['applyment_state'] as String? ?? 'APPLYMENT_STATE_AUDITING';
    final stateMsg = responseData['applyment_state_msg'] as String? ?? '审核中';

    return Dialog(
      child: Container(
        width: 700,
        height: 650,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF52C41A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '申请提交成功',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 重要信息卡片
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FFED),
                border: Border.all(color: const Color(0xFFB7EB8F)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF52C41A),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '业务申请编号：$businessCode',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '申请单号：$applymentId',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF52C41A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          stateMsg,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '请保存业务申请编号，用于查询进度',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 申请信息摘要
            const Text(
              '申请信息摘要',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection('主体信息', [
                      _buildInfoRow('商户名称', applicationData['subject_info']['business_license_info']['merchant_name']),
                      _buildInfoRow('主体类型', applicationData['subject_info']['subject_type']),
                      _buildInfoRow('营业执照号', applicationData['subject_info']['business_license_info']['license_number']),
                    ]),
                    _buildInfoSection('联系信息', [
                      _buildInfoRow('联系人', applicationData['contact_info']['contact_name']),
                      _buildInfoRow('手机号', applicationData['contact_info']['mobile_phone']),
                      _buildInfoRow('邮箱', applicationData['contact_info']['contact_email'] ?? '-'),
                    ]),
                    _buildInfoSection('经营信息', [
                      _buildInfoRow('商户简称', applicationData['business_info']['merchant_shortname']),
                      _buildInfoRow('客服电话', applicationData['business_info']['service_phone']),
                    ]),
                    _buildInfoSection('结算账户', [
                      _buildInfoRow('账户类型', applicationData['bank_account_info']['bank_account_type'] == 'CORPORATE' ? '对公账户' : '对私账户'),
                      _buildInfoRow('开户银行', applicationData['bank_account_info']['account_bank']),
                      _buildInfoRow('银行账号', _maskAccountNumber(applicationData['bank_account_info']['account_number'])),
                    ]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 底部按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF666666),
                      side: const BorderSide(color: Color(0xFFD9D9D9)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('关闭'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 复制业务申请编号
                      // TODO: 实现复制到剪贴板功能
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('业务申请编号：$businessCode'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1890FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('复制申请编号'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 8) {
      return accountNumber;
    }
    return '${accountNumber.substring(0, 4)}****${accountNumber.substring(accountNumber.length - 4)}';
  }
}

/// 申请状态查询对话框
class ApplicationStatusDialog extends StatefulWidget {
  const ApplicationStatusDialog({super.key});

  @override
  State<ApplicationStatusDialog> createState() => _ApplicationStatusDialogState();
}

class _ApplicationStatusDialogState extends State<ApplicationStatusDialog> {
  final _businessCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, dynamic>? _applicationStatus;

  // 状态映射
  final Map<String, String> _stateMap = {
    'APPLYMENT_STATE_EDITTING': '编辑中',
    'APPLYMENT_STATE_AUDITING': '审核中',
    'APPLYMENT_STATE_REJECTED': '已驳回',
    'APPLYMENT_STATE_TO_BE_CONFIRMED': '待账户验证',
    'APPLYMENT_STATE_TO_BE_SIGNED': '待签约',
    'APPLYMENT_STATE_SIGNING': '开通权限中',
    'APPLYMENT_STATE_FINISHED': '已完成',
    'APPLYMENT_STATE_CANCELED': '已作废',
  };

  @override
  void dispose() {
    _businessCodeController.dispose();
    super.dispose();
  }

  Future<void> _queryApplicationStatus() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: 调用后端API查询申请状态
    // GET /v3/applyment4sub/applyment/business_code/{business_code}
    await Future.delayed(const Duration(seconds: 1));

    // 模拟返回完整数据（包括申请内容和状态）
    final mockStatus = {
      'business_code': _businessCodeController.text,
      'applyment_id': 2000002124775691,
      'sub_mchid': '1234567890',
      'sign_url': 'https://pay.weixin.qq.com/public/apply4ec_sign/s?applymentId=2000002126198476',
      'applyment_state': 'APPLYMENT_STATE_AUDITING',
      'applyment_state_msg': '审核中',

      // 完整的申请信息（从后端数据库查询）
      'contact_info': {
        'contact_name': '刘熙庄',
        'contact_id_doc_type': '身份证',
        'contact_id_number': '320204198701242019',
        'mobile_phone': '15251513885',
        'contact_email': '815209544@qq.com',
      },
      'subject_info': {
        'subject_type': '企业',
        'business_license_info': {
          'license_number': '914523546135541X4',
          'merchant_name': '无锡都达网络科技有限公司',
        },
      },
      'business_info': {
        'merchant_shortname': '都达',
        'service_phone': '15251513885',
        'sales_scenes': ['小程序'],
      },
      'bank_account_info': {
        'bank_account_type': '对公账户',
        'account_name': '工商银行',
        'account_bank': '工商银行',
        'account_number': '6225885101708956',
      },

      // 审核详情（如果有驳回）
      'audit_detail': null,
    };

    setState(() {
      _applicationStatus = mockStatus;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '查询进件进度',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 查询表单
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _businessCodeController,
                      decoration: const InputDecoration(
                        labelText: '业务申请编号',
                        hintText: '请输入业务申请编号',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入业务申请编号';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _queryApplicationStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07C160),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('查询'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 查询结果
            if (_applicationStatus != null)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildApplicationStatusCard(),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Color(0xFFCCCCCC),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '请输入业务申请编号查询进度',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatusCard() {
    final status = _applicationStatus!;
    final state = status['applyment_state'] as String;
    final stateMsg = _stateMap[state] ?? status['applyment_state_msg'];
    final subMchid = status['sub_mchid'] as String?;
    final signUrl = status['sign_url'] as String?;
    final auditDetail = status['audit_detail'];

    // 根据状态确定颜色
    Color stateColor;
    IconData stateIcon;

    switch (state) {
      case 'APPLYMENT_STATE_AUDITING':
      case 'APPLYMENT_STATE_TO_BE_CONFIRMED':
      case 'APPLYMENT_STATE_TO_BE_SIGNED':
      case 'APPLYMENT_STATE_SIGNING':
        stateColor = const Color(0xFF1890FF);
        stateIcon = Icons.pending;
        break;
      case 'APPLYMENT_STATE_FINISHED':
        stateColor = const Color(0xFF52C41A);
        stateIcon = Icons.check_circle;
        break;
      case 'APPLYMENT_STATE_REJECTED':
        stateColor = const Color(0xFFFF4D4F);
        stateIcon = Icons.cancel;
        break;
      case 'APPLYMENT_STATE_CANCELED':
        stateColor = const Color(0xFF999999);
        stateIcon = Icons.cancel_outlined;
        break;
      default:
        stateColor = const Color(0xFFFA8C16);
        stateIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 状态标题
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  stateIcon,
                  color: stateColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stateMsg,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: stateColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '申请单号：${status['applyment_id']}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (subMchid != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow('特约商户号', subMchid),
          ],

          const SizedBox(height: 24),

          // 申请信息详情
          const Text(
            '申请信息详情',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 16),

          // 主体信息
          if (status['subject_info'] != null)
            _buildInfoSection('主体信息', [
              if (status['subject_info']['business_license_info'] != null) ...[
                _buildInfoRow('商户名称', status['subject_info']['business_license_info']['merchant_name'] ?? '-'),
                _buildInfoRow('主体类型', status['subject_info']['subject_type'] ?? '-'),
                _buildInfoRow('营业执照号', status['subject_info']['business_license_info']['license_number'] ?? '-'),
              ],
            ]),

          // 联系信息
          if (status['contact_info'] != null)
            _buildInfoSection('联系信息', [
              _buildInfoRow('联系人', status['contact_info']['contact_name'] ?? '-'),
              _buildInfoRow('证件类型', status['contact_info']['contact_id_doc_type'] ?? '-'),
              _buildInfoRow('手机号', status['contact_info']['mobile_phone'] ?? '-'),
              _buildInfoRow('邮箱', status['contact_info']['contact_email'] ?? '-'),
            ]),

          // 经营信息
          if (status['business_info'] != null)
            _buildInfoSection('经营信息', [
              _buildInfoRow('商户简称', status['business_info']['merchant_shortname'] ?? '-'),
              _buildInfoRow('客服电话', status['business_info']['service_phone'] ?? '-'),
              if (status['business_info']['sales_scenes'] != null)
                _buildInfoRow('经营场景', (status['business_info']['sales_scenes'] as List).join('、')),
            ]),

          // 结算账户
          if (status['bank_account_info'] != null)
            _buildInfoSection('结算账户', [
              _buildInfoRow('账户类型', status['bank_account_info']['bank_account_type'] ?? '-'),
              _buildInfoRow('开户银行', status['bank_account_info']['account_bank'] ?? '-'),
              _buildInfoRow('银行账号', _maskAccountNumber(status['bank_account_info']['account_number'] ?? '-')),
            ]),

          const SizedBox(height: 16),

          // 签约链接
          if (signUrl != null &&
              (state == 'APPLYMENT_STATE_TO_BE_SIGNED' ||
                  state == 'APPLYMENT_STATE_AUDITING'))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                border: Border.all(color: const Color(0xFFFFD591)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFFFA8C16)),
                      SizedBox(width: 8),
                      Text(
                        '待签约',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFA8C16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '请超级管理员使用微信扫描以下二维码，完成签约：',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code, size: 120, color: Color(0xFF333333)),
                          SizedBox(height: 8),
                          Text(
                            '签约二维码',
                            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 驳回原因
          if (state == 'APPLYMENT_STATE_REJECTED' && auditDetail != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                border: Border.all(color: const Color(0xFFFFCCC7)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.error_outline, size: 16, color: Color(0xFFFF4D4F)),
                      SizedBox(width: 8),
                      Text(
                        '驳回原因',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4D4F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // TODO: 展示audit_detail列表
                  const Text(
                    '请根据驳回原因修改申请资料后重新提交',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 底部按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                    side: const BorderSide(color: Color(0xFFD9D9D9)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('关闭'),
                ),
              ),
              if (state == 'APPLYMENT_STATE_REJECTED') ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: 打开申请表单，预填充被驳回的数据
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07C160),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('修改申请'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label：',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 8) {
      return accountNumber;
    }
    return '${accountNumber.substring(0, 4)}****${accountNumber.substring(accountNumber.length - 4)}';
  }
}
