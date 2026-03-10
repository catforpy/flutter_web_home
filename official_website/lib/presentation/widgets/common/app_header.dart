import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

/// 应用顶部导航栏
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          child: Row(
            children: [
              // Logo - 替换为图片
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => AppRouter.goToHome(context),
                  child: Image.network(
                    'https://fuyin15190311094.oss-cn-beijing.aliyuncs.com/%E7%94%B5%E5%95%86%E6%89%8B%E6%9C%BA.png',
                    height: 48,
                    width: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '都达',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF3B30),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),

              // 导航菜单 - 更新为：定制服务 | 解决方案 | 案例 | 我们（带下拉） | 联系
              Wrap(
                spacing: 24,
                children: [
                  _NavLink(
                    label: '定制服务',
                    path: AppRouter.serve,
                    onTap: () => AppRouter.goToServe(context),
                  ),
                  _NavSeparator(),
                  _NavLink(
                    label: '解决方案',
                    path: AppRouter.solutions,
                    onTap: () => AppRouter.goToSolutions(context),
                  ),
                  _NavSeparator(),
                  _NavLink(
                    label: '案例',
                    path: AppRouter.cases,
                    onTap: () => AppRouter.goToCases(context),
                  ),
                  _NavSeparator(),
                  // "我们"带下拉菜单
                  const _AboutDropdown(),
                  _NavSeparator(),
                  _NavLink(
                    label: '联系',
                    path: AppRouter.contact,
                    onTap: () => AppRouter.goToContact(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 导航链接组件
class _NavLink extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: _isExternalLink(path)
                  ? Colors.grey.withValues(alpha: 0.8)
                  : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // 判断是否为外部链接（未实现的页面）
  bool _isExternalLink(String path) {
    return false; // 暂无外部链接
  }
}

/// 导航分隔符（竖线）
class _NavSeparator extends StatelessWidget {
  const _NavSeparator();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '|',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

/// "我们"下拉菜单组件
class _AboutDropdown extends StatefulWidget {
  const _AboutDropdown();

  @override
  State<_AboutDropdown> createState() => _AboutDropdownState();
}

class _AboutDropdownState extends State<_AboutDropdown> {
  bool _isHovered = false;
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 触发区域：我们 + 箭头
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => AppRouter.goToAbout(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '我们',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isHovered ? Icons.expand_more : Icons.keyboard_arrow_down,
                        size: 20,
                        color: const Color(0xFF666666),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 下拉菜单内容（使用 Positioned 绝对定位，浮在页面上方）
            if (_isHovered)
              Positioned(
                top: 45,
                left: 0,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    offset: const Offset(0, 0),
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
                          _DropdownMenuItem(
                            title: '我们是谁？',
                            onTap: () {
                              AppRouter.goToAbout(context);
                            },
                          ),
                          _DropdownMenuItem(
                            title: '优势亮点',
                            onTap: () {
                              AppRouter.goToAbout(context);
                            },
                          ),
                          _DropdownMenuItem(
                            title: '资质荣誉',
                            onTap: () {
                              AppRouter.goToAbout(context);
                            },
                          ),
                          _DropdownMenuItem(
                            title: '发展历程',
                            onTap: () {
                              AppRouter.goToAbout(context);
                            },
                          ),
                          const Divider(height: 1),
                          _DropdownMenuItem(
                            title: '客户心声',
                            onTap: () {
                              AppRouter.goToAbout(context);
                            },
                          ),
                          // 红色的"了解更多"按钮
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  AppRouter.goToContact(context);
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 下拉菜单项
class _DropdownMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DropdownMenuItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}
