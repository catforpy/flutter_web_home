import 'package:flutter/material.dart';

/// 用户个人中心组件
/// 根据登录状态显示不同内容：
/// - 未登录：购物车图标 + "登录 / 注册"
/// - 已登录："我的小程序" + 头像
class UserProfileWidget extends StatefulWidget {
  final bool isLoggedIn;
  final String? avatarUrl;
  final VoidCallback onLoginTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;

  const UserProfileWidget({
    super.key,
    required this.isLoggedIn,
    this.avatarUrl,
    required this.onLoginTap,
    required this.onCartTap,
    required this.onProfileTap,
  });

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 购物车图标（始终显示）
        // MouseRegion(
        //   cursor: SystemMouseCursors.click,
        //   child: GestureDetector(
        //     onTap: widget.onCartTap,
        //     child: Container(
        //       padding: const EdgeInsets.all(4),
        //       child: const Icon(
        //         Icons.shopping_cart_outlined,
        //         size: 20,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),

        // const SizedBox(width: 8),

        // 登录/注册文字（始终显示）
        // MouseRegion(
        //   cursor: SystemMouseCursors.click,
        //   child: GestureDetector(
        //     onTap: widget.onLoginTap,
        //     child: const Text(
        //       '登录 / 注册',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: Colors.white,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ),
        // ),

        // 已登录时显示头像
        // if (widget.isLoggedIn) ...[
        //   const SizedBox(width: 8),
        //   MouseRegion(
        //     cursor: SystemMouseCursors.click,
        //     child: GestureDetector(
        //       onTap: widget.onProfileTap,
        //       child: Container(
        //         width: 32,
        //         height: 32,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: const Color(0xFFFFE5E9), // 浅粉背景
        //           border: Border.all(
        //             color: Colors.white,
        //             width: 2,
        //           ),
        //         ),
        //         child: ClipOval(
        //           child: widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
        //               ? Image.network(
        //                   widget.avatarUrl!,
        //                   fit: BoxFit.cover,
        //                   errorBuilder: (context, error, stackTrace) {
        //                     return _buildDefaultAvatar();
        //                   },
        //                 )
        //               : _buildDefaultAvatar(),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }

  /// 默认头像（卡通化男性头像）
  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFFFE5E9),
      child: const Icon(
        Icons.person,
        size: 20,
        color: Color(0xFFFF6B81),
      ),
    );
  }
}
