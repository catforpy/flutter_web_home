# 网页详细分析报告 - Flutter 实现参数

**网址**: https://www.junhesoftware.online/xcx/serve
**时间**: 2026-03-04 14:12:41

## 🎴 卡片组件参数 (Service Card)

共发现 0 个卡片元素

### Hover 动效参数:

```dart
// 卡片 Hover 动画参数
const Duration hoverAnimationDuration = Duration(milliseconds: 300); // 过渡时间
const double hoverScale = 1.05;  // Hover 缩放比例

// 正常状态
BoxShadow normalShadow = BoxShadow(
  color: Color(0x1A000000),  // 10% 黑色
  blurRadius: 8,
  offset: Offset(0, 2),
);

// Hover 状态
BoxShadow hoverShadow = BoxShadow(
  color: Color(0x33000000),  // 20% 黑色
  blurRadius: 16,
  offset: Offset(0, 4),
);
```

### 卡片样式:


## 🔘 按钮组件参数

共发现 0 个按钮

### 按钮样式:


## 🎨 颜色方案

共提取 46 种颜色值

### 主要颜色:

```dart
class AppColors {
  // 主色
  static const Color primary = Color(0xFF1890FF);     // 蓝色

  // 辅助色
  static const Color secondary = Color(0xFFFF0000);   // 红色 (CTA按钮)

  // 背景色
  static const Color background = Color(0xFFFFFFFF);  // 白色
  static const Color backgroundLight = Color(0xFFF5F5F5);  // 浅灰

  // 文字色
  static const Color textPrimary = Color(0xFF262626);    // 主文字
  static const Color textSecondary = Color(0xFF8C8C8C);  // 次要文字

  // 边框和分割线
  static const Color border = Color(0xFFD9D9D9);
  static const Color divider = Color(0xFFE8E8E8);
}
```

## 📐 布局参数

### Section 间距:


## ✨ 动画关键帧

共发现 24 个动画定义


### `swiper-preloader-spin`

```css
100% { transform: rotate(360deg); }
```


### `swiper-preloader-spin`

```css
100% { transform: rotate(360deg); }
```


### `rotating`

```css
0% { transform: rotate(0deg); }
100% { transform: rotate(1turn); }
```


## 📝 Flutter 实现建议

### 1. 卡片 Hover 动效实现

```dart
class ServiceCardWidget extends StatefulWidget {
  @override
  _ServiceCardWidgetState createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget>
    with SingleTickerProviderStateMixin {

  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered ? AppColors.shadowLg : AppColors.shadowMd,
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.divider,
            width: _isHovered ? 2.0 : 1.0,
          ),
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: // 卡片内容
        ),
      ),
    );
  }
}
```

### 2. 响应式网格布局

根据屏幕宽度调整列数:
- 移动端 (< 768px): 1 列
- 平板 (768px - 1024px): 2 列
- 桌面 (> 1024px): 4 列

---

*本报告由详细网页分析工具生成*
