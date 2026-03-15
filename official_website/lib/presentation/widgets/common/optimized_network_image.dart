import 'package:flutter/material.dart';

/// 优化的网络图片组件
///
/// 针对Flutter Web优化的图片加载组件，特性：
/// - 自动限制缓存尺寸，减少内存占用
/// - 内置加载状态和错误处理
/// - 利用浏览器HTTP缓存
/// - 支持占位符和自定义错误组件
class OptimizedNetworkImage extends StatelessWidget {
  /// 图片URL
  final String imageUrl;

  /// 图片宽度（可选）
  final double? width;

  /// 图片高度（可选）
  final double? height;

  /// 适配方式
  final BoxFit fit;

  /// 缓存图片的最大宽度（像素）
  ///
  /// 默认1200，根据实际显示大小调整可减少内存占用70%
  final int? cacheWidth;

  /// 缓存图片的最大高度（像素）
  ///
  /// 默认800，根据实际显示大小调整可减少内存占用70%
  final int? cacheHeight;

  /// 加载时显示的组件
  final Widget? placeholder;

  /// 加载失败时显示的组件
  final Widget? errorWidget;

  /// 是否圆角
  final BorderRadius? borderRadius;

  /// 构造函数
  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // 根据实际显示尺寸计算合适的缓存尺寸
    final computedCacheWidth = cacheWidth ?? _computeCacheWidth();
    final computedCacheHeight = cacheHeight ?? _computeCacheHeight();

    final image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: computedCacheWidth,
      cacheHeight: computedCacheHeight,
      loadingBuilder: (context, child, loadingProgress) {
        // 加载完成，返回图片
        if (loadingProgress == null) return child;

        // 显示加载进度
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: const Color(0xFFF5F5F5),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        // 加载失败，显示错误组件
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: const Color(0xFFF5F5F5),
              child: const Icon(
                Icons.broken_image,
                size: 48,
                color: Color(0xFFCCCCCC),
              ),
            );
      },
    );

    // 如果有圆角，用ClipRRect包装
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  /// 计算合适的缓存宽度
  ///
  /// 根据实际显示宽度和设备像素比计算，避免加载过大的图片
  int _computeCacheWidth() {
    if (width == null) return 1200; // 默认最大宽度

    // 获取设备像素比
    final devicePixelRatio = WidgetsBinding
        .instance.platformDispatcher.views.first.devicePixelRatio;

    // 计算物理像素宽度（向上取整到100的倍数）
    final physicalWidth = (width! * devicePixelRatio).ceil();
    return ((physicalWidth / 100).ceil() * 100).clamp(600, 1920);
  }

  /// 计算合适的缓存高度
  ///
  /// 根据实际显示高度和设备像素比计算，避免加载过大的图片
  int _computeCacheHeight() {
    if (height == null) return 800; // 默认最大高度

    // 获取设备像素比
    final devicePixelRatio = WidgetsBinding
        .instance.platformDispatcher.views.first.devicePixelRatio;

    // 计算物理像素高度（向上取整到100的倍数）
    final physicalHeight = (height! * devicePixelRatio).ceil();
    return ((physicalHeight / 100).ceil() * 100).clamp(400, 1080);
  }

  /// 预设的图片尺寸配置
  ///
  /// 针对不同场景优化的预设配置
  factory OptimizedNetworkImage.thumbnail({
    Key? key,
    required String imageUrl,
    double? size,
  }) {
    return OptimizedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: size ?? 80,
      height: size ?? 80,
      fit: BoxFit.cover,
      cacheWidth: 200,  // 缩略图使用小尺寸
      cacheHeight: 200,
    );
  }

  /// 卡片图片（适用于商品卡片、课程卡片等）
  factory OptimizedNetworkImage.card({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return OptimizedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width ?? 300,
      height: height ?? 200,
      fit: BoxFit.cover,
      cacheWidth: 600,
      cacheHeight: 400,
      borderRadius: borderRadius,
    );
  }

  /// 轮播图图片（适用于首页轮播、文章轮播等）
  factory OptimizedNetworkImage.carousel({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
  }) {
    return OptimizedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cacheWidth: 1920,  // 轮播图使用较大尺寸
      cacheHeight: 800,
    );
  }

  /// 详情页图片（适用于商品详情、文章详情等）
  factory OptimizedNetworkImage.detail({
    Key? key,
    required String imageUrl,
    double? width,
  }) {
    return OptimizedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      fit: BoxFit.contain,
      cacheWidth: 1200,
      cacheHeight: 1600,  // 详情页允许更高
    );
  }
}
