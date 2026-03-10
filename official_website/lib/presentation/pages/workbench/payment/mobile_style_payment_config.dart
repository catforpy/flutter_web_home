import 'package:flutter/material.dart';
import 'merchant_models.dart';
import 'mobile_style_progress_page.dart';

/// 移动端风格的特约商户进件向导（PC Web端）
/// 设计风格：微信支付小程序风格
/// 布局：单列居中，最大宽度480px
/// 主题：微信绿 #07C160
class MobileStylePaymentConfig extends StatefulWidget {
  const MobileStylePaymentConfig({super.key});

  @override
  State<MobileStylePaymentConfig> createState() => _MobileStylePaymentConfigState();
}

class _MobileStylePaymentConfigState extends State<MobileStylePaymentConfig> {
  // 当前步骤 (0-3)
  int _currentStep = 0;

  // 表单数据
  final Map<String, dynamic> _formData = {
    // Step 1: 主体资质
    'shortName': '',
    'subjectType': MerchantSubjectType.individual,
    'businessLicenseUrl': '',
    'creditCode': '',
    'licenseName': '',
    'legalPerson': '',
    'licenseValidForever': false,
    'licenseStartDate': null,
    'licenseEndDate': null,
    // Step 2: 管理员信息
    'adminIsLegalPerson': true,
    'authorizationUrl': '',
    'adminName': '',
    'adminIdCard': '',
    'idCardFrontUrl': '',
    'idCardBackUrl': '',
    'adminPhone': '',
    'verifyCode': '',
    'wechatId': '',
    // Step 3: 结算账户
    'accountType': 'corporate', // corporate | personal
    'accountName': '',
    'bankAccount': '',
    'bankName': '',
    'bankBranch': '',
    // Step 4: 经营场景
    'businessScenes': <String>[],
    'storeName': '',
    'storeAddress': '',
    'storePhotoUrl': '',
    'miniProgramAppId': '',
    'miniProgramScreenshot': '',
    'servicePhone': '',
  };

  // 全局表单Key
  final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(4, (_) => GlobalKey<FormState>());

  @override
  Widget build(BuildContext context) {
    // PC Web端使用移动端风格：单列居中布局
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Center(
        child: Container(
          width: 480, // 移动端宽度
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // 顶部导航栏
              _buildNavBar(),

              // 进度指示器
              _buildStepper(),

              // 表单内容区（可滚动）
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: _buildCurrentStepContent(),
                  ),
                ),
              ),

