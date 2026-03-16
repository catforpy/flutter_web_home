import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/auth/auth_state.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/mini_program_registration.dart';

/// 注册小程序弹窗
/// 分步骤表单，收集企业信息和小程序基本信息
class RegisterMiniProgramDialog extends StatefulWidget {
  /// 注册完成回调
  final Function(MiniProgramRegistration) onRegistrationComplete;

  /// 关闭回调
  final VoidCallback onClose;

  const RegisterMiniProgramDialog({
    super.key,
    required this.onRegistrationComplete,
    required this.onClose,
  });

  @override
  State<RegisterMiniProgramDialog> createState() => _RegisterMiniProgramDialogState();
}

class _RegisterMiniProgramDialogState extends State<RegisterMiniProgramDialog> {
  // 当前步骤（0=选择公司, 1=企业信息, 2=小程序信息, 3=扫码授权）
  int _currentStep = 0;

  // 公司选择方式
  bool _selectExistingCompany = false; // true=已注册公司, false=新注册公司
  CompanyInfo? _selectedCompany; // 选中的已注册公司

  // 表单数据
  final _formKey = GlobalKey<FormState>();
  final _enterpriseNameController = TextEditingController();
  final _enterpriseCodeController = TextEditingController();
  final _legalPersonNameController = TextEditingController();
  final _legalPersonWechatController = TextEditingController();
  final _servicePhoneController = TextEditingController();
  final _miniProgramNameController = TextEditingController();
  final _miniProgramIntroController = TextEditingController();
  final _miniProgramSignatureController = TextEditingController();

  // 企业类型选择
  int _selectedEnterpriseType = 1;

  // 服务类目列表
  final List<ServiceCategory> _selectedCategories = [];

  // 小程序Logo
  String? _miniProgramLogo;

  // 加载状态
  bool _isLoading = false;

  // 模拟公司列表数据
  final List<CompanyInfo> _companies = [
    CompanyInfo(
      id: '1',
      name: '上海都达网络科技有限公司',
      code: '91310000MA123456X',
      legalPerson: '张三',
      isVerified: true,
      verificationStatus: '已认证',
    ),
    CompanyInfo(
      id: '2',
      name: '北京都达科技有限公司',
      code: '91110000MA789012Y',
      legalPerson: '李四',
      isVerified: false,
      verificationStatus: '未认证',
    ),
    CompanyInfo(
      id: '3',
      name: '深圳都达信息技术有限公司',
      code: '91440300MA456789Z',
      legalPerson: '王五',
      isVerified: false,
      verificationStatus: '未认证',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // TODO: 从后端获取用户的真实公司列表
    // 示例代码：
    // final authState = Provider.of<AuthState>(context, listen: false);
    // final companies = authState.companies;
  }

  @override
  void dispose() {
    _enterpriseNameController.dispose();
    _enterpriseCodeController.dispose();
    _legalPersonNameController.dispose();
    _legalPersonWechatController.dispose();
    _servicePhoneController.dispose();
    _miniProgramNameController.dispose();
    _miniProgramIntroController.dispose();
    _miniProgramSignatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => widget.onClose(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // 阻止冒泡
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                  minWidth: 500,
                  maxHeight: 750,
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

  /// 构建标题栏
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
          const Text(
            '注册小程序',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  /// 构建步骤指示器
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          if (!_selectExistingCompany) ...[
            _buildStepItem(0, '选择公司'),
            _buildStepConnector(0),
            _buildStepItem(1, '企业信息'),
            _buildStepConnector(1),
            _buildStepItem(2, '小程序信息'),
            _buildStepConnector(2),
            _buildStepItem(3, '扫码授权'),
          ] else ...[
            _buildStepItem(0, '选择公司'),
            _buildStepConnector(0),
            _buildStepItem(1, '小程序信息'),
            _buildStepConnector(1),
            _buildStepItem(2, '扫码授权'),
          ],
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

  /// 构建步骤内容
  Widget _buildStepContent() {
    // 如果还没选择公司类型（初始状态），显示选择界面
    if (_currentStep == 0) {
      return _buildCompanySelectionStep();
    }

    // 已选择新注册公司模式
    if (!_selectExistingCompany) {
      switch (_currentStep) {
        case 1:
          return _buildEnterpriseInfoStep();
        case 2:
          return _buildMiniProgramInfoStep();
        case 3:
          return _buildAuthorizationStep();
        default:
          return const SizedBox.shrink();
      }
    } else {
      // 已选择已注册公司模式
      switch (_currentStep) {
        case 1:
          return _buildMiniProgramInfoStep();
        case 2:
          return _buildAuthorizationStep();
        default:
          return const SizedBox.shrink();
      }
    }
  }

  /// 步骤0：选择公司类型（新注册 vs 已注册）
  Widget _buildCompanySelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('选择公司'),
        const SizedBox(height: 16),
        const Text(
          '请选择您要注册小程序的公司',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 32),

        // 新注册公司
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectExistingCompany = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF1A9B8E),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9B8E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_business,
                      size: 24,
                      color: Color(0xFF1A9B8E),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '新注册公司',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '首次注册，需要填写完整企业信息',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF1A9B8E),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 已注册公司
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectExistingCompany = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _companies.isEmpty
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF1A9B8E),
                  width: _companies.isEmpty ? 1 : 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF52C41A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 24,
                      color: Color(0xFF52C41A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '已注册公司',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _companies.isEmpty
                              ? '暂无已注册公司'
                              : '从已注册公司中选择（${_companies.length}个）',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_companies.isNotEmpty)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF1A9B8E),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 步骤0（已注册公司模式）：选择已有的公司
  Widget _buildExistingCompanySelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('选择已注册公司'),
        const SizedBox(height: 16),
        const Text(
          '请从您的已注册公司中选择一个',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 24),

