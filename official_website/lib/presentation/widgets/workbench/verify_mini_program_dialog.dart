import 'package:flutter/material.dart';
import '../../../domain/models/mini_program_verification.dart';

/// 认证小程序弹窗
/// 分步骤表单，完成小程序认证流程
class VerifyMiniProgramDialog extends StatefulWidget {
  /// 小程序APPID
  final String appId;

  /// 临时小程序名称（可修改）
  final String initialMiniProgramName;

  /// 认证完成回调
  final Function(MiniProgramVerification) onVerificationComplete;

  /// 关闭回调
  final VoidCallback onClose;

  const VerifyMiniProgramDialog({
    super.key,
    required this.appId,
    required this.initialMiniProgramName,
    required this.onVerificationComplete,
    required this.onClose,
  });

  @override
  State<VerifyMiniProgramDialog> createState() => _VerifyMiniProgramDialogState();
}

class _VerifyMiniProgramDialogState extends State<VerifyMiniProgramDialog> {
  // 当前步骤（0=确认名称, 1=上传材料, 2=选择支付方式, 3=扫码授权）
  int _currentStep = 0;

  // 表单数据
  final _formKey = GlobalKey<FormState>();
  final _officialNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  // 支付方式
  PaymentMethod _selectedPaymentMethod = PaymentMethod.merchant;

  // 认证材料
  String? _businessLicenseUrl;
  String? _bankLicenseUrl;
  String? _operationDocUrl;

  // 名称检测结果
  NameCheckResult? _nameCheckResult;

  // 加载状态
  bool _isLoading = false;
  bool _isCheckingName = false;

  @override
  void initState() {
    super.initState();
    _officialNameController.text = widget.initialMiniProgramName;
  }

