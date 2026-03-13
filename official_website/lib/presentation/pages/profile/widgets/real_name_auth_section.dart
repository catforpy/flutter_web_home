import 'package:flutter/material.dart';

/// 实名认证区域
class RealNameAuthSection extends StatelessWidget {
  final bool isVerified;
  final String? verifiedName;
  final String? verifiedIdCard;
  final VoidCallback onAuthTap;

  const RealNameAuthSection({
    super.key,
    required this.isVerified,
    this.verifiedName,
    this.verifiedIdCard,
    required this.onAuthTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onAuthTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：图标和标题
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isVerified
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                          : const Color(0xFFD93025).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isVerified ? Icons.check_circle : Icons.error,
                      size: 24,
                      color: isVerified
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFD93025),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '实名认证',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isVerified
                              ? '✅ 已通过实名认证'
                              : '应国家相关政策要求,使用互联网服务需进行实名认证',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 操作按钮
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2196F3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isVerified ? '重新认证' : '去认证',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // 已认证状态下的详细信息
              if (isVerified) ...[
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 20),

                // 认证信息
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '真实姓名：',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          Text(
                            verifiedName ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '身份证号：',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                          Text(
                            verifiedIdCard ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 认证须知
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFD54F),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Color(0xFFF57C00),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '认证须知',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF57C00),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '1. 实名认证可以提升您在都达网的个人信息及虚拟财产安全等级，同时也能更好地体验都达网的各项虚拟服务。\n'
                        '2. 实名认证通过后，将无法修改和删除，请谨慎填写。\n'
                        '3. 实名认证通过后，系统将自动发放 10 个积分作为奖励，可在积分中心查看。\n'
                        '4. 我们将对您所提供的信息进行严格保密，不会泄露。\n'
                        '5. 实名认证由阿里云提供认证服务，您可放心使用，我们将对您所提供的信息进行严格保密，不会泄露。\n'
                        '6. 若多次认证不通过，请联系客服邮箱：user@doudawang.com\n'
                        '7. 如存在恶意乱填姓名、身份证号码，或上传与身份证无关的图片，一经发现将冻结都达网账号。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          height: 1.8,
                        ),
                      ),
                    ],
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
