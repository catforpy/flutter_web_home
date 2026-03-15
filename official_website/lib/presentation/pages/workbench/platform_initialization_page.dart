import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/mini_program_registration.dart';
import '../../../domain/models/mini_program_verification.dart';
import '../../routes/app_router.dart';
import '../../widgets/workbench/register_mini_program_dialog.dart';
import '../../widgets/workbench/registration_complete_guide.dart';
import '../../widgets/workbench/verify_mini_program_dialog.dart';

/// 平台接入中心页面
/// 展示已绑定的小程序平台列表（微信、抖音、百度等）
/// 点击"管理小程序"后进入对应平台的管理后台
class PlatformInitializationPage extends StatefulWidget {
  const PlatformInitializationPage({super.key});

  @override
  State<PlatformInitializationPage> createState() => _PlatformInitializationPageState();
}

class _PlatformInitializationPageState extends State<PlatformInitializationPage> {
  // 弹窗显示状态
  bool _showRegisterDialog = false;
  bool _showCompleteGuide = false;
  bool _showVerifyDialog = false;

  // 注册和认证数据
  MiniProgramRegistration? _registration;
  String? _registeredAppId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: Stack(
        children: [
          Column(
            children: [
              // 顶部简单标题栏
              _buildSimpleHeader(),

              // 主内容区
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // 微信小程序卡片
                          _buildWechatMiniProgramCard(),
                          const SizedBox(height: 16),

                          // 字节跳动小程序卡片
                          _buildByteDanceMiniProgramCard(),
                          const SizedBox(height: 16),

                          // 百度智能小程序卡片
                          _buildBaiduMiniProgramCard(),
                          const SizedBox(height: 16),

                          // 支付宝小程序卡片（预留）
                          _buildAlipayMiniProgramCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 注册小程序弹窗
          if (_showRegisterDialog)
            RegisterMiniProgramDialog(
              onRegistrationComplete: _handleRegistrationComplete,
              onClose: () => setState(() => _showRegisterDialog = false),
            ),

          // 注册完成引导页
          if (_showCompleteGuide && _registeredAppId != null)
            RegistrationCompleteGuide(
              appId: _registeredAppId!,
              onStartVerification: () => _startVerification(),
              onSkip: () => _handleSkipVerification(),
              onViewDocs: () => _viewVerificationDocs(),
            ),

          // 认证小程序弹窗
          if (_showVerifyDialog && _registeredAppId != null)
            VerifyMiniProgramDialog(
              appId: _registeredAppId!,
              initialMiniProgramName: _registration?.miniProgramName ?? '',
              onVerificationComplete: _handleVerificationComplete,
              onClose: () => setState(() => _showVerifyDialog = false),
            ),
        ],
      ),
    );
  }

  /// ==================== 注册和认证流程处理 ====================

  /// 处理注册完成
  void _handleRegistrationComplete(MiniProgramRegistration registration) {
    setState(() {
      _registration = registration;
      _registeredAppId = registration.appId ?? 'wx${DateTime.now().millisecondsSinceEpoch}';
      _showRegisterDialog = false;
      _showCompleteGuide = true;
    });
  }

  /// 开始认证
  void _startVerification() {
    setState(() {
      _showCompleteGuide = false;
      _showVerifyDialog = true;
    });
  }

