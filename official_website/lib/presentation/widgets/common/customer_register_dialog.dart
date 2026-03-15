import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/auth/auth_state.dart';

/// 客户注册弹窗
/// 支持两种注册方式：
/// 1. 注册都达网账户（账号+密码）
/// 2. 手机号码注册（手机号+验证码）
class CustomerRegisterDialog extends StatefulWidget {
  const CustomerRegisterDialog({super.key});

  @override
  State<CustomerRegisterDialog> createState() => _CustomerRegisterDialogState();
}

class _CustomerRegisterDialogState extends State<CustomerRegisterDialog> {
  /// 当前选中的注册方式
  int _selectedRegisterMethod = 0; // 0: 都达网账户, 1: 手机号码

  /// 都达网账号输入控制器
  final TextEditingController _accountController = TextEditingController();

  /// 密码输入控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 确认密码输入控制器
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// 手机号输入控制器
  final TextEditingController _phoneController = TextEditingController();

  /// 验证码输入控制器
  final TextEditingController _codeController = TextEditingController();

  /// 发送验证码倒计时秒数
  int _countdown = 0;

  /// 倒计时定时器
  Timer? _timer;

  /// 焦点节点
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();

  /// 是否同意协议
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _timer?.cancel();
    _accountController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        height: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 主内容区域
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 标题
                  const Text(
                    '注册都达网账号',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 注册方式选择
                  _buildRegisterMethodSelector(),
                  const SizedBox(height: 24),

                  // 注册表单内容
                  Expanded(
                    child: _buildRegisterForm(),
                  ),
                ],
              ),
            ),

            // 右上角关闭按钮
            Positioned(
              top: 16,
              right: 16,
              child: _buildCloseButton(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建注册方式选择器
  Widget _buildRegisterMethodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMethodTab('注册都达网账户', 0),
          _buildMethodTab('手机号码注册', 1),
        ],
      ),
    );
  }

  /// 构建注册方式标签
  Widget _buildMethodTab(String label, int index) {
    final isSelected = _selectedRegisterMethod == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRegisterMethod = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFFD93025)
                  : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建注册表单
  Widget _buildRegisterForm() {
    if (_selectedRegisterMethod == 0) {
      return _buildAccountRegisterForm();
    } else {
      return _buildPhoneRegisterForm();
    }
  }

  /// 都达网账户注册表单
  Widget _buildAccountRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 账号输入框
          const Text(
            '账号',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildAccountInput(),
          const SizedBox(height: 16),

          // 密码输入框
          const Text(
            '密码',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordInput(),
          const SizedBox(height: 16),

          // 确认密码输入框
          const Text(
            '确认密码',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildConfirmPasswordInput(),
          const SizedBox(height: 24),

          // 协议同意
          _buildAgreementCheckbox(),
          const SizedBox(height: 24),

          // 注册按钮
          _buildRegisterButton(),
        ],
      ),
    );
  }

  /// 手机号码注册表单
  Widget _buildPhoneRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 手机号输入框
          const Text(
            '手机号',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildPhoneInput(),
          const SizedBox(height: 16),

          // 验证码输入框
          const Text(
            '验证码',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildVerificationCodeInput(),
          const SizedBox(height: 24),

          // 协议同意
          _buildAgreementCheckbox(),
          const SizedBox(height: 24),

          // 注册按钮
          _buildRegisterButton(),
        ],
      ),
    );
  }

  /// 账号输入框
  Widget _buildAccountInput() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _accountController,
        focusNode: _accountFocusNode,
        decoration: const InputDecoration(
          hintText: '请输入账号（4-20位字符）',
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 15,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Color(0xFFCCCCCC),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF999999),
        ),
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          _passwordFocusNode.requestFocus();
        },
      ),
    );
  }

  /// 密码输入框
  Widget _buildPasswordInput() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: '请输入密码（6-20位字符）',
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 15,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: Color(0xFFCCCCCC),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF999999),
        ),
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          _confirmPasswordFocusNode.requestFocus();
        },
      ),
    );
  }

  /// 确认密码输入框
  Widget _buildConfirmPasswordInput() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordFocusNode,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: '请再次输入密码',
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 15,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: Color(0xFFCCCCCC),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF999999),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          _handleRegister();
        },
      ),
    );
  }

  /// 手机号输入框
  Widget _buildPhoneInput() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        decoration: const InputDecoration(
          hintText: '请输入手机号',
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 15,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: Color(0xFFCCCCCC),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF999999),
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          _codeFocusNode.requestFocus();
        },
      ),
    );
  }

  /// 验证码输入框
  Widget _buildVerificationCodeInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              decoration: const InputDecoration(
                hintText: '请输入验证码',
                hintStyle: TextStyle(
                  color: Color(0xFFCCCCCC),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: Icon(
                  Icons.verified_outlined,
                  color: Color(0xFFCCCCCC),
                  size: 20,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF999999),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                _handleRegister();
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 发送验证码按钮
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _countdown > 0 ? null : _sendVerificationCode,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _countdown > 0
                    ? const Color(0xFFCCCCCC)
                    : const Color(0xFFD93025),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _countdown > 0 ? '${_countdown}s' : '发送验证码',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 发送验证码
  void _sendVerificationCode() {
    debugPrint('发送验证码');

    // 开始60秒倒计时
    setState(() {
      _countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  /// 协议同意复选框
  Widget _buildAgreementCheckbox() {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreedToTerms = !_agreedToTerms;
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _agreedToTerms ? const Color(0xFFD93025) : Colors.white,
                border: Border.all(
                  color: _agreedToTerms ? const Color(0xFFD93025) : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _agreedToTerms
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                '我已阅读并同意',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('点击用户协议');
                },
                child: const Text(
                  '《用户协议》',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFD93025),
                  ),
                ),
              ),
              const Text(
                '和',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('点击隐私政策');
                },
                child: const Text(
                  '《隐私政策》',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFD93025),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 注册按钮
  Widget _buildRegisterButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleRegister,
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFD93025),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              '注册',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 处理注册
  void _handleRegister() async {
    // 验证协议同意
    if (!_agreedToTerms) {
      _showErrorDialog('请先同意用户协议和隐私政策');
      return;
    }

    if (_selectedRegisterMethod == 0) {
      // 都达网账户注册
      final account = _accountController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (account.isEmpty) {
        _showErrorDialog('请输入账号');
        return;
      }

      if (account.length < 4 || account.length > 20) {
        _showErrorDialog('账号长度应为4-20位字符');
        return;
      }

      if (password.isEmpty) {
        _showErrorDialog('请输入密码');
        return;
      }

      if (password.length < 6 || password.length > 20) {
        _showErrorDialog('密码长度应为6-20位字符');
        return;
      }

      if (confirmPassword.isEmpty) {
        _showErrorDialog('请确认密码');
        return;
      }

      if (password != confirmPassword) {
        _showErrorDialog('两次输入的密码不一致');
        return;
      }

      // 调用后端V2 API：都达网账户 - 账号密码注册
      debugPrint('📝 开始注册（V2）：都达网账户, 账号=$account');
      final success = await authState.registerPlatformAccount(
        username: account,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (success) {
        debugPrint('✅ 注册成功：账号=$account');
        _showSuccessDialog();
      } else {
        final errorMsg = authState.errorMessage ?? '注册失败，请重试';
        debugPrint('❌ 注册失败：$errorMsg');
        _showErrorDialog(errorMsg);
      }
    } else {
      // 手机号码注册
      final phone = _phoneController.text.trim();
      final code = _codeController.text.trim();

      if (phone.isEmpty) {
        _showErrorDialog('请输入手机号');
        return;
      }

      if (code.isEmpty) {
        _showErrorDialog('请输入验证码');
        return;
      }

      // TODO: 手机验证码注册暂时未实现，需要后端提供发送验证码接口
      debugPrint('⚠️ 手机验证码注册功能待实现');
      _showErrorDialog('手机验证码注册功能待实现，请使用账号密码注册');
    }
  }

  /// 显示错误提示弹窗
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Color(0xFFD93025),
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              '提示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFD93025),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示成功提示弹窗
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF4CAF50),
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              '注册成功',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '欢迎加入都达网！',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12),
            Text(
              '请使用您的账号和密码登录。',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭成功提示
              Navigator.of(context).pop(); // 关闭注册弹窗
            },
            child: const Text(
              '去登录',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFD93025),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 关闭按钮
  Widget _buildCloseButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.close,
            size: 18,
            color: Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}

/// 显示客户注册弹窗的工具函数
void showCustomerRegisterDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => const CustomerRegisterDialog(),
  );
}
