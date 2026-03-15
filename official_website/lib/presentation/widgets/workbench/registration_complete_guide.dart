import 'package:flutter/material.dart';

/// 注册完成引导页
/// 提示用户进行认证，包含认证权益说明
class RegistrationCompleteGuide extends StatelessWidget {
  /// 小程序APPID
  final String appId;

  /// 开始认证回调
  final VoidCallback onStartVerification;

  /// 稍后认证回调
  final VoidCallback onSkip;

  /// 查看文档回调
  final VoidCallback onViewDocs;

  const RegistrationCompleteGuide({
    super.key,
    required this.appId,
    required this.onStartVerification,
    required this.onSkip,
    required this.onViewDocs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          _buildHeader(context),

          // 内容区
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // 成功图标
                _buildSuccessIcon(),

                const SizedBox(height: 24),

                // 成功标题
                const Text(
                  '🎉 恭喜！小程序创建成功！',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // APPID信息卡片
                _buildAppIdCard(),

                const SizedBox(height: 24),

                // 重要提示
                _buildWarningBox(),

                const SizedBox(height: 24),

                // 认证权益说明
                _buildBenefitsSection(),

                const SizedBox(height: 32),

                // 操作按钮
                _buildActionButtons(context),

                const SizedBox(height: 12),

                // 查看文档链接
                TextButton(
                  onPressed: onViewDocs,
                  child: const Text('查看认证文档 >'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 构建成功图标
  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF52C41A),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  /// 构建APPID信息卡片
  Widget _buildAppIdCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          _buildInfoRow('APPID：', appId),
          const SizedBox(height: 12),
          _buildInfoRow('认证状态：', '未认证', showWarning: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool showWarning = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: showWarning ? FontWeight.bold : FontWeight.normal,
            color: showWarning ? const Color(0xFFFFA940) : const Color(0xFF333333),
          ),
        ),
        if (!showWarning) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // TODO: 复制到剪贴板
            },
            child: const Icon(
              Icons.content_copy,
              size: 16,
              color: Color(0xFF1890FF),
            ),
          ),
        ],
      ],
    );
  }

  /// 构建警告提示框
  Widget _buildWarningBox() {
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
                  Icons.warning,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '重要提示',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA940),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '企业类小程序必须完成微信认证后才能发布上架。',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建认证权益说明
  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💡 认证后可获得：',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        ..._buildBenefitItems(),
      ],
    );
  }

  List<Widget> _buildBenefitItems() {
    final benefits = [
      {'icon': Icons.publish, 'title': '发布上架权限', 'desc': '认证后可提交代码审核发布'},
      {'icon': Icons.search, 'title': '被搜索能力', 'desc': '用户可在微信中搜索到小程序'},
      {'icon': Icons.share, 'title': '微信分享能力', 'desc': '可分享到聊天和朋友圈'},
      {'icon': Icons.payment, 'title': '微信支付能力', 'desc': '接入微信支付功能'},
    ];

    return benefits.map((b) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A9B8E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                b['icon'] as IconData,
                color: const Color(0xFF1A9B8E),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    b['desc'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            '稍后再说',
            const Color(0xFF999999),
            icon: Icons.schedule,
            onPressed: onSkip,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildActionButton(
            '开始认证（300元）',
            const Color(0xFF1A9B8E),
            icon: Icons.verified,
            isRecommended: true,
            onPressed: onStartVerification,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    Color color, {
    IconData? icon,
    bool isRecommended = false,
    VoidCallback? onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (isRecommended) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '推荐',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A9B8E),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
