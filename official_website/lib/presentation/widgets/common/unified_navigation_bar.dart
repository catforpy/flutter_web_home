import 'package:flutter/material.dart';
import '../../routes/app_router.dart';
import 'auth_widget.dart';
import '../../../core/auth/auth_state.dart';

/// 导航栏菜单项数据模型
class NavbarMenuItem {
  /// 显示文本
  final String label;

  /// 路由路径
  final String path;

  /// 点击回调
  final VoidCallback? onTap;

  const NavbarMenuItem({
    required this.label,
    required this.path,
    this.onTap,
  });
}

/// 下拉菜单项数据模型
class DropdownMenuItem {
  /// 显示文本
  final String label;

  /// 点击回调
  final VoidCallback onTap;

  const DropdownMenuItem({
    required this.label,
    required this.onTap,
  });
}

/// 统一导航栏组件
/// 支持选中高亮、数据结构化
class UnifiedNavigationBar extends StatefulWidget {
  /// 当前选中的路由路径
  final String? currentPath;

  /// 是否显示"了解更多"按钮
  final bool showLearnMoreButton;

  const UnifiedNavigationBar({
    super.key,
    this.currentPath,
    this.showLearnMoreButton = true,
  });

  @override
  State<UnifiedNavigationBar> createState() => _UnifiedNavigationBarState();
}

class _UnifiedNavigationBarState extends State<UnifiedNavigationBar> {
  bool _isDropdownHovered = false;

  /// 导航菜单数据（可以以后从服务器获取）
  List<NavbarMenuItem> get _menuItems {
    // 基础菜单项（所有用户可见）
    final baseItems = [
      NavbarMenuItem(
        label: '首页',
        path: AppRouter.home,
        onTap: () => AppRouter.goToHome(context),
      ),
      NavbarMenuItem(
        label: '购买',
        path: AppRouter.purchase,
        onTap: () => AppRouter.goToPurchase(context),
      ),
      NavbarMenuItem(
        label: '租赁',
        path: AppRouter.lease,
        onTap: () => AppRouter.goToLease(context),
      ),
      NavbarMenuItem(
        label: '合作',
        path: AppRouter.partnership,
        onTap: () => AppRouter.goToPartnership(context),
      ),
      NavbarMenuItem(
        label: '定制开发',
        path: AppRouter.customDev,
        onTap: () => AppRouter.goToCustomDev(context),
      ),
      // 以下导航项暂时隐藏（保留代码，以后可能需要）
      /*
      NavbarMenuItem(
        label: '定制服务',
        path: AppRouter.serve,
        onTap: () => AppRouter.goToServe(context),
      ),
      NavbarMenuItem(
        label: '解决方案',
        path: AppRouter.solutions,
        onTap: () => AppRouter.goToSolutions(context),
      ),
      NavbarMenuItem(
        label: '案例',
        path: AppRouter.cases,
        onTap: () => AppRouter.goToCases(context),
      ),
      */
    ];

    // "合作"是下拉菜单，单独处理（暂时隐藏）
    /*
    final contactItem = NavbarMenuItem(
      label: '联系',
      path: AppRouter.contact,
      onTap: () => AppRouter.goToContact(context),
    );
    */

    // 工作台：客户、服务商和后台身份可见
    final List<NavbarMenuItem> items = [];
    items.addAll(baseItems);

    // 根据用户身份添加"工作台"（客户、服务商和后台可以访问）
    if (authState.userTypeEnum == UserType.customer ||
        authState.userTypeEnum == UserType.merchant ||
        authState.userTypeEnum == UserType.backend) {
      items.add(
        NavbarMenuItem(
          label: '工作台',
          path: AppRouter.workbench,
          onTap: () => AppRouter.goToWorkbench(context),
        ),
      );
    }

    // items.add(contactItem); // 暂时隐藏"联系"菜单项
    return items;
  }

  /// "合作"下拉菜单数据（可以以后从服务器获取）
  List<DropdownMenuItem> get _dropdownItems {
    return [
      DropdownMenuItem(
        label: '我们是谁？',
        onTap: () => AppRouter.goToCooperation(context),
      ),
      DropdownMenuItem(
        label: '优势亮点',
        onTap: () => AppRouter.goToCooperation(context),
      ),
      DropdownMenuItem(
        label: '资质荣誉',
        onTap: () => AppRouter.goToCooperation(context),
      ),
      DropdownMenuItem(
        label: '发展历程',
        onTap: () => AppRouter.goToCooperation(context),
      ),
      DropdownMenuItem(
        label: '客户心声',
        onTap: () => AppRouter.goToCooperation(context),
      ),
    ];
  }

  /// 判断菜单项是否被选中
  bool _isSelected(String path) {
    return widget.currentPath == path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 白色背景
      clipBehavior: Clip.none, // 不裁剪溢出内容
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: [
          // Logo
          _buildLogo(),

          const Spacer(),

          // 导航菜单
          Wrap(
            spacing: 24,
            children: [
              ..._menuItems.map((item) => _buildMenuItem(item)),
              // "合作"下拉菜单（暂时隐藏）
              // _buildWeDropdown(),
            ],
          ),

          const Spacer(flex: 2),

          // 购物车图标
          _buildCartButton(),

          const SizedBox(width: 24),

          // 认证组件（登录/注册）
          const AuthWidget(),
        ],
      ),
    );
  }

  /// 构建 Logo
  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => AppRouter.goToHome(context),
        child: Image.network(
          'https://fuyin15190311094.oss-cn-beijing.aliyuncs.com/%E9%83%BD%E8%BE%BE_108_108.png',
          height: 48,
          width: 48,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '都达小程序', // 改为 "都达小程序"
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF3B30), // 红色
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建普通菜单项
  Widget _buildMenuItem(NavbarMenuItem item) {
    final isSelected = _isSelected(item.path);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD93025) // 选中：红色背景
                : Colors.transparent, // 未选中：透明背景
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected
                  ? Colors.white // 选中：白色文字
                  : Colors.black, // 未选中：黑色文字
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建"合作"下拉菜单
  Widget _buildWeDropdown() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isDropdownHovered = true),
      onExit: (_) => setState(() => _isDropdownHovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 触发区域
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => AppRouter.goToCooperation(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '合作',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isDropdownHovered ? Icons.expand_more : Icons.keyboard_arrow_down,
                      size: 20,
                      color: const Color(0xFF666666),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 下拉菜单内容
          if (_isDropdownHovered)
            Positioned(
              top: 45,
              left: 0,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isDropdownHovered = true),
                onExit: (_) => setState(() => _isDropdownHovered = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._dropdownItems.map((item) => _buildDropdownMenuItem(item)),
                      const Divider(height: 1),
                      // 红色的"了解更多"按钮
                      if (widget.showLearnMoreButton)
                        _buildLearnMoreButton(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建下拉菜单项
  Widget _buildDropdownMenuItem(DropdownMenuItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建"了解更多"按钮
  Widget _buildLearnMoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            AppRouter.goToCooperation(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFD93025), // 红色背景
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '了解更多',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建购物车按钮
  Widget _buildCartButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => AppRouter.goToCart(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 20,
                color: Color(0xFF666666),
              ),
              SizedBox(width: 6),
              Text(
                '购物车',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