  @override
  void dispose() {
    _officialNameController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => widget.onClose(),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                  minWidth: 500,
                  maxHeight: 800,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题栏
                    _buildHeader(),

                    // 步骤指示器
                    _buildStepIndicator(),

                    // 内容区
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: _buildStepContent(),
                      ),
                    ),

                    // 底部按钮
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A9B8E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '认证小程序',
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
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          _buildStepItem(0, '确认名称'),
          _buildStepConnector(0),
          _buildStepItem(1, '上传材料'),
          _buildStepConnector(1),
          _buildStepItem(2, '支付方式'),
          _buildStepConnector(2),
          _buildStepItem(3, '扫码授权'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String label) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? const Color(0xFF1A9B8E)
                : isCompleted
                    ? const Color(0xFF52C41A)
                    : const Color(0xFFE0E0E0),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : const Color(0xFF999999),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF1A9B8E) : const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int step) {
    final isActive = step < _currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? const Color(0xFF52C41A) : const Color(0xFFE0E0E0),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildConfirmNameStep();
      case 1:
        return _buildUploadMaterialsStep();
      case 2:
        return _buildPaymentMethodStep();
      case 3:
        return _buildAuthorizationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  /// 步骤1：确认/修改小程序名称
  Widget _buildConfirmNameStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('确认小程序名称'),
          const SizedBox(height: 16),
          const Text(
            '认证后的小程序名称将无法修改，请仔细确认',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 24),

          // 当前临时名称
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前名称（临时）',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.initialMiniProgramName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 正式名称输入
          const Text(
            '正式名称（认证后不可修改）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _officialNameController,
            maxLength: 30,
            style: const TextStyle(color: Color(0xFF333333)),
            decoration: InputDecoration(
              hintText: '输入小程序正式名称（2-30个字）',
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1890FF)),
              ),
              suffixIcon: IconButton(
                icon: _isCheckingName
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle),
                onPressed: _isCheckingName ? null : _checkNameAvailability,
                tooltip: '检测名称是否可用',
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入小程序名称';
              }
              if (value.length < 2 || value.length > 30) {
                return '小程序名称长度应在2-30个字符之间';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // 名称检测结果
          if (_nameCheckResult != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _nameCheckResult!.isAvailable
                    ? const Color(0xFFF0F9FF)
                    : const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _nameCheckResult!.isAvailable
                      ? const Color(0xFF52C41A)
                      : const Color(0xFFFFA940),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _nameCheckResult!.isAvailable
                        ? Icons.check_circle
                        : Icons.error,
                    size: 16,
                    color: _nameCheckResult!.isAvailable
                        ? const Color(0xFF52C41A)
                        : const Color(0xFFFFA940),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _nameCheckResult!.message,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // 温馨提示
          _buildTipsBox([
            '💡 建议使用品牌词或产品词作为小程序名称',
            '💡 避免使用通用词汇，如"商城"、"购物"等',
            '💡 名称需符合微信命名规范',
          ]),
        ],
      ),
    );
  }

  /// 步骤2：上传认证材料
  Widget _buildUploadMaterialsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('上传认证材料'),
        const SizedBox(height: 16),
        const Text(
          '请上传清晰、完整的认证材料',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 24),

        // 营业执照
        _buildUploadCard(
          '营业执照',
          '请上传清晰的营业执照照片',
          Icons.business,
          _businessLicenseUrl,
          (url) => setState(() => _businessLicenseUrl = url),
          isRequired: true,
        ),
        const SizedBox(height: 16),

        // 开户许可证
        _buildUploadCard(
          '对公账户信息',
          '请上传开户许可证或银行回单',
          Icons.account_balance,
          _bankLicenseUrl,
          (url) => setState(() => _bankLicenseUrl = url),
        ),
        if (_bankLicenseUrl != null) ...[
          const SizedBox(height: 16),
          // 对公账户信息表单
          _buildBankAccountForm(),
        ],
        const SizedBox(height: 16),

        // 运营文档
        _buildUploadCard(
          '运营文档',
          '请上传小程序运营说明文档',
          Icons.description,
          _operationDocUrl,
          (url) => setState(() => _operationDocUrl = url),
        ),
        const SizedBox(height: 24),

        // 温馨提示
        _buildTipsBox([
          '💡 图片格式：jpg、png',
          '💡 图片大小：不超过2MB',
          '💡 请确保图片清晰、文字可辨认',
        ]),
      ],
    );
  }

  /// 步骤3：选择支付方式
  Widget _buildPaymentMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('选择支付方式'),
        const SizedBox(height: 24),

        // 认证费用说明
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFA940)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info, color: Color(0xFFFFA940)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '认证费用：',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '300元/年',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA940),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '认证有效期1年，到期前需进行年审',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 支付方式选择
        ..._buildPaymentOptions(),
        const SizedBox(height: 24),

        // 支付说明
        _buildPaymentDescription(),
      ],
    );
  }

  /// 步骤4：法人扫码授权
  Widget _buildAuthorizationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('法人扫码授权'),
        const SizedBox(height: 24),

        // 二维码
        Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('正在生成授权码...'),
                      ],
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        size: 120,
                        color: Color(0xFF999999),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '授权二维码',
                        style: TextStyle(
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 32),

        // 说明文字
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1890FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info, color: Color(0xFF1890FF), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '操作说明',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInstructionItem('1. 法人将收到"公众平台安全助手"的模板消息'),
              _buildInstructionItem('2. 点击消息进入授权页面'),
              _buildInstructionItem('3. 完成人脸识别验证'),
              if (_selectedPaymentMethod == PaymentMethod.merchant)
                _buildInstructionItem('4. 支付认证费用300元'),
              _buildInstructionItem(
                '⏱ 请在24小时内完成操作',
                color: const Color(0xFFFFA940),
              ),
            ],
          ),
        ),
        if (!_isLoading) ...[
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 刷新二维码
              },
              icon: const Icon(Icons.refresh),
              label: const Text('刷新二维码'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _goToPreviousStep,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                '← 上一步',
                style: TextStyle(fontSize: 14),
              ),
            ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _canProceed ? _goToNextStep : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A9B8E),
              disabledBackgroundColor: const Color(0xFFCCCCCC),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              _currentStep == 3 ? '完成认证' : '下一步 →',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 辅助方法 ====================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildInstructionItem(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: color ?? const Color(0xFF333333),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildUploadCard(
    String title,
    String hint,
    IconData icon,
    String? uploadedUrl,
    Function(String) onUpload, {
    bool isRequired = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF1A9B8E)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF4D4F),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (uploadedUrl != null)
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF52C41A)),
                image: DecorationImage(
                  image: NetworkImage(uploadedUrl),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            InkWell(
              onTap: () => _showUploadDialog(title, onUpload),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE0E0E0), style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 32,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hint,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBankAccountForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '对公账户信息',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _bankNameController,
            style: const TextStyle(color: Color(0xFF333333)),
            decoration: const InputDecoration(
              labelText: '银行名称',
              hintText: '如：中国工商银行',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1890FF)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _branchNameController,
            style: const TextStyle(color: Color(0xFF333333)),
            decoration: const InputDecoration(
              labelText: '开户行名称',
              hintText: '如：北京分行朝阳支行',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1890FF)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _accountNameController,
            style: const TextStyle(color: Color(0xFF333333)),
            decoration: const InputDecoration(
              labelText: '账户名称',
              hintText: '企业全称',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1890FF)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _accountNumberController,
            style: const TextStyle(color: Color(0xFF333333)),
            decoration: const InputDecoration(
              labelText: '账户号码',
              hintText: '银行账号',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1890FF)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentOptions() {
    return [
      _buildPaymentOptionCard(
        '商家交纳',
        '由商户自行支付认证审核费用',
        Icons.person,
        PaymentMethod.merchant,
        isRecommended: false,
      ),
      const SizedBox(height: 12),
      _buildPaymentOptionCard(
        '服务商代交',
        '服务商已批量采购认证费额度，无需额外支付',
        Icons.business_center,
        PaymentMethod.provider,
        isRecommended: true,
      ),
    ];
  }

  Widget _buildPaymentOptionCard(
    String title,
    String description,
    IconData icon,
    PaymentMethod method, {
    bool isRecommended = false,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6F7FF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF1890FF) : const Color(0xFFE0E0E0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF999999),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF1890FF) : const Color(0xFF333333),
                          ),
                        ),
                        if (isRecommended) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFA940),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  size: 24,
                  color: Color(0xFF1890FF),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDescription() {
    if (_selectedPaymentMethod == PaymentMethod.merchant) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFA940)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA940),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '商家交纳说明',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFA940),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '法人扫码后需要在微信内完成300元认证费用的支付，支付方式包括微信支付、支付宝等。',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF52C41A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF52C41A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '服务商代交说明',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF52C41A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '服务商已为您批量采购认证费额度，您无需额外支付费用。法人扫码后仅需完成人脸识别即可。',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTipsBox(List<String> tips) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFA940)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tips
            .map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ==================== 事件处理 ====================

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _officialNameController.text.isNotEmpty &&
            (_nameCheckResult?.isAvailable ?? false);
      case 1:
        return _businessLicenseUrl != null;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _goToNextStep() {
    if (!_canProceed) return;

    // 如果是最后一步，提交认证
    if (_currentStep == 3) {
      _submitVerification();
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _checkNameAvailability() async {
    final name = _officialNameController.text;
    if (name.isEmpty) return;

    setState(() {
      _isCheckingName = true;
      _nameCheckResult = null;
    });

    // TODO: 调用API检测名称
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isCheckingName = false;
        // 模拟检测结果
        _nameCheckResult = const NameCheckResult(
          isAvailable: true,
          message: '名称可用',
        );
      });
    }
  }

  void _showUploadDialog(String title, Function(String) onUpload) {
    // TODO: 显示上传对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('上传$title - 功能待实现')),
    );
  }

  void _submitVerification() {
    setState(() {
      _isLoading = true;
    });

    // 构建认证信息
    final verification = MiniProgramVerification(
      appId: widget.appId,
      officialMiniProgramName: _officialNameController.text,
      businessLicenseUrl: _businessLicenseUrl,
      bankAccountInfo: _bankLicenseUrl != null
          ? BankAccountInfo(
              bankName: _bankNameController.text,
              branchName: _branchNameController.text,
              accountName: _accountNameController.text,
              accountNumber: _accountNumberController.text,
              licenseUrl: _bankLicenseUrl,
            )
          : null,
      operationDocUrl: _operationDocUrl,
      otherMaterials: [],
      paymentMethod: _selectedPaymentMethod,
      status: VerificationStatus.waitingAuthorization,
      submittedAt: DateTime.now(),
    );

    // TODO: 调用API提交认证
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onVerificationComplete(verification);
      }
    });
  }
}

/// 名称检测结果
class NameCheckResult {
  final bool isAvailable;
  final String message;

  const NameCheckResult({
    required this.isAvailable,
    required this.message,
  });
}