              // 底部操作栏
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildNavBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '步骤 ${_currentStep + 1}/4：${_getStepTitle()}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.headset_mic,
            size: 20,
            color: Color(0xFF07C160),
          ),
        ],
      ),
    );
  }

  /// 构建进度指示器
  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: List.generate(7, (index) {
          if (index % 2 == 0) {
            // 圆点
            final stepIndex = index ~/ 2;
            final isActive = stepIndex == _currentStep;
            final isCompleted = stepIndex < _currentStep;

            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF07C160)
                          : isCompleted
                              ? const Color(0xFF07C160)
                              : const Color(0xFFE5E5E5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isActive || isCompleted ? Colors.white : const Color(0xFF999999),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStepLabel(stepIndex),
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? const Color(0xFF07C160)
                          : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // 连接线
            final lineIndex = index ~/ 2;
            final isCompleted = lineIndex < _currentStep;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF07C160) : const Color(0xFFE5E5E5),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  /// 获取步骤标题
  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return '主体资质';
      case 1:
        return '管理员信息';
      case 2:
        return '结算账户';
      case 3:
        return '经营场景';
      default:
        return '';
    }
  }

  /// 获取步骤标签
  String _getStepLabel(int step) {
    switch (step) {
      case 0:
        return '主体';
      case 1:
        return '管理员';
      case 2:
        return '结算';
      case 3:
        return '场景';
      default:
        return '';
    }
  }

  /// 构建当前步骤内容
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1SubjectInfo();
      case 1:
        return _buildStep2AdminInfo();
      case 2:
        return _buildStep3BankAccount();
      case 3:
        return _buildStep4BusinessScenes();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: 主体资质
  Widget _buildStep1SubjectInfo() {
    return Form(
      key: _stepFormKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商户简称
          _buildFieldLabel('商户简称 *'),
          _buildTextField(
            placeholder: '请输入商户简称',
            validator: (value) => value?.isEmpty ?? true ? '请输入商户简称' : null,
            onSaved: (value) => _formData['shortName'] = value,
          ),
          _buildHint('将显示在用户支付账单上，限10个字'),

          const SizedBox(height: 24),

          // 主体类型
          _buildFieldLabel('主体类型 *'),
          _buildSubjectTypeSelector(),

          const SizedBox(height: 24),

          // 营业执照上传
          _buildFieldLabel('营业执照 *'),
          _buildUploadArea(
            label: '点击上传/拍照',
            hint: '支持JPG/PNG，最大5MB',
            onTap: () => _simulateUpload('businessLicenseUrl'),
          ),
          if (_formData['businessLicenseUrl'] != null && _formData['businessLicenseUrl'].toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildOcrRecognizingSection(),
          ],

          const SizedBox(height: 24),

          // 统一社会信用代码
          _buildFieldLabel('统一社会信用代码 *'),
          _buildTextField(
            placeholder: '请输入统一社会信用代码',
            initialValue: _formData['creditCode'],
            validator: (value) => value?.isEmpty ?? true ? '请输入统一社会信用代码' : null,
            onSaved: (value) => _formData['creditCode'] = value,
          ),

          const SizedBox(height: 16),

          // 执照名称
          _buildFieldLabel('执照名称 *'),
          _buildTextField(
            placeholder: '请输入执照名称',
            initialValue: _formData['licenseName'],
            validator: (value) => value?.isEmpty ?? true ? '请输入执照名称' : null,
            onSaved: (value) => _formData['licenseName'] = value,
          ),

          const SizedBox(height: 16),

          // 法人姓名
          _buildFieldLabel('法人姓名 *'),
          _buildTextField(
            placeholder: '请输入法人姓名',
            initialValue: _formData['legalPerson'],
            validator: (value) => value?.isEmpty ?? true ? '请输入法人姓名' : null,
            onSaved: (value) => _formData['legalPerson'] = value,
          ),

          const SizedBox(height: 16),

          // 有效期
          _buildFieldLabel('有效期 *'),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  placeholder: '开始日期',
                  onTap: () => _selectDate('licenseStartDate'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  placeholder: '结束日期',
                  onTap: () => _selectDate('licenseEndDate'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _formData['licenseValidForever'],
                onChanged: (value) {
                  setState(() {
                    _formData['licenseValidForever'] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF07C160),
              ),
              const Text('长期有效', style: TextStyle(fontSize: 14)),
            ],
          ),

          const SizedBox(height: 32), // 底部留白
        ],
      ),
    );
  }

  /// Step 2: 管理员信息
  Widget _buildStep2AdminInfo() {
    return Form(
      key: _stepFormKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部提示条
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF1890FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '超级管理员将负责接收通知及扫码签约，请填写真实负责人信息',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF1890FF),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 管理员类型
          _buildFieldLabel('管理员类型 *'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _formData['adminIsLegalPerson'] = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _formData['adminIsLegalPerson']
                            ? const Color(0xFF07C160)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        '法人本人',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _formData['adminIsLegalPerson']
                              ? Colors.white
                              : const Color(0xFF666666),
                          fontWeight: _formData['adminIsLegalPerson']
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _formData['adminIsLegalPerson'] = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_formData['adminIsLegalPerson']
                            ? const Color(0xFF07C160)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        '代理人',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_formData['adminIsLegalPerson']
                              ? Colors.white
                              : const Color(0xFF666666),
                          fontWeight: !_formData['adminIsLegalPerson']
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 代理人授权书
          if (!_formData['adminIsLegalPerson']) ...[
            const SizedBox(height: 16),
            _buildUploadArea(
              label: '点击上传授权书',
              hint: '需法人签字',
              onTap: () => _simulateUpload('authorizationUrl'),
            ),
          ],

          const SizedBox(height: 24),

          // 姓名
          _buildFieldLabel('姓名 *'),
          _buildTextField(
            placeholder: '请输入管理员姓名',
            validator: (value) => value?.isEmpty ?? true ? '请输入姓名' : null,
            onSaved: (value) => _formData['adminName'] = value,
          ),

          const SizedBox(height: 16),

          // 身份证号
          _buildFieldLabel('身份证号 *'),
          _buildTextField(
            placeholder: '请输入身份证号',
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return '请输入身份证号';
              if (value!.length != 18) return '身份证号格式错误';
              return null;
            },
            onSaved: (value) => _formData['adminIdCard'] = value,
          ),

          const SizedBox(height: 16),

          // 身份证照片
          _buildFieldLabel('身份证照片 *'),
          Row(
            children: [
              Expanded(
                child: _buildUploadArea(
                  label: '人像面',
                  hint: '正面',
                  height: 120,
                  onTap: () => _simulateUpload('idCardFrontUrl'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUploadArea(
                  label: '国徽面',
                  hint: '反面',
                  height: 120,
                  onTap: () => _simulateUpload('idCardBackUrl'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 手机号
          _buildFieldLabel('手机号 *'),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  placeholder: '请输入手机号',
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty ?? true ? '请输入手机号' : null,
                  onSaved: (value) => _formData['adminPhone'] = value,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () => _sendVerifyCode(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF07C160),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('获取验证码', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 验证码
          _buildFieldLabel('验证码 *'),
          _buildTextField(
            placeholder: '请输入验证码',
            validator: (value) => value?.isEmpty ?? true ? '请输入验证码' : null,
            onSaved: (value) => _formData['verifyCode'] = value,
          ),

          const SizedBox(height: 16),

          // 微信号（可选）
          _buildFieldLabel('微信号（可选）'),
          _buildTextField(
            placeholder: '填写后微信会推送消息',
            onSaved: (value) => _formData['wechatId'] = value,
          ),
          _buildHint('微信支付将通过此微信号推送重要通知'),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Step 3: 结算账户
  Widget _buildStep3BankAccount() {
    return Form(
      key: _stepFormKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 账户类型
          _buildFieldLabel('账户类型 *'),
          _buildAccountTypeSelector(),

          const SizedBox(height: 24),

          // 开户名称
          _buildFieldLabel('开户名称 *'),
          _buildTextField(
            placeholder: '请输入开户名称',
            validator: (value) => value?.isEmpty ?? true ? '请输入开户名称' : null,
            onSaved: (value) => _formData['accountName'] = value,
          ),
          _buildHint('需与执照/身份证姓名一致'),

          const SizedBox(height: 16),

          // 银行账号
          _buildFieldLabel('银行账号 *'),
          _buildTextField(
            placeholder: '请输入银行账号',
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (value) => value?.isEmpty ?? true ? '请输入银行账号' : null,
            onSaved: (value) => _formData['bankAccount'] = value,
          ),

          const SizedBox(height: 16),

          // 开户银行
          _buildFieldLabel('开户银行 *'),
          InkWell(
            onTap: () => _selectBank(),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formData['bankName'].toString().isEmpty
                          ? '请选择开户银行'
                          : _formData['bankName'],
                      style: TextStyle(
                        color: _formData['bankName'].toString().isEmpty
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF999999)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Step 4: 经营场景
  Widget _buildStep4BusinessScenes() {
    return Form(
      key: _stepFormKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 经营场景勾选
          _buildFieldLabel('经营场景 *（可多选）'),
          ...List.generate(5, (index) {
            final scenes = ['线下门店', '微信小程序', '公众号', 'APP', '网站'];
            final scene = scenes[index];
            final isSelected = _formData['businessScenes'].contains(scene);

            return Column(
              children: [
                CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _formData['businessScenes'].add(scene);
                      } else {
                        _formData['businessScenes'].remove(scene);
                      }
                    });
                  },
                  title: Text(scene),
                  activeColor: const Color(0xFF07C160),
                  contentPadding: EdgeInsets.zero,
                ),
                if (isSelected) _buildDynamicFormFields(scene),
              ],
            );
          }),

          const SizedBox(height: 24),

          // 客服电话
          _buildFieldLabel('客服电话 *'),
          _buildTextField(
            placeholder: '请输入客服电话',
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? '请输入客服电话' : null,
            onSaved: (value) => _formData['servicePhone'] = value,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建动态表单字段
  Widget _buildDynamicFormFields(String scene) {
    if (scene == '线下门店') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('门店名称 *'),
                _buildTextField(
                  placeholder: '请输入门店名称',
                  validator: (value) => value?.isEmpty ?? true ? '请输入门店名称' : null,
                  onSaved: (value) => _formData['storeName'] = value,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel('门店地址 *'),
                _buildTextField(
                  placeholder: '请输入门店地址',
                  suffix: const Icon(Icons.location_on, size: 16),
                  validator: (value) => value?.isEmpty ?? true ? '请输入门店地址' : null,
                  onSaved: (value) => _formData['storeAddress'] = value,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel('门头照 *'),
                _buildUploadArea(
                  label: '上传门头照',
                  hint: '需包含完整店招',
                  onTap: () => _simulateUpload('storePhotoUrl'),
                ),
                _buildHint('需包含完整店招'),
              ],
            ),
          ),
        ],
      );
    } else if (scene == '微信小程序') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('小程序AppID *'),
                _buildTextField(
                  placeholder: 'wx...',
                  validator: (value) => value?.isEmpty ?? true ? '请输入AppID' : null,
                  onSaved: (value) => _formData['miniProgramAppId'] = value,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel('小程序截图 *'),
                _buildUploadArea(
                  label: '上传小程序截图',
                  hint: '小程序首页',
                  onTap: () => _simulateUpload('miniProgramScreenshot'),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  /// 构建底部操作栏
  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
        top: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 上一步按钮
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF999999),
                  side: const BorderSide(color: Color(0xFFE5E5E5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('上一步', style: TextStyle(fontSize: 16)),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 12),

          // 下一步/提交按钮
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: _handleNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF07C160),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                _currentStep < 3 ? '下一步' : '提交申请',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ 辅助组件 ============

  /// 构建字段标签
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  /// 构建输入框
  Widget _buildTextField({
    String? placeholder,
    String? initialValue,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  /// 构建提示文字
  Widget _buildHint(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
      ),
    );
  }

  /// 构建主体类型选择器
  Widget _buildSubjectTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSubjectTypeCard(
            icon: '🏢',
            label: '企业',
            type: MerchantSubjectType.enterprise,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSubjectTypeCard(
            icon: '🧑',
            label: '个体户',
            type: MerchantSubjectType.individual,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSubjectTypeCard(
            icon: '📋',
            label: '其他',
            type: MerchantSubjectType.other,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectTypeCard({
    required String icon,
    required String label,
    required MerchantSubjectType type,
  }) {
    final isSelected = _formData['subjectType'] == type;
    return InkWell(
      onTap: () {
        setState(() {
          _formData['subjectType'] = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF07C160).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF07C160) : const Color(0xFFE5E5E5),
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? const Color(0xFF07C160) : const Color(0xFF666666),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建账户类型选择器
  Widget _buildAccountTypeSelector() {
    return Column(
      children: [
        _buildAccountTypeCard(
          label: '对公账户',
          hint: '企业必须使用对公账户',
          value: 'corporate',
        ),
        const SizedBox(height: 12),
        _buildAccountTypeCard(
          label: '经营者个人卡',
          hint: '个体户可选',
          value: 'personal',
        ),
      ],
    );
  }

  Widget _buildAccountTypeCard({
    required String label,
    required String hint,
    required String value,
  }) {
    final isSelected = _formData['accountType'] == value;
    return InkWell(
      onTap: () {
        setState(() {
          _formData['accountType'] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF07C160) : const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF07C160) : const Color(0xFFCCCCCC),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF07C160) : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hint,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建上传区域
  Widget _buildUploadArea({
    required String label,
    required String hint,
    required VoidCallback onTap,
    double? height,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 160,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: const Color(0xFF07C160),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: 32,
                color: Color(0xFF07C160),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF07C160),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hint,
                style: const TextStyle(fontSize: 12, color: Color(0xFFCCCCCC)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建OCR识别区
  Widget _buildOcrRecognizingSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFD591)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFA5151)),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '⚡️ 正在识别执照信息...',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFFFA5151),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建日期选择字段
  Widget _buildDateField({
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                placeholder,
                style: TextStyle(
                  color: const Color(0xFFCCCCCC),
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }

  // ============ 交互方法 ============

  /// 处理下一步/提交
  void _handleNextStep() {
    if (!_stepFormKeys[_currentStep].currentState!.validate()) {
      return;
    }

    if (_currentStep < 3) {
      _stepFormKeys[_currentStep].currentState!.save();
      setState(() {
        _currentStep++;
      });
    } else {
      _submitApplication();
    }
  }

  /// 提交申请
  void _submitApplication() {
    _stepFormKeys[_currentStep].currentState!.save();

    // 显示Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在加密上传资料至微信支付...\n请勿关闭'),
              ],
            ),
          ),
        ),
      ),
    );

    // 模拟提交
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      Navigator.pop(context); // 关闭Loading

      // 跳转到进度页面
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileStyleProgressPage(),
        ),
      );
    });
  }

  /// 模拟上传
  void _simulateUpload(String fieldKey) {
    setState(() {
      _formData[fieldKey] = 'mock_file_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 文件上传成功（模拟）'),
        backgroundColor: Color(0xFF07C160),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 发送验证码
  void _sendVerifyCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 验证码已发送（模拟）'),
        backgroundColor: Color(0xFF07C160),
      ),
    );
  }

  /// 选择日期
  void _selectDate(String fieldKey) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((date) {
      if (date != null) {
        setState(() {
          _formData[fieldKey] = date;
        });
      }
    });
  }

  /// 选择银行
  void _selectBank() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择开户银行'),
        children: [
          '中国工商银行',
          '中国建设银行',
          '招商银行',
          '中国银行',
          '中国农业银行',
        ]
            .map(
              (bank) => SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _formData['bankName'] = bank;
                  });
                  Navigator.pop(context);
                },
                child: Text(bank),
              ),
            )
            .toList(),
      ),
    );
  }
}
