import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'merchant_models.dart';

/// 移动端风格的进件进度看板（PC Web端）
/// 显示进件进度、状态、二维码等
class MobileStyleProgressPage extends StatefulWidget {
  const MobileStyleProgressPage({super.key});

  @override
  State<MobileStyleProgressPage> createState() => _MobileStyleProgressPageState();
}

class _MobileStyleProgressPageState extends State<MobileStyleProgressPage> {
  // 模拟当前状态（实际应该从API获取）
  final MerchantStatus _currentStatus = MerchantStatus.pendingVerification;

  // 二维码倒计时
  int _qrCodeCountdown = 300; // 5分钟

  @override
  void initState() {
    super.initState();
    // 模拟倒计时
    _startCountdown();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_qrCodeCountdown > 0) {
          _qrCodeCountdown--;
        }
      });
      return _qrCodeCountdown > 0;
    });
  }

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

              // 主内容区（可滚动）
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // 状态卡片
                      _buildStatusCard(),

                      const SizedBox(height: 24),

                      // 核心操作区
                      _buildActionZone(),

                      const SizedBox(height: 24),

                      // 进度时间轴
                      _buildTimeline(),

                      const SizedBox(height: 24),

                      // 底部功能栏
                      _buildFooter(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
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
          const Text(
            '进件进度',
            style: TextStyle(
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

  /// 构建状态卡片（动态颜色）
  Widget _buildStatusCard() {
    Color bgColor;
    Color iconColor;
    IconData icon;
    String title;
    String subtitle;

    switch (_currentStatus) {
      case MerchantStatus.pendingVerification:
        bgColor = const Color(0xFFE6F7FF); // 淡蓝色
        iconColor = const Color(0xFF1890FF);
        icon = Icons.qr_code_scanner;
        title = '待超级管理员扫码';
        subtitle = '请使用法人微信扫码完成身份验证，预计 5 分钟内有效';
        break;
      case MerchantStatus.pendingContract:
        bgColor = const Color(0xFFE6F7FF); // 淡蓝色
        iconColor = const Color(0xFF1890FF);
        icon = Icons.description;
        title = '待超级管理员签约';
        subtitle = '请使用法人微信扫码完成协议签约，预计 5 分钟内有效';
        break;
      case MerchantStatus.reviewing:
        bgColor = const Color(0xFFFFFBE6); // 淡黄色
        iconColor = const Color(0xFFFFA940);
        icon = Icons.hourglass_empty;
        title = '审核中';
        subtitle = '微信支付正在审核您的资料，预计 1-3 个工作日完成';
        break;
      case MerchantStatus.completed:
        bgColor = const Color(0xFFF6FFED); // 淡绿色
        iconColor = const Color(0xFF52C41A);
        icon = Icons.check_circle;
        title = '入驻成功';
        subtitle = '恭喜！您的特约商户进件已成功完成';
        break;
      case MerchantStatus.rejected:
        bgColor = const Color(0xFFFFF1F0); // 淡红色
        iconColor = const Color(0xFFFF4D4F);
        icon = Icons.error;
        title = '审核驳回';
        subtitle = '您的资料未通过审核，请查看详情并修改';
        break;
      default:
        bgColor = const Color(0xFFF7F8FA);
        iconColor = const Color(0xFF999999);
        icon = Icons.help;
        title = '未知状态';
        subtitle = '';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '更新于：刚刚',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建核心操作区（动态渲染）
  Widget _buildActionZone() {
    if (_currentStatus == MerchantStatus.pendingVerification ||
        _currentStatus == MerchantStatus.pendingContract) {
      return _buildQrCodeSection();
    } else if (_currentStatus == MerchantStatus.reviewing) {
      return _buildReviewingSection();
    } else if (_currentStatus == MerchantStatus.completed) {
      return _buildCompletedSection();
    } else if (_currentStatus == MerchantStatus.rejected) {
      return _buildRejectedSection();
    }
    return const SizedBox.shrink();
  }

  /// 二维码区域（待扫码/待签约）
  Widget _buildQrCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          // 二维码
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: QrImageView(
              data: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=mock_${DateTime.now().millisecondsSinceEpoch}',
              version: QrVersions.auto,
              size: 180.0,
            ),
          ),
          const SizedBox(height: 16),

          // 提示文字
          const Text(
            '微信扫一扫，立即验证',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),

          // 倒计时条
          Column(
            children: [
              LinearProgressIndicator(
                value: _qrCodeCountdown / 300,
                backgroundColor: const Color(0xFFF0F0F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF07C160)),
              ),
              const SizedBox(height: 8),
              Text(
                '二维码剩余有效时间 ${_formatCountdown(_qrCodeCountdown)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 刷新按钮（如果过期）
          if (_qrCodeCountdown == 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _qrCodeCountdown = 300;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF07C160),
                foregroundColor: Colors.white,
              ),
              child: const Text('刷新二维码'),
            ),

          const SizedBox(height: 16),

          // 辅助链接
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已发送短信提醒法人（模拟）')),
                );
              },
              child: const Text(
                '无法扫码？发送短信提醒法人',
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
    );
  }

  /// 审核中区
  Widget _buildReviewingSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          // 插画（使用Icon代替）
          const Icon(
            Icons.file_upload,
            size: 64,
            color: Color(0xFFFFA940),
          ),
          const SizedBox(height: 24),

          const Text(
            '微信支付正在审核您的资料',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '预计 1-3 个工作日完成',
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '审核结果将通过短信通知，\n您也可以随时回来查看。',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// 已完成区
  Widget _buildCompletedSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF52C41A)),
      ),
      child: Column(
        children: [
          _buildInfoRow('商户号', '1900xxxxxx'),
          const SizedBox(height: 12),
          _buildInfoRow('费率', '0.38%'),
          const SizedBox(height: 12),
          _buildInfoRow('AppID', 'wx...'),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('即将跳转商户后台...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF07C160),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('进入商户后台'),
          ),
        ],
      ),
    );
  }

  /// 驳回区
  Widget _buildRejectedSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF4D4F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error, color: Color(0xFFFF4D4F)),
              SizedBox(width: 8),
              Text(
                '驳回原因',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF4D4F),
                ),
            ),
          ],
          ),
          const SizedBox(height: 16),
          const Text(
            '• 营业执照照片反光，请重新拍摄\n• 法人身份证号码与执照不一致',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.8),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF07C160),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('修改资料并重新提交'),
          ),
        ],
      ),
    );
  }

  /// 构建进度时间轴
  Widget _buildTimeline() {
    final steps = [
      {'label': '资料提交', 'status': 'completed', 'time': '2024-03-08 10:30'},
      {'label': '微信审核', 'status': 'completed', 'time': '2024-03-08 14:20'},
      {'label': '账户验证（扫码）', 'status': 'current', 'time': ''},
      {'label': '协议签约（扫码）', 'status': 'pending', 'time': ''},
      {'label': '入驻成功', 'status': 'pending', 'time': ''},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '进度时间轴',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图标
                  _buildTimelineIcon(step['status'] as String),
                  const SizedBox(width: 12),

                  // 内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['label'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: step['status'] == 'current'
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: step['status'] == 'completed'
                                ? const Color(0xFF52C41A)
                                : step['status'] == 'current'
                                    ? const Color(0xFF1890FF)
                                    : const Color(0xFF999999),
                          ),
                        ),
                        if (step['time'] != null && step['time'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              step['time'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // 连接线
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 2,
                    height: 32,
                    color: step['status'] == 'completed'
                        ? const Color(0xFF52C41A)
                        : const Color(0xFFE5E5E5),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  /// 构建时间轴图标
  Widget _buildTimelineIcon(String status) {
    switch (status) {
      case 'completed':
        return Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFF52C41A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 10, color: Colors.white),
        );
      case 'current':
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF1890FF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1890FF).withValues(alpha: 0.3),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      case 'pending':
        return Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Color(0xFFE5E5E5),
            shape: BoxShape.circle,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// 构建底部功能栏
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('正在联系客服...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF07C160),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('联系客服'),
          ),
          const SizedBox(height: 8),
          const Text(
            '遇到问题？请拨打服务商客服电话 400-XXXX-XXXX',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.copy,
              size: 14,
              color: Color(0xFF1890FF),
            ),
          ],
        ),
      ],
    );
  }

  /// 格式化倒计时
  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
