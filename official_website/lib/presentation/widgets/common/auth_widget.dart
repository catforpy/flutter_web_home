import 'package:flutter/material.dart';
import 'login_dialog.dart';
import '../../../core/auth/auth_state.dart';
import '../../routes/app_router.dart';

/// 认证组件
/// 根据登录状态展示不同形态：
/// - 未登录：显示"登录 / 注册"按钮
/// - 已登录：显示头像、购物车，悬停头像显示下拉菜单
class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _isHovered = false;
  bool _isAvatarHovered = false;
  final GlobalKey _avatarKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isDropdownHovered = false;

  @override
  void initState() {
    super.initState();
    // 监听登录状态变化
    authState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    authState.removeListener(_onAuthStateChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onAuthStateChanged() {
    setState(() {}); // 登录状态变化时刷新UI
  }

  /// 显示下拉菜单
  void _showDropdownMenu() {
    if (_overlayEntry != null) return;

    debugPrint('准备显示下拉菜单');

    // 获取头像的位置信息
    final RenderBox? renderBox =
        _avatarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint('无法获取 RenderBox');
      return;
    }

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    debugPrint('头像位置: offset=$offset, size=$size');

    // 创建 Overlay
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 10,
        right: MediaQuery.of(context).size.width - offset.dx - size.width, // 使用 right 定位
        child: MouseRegion(
          onEnter: (_) {
            debugPrint('鼠标进入菜单区域');
            setState(() {
              _isAvatarHovered = true;
              _isDropdownHovered = true;
            });
          },
          onExit: (_) {
            debugPrint('鼠标离开菜单区域');
            setState(() {
              _isAvatarHovered = false;
              _isDropdownHovered = false;
            });
            Future.delayed(const Duration(milliseconds: 200), () {
              _removeOverlay();
            });
          },
          child: Material(
            elevation: 16,
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildDropdownMenuContent(),
            ),
          ),
        ),
      ),
    );

    debugPrint('创建 OverlayEntry 成功');

    // 使用 Navigator 的 Overlay
    try {
      final overlay = Navigator.of(context).overlay;
      if (overlay != null) {
        overlay.insert(_overlayEntry!);
        debugPrint('Overlay 插入成功');
      } else {
        debugPrint('Overlay 为 null');
      }
    } catch (e) {
      debugPrint('Overlay 插入失败: $e');
      // 备用方案：使用 Overlay.of
      try {
        Overlay.of(context).insert(_overlayEntry!);
        debugPrint('使用 Overlay.of 插入成功');
      } catch (e2) {
        debugPrint('Overlay.of 也失败: $e2');
      }
    }
  }

  /// 移除下拉菜单
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // 未登录状态：显示"登录 / 注册"按钮
    if (!authState.isLoggedIn) {
      return _buildLoginButton();
    }

    // 已登录状态：显示头像
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        debugPrint('鼠标进入头像区域');
        setState(() => _isAvatarHovered = true);
        _showDropdownMenu();
      },
      onExit: (_) {
        debugPrint('鼠标离开头像区域');
        setState(() => _isAvatarHovered = false);
        if (!_isDropdownHovered) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (!_isDropdownHovered) {
              _removeOverlay();
            }
          });
        }
      },
      child: GestureDetector(
        key: _avatarKey,
        onTap: () {
          // 点击头像跳转到个人中心
          AppRouter.goToProfile(context);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: authState.avatarUrl != null && authState.avatarUrl!.isNotEmpty
                ? Image.network(
                    authState.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
      ),
    );
  }

  /// 构建下拉菜单内容
  Widget _buildDropdownMenuContent() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部用户信息区
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // 默认头像
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF5F5F5),
                  ),
                  child: ClipOval(
                    child: authState.avatarUrl != null && authState.avatarUrl!.isNotEmpty
                        ? Image.network(
                            authState.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 24,
                                color: Color(0xFF999999),
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            size: 24,
                            color: Color(0xFF999999),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.nickname,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authState.getUserTypeName(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFE0E0E0)),
          // 功能菜单（2x2 网格布局）
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左列
                Expanded(
                  child: Column(
                    children: _buildLeftColumnItems(),
                  ),
                ),
                const SizedBox(width: 8),
                // 右列
                Expanded(
                  child: Column(
                    children: _buildRightColumnItems(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 底部安全退出按钮（小文字，左下角）
          _buildLogoutButton(),
        ],
      ),
    );
  }

  /// 构建左列菜单项（订单中心、我的设置）
  List<Widget> _buildLeftColumnItems() {
    switch (authState.userType) {
      case UserType.customer:
        return [
          _buildMenuCard(
            icon: Icons.shopping_bag_outlined,
            label: '订单中心',
            onTap: () {
              debugPrint('点击订单中心');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.settings_outlined,
            label: '我的设置',
            onTap: () {
              debugPrint('点击我的设置');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case UserType.merchant:
        return [
          _buildMenuCard(
            icon: Icons.phone_android,
            label: '我的小程序',
            onTap: () {
              debugPrint('点击我的小程序');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.settings_outlined,
            label: '我的设置',
            onTap: () {
              debugPrint('点击我的设置');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case UserType.backend:
        return [
          _buildMenuCard(
            icon: Icons.assignment_outlined,
            label: '我的任务',
            onTap: () {
              debugPrint('点击我的任务');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.settings_outlined,
            label: '我的设置',
            onTap: () {
              debugPrint('点击我的设置');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case null:
        return [];
    }
  }

  /// 构建右列菜单项（我的收藏、我的关注）
  List<Widget> _buildRightColumnItems() {
    switch (authState.userType) {
      case UserType.customer:
        return [
          _buildMenuCard(
            icon: Icons.favorite_border,
            label: '我的收藏',
            onTap: () {
              debugPrint('点击我的收藏');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.star_border,
            label: '我的关注',
            onTap: () {
              debugPrint('点击我的关注');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case UserType.merchant:
        return [
          _buildMenuCard(
            icon: Icons.cottage_outlined,
            label: '我的租赁',
            onTap: () {
              debugPrint('点击我的租赁');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.handshake_outlined,
            label: '我的合作',
            onTap: () {
              debugPrint('点击我的合作');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case UserType.backend:
        return [
          _buildMenuCard(
            icon: Icons.bar_chart,
            label: '我的排名',
            onTap: () {
              debugPrint('点击我的排名');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
          const SizedBox(height: 8),
          _buildMenuCard(
            icon: Icons.mail_outline,
            label: '站内信',
            onTap: () {
              debugPrint('点击站内信');
              _removeOverlay();
              AppRouter.goToProfile(context);
            },
          ),
        ];

      case null:
        return [];
    }
  }

  /// 安全退出按钮（小文字，左下角）
  Widget _buildLogoutButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          debugPrint('点击安全退出');
          setState(() {
            _isAvatarHovered = false;
            _isDropdownHovered = false;
          });
          _removeOverlay();
          authState.logout();
        },
        child: const Text(
          '安全退出',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      ),
    );
  }

  /// 构建单个菜单卡片
  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isAvatarHovered = false;
            _isDropdownHovered = false;
          });
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: const Color(0xFF666666),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 未登录：显示"登录 / 注册"按钮
  Widget _buildLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // 显示登录弹窗
          showLoginDialog(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFFD93025).withValues(alpha: 0.9)
                : const Color(0xFFD93025),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '登录 / 注册',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建图标按钮
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  /// 默认头像
  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Icon(
        Icons.person,
        size: 22,
        color: Color(0xFF999999),
      ),
    );
  }
}
