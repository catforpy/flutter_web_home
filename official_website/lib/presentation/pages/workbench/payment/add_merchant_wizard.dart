import 'package:flutter/material.dart';
import 'merchant_models.dart';

/// 新增商户进件向导
/// 分步骤表单：基础信息 -> 主体资质 -> 结算账户 -> 超级管理员 -> 提交
class AddMerchantWizard extends StatefulWidget {
  const AddMerchantWizard({super.key});

  @override
  State<AddMerchantWizard> createState() => _AddMerchantWizardState();
}

class _AddMerchantWizardState extends State<AddMerchantWizard> {
  // 当前步骤 (0-3)
  int _currentStep = 0;

  // 表单数据
  final Map<String, dynamic> _formData = {
    // 第一步：基础信息
    'shortName': '',
    'servicePhone': '',
    'businessScenes': <String>[],
    // 第二步：主体资质
    'subjectType': MerchantSubjectType.individual,
    'businessLicenseUrl': '',
    'legalPersonIdCardUrl': '',
    // 第三步：结算账户
    'bankName': '',
    'bankAccount': '',
    'accountName': '',
    // 第四步：超级管理员
    'adminName': '',
    'adminPhone': '',
    'adminEmail': '',
    'adminIdCard': '',
  };

  // 表单Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 顶部标题栏
          _buildHeader(),

          // 步骤指示器
          _buildStepper(),

