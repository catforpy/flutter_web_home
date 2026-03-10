import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'register_dialog.dart';
import 'customer_register_dialog.dart';
import 'merchant_register_dialog.dart';
import '../../../core/auth/auth_state.dart';

/// 登录弹窗组件
class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog>
    with SingleTickerProviderStateMixin {
  /// 当前选中的用户类型标签
  int _selectedUserType = 0; // 0: 客户, 1: 商户, 2: 后台管理

  /// 当前选中的登录方式
  int _selectedLoginMethod = 0; // 0: 都达网账号, 1: 手机登录, 2: 微信登录

  /// 发送验证码倒计时秒数
  int _countdown = 0;

  /// 倒计时定时器
  Timer? _timer;

  /// 后台部门选择
  int? _selectedDepartment; // 0: 客服, 1: 销售, 2: 财务, 3: 技术

  /// 都达网账号输入控制器
  final TextEditingController _accountController = TextEditingController();

  /// 密码输入控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 手机号输入控制器
  final TextEditingController _phoneController = TextEditingController();

  /// 验证码输入控制器
  final TextEditingController _codeController = TextEditingController();

  /// 焦点节点
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _loginButtonFocusNode = FocusNode();
  final FocusNode _sendCodeFocusNode = FocusNode();

  @override
  void dispose() {
    _timer?.cancel();
    _accountController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    _loginButtonFocusNode.dispose();
    _sendCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 900,
        height: 600,
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
            Row(
              children: [
                // 左侧：图片（占3/8宽度）
                SizedBox(
                  width: 337.5, // 900 * 3/8 = 337.5
                  child: _buildLeftSide(),
                ),

                // 右侧：登录表单（占5/8宽度）
                Expanded(
                  child: _buildRightSide(),
                ),
              ],
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

  /// 构建左侧图片区域
  Widget _buildLeftSide() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Image.asset(
        'login-banner.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // 图片加载失败时显示渐变背景
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFD93025),
                  const Color(0xFFB71C1C),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                '都达网络',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建右侧登录表单区域
  Widget _buildRightSide() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // 标题 + 用户类型选项卡（Row组合）
            Row(
              children: [
                const Text(
                  '欢迎登录',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 16),
                _buildUserTypeTabs(),
              ],
            ),
            const SizedBox(height: 24),

            // 登录表单内容（使用 SizedBox 限制高度）
            SizedBox(
              height: 400,
              child: Column(
                children: [
                  // 表单内容区域（可滚动）
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildLoginFormContent(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 底部固定的"其他登录方式"区域
                  _buildOtherLoginMethods(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户类型选项卡
  Widget _buildUserTypeTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabItem('都达用户账号', 0),
          _buildTabItem('服务商户', 1),
          _buildTabItem('管理', 2),
        ],
      ),
    );
  }

  /// 构建选项卡单项
  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedUserType == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUserType = index;
            _selectedLoginMethod = 0; // 切换标签时重置登录方式
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              fontSize: 13,
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

  /// 构建登录表单内容
  Widget _buildLoginForm() {
    // 都达用户账号：支持都达网账号、手机登录、微信登录
    if (_selectedUserType == 0) {
      if (_selectedLoginMethod == 0) {
        return _buildAccountLoginFormContent();
      } else if (_selectedLoginMethod == 1) {
        return _buildPhoneLoginFormContent();
      } else {
        return _buildWechatQRCodeFormContent();
      }
    }

    // 服务商户、后台管理：手机登录或微信扫码登录
    if (_selectedUserType == 1 || _selectedUserType == 2) {
      if (_selectedLoginMethod == 0) {
        return _buildPhoneLoginFormContent();
      } else {
        return _buildWechatQRCodeFormContent();
      }
    }

    // 其他情况 - 显示占位内容
    return _buildPlaceholderForm();
  }

  /// 构建表单内容区域（不含"其他登录方式"）
  Widget _buildLoginFormContent() {
    // 都达用户账号：支持都达网账号、手机登录、微信登录
    if (_selectedUserType == 0) {
      if (_selectedLoginMethod == 0) {
        return _buildAccountLoginFormContent();
      } else if (_selectedLoginMethod == 1) {
        return _buildPhoneLoginFormContent();
      } else {
        return _buildWechatQRCodeFormContent();
      }
    }

    // 服务商户：支持服务商账号、手机登录、微信登录
    if (_selectedUserType == 1) {
      if (_selectedLoginMethod == 0) {
        return _buildMerchantAccountLoginFormContent();
      } else if (_selectedLoginMethod == 1) {
        return _buildPhoneLoginFormContent();
      } else {
        return _buildWechatQRCodeFormContent();
      }
    }

    // 后台管理：手机登录或微信扫码登录
    if (_selectedUserType == 2) {
      if (_selectedLoginMethod == 0) {
        return _buildPhoneLoginFormContent();
      } else {
        return _buildWechatQRCodeFormContent();
      }
    }

    // 其他情况 - 显示占位内容
    return _buildPlaceholderForm();
  }

  /// 都达网账号登录表单内容（不含"其他登录方式"）
  Widget _buildAccountLoginFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 账号输入框
        const Text(
          '都达网账号',
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
        const SizedBox(height: 24),

        // 登录按钮
        _buildLoginButton(),
        const SizedBox(height: 16),

        // 【都达网账号登录】代表同意《用户协议》《隐私政策》
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '【都达网账号登录】代表同意',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击用户协议');
                // TODO: 跳转到用户协议页面
              },
              child: const Text(
                '《用户协议》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
            const Text(
              '、',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击隐私政策');
                // TODO: 跳转到隐私政策页面
              },
              child: const Text(
                '《隐私政策》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 服务商账号登录表单内容（不含"其他登录方式"）
  Widget _buildMerchantAccountLoginFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 账号输入框
        const Text(
          '服务商账号',
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
        const SizedBox(height: 24),

        // 登录按钮
        _buildLoginButton(),
        const SizedBox(height: 16),

        // 【服务商账号登录】代表同意《用户协议》《隐私政策》
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '【服务商账号登录】代表同意',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击用户协议');
                // TODO: 跳转到用户协议页面
              },
              child: const Text(
                '《用户协议》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
            const Text(
              '、',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击隐私政策');
                // TODO: 跳转到隐私政策页面
              },
              child: const Text(
                '《隐私政策》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
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
          hintText: '请输入都达网账号',
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
          hintText: '请输入密码',
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
          _handleLogin();
        },
      ),
    );
  }

  /// 手机验证码登录表单内容（不含"其他登录方式"）
  Widget _buildPhoneLoginFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 后台管理：部门选择
        if (_selectedUserType == 2) ...[
          const Text(
            '选择部门',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          _buildDepartmentDropdown(),
          const SizedBox(height: 16),
        ],

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

        // 登录按钮
        _buildLoginButton(),
        const SizedBox(height: 16),

        // 【手机验证码登录】代表同意《用户协议》《隐私政策》
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '【手机验证码登录】代表同意',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击用户协议');
                // TODO: 跳转到用户协议页面
              },
              child: const Text(
                '《用户协议》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
            const Text(
              '、',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击隐私政策');
                // TODO: 跳转到隐私政策页面
              },
              child: const Text(
                '《隐私政策》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建部门选择下拉框（后台管理专用）
  Widget _buildDepartmentDropdown() {
    return Container(
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
    );
  }

  /// 手机号输入框
  Widget _buildPhoneInput() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white, // 白色背景
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
            color: Color(0xFFCCCCCC), // 浅灰色提示文字
            fontSize: 15,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white, // 输入框内部白色背景
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: Color(0xFFCCCCCC),
            size: 20,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF999999), // 灰色输入文字
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next, // 显示"下一步"按钮
        onSubmitted: (_) {
          // 按回车键时，焦点移动到验证码输入框
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
              color: Colors.white, // 白色背景
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
                  color: Color(0xFFCCCCCC), // 浅灰色提示文字
                  fontSize: 15,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white, // 输入框内部白色背景
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
                color: Color(0xFF999999), // 灰色输入文字
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done, // 显示"完成"按钮
              onSubmitted: (_) {
                // 按回车键时，触发登录
                _handleLogin();
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 发送验证码按钮
        Focus(
          focusNode: _sendCodeFocusNode,
          onKeyEvent: (node, event) {
            // 监听发送验证码按钮的键盘事件
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                if (_countdown == 0) {
                  _sendVerificationCode();
                }
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _countdown > 0 ? null : _sendVerificationCode,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: _countdown > 0
                      ? const Color(0xFFCCCCCC) // 倒计时中：灰色
                      : const Color(0xFFD93025), // 正常：红色
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
        ),
      ],
    );
  }

  /// 发送验证码
  void _sendVerificationCode() {
    debugPrint('发送验证码');
    // TODO: 实现发送验证码的逻辑

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
              '登录成功',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        content: const Text(
          '欢迎回来！',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 关闭成功提示
              Navigator.of(context).pop(); // 关闭登录弹窗
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

  /// 显示未注册提示弹窗（后台专用）
  void _showNotRegisteredDialog() {
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
              Icons.info_outline,
              color: Color(0xFFFF9800),
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
        content: const Text(
          '该账号未在后台数据库中注册，请完成注册后再登录',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '我知道了',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 登录按钮
  Widget _buildLoginButton() {
    return Focus(
      focusNode: _loginButtonFocusNode,
      onKeyEvent: (node, event) {
        // 监听登录按钮的键盘事件
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            _handleLogin();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleLogin,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD93025),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '登录',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 处理登录
  void _handleLogin() {
    // 都达网账号登录
    if (_selectedUserType == 0 && _selectedLoginMethod == 0) {
      final account = _accountController.text.trim();
      final password = _passwordController.text.trim();

      if (account.isEmpty) {
        _showErrorDialog('请输入都达网账号');
        return;
      }

      if (password.isEmpty) {
        _showErrorDialog('请输入密码');
        return;
      }

      // TODO: 实际项目中需要调用API验证账号密码
      // 这里暂时直接登录成功
      debugPrint('登录成功：用户类型=都达用户账号, 账号=$account');
      authState.login(userType: UserType.customer);
      _showSuccessDialog();
      return;
    }

    // 服务商账号登录
    if (_selectedUserType == 1 && _selectedLoginMethod == 0) {
      final account = _accountController.text.trim();
      final password = _passwordController.text.trim();

      if (account.isEmpty) {
        _showErrorDialog('请输入服务商账号');
        return;
      }

      if (password.isEmpty) {
        _showErrorDialog('请输入密码');
        return;
      }

      // TODO: 实际项目中需要调用API验证账号密码
      // 这里暂时直接登录成功
      debugPrint('登录成功：用户类型=服务商户, 账号=$account');
      authState.login(userType: UserType.merchant);
      _showSuccessDialog();
      return;
    }

    // 手机登录
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();

    // 验证输入
    if (phone.isEmpty) {
      _showErrorDialog('请输入手机号');
      return;
    }

    if (code.isEmpty) {
      _showErrorDialog('请输入验证码');
      return;
    }

    // 后台管理需要选择部门
    if (_selectedUserType == 2 && _selectedDepartment == null) {
      _showErrorDialog('请选择部门');
      return;
    }

    // 验证码必须是 111111
    if (code != '111111') {
      _showErrorDialog('验证码错误');
      return;
    }

    // 客户和商户：只要输入了手机号和验证码就登录成功
    if (_selectedUserType == 0 || _selectedUserType == 1) {
      debugPrint('登录成功：用户类型=$_selectedUserType, 手机号=$phone');

      // 更新登录状态
      final userType = _selectedUserType == 0 ? UserType.customer : UserType.merchant;
      authState.login(userType: userType);

      _showSuccessDialog();
      return;
    }

    // 后台管理：验证手机号是否是主管手机 15251513885
    if (_selectedUserType == 2) {
      if (phone == '15251513885') {
        // 主管认证的手机号，登录成功
        debugPrint('登录成功：后台, 手机号=$phone, 部门=$_selectedDepartment');

        // 更新登录状态
        authState.login(userType: UserType.backend);

        _showSuccessDialog();
      } else {
        // 不是主管手机号，需要注册
        _showNotRegisteredDialog();
      }
    }
  }

  /// 其他登录方式（固定在底部，根据用户类型显示不同选项）
  Widget _buildOtherLoginMethods() {
    return Column(
      children: [
        // 分割线
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '其他登录方式',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 图标按钮 + 注册按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildLoginMethodButtons(),
        ),
      ],
    );
  }

  /// 构建登录方式按钮列表
  List<Widget> _buildLoginMethodButtons() {
    // 都达用户账号：显示都达网账号、手机登录、微信登录、注册按钮
    if (_selectedUserType == 0) {
      return [
        _buildLoginMethodIcon(
          icon: Icons.person_outline,
          label: '都达网账号',
          isSelected: _selectedLoginMethod == 0,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 0;
            });
          },
        ),
        const SizedBox(width: 32),
        _buildLoginMethodIcon(
          icon: Icons.phone_outlined,
          label: '手机登录',
          isSelected: _selectedLoginMethod == 1,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 1;
            });
          },
        ),
        const SizedBox(width: 32),
        _buildLoginMethodIcon(
          icon: Icons.wechat,
          label: '微信登录',
          isSelected: _selectedLoginMethod == 2,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 2;
            });
          },
        ),
        const SizedBox(width: 32),
        // 注册按钮
        _buildRegisterButton(),
      ];
    }

    // 服务商户：显示服务商账号、手机登录、微信登录、注册按钮
    if (_selectedUserType == 1) {
      return [
        _buildLoginMethodIcon(
          icon: Icons.business_center,
          label: '服务商账号',
          isSelected: _selectedLoginMethod == 0,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 0;
            });
          },
        ),
        const SizedBox(width: 32),
        _buildLoginMethodIcon(
          icon: Icons.phone_outlined,
          label: '手机登录',
          isSelected: _selectedLoginMethod == 1,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 1;
            });
          },
        ),
        const SizedBox(width: 32),
        _buildLoginMethodIcon(
          icon: Icons.wechat,
          label: '微信登录',
          isSelected: _selectedLoginMethod == 2,
          onTap: () {
            setState(() {
              _selectedLoginMethod = 2;
            });
          },
        ),
        const SizedBox(width: 32),
        // 注册按钮
        _buildRegisterButton(),
      ];
    }

    // 后台管理：显示手机登录、微信登录
    List<Widget> buttons = [
      _buildLoginMethodIcon(
        icon: Icons.phone_outlined,
        label: '手机登录',
        isSelected: _selectedLoginMethod == 0,
        onTap: () {
          setState(() {
            _selectedLoginMethod = 0;
          });
        },
      ),
      const SizedBox(width: 32),
      _buildLoginMethodIcon(
        icon: Icons.wechat,
        label: '微信登录',
        isSelected: _selectedLoginMethod == 1,
        onTap: () {
          setState(() {
            _selectedLoginMethod = 1;
          });
        },
      ),
    ];

    // 后台管理：显示注册按钮
    if (_selectedUserType == 2) {
      buttons.add(const SizedBox(width: 32));
      buttons.add(_buildRegisterButton());
    }

    return buttons;
  }

  /// 构建注册按钮
  Widget _buildRegisterButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击注册');
          _showRegisterDialog();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFD93025),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '注册',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD93025),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 显示注册弹窗
  void _showRegisterDialog() {
    // 都达用户账号：显示客户注册弹窗
    if (_selectedUserType == 0) {
      showCustomerRegisterDialog(context);
    } else if (_selectedUserType == 1) {
      // 服务商户：显示服务商注册弹窗
      showMerchantRegisterDialog(context);
    } else if (_selectedUserType == 2) {
      // 后台管理：显示后台注册弹窗
      showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (context) => const RegisterDialog(),
      );
    }
  }

  /// 登录方式图标按钮
  Widget _buildLoginMethodIcon({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF5F5F5)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD93025)
                      : const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFFD93025)
                    : const Color(0xFF999999),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected
                    ? const Color(0xFFD93025)
                    : const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 微信扫码登录表单内容（不含"其他登录方式"）
  Widget _buildWechatQRCodeFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),

        // 标题
        const Text(
          '微信一键登录',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 6),

        // 副标题
        const Text(
          '关注后自动登录',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 24),

        // 后台登录：部门选择（仅后台显示）
        if (_selectedUserType == 2) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 300,
              child: _buildDepartmentDropdown(),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // 二维码占位
        Container(
          width: 160,
          height: 160,
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

        // 【扫码登录】代表同意...
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '【扫码登录】代表同意',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击用户协议');
                // TODO: 跳转到用户协议页面
              },
              child: const Text(
                '《用户协议》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
            const Text(
              '、',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
                height: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('点击隐私政策');
                // TODO: 跳转到隐私政策页面
              },
              child: const Text(
                '《隐私政策》',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD93025),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 商户和后台管理的占位表单
  Widget _buildPlaceholderForm() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_outlined,
            size: 64,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            '该登录方式正在开发中',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '敬请期待',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFCCCCCC),
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

/// 显示登录弹窗的工具函数
void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => LoginDialog(),
  );
}