        // 公司列表
        ..._companies.map((company) {
          final isSelected = _selectedCompany?.id == company.id;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCompany = company;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A9B8E).withOpacity(0.05)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A9B8E)
                        : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: company.isVerified
                            ? const Color(0xFF52C41A).withOpacity(0.1)
                            : const Color(0xFFFAAD14).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        company.isVerified ? Icons.verified : Icons.business,
                        size: 20,
                        color: company.isVerified
                            ? const Color(0xFF52C41A)
                            : const Color(0xFFFAAD14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '统一社会信用代码: ${company.code}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '法人: ${company.legalPerson}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: company.isVerified
                                      ? const Color(0xFF52C41A).withOpacity(0.1)
                                      : const Color(0xFFFAAD14).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  company.verificationStatus,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: company.isVerified
                                        ? const Color(0xFF52C41A)
                                        : const Color(0xFFFAAD14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  /// 步骤1：企业主体信息（新注册公司模式）
  Widget _buildEnterpriseInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('企业主体信息'),
          const SizedBox(height: 24),

          // 企业类型
          _buildDropdownField<int>(
            '企业类型',
            '请选择企业类型',
            const [
              DropdownMenuItem(value: 1, child: Text('企业')),
              DropdownMenuItem(value: 2, child: Text('政府')),
              DropdownMenuItem(value: 3, child: Text('媒体')),
              DropdownMenuItem(value: 4, child: Text('其他组织')),
              DropdownMenuItem(value: 5, child: Text('个人')),
            ],
            (value) {
              if (value != null) {
                setState(() => _selectedEnterpriseType = value);
              }
            },
            _selectedEnterpriseType,
          ),
          const SizedBox(height: 16),

          // 企业名称
          _buildTextField(
            '企业名称',
            '请输入与工商部门登记一致的企业名称',
            _enterpriseNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入企业名称';
              }
              if (value.length < 2 || value.length > 100) {
                return '企业名称长度应在2-100个字符之间';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 统一社会信用代码
          _buildTextField(
            '统一社会信用代码',
            '请输入18位统一社会信用代码',
            _enterpriseCodeController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            ],
            maxLength: 18,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入统一社会信用代码';
              }
              if (value.length != 18) {
                return '统一社会信用代码应为18位';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 法人姓名
          _buildTextField(
            '法人姓名',
            '请输入法人姓名（需与微信支付银行卡一致）',
            _legalPersonNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入法人姓名';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 法人微信
          _buildTextField(
            '法人微信',
            '请输入法人微信号（在"微信-我"中获取）',
            _legalPersonWechatController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入法人微信号';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 客服电话
          _buildTextField(
            '客服电话（建议填写）',
            '请输入第三方客服电话',
            _servicePhoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
                if (!phoneRegex.hasMatch(value)) {
                  return '请输入正确的手机号码';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // 温馨提示
          _buildTipsBox([
            '💡 企业名称需与工商部门登记一致',
            '💡 法人微信需在"微信-我"中获取，不能使用手机号',
            '💡 法人姓名需与微信支付银行卡绑定姓名一致',
          ]),
        ],
      ),
    );
  }

  /// 步骤2：小程序基本信息
  Widget _buildMiniProgramInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('小程序基本信息'),
          const SizedBox(height: 24),

          // 小程序名称
          _buildTextField(
            '小程序名称',
            '2-30个字，认证后可修改',
            _miniProgramNameController,
            maxLength: 30,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入小程序名称';
              }
              if (value.length < 2 || value.length > 30) {
                return '小程序名称长度应在2-30个字符之间';
              }
              return null;
            },
            suffix: IconButton(
              icon: const Icon(Icons.search, size: 18),
              onPressed: _checkMiniProgramName,
              tooltip: '检测名称是否可用',
            ),
          ),
          const SizedBox(height: 16),

          // 小程序简介
          _buildTextareaField(
            '小程序简介',
            '4-120个字，介绍小程序的功能和特色',
            _miniProgramIntroController,
            maxLength: 120,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入小程序简介';
              }
              if (value.length < 4 || value.length > 120) {
                return '小程序简介长度应在4-120个字符之间';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 功能介绍
          _buildTextareaField(
            '功能介绍',
            '4-120个字，一句话描述小程序的核心功能',
            _miniProgramSignatureController,
            maxLength: 120,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入功能介绍';
              }
              if (value.length < 4 || value.length > 120) {
                return '功能介绍长度应在4-120个字符之间';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 服务类目选择器
          _buildCategorySelector(),
          const SizedBox(height: 16),

          // 小程序头像（可选）
          _buildLogoUploader(),
          const SizedBox(height: 24),

          // 温馨提示
          _buildTipsBox([
            '💡 小程序名称认证后可修改',
            '💡 服务类目最多选择5个',
            '💡 小程序头像可以后续修改',
          ]),
        ],
      ),
    );
  }

  /// 步骤3：法人扫码授权
  Widget _buildAuthorizationStep() {
    return Column(
      children: [
        _buildSectionTitle('法人扫码授权'),
        const SizedBox(height: 24),

        // 说明文字
        const Text(
          '请法人使用微信扫描下方二维码，完成人脸识别验证',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // 二维码占位符
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFDDDDDD),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
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
        const SizedBox(height: 24),

        // 操作提示
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1890FF)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📱 操作说明',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1890FF),
                ),
              ),
              SizedBox(height: 12),
              Text('1. 法人将收到"公众平台安全助手"的模板消息'),
              SizedBox(height: 8),
              Text('2. 点击消息进入授权页面'),
              SizedBox(height: 8),
              Text('3. 完成人脸识别验证'),
              SizedBox(height: 8),
              Text(
                '⏱ 请在24小时内完成操作',
                style: TextStyle(
                  color: Color(0xFFFFA940),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建底部按钮
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
          if (_currentStep < _getMaxStep())
            ElevatedButton(
              onPressed: _canGoToNextStep ? _goToNextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9B8E),
                disabledBackgroundColor: const Color(0xFFCCCCCC),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                _getNextButtonText(),
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          else
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9B8E),
                disabledBackgroundColor: const Color(0xFFCCCCCC),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
                  : const Text(
                      '提交注册',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
            ),
        ],
      ),
    );
  }

  /// 获取最大步骤数
  int _getMaxStep() {
    if (_selectExistingCompany) {
      return 2; // 选择公司(0) → 小程序信息(1) → 扫码授权(2)
    } else {
      return 3; // 选择公司(0) → 企业信息(1) → 小程序信息(2) → 扫码授权(3)
    }
  }

  /// 获取下一步按钮的文字
  String _getNextButtonText() {
    if (_currentStep == 0) {
      return '下一步 →';
    } else if (_currentStep == 1) {
      return '下一步 →';
    } else {
      return '下一步 →';
    }
  }

  /// ==================== 辅助方法 ====================

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

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          validator: validator,
          style: const TextStyle(color: Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1890FF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildTextareaField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 3,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          style: const TextStyle(color: Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1890FF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(
    String label,
    String hint,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged,
    T value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: const TextStyle(color: Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1890FF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
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

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '服务类目',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '已选择 ${_selectedCategories.length}/5',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFFA940),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedCategories.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedCategories.map((category) {
              return Chip(
                label: Text(
                  '${category.firstName} > ${category.secondName}',
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    _selectedCategories.remove(category);
                  });
                },
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _selectedCategories.length >= 5
              ? null
              : () => _showCategoryPickerDialog(),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('选择类目'),
        ),
        const SizedBox(height: 8),
        const Text(
          '提示：服务类目最多添加5个',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '小程序头像（可选）',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        if (_miniProgramLogo != null)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              image: DecorationImage(
                image: NetworkImage(_miniProgramLogo!),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => _uploadLogo(),
            icon: const Icon(Icons.upload, size: 16),
            label: const Text('上传头像'),
          ),
      ],
    );
  }

  /// ==================== 事件处理 ====================

  bool get _canGoToNextStep {
    // 步骤0：选择公司类型（总是允许下一步）
    if (_currentStep == 0) {
      return true;
    }

    // 新注册公司模式的步骤1：企业信息
    if (!_selectExistingCompany && _currentStep == 1) {
      return _enterpriseNameController.text.isNotEmpty &&
          _enterpriseCodeController.text.isNotEmpty &&
          _legalPersonNameController.text.isNotEmpty &&
          _legalPersonWechatController.text.isNotEmpty;
    }

    // 小程序信息步骤（新注册公司步骤2，已注册公司步骤1）
    int miniProgramInfoStep = _selectExistingCompany ? 1 : 2;
    if (_currentStep == miniProgramInfoStep) {
      return _miniProgramNameController.text.isNotEmpty &&
          _miniProgramIntroController.text.isNotEmpty &&
          _miniProgramSignatureController.text.isNotEmpty &&
          _selectedCategories.isNotEmpty;
    }

    return true;
  }

  void _goToNextStep() {
    if (!_canGoToNextStep) return;

    // 验证当前步骤
    int enterpriseInfoStep = _selectExistingCompany ? -1 : 1;
    if (_currentStep == enterpriseInfoStep) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    setState(() {
      _currentStep++;
    });

    // 如果进入扫码授权步骤，自动提交注册
    int maxStep = _getMaxStep();
    if (_currentStep == maxStep) {
      _submitRegistration();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _checkMiniProgramName() {
    // TODO: 调用API检测名称
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('名称检测功能待实现')),
    );
  }

  void _showCategoryPickerDialog() {
    // TODO: 显示类目选择器
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('类目选择器待实现')),
    );
  }

  void _uploadLogo() {
    // TODO: 上传Logo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logo上传功能待实现')),
    );
  }

  void _submitRegistration() {
    // 如果是已注册公司模式，不需要验证企业信息表单
    if (!_selectExistingCompany) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    // 如果是已注册公司，但没有选择公司
    if (_selectExistingCompany && _selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择一个公司')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 构建注册信息
    final registration = MiniProgramRegistration(
      enterpriseName: _selectExistingCompany
          ? _selectedCompany!.name
          : _enterpriseNameController.text,
      enterpriseCode: _selectExistingCompany
          ? _selectedCompany!.code
          : _enterpriseCodeController.text,
      enterpriseType: _selectedEnterpriseType,
      legalPersonName: _selectExistingCompany
          ? _selectedCompany!.legalPerson
          : _legalPersonNameController.text,
      legalPersonWechat: _legalPersonWechatController.text,
      servicePhone: _servicePhoneController.text.isNotEmpty
          ? _servicePhoneController.text
          : null,
      miniProgramName: _miniProgramNameController.text,
      miniProgramIntro: _miniProgramIntroController.text,
      miniProgramSignature: _miniProgramSignatureController.text,
      categories: _selectedCategories,
      miniProgramLogo: _miniProgramLogo,
      status: RegistrationStatus.submitted,
      createdAt: DateTime.now(),
    );

    // TODO: 调用API提交注册
    // 模拟API调用
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // 触发完成回调
        widget.onRegistrationComplete(registration);
      }
    });
  }
}

/// 公司信息模型
class CompanyInfo {
  final String id;
  final String name;
  final String code; // 统一社会信用代码
  final String legalPerson; // 法人姓名
  final bool isVerified; // 是否已认证
  final String verificationStatus; // 认证状态：已认证/未认证

  CompanyInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.legalPerson,
    required this.isVerified,
    required this.verificationStatus,
  });
}
