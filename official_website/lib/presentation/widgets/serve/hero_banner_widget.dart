import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

/// 服务页Hero横幅组件
/// 包含：背景图 + 主标题 + 副标题 + 右侧手机展示
class HeroBannerWidget extends StatelessWidget {
  /// 主标题
  final String title;

  /// 副标题
  final String subtitle;

  /// 背景图路径（必填，可以是本地assets路径或网络URL）
  final String backgroundImageUrl;

  /// 是否显示APP下载按钮（默认false）
  final bool showDownloadButton;

  const HeroBannerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundImageUrl,
    this.showDownloadButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          // 背景图
          Positioned.fill(
            child: Image.asset(
              backgroundImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('HeroBanner: 图片加载失败 - $error');
                // 图片加载失败时显示渐变背景
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A2332),
                        Color(0xFF0D1B2A),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 黑色半透明蒙版
          Container(
            color: Colors.black.withValues(alpha: 0.65),
          ),

          // 左侧文案区（距左40px，距顶180px）
          Positioned(
            top: 180,
            left: 40,
            child: _buildLeftContent(context),
          ),
        ],
      ),
    );
  }

  /// 构建左侧文案区
  Widget _buildLeftContent(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主标题
          Text(
            title,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          // 副标题
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          // APP下载按钮（仅当showDownloadButton为true时显示）
          if (showDownloadButton) ...[
            const SizedBox(height: 32),
            _buildDownloadButton(context),
          ],
        ],
      ),
    );
  }

  /// 构建APP下载按钮
  Widget _buildDownloadButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 跳转到下载页面
          AppRouter.openUrl('http://192.168.2.14:3000/assets/download.html');
        },
        child: Container(
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.android,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'APP下载',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