  /// 跳过认证
  void _handleSkipVerification() {
    setState(() {
      _showCompleteGuide = false;
    });

    // 显示提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('您可以稍后在"开发设置"中进行认证'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '知道了',
          textColor: const Color(0xFF1A9B8E),
          onPressed: () {
            // Do nothing
          },
        ),
      ),
    );
  }

  /// 查看认证文档
  void _viewVerificationDocs() {
    // TODO: 打开认证文档页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('认证文档功能待实现')),
    );
  }

  /// 处理认证完成
  void _handleVerificationComplete(MiniProgramVerification verification) {
    setState(() {
      _showVerifyDialog = false;
    });

    // 显示成功消息
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF52C41A)),
            SizedBox(width: 12),
            Text('认证申请已提交'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('您的认证申请已成功提交！'),
            const SizedBox(height: 16),
            Text('订单号：${verification.orderId ?? "生成中..."}'),
            const SizedBox(height: 8),
            const Text('预计审核时间：1-3个工作日'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '法人将收到微信模板消息，请在24小时内完成授权',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 跳转到管理后台
              AppRouter.goToMerchantDashboard(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A9B8E),
            ),
            child: const Text('前往管理后台'),
          ),
        ],
      ),
    );
  }

  /// 构建顶部简单标题栏
  Widget _buildSimpleHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 左侧：系统名称 + 注册小程序按钮
          Row(
            children: [
              // 系统名称 - 可点击跳转到首页
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // 点击标题跳转到首页
                    context.go(AppRouter.home);
                  },
                  child: const Text(
                    '唐极课得 | 管理系统',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // 注册小程序按钮（醒目）
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showRegisterDialog = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.app_registration,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '注册小程序',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // 右侧：用户头像/菜单
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // 点击头像进入个人中心页面
                context.go(AppRouter.profile);
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A9B8E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建微信小程序卡片
  Widget _buildWechatMiniProgramCard() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 平台标识 + 名称
            Row(
              children: [
                // 微信小程序 Logo（绿色气泡）
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF07C160),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '微信小程序',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 分割线
            Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
            const SizedBox(height: 16),

            // 详细内容行
            Row(
              children: [
                // 左侧：小程序头像 + 文本信息
                Expanded(
                  child: Row(
                    children: [
                      // 小程序头像（圆形卡通大象）
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A9B8E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 文本信息组
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 第一行：名称 + 标签
                            Row(
                              children: [
                                const Text(
                                  'JJDXCX',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7FF),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: const Text(
                                    '知识付费',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1890FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // 第二行：小程序主体
                            const Row(
                              children: [
                                Text(
                                  '小程序主体',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '个人',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // 第三行：小程序简介
                            const Text(
                              'junjundexiaochengxu',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // 右侧：操作按钮区
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 主按钮：管理小程序
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('点击管理小程序（微信）');
                          // 使用 go_router 跳转到唐极课得管理后台
                          AppRouter.goToMerchantDashboard(context);
                        },
                        child: Container(
                          width: 100,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1890FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              '管理小程序',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 次链接：重新授权
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('点击重新授权（微信）');
                        },
                        child: const Text(
                          '重新授权',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1890FF),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建字节跳动小程序卡片
  Widget _buildByteDanceMiniProgramCard() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 平台标识 + 名称
            Row(
              children: [
                // 字节跳动 Logo（黑色音符）
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF000000),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '字节跳动小程序',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 分割线
            Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
            const SizedBox(height: 16),

            // 详细内容行
            Row(
              children: [
                // 左侧：小程序头像 + 文本信息
                Expanded(
                  child: Row(
                    children: [
                      // 小程序头像（方形圆角棋子）
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.grid_view,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 文本信息组
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 第一行：名称 + 标签
                            Row(
                              children: [
                                const Text(
                                  '知识付费',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7FF),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: const Text(
                                    '知识付费',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1890FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // 第二行：小程序简介
                            const Text(
                              '抖音知识付费小程序',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // 右侧：操作按钮区
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 主按钮：管理小程序
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('点击管理小程序（字节跳动）');
                        },
                        child: Container(
                          width: 100,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1890FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              '管理小程序',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 次链接：重新授权
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('点击重新授权（字节跳动）');
                        },
                        child: const Text(
                          '重新授权',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1890FF),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建百度智能小程序卡片
  Widget _buildBaiduMiniProgramCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 平台标识 + 名称
          Row(
            children: [
              // 百度 Logo（蓝色熊掌）
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF2932E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '百度小程序',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 分割线
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
          const SizedBox(height: 16),

          // 详细内容行
          Row(
            children: [
              // 左侧：平台 Logo + 文本信息
              Expanded(
                child: Row(
                  children: [
                    // 百度智能小程序官方 Logo（红蓝几何图形）
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2932E1), Color(0xFFFA541C)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.apps,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 文本信息组
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题
                          Text(
                            '百度智能小程序',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 8),

                          // 简介描述
                          Text(
                            '百度智能小程序，智能连接人与信息、人与服务、人与万物的开放生态...无需下载安装便可享受智慧超前的使用体验。',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.6,
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // 右侧：操作区
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 联系服务商链接
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('点击联系服务商（百度）');
                        // TODO: 显示联系方式弹窗
                      },
                      child: const Text(
                        '请联系服务商开通',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1890FF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建支付宝小程序卡片（预留/占位）
  Widget _buildAlipayMiniProgramCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 平台标识 + 名称
          Row(
            children: [
              // 支付宝 Logo（蓝色）
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF1677FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '支付宝小程序',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 分割线
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
          const SizedBox(height: 16),

          // 详细内容行
          Row(
            children: [
              // 左侧：平台 Logo + 文本信息
              Expanded(
                child: Row(
                  children: [
                    // 支付宝小程序 Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1677FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.payment,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 文本信息组
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题
                          Text(
                            '支付宝小程序',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 8),

                          // 简介描述
                          Text(
                            '敬请期待',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // 右侧：操作区
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 联系服务商链接
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('点击联系服务商（支付宝）');
                      },
                      child: const Text(
                        '请联系服务商开通',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1890FF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建注册小程序弹窗（已废弃，使用RegisterMiniProgramDialog组件）
  Widget _buildRegisterDialog() {
    // 这个方法已被RegisterMiniProgramDialog组件替代
    return const SizedBox.shrink();
  }
}
