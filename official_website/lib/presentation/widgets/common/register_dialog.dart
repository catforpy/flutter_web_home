import 'package:flutter/material.dart';
import 'dart:async';

/// 注册弹窗组件
class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  /// 部门选择
  int? _selectedDepartment;

  /// 个人注册方式：0: 手机验证码, 1: 微信扫码
  int _personalRegisterMethod = 0;

  /// 主管认证方式：0: 手机验证码, 1: 微信扫码
  int _supervisorAuthMethod = 0;

  /// 个人注册倒计时
  int _personalCountdown = 0;

  /// 主管认证倒计时
  int _supervisorCountdown = 0;

  /// 定时器
  Timer? _personalTimer;
  Timer? _supervisorTimer;

  /// 输入控制器
  final TextEditingController _personalPhoneController = TextEditingController();
  final TextEditingController _personalCodeController = TextEditingController();
  final TextEditingController _supervisorPhoneController = TextEditingController();
  final TextEditingController _supervisorCodeController = TextEditingController();

  @override
  void dispose() {
    _personalTimer?.cancel();
    _supervisorTimer?.cancel();
    _personalPhoneController.dispose();
    _personalCodeController.dispose();
    _supervisorPhoneController.dispose();
    _supervisorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        height: 700,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题栏
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '注册',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        _buildCloseButton(),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 部门选择
                    _buildDepartmentSection(),
                    const SizedBox(height: 24),

                    // 第一部分：个人注册
                    _buildPersonalRegisterSection(),
                    const SizedBox(height: 24),

                    // 第二部分：主管认证
                    _buildSupervisorAuthSection(),
                    const SizedBox(height: 32),

                    // 注册按钮
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建部门选择区域
  Widget _buildDepartmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '部门',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white, // 白色背景
            border: Border.all(
              color: const Color(0xFFD93025), // 红色边框，更鲜亮
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedDepartment,
              hint: const Text(
                '请选择部门',
                style: TextStyle(
                  color: Color(0xFF333333), // 深灰色提示文字
                  fontSize: 15,
                ),
              ),
              dropdownColor: Colors.white,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFD93025), // 红色图标，更鲜亮
                size: 24,
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    '客服',
                    style: TextStyle(
                      color: Color(0xFF333333), // 深灰色文字
                      fontSize: 15,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    '销售',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(
                    '财务',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text(
                    '技术',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 构建个人注册区域
  Widget _buildPersonalRegisterSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题 + 切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '个人注册',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: [
                  _buildMethodToggle(
                    label: '手机验证码',
                    isSelected: _personalRegisterMethod == 0,
                    onTap: () {
                      setState(() {
                        _personalRegisterMethod = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildMethodToggle(
                    label: '微信扫码',
                    isSelected: _personalRegisterMethod == 1,
                    onTap: () {
                      setState(() {
                        _personalRegisterMethod = 1;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 表单内容
          if (_personalRegisterMethod == 0) ...[
            _buildPhoneInput(
              controller: _personalPhoneController,
              label: '手机号',
            ),
            const SizedBox(height: 16),
            _buildCodeInput(
              controller: _personalCodeController,
              countdown: _personalCountdown,
              onSendCode: () {
                _startPersonalCountdown();
              },
            ),
          ] else ...[
            _buildWechatQRSection('请扫描二维码完成注册'),
          ],
        ],
      ),
    );
  }

  /// 构建主管认证区域
  Widget _buildSupervisorAuthSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题 + 切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '主管认证',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: [
                  _buildMethodToggle(
                    label: '手机验证码',
                    isSelected: _supervisorAuthMethod == 0,
                    onTap: () {
                      setState(() {
                        _supervisorAuthMethod = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildMethodToggle(
                    label: '微信扫码',
                    isSelected: _supervisorAuthMethod == 1,
                    onTap: () {
                      setState(() {
                        _supervisorAuthMethod = 1;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 表单内容
          if (_supervisorAuthMethod == 0) ...[
            _buildPhoneInput(
              controller: _supervisorPhoneController,
              label: '主管手机号',
            ),
            const SizedBox(height: 16),
            _buildCodeInput(
              controller: _supervisorCodeController,
              countdown: _supervisorCountdown,
              onSendCode: () {
                _startSupervisorCountdown();
              },
            ),
          ] else ...[
            _buildWechatQRSection('请主管扫描二维码完成认证'),
          ],
        ],
      ),
    );
  }

  /// 构建方式切换按钮
  Widget _buildMethodToggle({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD93025) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color(0xFFD93025),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : const Color(0xFFD93025),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建手机号输入框
  Widget _buildPhoneInput({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
            controller: controller,
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
          ),
        ),
      ],
    );
  }

  /// 构建验证码输入框
  Widget _buildCodeInput({
    required TextEditingController controller,
    required int countdown,
    required VoidCallback onSendCode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '验证码',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Row(
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
                  controller: controller,
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
                ),
              ),
            ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: countdown > 0 ? null : onSendCode,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: countdown > 0
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFFD93025),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      countdown > 0 ? '${countdown}s' : '发送验证码',
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
        ),
      ],
    );
  }

  /// 构建微信扫码区域
  Widget _buildWechatQRSection(String tip) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.qr_code_2,
              size: 80,
              color: Color(0xFF999999),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          tip,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  /// 构建注册按钮
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

  /// 关闭按钮
  Widget _buildCloseButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
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

  /// 开始个人注册倒计时
  void _startPersonalCountdown() {
    setState(() {
      _personalCountdown = 60;
    });

    _personalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_personalCountdown > 0) {
        setState(() {
          _personalCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  /// 开始主管认证倒计时
  void _startSupervisorCountdown() {
    setState(() {
      _supervisorCountdown = 60;
    });

    _supervisorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_supervisorCountdown > 0) {
        setState(() {
          _supervisorCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  /// 处理注册
  void _handleRegister() {
    // 验证部门选择
    if (_selectedDepartment == null) {
      _showErrorDialog('请选择部门');
      return;
    }

    // 验证个人注册信息
    if (_personalRegisterMethod == 0) {
      if (_personalPhoneController.text.trim().isEmpty) {
        _showErrorDialog('请输入个人手机号');
        return;
      }
      if (_personalCodeController.text.trim().isEmpty) {
        _showErrorDialog('请输入个人验证码');
        return;
      }
    }

    // 验证主管认证信息
    if (_supervisorAuthMethod == 0) {
      if (_supervisorPhoneController.text.trim().isEmpty) {
        _showErrorDialog('请输入主管手机号');
        return;
      }
      if (_supervisorCodeController.text.trim().isEmpty) {
        _showErrorDialog('请输入主管验证码');
        return;
      }
    }

    // TODO: 实现注册逻辑
    _showSuccessDialog();
  }

  /// 显示错误弹窗
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

  /// 显示成功弹窗
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
              '注册申请已提交',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: const Text(
          '等待管理员审核',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭成功提示
              Navigator.of(context).pop(); // 关闭注册弹窗
            },
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
}