          // 表单内容区
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: _buildCurrentStepContent(),
              ),
            ),
          ),

          // 底部操作按钮
          _buildFooter(),
        ],
      ),
    );
  }

  /// 构建顶部标题栏
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '新增特约商户进件',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建步骤指示器
  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        children: List.generate(4, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Row(
            children: [
              // 步骤圆圈
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF07C160)
                      : isCurrent
                          ? const Color(0xFF07C160)
                          : const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? Colors.white : const Color(0xFF999999),
                          ),
                        ),
                ),
              ),

              // 步骤名称
              if (index < 3) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? const Color(0xFF07C160) : const Color(0xFFE8E8E8),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ],
          );
        }),
      ),
    );
  }

  /// 构建当前步骤内容
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2Qualification();
      case 2:
        return _buildStep3SettlementAccount();
      case 3:
        return _buildStep4Administrator();
      default:
        return const SizedBox.shrink();
    }
  }

  /// 第一步：基础信息
  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '基础信息',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 24),

        // 商户简称
        TextFormField(
          decoration: const InputDecoration(
            labelText: '商户简称 *',
            hintText: '请输入商户简称',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? '请输入商户简称' : null,
          onSaved: (value) => _formData['shortName'] = value,
        ),
        const SizedBox(height: 20),

        // 客服电话
        TextFormField(
          decoration: const InputDecoration(
            labelText: '客服电话 *',
            hintText: '请输入客服电话',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? '请输入客服电话' : null,
          onSaved: (value) => _formData['servicePhone'] = value,
        ),
        const SizedBox(height: 20),

        // 经营场景
        const Text(
          '经营场景 *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: BusinessScene.values.map((scene) {
            final isSelected = _formData['businessScenes'].contains(scene.label);
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _formData['businessScenes'].remove(scene.label);
                    } else {
                      _formData['businessScenes'].add(scene.label);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF07C160).withValues(alpha: 0.1)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF07C160) : const Color(0xFFE8E8E8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 18,
                        color: isSelected ? const Color(0xFF07C160) : const Color(0xFF999999),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        scene.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? const Color(0xFF07C160) : const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 第二步：主体资质
  Widget _buildStep2Qualification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '主体资质',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 24),

        // 主体类型
        DropdownButtonFormField<MerchantSubjectType>(
          decoration: const InputDecoration(
            labelText: '主体类型 *',
            border: OutlineInputBorder(),
          ),
          value: _formData['subjectType'],
          items: MerchantSubjectType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Text(type.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Text(type.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _formData['subjectType'] = value;
            });
          },
        ),
        const SizedBox(height: 20),

        // 营业执照上传
        _buildUploadArea(
          label: '营业执照 *',
          hint: '点击上传或拖拽文件到此处',
          onTap: () {
            _simulateUpload('businessLicenseUrl');
          },
        ),
        const SizedBox(height: 20),

        // 法人/经营者身份证上传
        _buildUploadArea(
          label: '法人/经营者身份证 *',
          hint: '点击上传或拖拽文件到此处',
          onTap: () {
            _simulateUpload('legalPersonIdCardUrl');
          },
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xFF1890FF),
              width: 1,
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF1890FF),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '上传的图片将自动使用 OCR 识别，请确保图片清晰完整',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1890FF),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 第三步：结算账户
  Widget _buildStep3SettlementAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '结算账户',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 24),

        // 开户银行
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: '开户银行 *',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'ICBC', child: Text('中国工商银行')),
            DropdownMenuItem(value: 'ABC', child: Text('中国农业银行')),
            DropdownMenuItem(value: 'BOC', child: Text('中国银行')),
            DropdownMenuItem(value: 'CCB', child: Text('中国建设银行')),
            DropdownMenuItem(value: 'BCM', child: Text('交通银行')),
            DropdownMenuItem(value: 'CMB', child: Text('招商银行')),
          ],
          onChanged: (value) {
            _formData['bankName'] = value;
          },
        ),
        const SizedBox(height: 20),

        // 银行账号
        TextFormField(
          decoration: const InputDecoration(
            labelText: '银行账号 *',
            hintText: '请输入银行账号',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? '请输入银行账号' : null,
          onSaved: (value) => _formData['bankAccount'] = value,
        ),
        const SizedBox(height: 20),

        // 开户名称
        TextFormField(
          decoration: InputDecoration(
            labelText: '开户名称 *',
            hintText: _formData['subjectType'] == MerchantSubjectType.individual
                ? '个体户可填法人姓名'
                : '企业必须填营业执照名称',
            border: const OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? '请输入开户名称' : null,
          onSaved: (value) => _formData['accountName'] = value,
        ),
      ],
    );
  }

  /// 第四步：超级管理员
  Widget _buildStep4Administrator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '超级管理员信息',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '该管理员将接收微信支付的通知及进行最终签约，请填写真实负责人信息',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 24),

        // 姓名
        TextFormField(
          decoration: const InputDecoration(
            labelText: '姓名 *',
            hintText: '请输入管理员姓名',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? '请输入姓名' : null,
          onSaved: (value) => _formData['adminName'] = value,
        ),
        const SizedBox(height: 20),

        // 手机号
        TextFormField(
          decoration: const InputDecoration(
            labelText: '手机号 *',
            hintText: '请输入手机号',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isEmpty ?? true ? '请输入手机号' : null,
          onSaved: (value) => _formData['adminPhone'] = value,
        ),
        const SizedBox(height: 20),

        // 邮箱
        TextFormField(
          decoration: const InputDecoration(
            labelText: '邮箱 *',
            hintText: '请输入邮箱',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value?.isEmpty ?? true ? '请输入邮箱' : null,
          onSaved: (value) => _formData['adminEmail'] = value,
        ),
        const SizedBox(height: 20),

        // 身份证号
        TextFormField(
          decoration: const InputDecoration(
            labelText: '身份证号 *',
            hintText: '请输入身份证号',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty ?? true ? '请输入身份证号' : null,
          onSaved: (value) => _formData['adminIdCard'] = value,
        ),
      ],
    );
  }

  /// 构建上传区域
  Widget _buildUploadArea({
    required String label,
    required String hint,
    required VoidCallback onTap,
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
        const SizedBox(height: 12),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: _formData[label] != null && _formData[label].isNotEmpty
                        ? const Color(0xFF07C160)
                        : const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formData[label] != null && _formData[label].isNotEmpty
                        ? '已上传：${_formData[label]}'
                        : hint,
                    style: TextStyle(
                      fontSize: 14,
                      color: _formData[label] != null && _formData[label].isNotEmpty
                          ? const Color(0xFF07C160)
                          : const Color(0xFF999999),
                    ),
                  ),
                  if (_formData[label] != null && _formData[label].isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '点击重新上传',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1890FF),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 模拟文件上传
  void _simulateUpload(String fieldKey) {
    setState(() {
      _formData[fieldKey] = 'mock_file_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 文件上传成功（模拟）')),
    );
  }

  /// 构建底部操作按钮
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 上一步按钮
          if (_currentStep > 0)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '上一步',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 12),

          // 下一步/提交按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _handleNextStep,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF07C160),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _currentStep < 3 ? '下一步' : '提交审核',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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

  /// 处理下一步/提交
  void _handleNextStep() {
    // 验证表单
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep < 3) {
      // 进入下一步
      _formKey.currentState!.save();
      setState(() {
        _currentStep++;
      });
    } else {
      // 提交
      _submitMerchant();
    }
  }

  /// 提交商户进件
  void _submitMerchant() {
    _formKey.currentState!.save();

    // 创建商户对象
    final merchant = MerchantInfo(
      id: 'M${DateTime.now().millisecondsSinceEpoch}',
      shortName: _formData['shortName'],
      fullName: _formData['shortName'], // 简化处理
      subjectType: _formData['subjectType'],
      servicePhone: _formData['servicePhone'],
      businessScenes: List<String>.from(_formData['businessScenes']),
      adminName: _formData['adminName'],
      adminPhone: _formData['adminPhone'],
      adminEmail: _formData['adminEmail'],
      status: MerchantStatus.reviewing,
      submitTime: DateTime.now(),
      currentStep: ProgressStep.submitted,
      completedSteps: [ProgressStep.submitted],
    );

    // 返回商户对象
    Navigator.pop(context, merchant);
  }
}
